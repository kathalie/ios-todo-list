//
//  ViewController.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 07.10.2024.
//

import UIKit
import LocalAuthentication

class TasksViewController: UITableViewController, CreateTaskDelegate {
    struct Const {
        static let cellReuseIdentifier = "task_cell"
        static let goToSubtasks = "go_to_subtasks"
        static let goToCreateTask = "go_to_create_task"
    }
    
    var taskEntities: [TaskEntity] = []
    
    enum DBManagers: String, CaseIterable {
        case coreData = "CoreData"
        case realm = "Realm"
    }
    
    let dbManagers: [DBManagers: DBManager] = [
        .coreData: CoreDataManager.shared,
        .realm: RealmManager.shared
    ]
    
    var dbManager: DBManager = CoreDataManager.shared
    
//    var laSuccess: Bool = false {
//        didSet {
//            tableView.isHidden = !laSuccess
//        }
//    }
    
//    func askAuthentication() {
//        var context = LAContext()
//        
//        var error: NSError?
//        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
//            print(error?.localizedDescription ?? "Can't evaluate policy")
//
//            return
//        }
//        
//        Task {
//            do {
//                try await context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Log in to your account")
//                state = .loggedin
//            } catch let error {
//                print(error.localizedDescription)
//                // Fall back to a asking for username and password.
//                // ...
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        askAuthentication()
        loadTasks()
    }
    
    func loadTasks() {
        guard let taskEntities = dbManager.getTasks()
        else {
            print("Failed to load tasks")
            
            return
        }
        
        self.taskEntities = taskEntities
        self.tableView.reloadData()
    }
    
    func createTask(content: String, dueDate: Date) {
        let newTask = CreateTaskEntity(content: content, dueDate: dueDate)
        
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
            
            subtasksVC.config(
                with: taskEntity.subtasks,
                taskEntity: taskEntity,
                delegate: self
            )
        case Const.goToCreateTask:
            let createTaskVC = segue.destination as! CreateTaskViewController
            createTaskVC.delegate = self
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

extension TasksViewController: DBManagerDelegate {
    func getDBManager() -> DBManager {
        return dbManager
    }
}

extension TasksViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        dbManagers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let dbManager = DBManagers.allCases[row]
        self.dbManager = self.dbManagers[dbManager]!
        
        loadTasks()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        DBManagers.allCases[row].rawValue
    }
}
