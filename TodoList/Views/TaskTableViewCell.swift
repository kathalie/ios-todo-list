//
//  TaskCellView.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 08.10.2024.
//

import UIKit

protocol TaskEditorDelegate {
    func saveEditedTask(_ newTask: TaskEntity) -> Bool
    func showErrorAlert(title: String, message: String)
}

final class TaskTableViewCell: UITableViewCell {
    @IBOutlet private weak var taskCompletionButton: UIButton!
    @IBOutlet private weak var taskLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    var taskEntity: TaskEntity?
    var delegate: TaskEditorDelegate?
    
    
    private func dueDateFormat(of date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("dd.MM.yy HH:mm:ss")
        
        return dateFormatter.string(from: date)
    }
    
    private func setupTaskLabel(text: String) {
        taskLabel.text = text
    }
    
    private func setupDueDateLabel(dueDate: Date) {
        dueDateLabel.text = dueDateFormat(of: dueDate)
        
        let deadlineMissed = dueDate > Date()
        dueDateLabel.textColor = deadlineMissed ? UIColor(named: "DeadlineMissedColor") : UIColor(named: "DeadlineActiveColor")
    }
    
    private func setupCompletionButton(as isCompleted: Bool) {
        let tapRecogniser = UITapGestureRecognizer(
            target: self,
            action: #selector(toggleTaskCompletion)
        )
        
        setCompletionButton(to: isCompleted)
        taskCompletionButton.addGestureRecognizer(tapRecogniser)
    }
    
    func config(taskEntity: TaskEntity, delegate: TaskEditorDelegate) {
        self.taskEntity = taskEntity
        self.delegate = delegate
        
        setupTaskLabel(text: taskEntity.content)
        setupDueDateLabel(dueDate: taskEntity.dueDate)
        setupCompletionButton(as: taskEntity.isCompleted)
    }
    
    @objc
    func toggleTaskCompletion() {
        guard 
            let taskEntity,
            let delegate
        else {
            print("failed to initialize taskEntity or delegate")
            
            return
        }
        
        let editedTaskEntity = TaskEntity(
            id: taskEntity.id,
            content: taskEntity.content,
            isCompleted: !taskEntity.isCompleted,
            dueDate: taskEntity.dueDate
        )
        
        let editedSuccessfully = delegate.saveEditedTask(editedTaskEntity)
        
        if !editedSuccessfully {
            delegate.showErrorAlert(
                title: "Something went wrong",
                message: "Failed to edit a task with id \(taskEntity.id)"
            )
            
            return
        }
        
        setCompletionButton(to: editedTaskEntity.isCompleted)
    }
    
    private func setCompletionButton(to completed: Bool) {
        let checkmark = UIImage(systemName: "checkmark.circle.fill")
        let circle = UIImage(systemName: "circle")
        
        taskCompletionButton.setImage(
            completed ? checkmark : circle,
            for: .normal
        )
    }
}
