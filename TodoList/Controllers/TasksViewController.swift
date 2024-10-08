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
    
    var tasks: [(Int, [Int])] = []
    
    @IBAction func addTask(_ sender: Any) {
        print("Adding task")
        
        self.showInpulert(
            title: "Creating a task",
            message: "Enter the task to the text field below.",
            placeholder: "Task",
            callback: {[weak self] input in self?.createTask(input)})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasks = [(1, [11, 111, 1111]), (2, [22, 222])]
    }
    
    private func createTask(_ newTask: String) {
        //TODO
        
        print("Task created: \(newTask)")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.cellReuseIdentifier
        ) as! TaskTableViewCell
        
        let task = tasks[indexPath.row]
        
        cell.config(task: task.0)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let task = tasks[indexPath.row]
        
        performSegue(withIdentifier: Const.goToSubtasks, sender: task.1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Const.goToSubtasks:
            let subtasksVC = segue.destination as! SubtasksViewController
            let subtasks = sender as! [Int]
            
            subtasksVC.config(with: subtasks)
        default: break
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //TODO remove from database!
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
