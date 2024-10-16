//
//  CreateSubtaskViewController.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 16.10.2024.
//

import Foundation
import UIKit

protocol CreateSubtaskDelegate {
    func createSubtask(content: String)
}

class CreateSubtaskViewController: UIViewController {
    var delegate: CreateSubtaskDelegate?
    private var subtaskContent: String = ""
    
    @IBOutlet weak var subtaskContentTextField: UITextField!
    
    @IBAction func subtaskContentChanged(_ sender: UITextField) {
        self.subtaskContent = sender.text ?? ""
    }
    
    @IBAction func createSubtask(_ sender: UIButton) {
        delegate?.createSubtask(content: self.subtaskContent)
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension CreateSubtaskViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
