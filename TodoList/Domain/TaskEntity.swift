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
}

struct TaskEntity {
    let id: UUID
    let content: String
    let isCompleted: Bool
    let dueDate: Date
    let subtasks: [SubtaskEntity]
    
    init(from task: Task, with subtasks: [SubtaskEntity] = []) {
        self.id = task.id
        self.content = task.content
        self.dueDate = task.dueDate
        self.isCompleted = task.isCompleted
        self.subtasks = subtasks
    }
    
    init(id: UUID, content: String, isCompleted: Bool, dueDate: Date, subtasks: [SubtaskEntity] = []) {
        self.id = id
        self.content = content
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.subtasks = subtasks
    }
}
