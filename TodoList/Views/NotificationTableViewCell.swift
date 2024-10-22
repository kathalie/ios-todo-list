//
//  NotificationTableViewCell.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 22.10.2024.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    @IBOutlet private weak var taskContentLabel: UILabel!
    @IBOutlet private weak var dueDateLabel: UILabel!
    @IBOutlet private weak var acceptedLabel: UILabel!
    
    var notificationEntity: NotificationEntity?
    
    func setupContentLabel(text: String) {
        taskContentLabel.text = text
    }
    
    func setupDueDateLabel(dueDate: Date) {
        dueDateLabel.text = dueDateFormat(of: dueDate)
    }
    
    func setupAcceptedLabel(isAccepted: Bool) {
        acceptedLabel.text = isAccepted ? "Accepted" : "Denied"
    }
    
    func setupView(isAccepted: Bool) {
        self.backgroundColor = isAccepted ? UIColor(named: "NotificationAcceptedColor") : UIColor(named: "NotificationDeclinedColor")
    }
    
    func config(with notificationEntity: NotificationEntity) {
        self.notificationEntity = notificationEntity
        
        setupContentLabel(text: notificationEntity.content)
        setupDueDateLabel(dueDate: notificationEntity.dueDate)
        setupAcceptedLabel(isAccepted: notificationEntity.isAccepted)
        setupView(isAccepted: notificationEntity.isAccepted)
    }
}
