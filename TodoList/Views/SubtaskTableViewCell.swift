//
//  SubtaskTableViewCell.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 08.10.2024.
//

import UIKit

protocol SubtaskEditorDelegate {
    func saveEditedSubtask(_ newSubtask: SubtaskEntity) -> Bool
    func showErrorAlert(title: String, message: String)
}

final class SubtaskTableViewCell: UITableViewCell {
    @IBOutlet private weak var subtaskCompletionButton: UIButton!
    @IBOutlet private weak var subtaskLabel: UILabel!
    
    var subtaskEntity: SubtaskEntity?
    var delegate: SubtaskEditorDelegate?
    
    private func setupSubtaskLabel(text: String, isCompleted: Bool) {
        let attributedText = NSAttributedString(
            string: text,
            attributes: isCompleted ?
                [.strikethroughStyle: NSUnderlineStyle.single.rawValue] :
                [:]
        )
        
        subtaskLabel.attributedText = attributedText
    }
    
    private func setupCompletionButton(as isCompleted: Bool) {
        let tapRecogniser = UITapGestureRecognizer(
            target: self,
            action: #selector(toggleSubtaskCompletion)
        )
        
        setCompletionButton(to: isCompleted)
        subtaskCompletionButton.addGestureRecognizer(tapRecogniser)
    }
    
    func config(with subtaskEntity: SubtaskEntity, delegate: SubtaskEditorDelegate) {
        self.subtaskEntity = subtaskEntity
        self.delegate = delegate
        
        setupSubtaskLabel(text: subtaskEntity.content, isCompleted: subtaskEntity.isCompleted)
        setupCompletionButton(as: subtaskEntity.isCompleted)
    }
    
    @objc
    func toggleSubtaskCompletion() {
        guard
            let subtaskEntity,
            let delegate
        else {
            print("failed to initialize subtaskEntity or delegate")
            
            return
        }
        
        let editedSubtaskEntity = SubtaskEntity(
            id: subtaskEntity.id,
            content: subtaskEntity.content,
            isCompleted: !subtaskEntity.isCompleted,
            parentTaskId: subtaskEntity.parentTaskId
        )
        
        let editedSuccessfully = delegate.saveEditedSubtask(editedSubtaskEntity)
        
        if !editedSuccessfully {
            delegate.showErrorAlert(
                title: "Something went wrong",
                message: "Failed to edit a task with id \(subtaskEntity.id)"
            )
            
            return
        }
        
        setCompletionButton(to: editedSubtaskEntity.isCompleted)
    }
    
    private func setCompletionButton(to completed: Bool) {
        let checkmark = UIImage(systemName: "checkmark.circle.fill")
        let circle = UIImage(systemName: "circle")
        
        subtaskCompletionButton.setImage(
            completed ? checkmark : circle,
            for: .normal
        )
    }
}
