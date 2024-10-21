//
//  SubtasksViewController.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 08.10.2024.
//

import UIKit

class SubtasksViewController: UITableViewController {
    struct Const {
        static let cellReuseIdentifier = "subtask_cell"
        static let goToCreateSubtask = "go_to_create_subtask"
        static let goToEditSubtask = "go_to_edit_subtask"
    }
    
    var taskEntity: TaskEntity?
    var subtaskEntities: [SubtaskEntity] = []
    
    @IBOutlet private weak var taskLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let taskEntity {
            taskLabel.text = taskEntity.content
        }
        
        loadSubtasks()
    }
    
    private func loadSubtasks() {
        guard let taskId = taskEntity?.id,
              let subtaskEntities = SettingsProvider.currentDbManager.getSubtasks(for: taskId)
        else {
            print("Failed to load subtasks")
            
            return
        }
        
        self.subtaskEntities = subtaskEntities
        self.tableView.reloadData()
    }
    
    func config(with subtaskEntities: [SubtaskEntity], taskEntity: TaskEntity) {
        self.subtaskEntities = subtaskEntities
        self.taskEntity = taskEntity
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
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (action, view, completion) in
            guard let self else {return}
            
            let subtaskToEdit = self.subtaskEntities[indexPath.row]
            
            self.performSegue(withIdentifier: Const.goToEditSubtask, sender: subtaskToEdit)
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completion) in
            guard let self else {return}
            
            let subtaskToRemove = subtaskEntities[indexPath.row]
            
            let deletedSuccessfully = SettingsProvider.currentDbManager.deleteSubtask(id: subtaskToRemove.id)
            
            if !deletedSuccessfully {
                self.showErrorAlert(title: "Something went wrong", message: "Failed to delete a subtask")
                
                return
            }

            subtaskEntities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Const.goToCreateSubtask:
            let createSubtaskVC = segue.destination as! SubtaskFormViewController
            
            createSubtaskVC.configForCreating()
            createSubtaskVC.delegate = self
        case Const.goToEditSubtask:
            let editSubtaskVC = segue.destination as! SubtaskFormViewController
            let subtaskToEdit = sender as! SubtaskEntity
            
            editSubtaskVC.configForEditing(subtaskEntity: subtaskToEdit)
            editSubtaskVC.delegate = self
        default: break
        }
    }
}

extension SubtasksViewController: SubtaskEditorDelegate {
    func saveEditedSubtask(_ newSubtask: SubtaskEntity) -> Bool {
        let editedSuccessfully = SettingsProvider.currentDbManager.editSubtask(subtask: newSubtask)
        
        loadSubtasks()
        
        return editedSuccessfully
    }
}

extension SubtasksViewController: SubtaskFormDelegate {
    func editSubtask(as subtaskEntity: SubtaskEntity) {
        let successfullyEdited = SettingsProvider.currentDbManager.editSubtask(subtask: subtaskEntity)
        
        if !successfullyEdited {
            self.showErrorAlert(title: "Something went wrong.", message: "Failed to edit a subtask.")
        }
        
        loadSubtasks()
    }
    
    func createSubtask(content subtaskContent: String) {
        guard let taskEntity else {
            showErrorAlert(title: "Something went wrong.", message: "Failed to create a subtask.")
            print("Task entity to create a subtask does not exist")
            
            return
        }
        
        let newSubtask = CreateSubtaskEntity(content: subtaskContent, parentTaskId: taskEntity.id)
        
        let createdSubtask = SettingsProvider.currentDbManager.createSubtask(newSubtask: newSubtask)
        
        guard let createdSubtask else {
            self.showErrorAlert(title: "Something went wrong.", message: "Failed to create a subtask.")
            
            return
        }
        
        loadSubtasks()
    }
}
