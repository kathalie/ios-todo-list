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
    
    func config(task: Int) {
        taskLabel.text = task.formatted()
    }
}
