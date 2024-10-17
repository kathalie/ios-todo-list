//
//  CreateSubtaskViewController.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 16.10.2024.
//

import Foundation
import UIKit

protocol SubtaskFormDelegate {
    func createSubtask(content: String)
    func editSubtask(as subtaskEntity: SubtaskEntity)
}

class SubtaskFormViewController: UIViewController {
    enum Mode {
        case creating
        case editing(_ subtaskEntity: SubtaskEntity)
    }
    
    var delegate: SubtaskFormDelegate?
    private var mode: Mode = .creating
    
    private var subtaskContent: String = ""
    
    @IBOutlet private weak var navBar: UINavigationItem!
    
    @IBOutlet private weak var subtaskContentTextField: UITextField!
    
    @IBAction private func subtaskContentChanged(_ sender: UITextField) {
        self.subtaskContent = sender.text ?? ""
    }
    
    @IBAction private func saveChanges(_ sender: UIButton) {
        let subtaskContent = subtaskContentTextField.text ?? ""
        
        switch mode {
        case .creating:
            delegate?.createSubtask(content: self.subtaskContent)
        case .editing(let subtaskEntity):
            let editedSubtask = SubtaskEntity(
                id: subtaskEntity.id,
                content: subtaskContent,
                isCompleted: subtaskEntity.isCompleted,
                parentTaskId: subtaskEntity.parentTaskId
            )
            
            delegate?.editSubtask(as: editedSubtask)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subtaskContentTextField.text = subtaskContent
        
        switch mode {
        case .creating:
            navBar.title = "New Subtask"
        case .editing(_):
            navBar.title = "Edit Subtask"
        }
    }
    
    func configForCreating() {
        mode = .creating
    }
    
    func configForEditing(subtaskEntity: SubtaskEntity) {
        mode = .editing(subtaskEntity)
        
        self.subtaskContent = subtaskEntity.content
    }
}

extension SubtaskFormViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
