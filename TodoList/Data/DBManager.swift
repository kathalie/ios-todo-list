//
//  DBService.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 13.10.2024.
//

import Foundation

protocol DBManager {
    func createTask(newTask: CreateTaskEntity) -> TaskEntity?
    func editTask(task: TaskEntity) -> Bool
    func deleteTask(id: UUID) -> Bool
    func getTasks() -> [TaskEntity]?
    
    func createSubtask(newSubtask: CreateSubtaskEntity) -> SubtaskEntity?
    func editSubtask(subtask: SubtaskEntity) -> Bool
    func deleteSubtask(id: UUID) -> Bool
    func getSubtasks(for taskEntity: TaskEntity) -> [SubtaskEntity]?
}
