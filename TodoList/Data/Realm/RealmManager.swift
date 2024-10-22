//
//  RealmManager.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 15.10.2024.
//

import Foundation
import RealmSwift

class RealmManager: DBManager {
    static let shared = RealmManager()
    
    let realm = try! Realm()
    
    private init() {}
    
    private func getTask(with id: UUID) -> TaskRealmModel? {
        return realm.object(ofType: TaskRealmModel.self, forPrimaryKey: id)
    }
    
    func createTask(newTask: CreateTaskEntity) -> TaskEntity? {
        let task = TaskRealmModel(content: newTask.content, dueDate: newTask.dueDate)
        
        do {
            try realm.write {
                realm.add(task)
            }
            
            return TaskEntity(from: task)
        } catch {
            print(error.localizedDescription)
            
            return nil
        }
    }
    
    func editTask(task: TaskEntity) -> Bool {
        guard let taskToEdit = getTask(with: task.id) else {
            return false
        }
        
        do {
            try realm.write {
                taskToEdit.content = task.content
                taskToEdit.dueDate = task.dueDate
                taskToEdit.notificationsOn = task.notificationsOn
                taskToEdit.isCompleted = task.isCompleted
            }
            
            return true
        } catch {
            print(error.localizedDescription)
            
            return false
        }
    }
    
    func deleteTask(id: UUID) -> Bool {
        guard let taskToDelete = getTask(with: id) else {
            return false
        }
        
        do {
            try realm.write {
                realm.delete(taskToDelete.subtasks)
                realm.delete(taskToDelete)
            }
            
            return true
        } catch {
            print(error.localizedDescription)
            
            return false
        }
    }
    
    func getTasks() -> [TaskEntity]? {
        let tasks = realm.objects(TaskRealmModel.self)
        let taskEntities = tasks.map{task in TaskEntity(from: task)}
        
        return taskEntities.dropLast(0) // Just to make it return an array instead of LazySequence
    }
    
    func createSubtask(newSubtask: CreateSubtaskEntity) -> SubtaskEntity? {
        guard let parentTask = realm.object(ofType: TaskRealmModel.self, forPrimaryKey: newSubtask.parentTaskId) else {
            return nil
        }
        
        let subtask = SubtaskRealmModel(content: newSubtask.content, parentTask: parentTask)
        
        do {
            try realm.write {
                realm.add(subtask)
            }
                        
            return SubtaskEntity(from: subtask)
        } catch {
            print(error.localizedDescription)
            
            return nil
        }
    }
    
    private func getSubtask(with id: UUID) -> SubtaskRealmModel? {
        return realm.object(ofType: SubtaskRealmModel.self, forPrimaryKey: id)
    }
    
    func editSubtask(subtask: SubtaskEntity) -> Bool {
        guard let subtaskToEdit = getSubtask(with: subtask.id) else {
            return false
        }
        
        do {
            try realm.write {
                subtaskToEdit.content = subtask.content
                subtaskToEdit.isCompleted = subtask.isCompleted
            }
            
            return true
        } catch {
            print(error.localizedDescription)
            
            return false
        }
    }
    
    func deleteSubtask(id: UUID) -> Bool {
        guard let subtaskToDelete = getSubtask(with: id) else {
            return false
        }
        
        do {
            try realm.write {
                realm.delete(subtaskToDelete)
            }
            
            return true
        } catch {
            print(error.localizedDescription)
            
            return false
        }
    }
    
    func getSubtasks(for taskId: UUID) -> [SubtaskEntity]? {
        let substasks = realm
            .objects(SubtaskRealmModel.self)
            .where{$0.parentTask.id == taskId}
        
        let subtaskEntities = substasks.map{subtask in SubtaskEntity(from: subtask)}
        
        return subtaskEntities.dropLast(0) // Just to make it return an array instead of LazySequence
    }
}
