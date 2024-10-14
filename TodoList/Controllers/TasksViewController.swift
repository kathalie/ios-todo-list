//
//  ViewController.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 07.10.2024.
//

import UIKit

class TasksViewController: UITableViewController {
    struct Const {
        static let cellReuseIdentifier = "task_cell"
        static let goToSubtasks = "go_to_subtasks"
    }
    
    var taskEntities: [TaskEntity] = []
    var dbManager: DBManager = CoreDataManager()
    
    @IBAction func addTask(_ sender: Any) {
        print("Adding task")
        
        self.showInpulert(
            title: "Creating a task",
            message: "Enter the task to the text field below.",
            placeholder: "Task",
            callback: {[weak self] input in self?.createTask(input)}
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTasks()
    }
    
    private func loadTasks() {
        guard let taskEntities = dbManager.getTasks()
        else {
            print("Failed to load tasks")
            
            return
        }
        
        self.taskEntities = taskEntities
        self.tableView.reloadData()
    }
    
    private func createTask(_ taskContent: String) {
        let newTask = CreateTaskEntity(content: taskContent, dueDate: Date.now)
        
        _ = dbManager.createTask(newTask: newTask)
        
        loadTasks()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskEntities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.cellReuseIdentifier
        ) as! TaskTableViewCell
        
        let taskEntity = taskEntities[indexPath.row]
        
        cell.config(taskEntity: taskEntity, delegate: self)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let taskEntity = taskEntities[indexPath.row]
        
        performSegue(withIdentifier: Const.goToSubtasks, sender: taskEntity)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Const.goToSubtasks:
            let subtasksVC = segue.destination as! SubtasksViewController
            let taskEntity = sender as! TaskEntity
            
            subtasksVC.config(with: taskEntity.subtasks, taskEntity: taskEntity)
        default: break
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskToRemove = taskEntities[indexPath.row]
            
            let deletedSuccessfully = dbManager.deleteTask(id: taskToRemove.id)
            
            if !deletedSuccessfully {
                self.showErrorAlert(title: "Something went wrong", message: "Failed to delete a task")
                
                return
            }
            
            taskEntities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension TasksViewController: TaskEditorDelegate {
    func saveEditedTask(_ newTask: TaskEntity) -> Bool {
        let editedSuccessfully = dbManager.editTask(task: newTask)
        
        loadTasks()
        
        return editedSuccessfully
    }
}
