//
//  ViewController.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 07.10.2024.
//

import UIKit
import LocalAuthentication

class TasksViewController: UITableViewController {
    struct Const {
        static let cellReuseIdentifier = "task_cell"
        static let goToSubtasks = "go_to_subtasks"
        static let goToCreateTask = "go_to_create_task"
        static let goToEditTask = "go_to_edit_task"
        static let goToSettings = "go_to_settings"
        static let goToNotifications = "go_to_notifications"
    }
    
    let localNotificationService = LocalNotificationsService.shared
    
    var taskEntities: [TaskEntity] = []
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
        guard let taskEntities = SettingsProvider.currentDbManager.getTasks()
        else {
            print("Failed to load tasks")
            
            return
        }
        
        self.taskEntities = taskEntities
        self.tableView.reloadData()
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
                taskEntity: taskEntity
            )
        case Const.goToCreateTask:
            let createTaskVC = segue.destination as! TaskFormViewController
            
            createTaskVC.configForCreating()
            createTaskVC.delegate = self
        case Const.goToEditTask:
            let editTaskVC = segue.destination as! TaskFormViewController
            let taskToEdit = sender as! TaskEntity
            
            editTaskVC.configForEditing(taskEntity: taskToEdit)
            editTaskVC.delegate = self
        case Const.goToSettings:
            let settingsVC = segue.destination as! SettingsTableViewController
            settingsVC.delegate = self
//        case Const.goToNotifications:
//            let notificationsVC = segue.destination as! NotificationsViewController
        default: break
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (action, view, completion) in
            guard let self else {return}
            
            let taskToEdit = self.taskEntities[indexPath.row]
            
            self.performSegue(withIdentifier: Const.goToEditTask, sender: taskToEdit)
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completion) in
            guard let self else {return}
            
            let taskToRemove = self.taskEntities[indexPath.row]
            
            let deletedSuccessfully = SettingsProvider.currentDbManager.deleteTask(id: taskToRemove.id)
            
            if !deletedSuccessfully {
                self.showErrorAlert(title: "Something went wrong", message: "Failed to delete a task")
                
                return
            }
            
            taskEntities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // Remove local notification
            removeLocalNotification(for: taskToRemove)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}

extension TasksViewController: TaskEditorDelegate {
    func saveEditedTask(_ newTask: TaskEntity) -> Bool {
        let editedSuccessfully = SettingsProvider.currentDbManager.editTask(task: newTask)
        
        loadTasks()
        
        return editedSuccessfully
    }
}

extension TasksViewController: SettingsTableViewControllerDelegate {
    func update() {
        loadTasks()
    }
}

extension TasksViewController: TaskFormDelegate {
    func editTask(as taskEntity: TaskEntity) {
        let successfullyEdited = SettingsProvider.currentDbManager.editTask(task: taskEntity)
        
        if !successfullyEdited {
            self.showErrorAlert(title: "Something went wrong.", message: "Failed to edit a task.")
        }
        
        // Reschedule local notidication
        if taskEntity.notificationsOn {
            removeLocalNotification(for: taskEntity)
            scheduleLocalNotification(for: taskEntity)
        } else {
            removeLocalNotification(for: taskEntity)
        }
        
        loadTasks()
    }
    
    func createTask(content: String, dueDate: Date, notificationsOn: Bool) {
        let newTask = CreateTaskEntity(content: content, dueDate: dueDate, notificationsOn: notificationsOn)
        
        let createdTask = SettingsProvider.currentDbManager.createTask(newTask: newTask)
        
        guard let createdTask else {
            self.showErrorAlert(title: "Something went wrong.", message: "Failed to create a task.")
            
            return
        }
        
        // Schedule local notification
        if notificationsOn {
            scheduleLocalNotification(for: createdTask)
        }
        
        loadTasks()
    }
    
    private func scheduleLocalNotification(for task: TaskEntity) {
//        guard SettingsProvider.localNotificationsAllowed else {
//            return
//        }
        
        Task {
            await localNotificationService.scheduleNotification(
                task.id,
                on: task.dueDate,
                title: "The following task is due now",
                body: task.content
            )
        }
    }
    
    private func removeLocalNotification(for task: TaskEntity) {
        LocalNotificationsService.shared.removeNotification(task.id)
    }
}
