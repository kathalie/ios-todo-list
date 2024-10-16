//
//  SubtasksViewController.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 08.10.2024.
//

import UIKit

protocol DBManagerDelegate {
    func getDBManager() -> DBManager
}

class SubtasksViewController: UITableViewController, CreateSubtaskDelegate {
    struct Const {
        static let cellReuseIdentifier = "subtask_cell"
        static let goToCreateSubtask = "go_to_create_subtask"
    }
    
    var taskEntity: TaskEntity?
    var subtaskEntities: [SubtaskEntity] = []
    var delegate: DBManagerDelegate?
    
    @IBOutlet private weak var taskLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let taskEntity {
            taskLabel.text = taskEntity.content
        }
        
        loadSubtasks()
    }
    
    private func loadSubtasks() {
        guard let delegate,
              let taskId = taskEntity?.id,
              let subtaskEntities = delegate.getDBManager().getSubtasks(for: taskId)
        else {
            print("Failed to load subtasks")
            
            return
        }
        
        self.subtaskEntities = subtaskEntities
        self.tableView.reloadData()
    }
    
    func config(with subtaskEntities: [SubtaskEntity], taskEntity: TaskEntity, delegate: DBManagerDelegate) {
        self.subtaskEntities = subtaskEntities
        self.taskEntity = taskEntity
        self.delegate = delegate
    }
    
    func createSubtask(content subtaskContent: String) {
        guard let taskEntity else {
            showErrorAlert(title: "Somthing went wrong", message: "Failed to create a subtask")
            
            return
        }
        
        let newSubtask = CreateSubtaskEntity(content: subtaskContent, parentTaskId: taskEntity.id)
        
        _ = delegate?.getDBManager().createSubtask(newSubtask: newSubtask)
        
        loadSubtasks()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        subtaskEntities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.cellReuseIdentifier) as! SubtaskTableViewCell
        
        let subtaskEntity = subtaskEntities[indexPath.row]
        
        cell.config(with: subtaskEntity, delegate: self)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let subtaskToRemove = subtaskEntities[indexPath.row]
            
            guard let delegate else {
                self.showErrorAlert(title: "Something went wrong", message: "Failed to delete a subtask")
                
                return
            }
            
            let deletedSuccessfully = delegate.getDBManager().deleteSubtask(id: subtaskToRemove.id)
            
            if !deletedSuccessfully {
                self.showErrorAlert(title: "Something went wrong", message: "Failed to delete a subtask")
                
                return
            }

            subtaskEntities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Const.goToCreateSubtask:
            let createSubtaskVC = segue.destination as! CreateSubtaskViewController
            createSubtaskVC.delegate = self
        default: break
        }
    }
}

extension SubtasksViewController: SubtaskEditorDelegate {
    func saveEditedSubtask(_ newSubtask: SubtaskEntity) -> Bool {
        guard let delegate else {
            return false
        }
        
        let editedSuccessfully = delegate.getDBManager().editSubtask(subtask: newSubtask)
        
        loadSubtasks()
        
        return editedSuccessfully
    }
}
