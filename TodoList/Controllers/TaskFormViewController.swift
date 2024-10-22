//
//  CreateTaskViewController.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 15.10.2024.
//

import UIKit

protocol TaskFormDelegate {
    func createTask(content: String, dueDate: Date, notificationsOn: Bool)
    func editTask(as taskEntity: TaskEntity)
}

class TaskFormViewController: UIViewController {
    enum Mode {
        case creating
        case editing(_ taskEntity: TaskEntity)
    }
    
    var delegate: TaskFormDelegate?
    private var mode: Mode = .creating
    
    private var taskContent: String = ""
    private var dueDate: Date = Date()
    private var notificationsOn: Bool = true
    
    @IBOutlet private weak var taskContentTextField: UITextField!
    
    @IBOutlet private weak var dueDatePicker: UIDatePicker!
    
    @IBOutlet private weak var turnOnNotificationsSwitch: UISwitch!
    
    @IBAction private func saveChanges(_ sender: Any) {
        let taskContent = taskContentTextField.text ?? ""
        let dueDate = dueDatePicker.date
        let notificationsOn = turnOnNotificationsSwitch.isOn
        
        switch mode {
        case .creating:
            delegate?.createTask(content: taskContent, dueDate: dueDate, notificationsOn: notificationsOn)
        case .editing(let taskEntity):
            let editedTaskEntity = TaskEntity(
                id: taskEntity.id,
                content: taskContent,
                isCompleted: taskEntity.isCompleted,
                dueDate: dueDate,
                notificationsOn: notificationsOn,
                subtasks: taskEntity.subtasks
            )
            
            delegate?.editTask(as: editedTaskEntity)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskContentTextField.text = taskContent
        dueDatePicker.date = dueDate
        turnOnNotificationsSwitch.isOn = notificationsOn
        
        switch mode {
        case .creating:
            self.title = "New Task"
        case .editing(_):
            self.title = "Edit Task"
        }
    }
    
    func configForCreating() {
        mode = .creating
    }
    
    func configForEditing(taskEntity: TaskEntity) {
        mode = .editing(taskEntity)
        
        self.taskContent = taskEntity.content
        self.dueDate = taskEntity.dueDate
        self.notificationsOn = taskEntity.notificationsOn
    }
}

extension TaskFormViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
