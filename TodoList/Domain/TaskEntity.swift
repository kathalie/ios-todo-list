//
//  TaskEntity.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 13.10.2024.
//

import Foundation

struct CreateTaskEntity {
    let content: String
    let dueDate: Date
    let notificationsOn: Bool
}

struct TaskEntity {
    let id: UUID
    let content: String
    let isCompleted: Bool
    let dueDate: Date
    let notificationsOn: Bool
    let subtasks: [SubtaskEntity]
    
    init(from task: TodoTask, with subtasks: [SubtaskEntity] = []) {
        self.id = task.id
        self.content = task.content
        self.dueDate = task.dueDate
        self.isCompleted = task.isCompleted
        self.subtasks = subtasks
        self.notificationsOn = task.notificationsOn
    }
    
    init(id: UUID, content: String, isCompleted: Bool, dueDate: Date, notificationsOn: Bool, subtasks: [SubtaskEntity] = []) {
        self.id = id
        self.content = content
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.subtasks = subtasks
        self.notificationsOn = notificationsOn
    }
    
    init(from realmTask: TaskRealmModel, with subtasks: [SubtaskEntity] = []) {
        self.id = realmTask.id
        self.content = realmTask.content
        self.dueDate = realmTask.dueDate
        self.isCompleted = realmTask.isCompleted
        self.notificationsOn = realmTask.notificationsOn
        self.subtasks = subtasks
    }
}
