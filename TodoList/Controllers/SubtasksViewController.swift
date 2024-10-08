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
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func config(with subtasks: [Int]) {
        self.subtasks = subtasks
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
}
