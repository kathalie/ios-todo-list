//
//  CoreDataManager.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 13.10.2024.
//

import Foundation

class CoreDataManager: DBManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    private var context = CoreDataStack.shared.persistentContainer.viewContext
    
    private func getTask(by id: UUID) -> TodoTask? {
        let request = TodoTask.fetchRequest()
        
        request.predicate = NSPredicate(format: "id = \"\(id)\"")
        
        do {
            let fetchedTasks = try context.fetch(request)
            
            guard let task = fetchedTasks.first else {
                print("Failed to find task with id \(id)")
                
                return nil
            }
            
            return task
        } catch {
            print("Failed to get task with id \(id)")
            
            return nil
        }
    }
    
    func createTask(newTask: CreateTaskEntity) -> TaskEntity? {
        let task = TodoTask(context: context)
        task.content = newTask.content
        task.dueDate = newTask.dueDate
        task.notificationsOn = newTask.notificationsOn
        task.isCompleted = false
        task.id = UUID()
        
        do {
            try context.save()
            
            print("New task created")
        } catch {
            print("Failed to create task: \(error.localizedDescription)")
            
            return nil
        }
        
        return TaskEntity(from: task)
    }
    
    func editTask(task: TaskEntity) -> Bool {
        guard let taskToEdit = getTask(by: task.id) else {
            return false
        }
        
        taskToEdit.content = task.content
        taskToEdit.dueDate = task.dueDate
        taskToEdit.notificationsOn = task.notificationsOn
        taskToEdit.isCompleted = task.isCompleted
        
        do {
            try context.save()
            
            print("Task edited")
            
            return true
        } catch {
            print("Failed to edit task: \(error.localizedDescription)")
            
            return false
        }
    }
    
    func deleteTask(id: UUID) -> Bool {
        do {
            guard let taskToDelete = getTask(by: id) else {
                return false
            }
            
            context.delete(taskToDelete)
            
            try context.save()
            
            print("Task deleted")
            
            return true
        } catch {
            print("Failed to delete task: \(error.localizedDescription)")
            
            return false
        }
    }
    
    func getTasks() -> [TaskEntity]? {
        do {
            let tasks = try context.fetch(TodoTask.fetchRequest())
            var taskEntities: [TaskEntity] = []
            
            for task in tasks {
                guard let subtasks = getSubtasks(for: task.id) else {
                    return nil
                }
                
                let taskEntity = TaskEntity(from: task, with: subtasks)
                
                
                taskEntities.append(taskEntity)
            }
            
            
            return taskEntities
        } catch {
            print("Failed to get tasks: \(error.localizedDescription)")
            
            return nil
        }
    }
    
    func createSubtask(newSubtask: CreateSubtaskEntity) -> SubtaskEntity? {
        guard let parentTask = getTask(by: newSubtask.parentTaskId) else {
            return nil
        }
        
        let subtask = TodoSubtask(context: context)
        subtask.content = newSubtask.content
        subtask.isCompleted = false
        subtask.parentTask = parentTask
        subtask.id = UUID()
        
        do {
            try context.save()
            
            print("New subtask created")
        } catch {
            print("Failed to create subtask: \(error.localizedDescription)")
            
            return nil
        }
        
        return SubtaskEntity(from: subtask)
    }
    
    private func getSubtask(by id: UUID) -> TodoSubtask? {
        let request = TodoSubtask.fetchRequest()
        
        request.predicate = NSPredicate(format: "id = \"\(id)\"")
        
        do {
            let fetchedSubtasks = try context.fetch(request)
            
            guard let subtask = fetchedSubtasks.first else{
                print("Failed to find subtask with id \(id)")
                
                return nil
            }
            
            return subtask
        } catch {
            print("Failed to get subtask: \(error.localizedDescription)")
            
            return nil
        }
    }
    
    func editSubtask(subtask: SubtaskEntity) -> Bool {
        guard let subtaskToEdit = getSubtask(by: subtask.id) else {
            return false
        }
        
        subtaskToEdit.content = subtask.content
        subtaskToEdit.isCompleted = subtask.isCompleted
        
        do {
            try context.save()
            
            print("Subtask edited")
            
            return true
        } catch {
            print("Failed to edit subtask: \(error.localizedDescription)")
            
            return false
        }
    }
    
    func deleteSubtask(id: UUID) -> Bool {
        guard let subtaskToDelete = getSubtask(by: id) else {
            return false
        }
        
        do {
            context.delete(subtaskToDelete)
            
            try context.save()
            
            print("Subtask deleted")
            
            return true
        } catch {
            print("Failed to delete subtask: \(error.localizedDescription)")
            
            return false
        }
    }
    
    func getSubtasks(for taskId: UUID) -> [SubtaskEntity]? {
        let request = TodoSubtask.fetchRequest()
        
        request.predicate = NSPredicate(format: "parentTask.id = \"\(taskId)\"")
        
        do {
            let fetchedSubtasks = try context.fetch(request)
            let fetchedSubtaskEntities = fetchedSubtasks.map{subtask in SubtaskEntity(from: subtask)}
            
            return fetchedSubtaskEntities
        } catch {
            print("Failed to get subtasks: \(error.localizedDescription)")
            
            return nil
        }
    }
}
