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
    
    var taskEntity: TaskEntity?
    var subtaskEntities: [SubtaskEntity] = []
    
    @IBOutlet private weak var taskLabel: UILabel!
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
        if let taskEntity {
            taskLabel.text = taskEntity.content
        }
    }
    
    func config(with subtaskEntities: [SubtaskEntity], taskEntity: TaskEntity) {
        self.subtaskEntities = subtaskEntities
        self.taskEntity = taskEntity
    }
    
    private func createSubtask(_ newTask: String) {
        //TODO
        
        print("Task created: \(newTask)")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        subtaskEntities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.cellReuseIdentifier) as! SubtaskTableViewCell
        
        let subtaskEntity = subtaskEntities[indexPath.row]
        
        cell.config(with: subtaskEntity)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //TODO remove from database!
            subtaskEntities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
