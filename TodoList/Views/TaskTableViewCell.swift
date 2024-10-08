//
//  TaskCellView.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 08.10.2024.
//

import UIKit

final class TaskTableViewCell: UITableViewCell {
    @IBOutlet private weak var taskCompletionButton: UIButton!
    @IBOutlet private weak var taskLabel: UILabel!
    
    var completed: Bool = false
    
    func config(task: Int) {
        taskLabel.text = task.formatted()
        
        let tapRecogniser = UITapGestureRecognizer(
            target: self,
            action: #selector(toggleTaskCompletion)
        )
        taskCompletionButton.addGestureRecognizer(tapRecogniser)
    }
    
    @objc
    func toggleTaskCompletion() {
        completed = !completed
        
        let checkmark = UIImage(systemName: "checkmark.circle.fill")
        let circle = UIImage(systemName: "circle")
        
        taskCompletionButton.setImage(
            completed ? checkmark : circle,
            for: .normal
        )
    }
}
