//
//  CreateTaskViewController.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 15.10.2024.
//

import UIKit

class CreateTaskViewController: UIViewController {
    @IBOutlet weak var taskContentTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dueDatePicker.date = Date()
    }
    
    
}
