//
//  SubtaskEntity.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 13.10.2024.
//

import Foundation

struct CreateSubtaskEntity {
    let content: String
    let parentTaskId: UUID
}

struct SubtaskEntity {
    let id: UUID
    let content: String
    let isCompleted: Bool
    let parentTaskId: UUID
    
    init(from subtask: TodoSubtask) {
        self.id = subtask.id
        self.content = subtask.content
        self.isCompleted = subtask.isCompleted
        self.parentTaskId = subtask.parentTask.id
    }
    
    init(id: UUID, content: String, isCompleted: Bool, parentTaskId: UUID) {
        self.id = id
        self.content = content
        self.isCompleted = isCompleted
        self.parentTaskId = parentTaskId
    }
    
    init(from realmSubtask: SubtaskRealmModel) {
        self.id = realmSubtask.id
        self.content = realmSubtask.content
        self.isCompleted = realmSubtask.isCompleted
        self.parentTaskId = realmSubtask.parentTask!.id
    }
}
