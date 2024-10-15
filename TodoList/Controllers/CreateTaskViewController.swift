//
//  CreateTaskViewController.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 15.10.2024.
//

import UIKit

protocol CreateTaskDelegate {
    func createTask(content: String, dueDate: Date)
//    func loadTasks()
}

class CreateTaskViewController: UIViewController {
    var delegate: CreateTaskDelegate?
    private var taskContent: String = ""
    private var dueDate: Date = Date()
        
    @IBOutlet weak var taskContentTextField: UITextField!
    
    @IBAction func taskContentChanged(_ sender: UITextField) {
        self.taskContent = sender.text ?? ""
    }
    
    @IBAction func dueDateChanged(_ sender: UIDatePicker) {
        self.dueDate = sender.date
    }
    
    @IBAction func createTask(_ sender: Any) {
        delegate?.createTask(content: self.taskContent, dueDate: self.dueDate)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension CreateTaskViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
