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
    
    var completed: Bool = false
    
    func config(with subtaskEntity: SubtaskEntity) {
        subtaskLabel.text = subtaskEntity.content
        
        let tapRecogniser = UITapGestureRecognizer(
            target: self,
            action: #selector(toggleSubtaskCompletion)
        )
        subtaskCompletionButton.addGestureRecognizer(tapRecogniser)
    }
    
    @objc
    func toggleSubtaskCompletion() {
        completed = !completed
        
        let checkmark = UIImage(systemName: "checkmark.circle.fill")
        let circle = UIImage(systemName: "circle")
        
        subtaskCompletionButton.setImage(
            completed ? checkmark : circle,
            for: .normal
        )
    }
}
