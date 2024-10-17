//
//  CreateTaskViewController.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 15.10.2024.
//

import UIKit

protocol TaskFormDelegate {
    func createTask(content: String, dueDate: Date)
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
        
    @IBOutlet private weak var taskContentTextField: UITextField!
    
    @IBOutlet private weak var dueDatePicker: UIDatePicker!
    
    @IBOutlet private weak var navBar: UINavigationItem!
    
    @IBAction private func saveChanges(_ sender: Any) {
        let taskContent = taskContentTextField.text ?? ""
        let dueDate = dueDatePicker.date
        
        switch mode {
        case .creating:
            delegate?.createTask(content: taskContent, dueDate: dueDate)
        case .editing(let taskEntity):
            let editedTaskEntity = TaskEntity(
                id: taskEntity.id,
                content: taskContent,
                isCompleted: taskEntity.isCompleted,
                dueDate: dueDate,
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
        
        switch mode {
        case .creating:
            navBar.title = "New Task"
        case .editing(_):
            navBar.title = "Edit Task"
        }
    }
    
    func configForCreating() {
        mode = .creating
    }
    
    func configForEditing(taskEntity: TaskEntity) {
        mode = .editing(taskEntity)
        
        self.taskContent = taskEntity.content
        self.dueDate = taskEntity.dueDate
    }
}

extension TaskFormViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
