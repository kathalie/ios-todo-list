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
    let parentTaskId: UUID
}
