//
//  SubtaskTableViewCell.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 08.10.2024.
//

import UIKit

final class SubtaskTableViewCell: UITableViewCell {
    @IBOutlet private weak var subtaskCompletionButton: UIButton!
    
    @IBOutlet private weak var subtaskLabel: UILabel!
    
    func config(subtask: Int) {
        subtaskLabel.text = subtask.formatted()
    }
}