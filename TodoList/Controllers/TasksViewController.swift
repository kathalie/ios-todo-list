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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasks = [(1, [11, 111, 1111]), (2, [22, 222])]
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
}