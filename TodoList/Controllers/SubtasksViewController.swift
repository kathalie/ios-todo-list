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
    }
    
    var subtasks: [Int] = []
    
    @IBAction private func addSubtask(_ sender: UIButton) {
        print("Adding subtask")
        
        self.showInpulert(
            title: "Creating a task",
            message: "Enter the task to the text field below.",
            placeholder: "Task",
            callback: {[weak self] input in self?.createSubtask(input)})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func config(with subtasks: [Int]) {
        self.subtasks = subtasks
    }
    
    private func createSubtask(_ newTask: String) {
        //TODO
        
        print("Task created: \(newTask)")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        subtasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.cellReuseIdentifier) as! SubtaskTableViewCell
        
        let subtask = subtasks[indexPath.row]
        
        cell.config(subtask: subtask)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //TODO remove from database!
            subtasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
