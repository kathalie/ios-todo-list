//
//  NotificationEntity.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 22.10.2024.
//

import Foundation

struct CreateNotificationEntity {
    let content: String
    let dueDate: Date
    let isAccepted: Bool
}

struct NotificationEntity {
    let id: UUID
    let content: String
    let dueDate: Date
    let isAccepted: Bool
    
    init(id: UUID, content: String, dueDate: Date, isAccepted: Bool) {
        self.id = id
        self.content = content
        self.dueDate = dueDate
        self.isAccepted = isAccepted
    }
    
    init(from realmTask: NotificationRealmModel) {
        self.id = realmTask.id
        self.content = realmTask.content
        self.dueDate = realmTask.dueDate
        self.isAccepted = realmTask.isAccepted
    }
}
