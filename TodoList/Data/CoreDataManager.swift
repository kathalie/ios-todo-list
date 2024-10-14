//
//  CoreDataManager.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 13.10.2024.
//

import Foundation

class CoreDataManager: DBManager {
    private var context = CoreDataStack.shared.persistentContainer.viewContext
    
    func createTask(newTask: CreateTaskEntity) -> TaskEntity? {
        let task = Task(context: context)
        task.content = newTask.content
        task.dueDate = newTask.dueDate
        task.isCompleted = false
        task.id = UUID()
        
        do {
            try context.save()
            
            print("New task created")
        } catch {
            print(error.localizedDescription)
            
            return nil
        }
        
        return TaskEntity(from: task)
    }
    
    func editTask(task: TaskEntity) -> Bool {
        let request = Task.fetchRequest()
        
        request.predicate = NSPredicate(format: "id = \"\(task.id)\"")
        
        do {
            let fetchedTasks = try context.fetch(request)
            
            guard let taskToEdit = fetchedTasks.first else{
                print("Failed to edit task: Task with id \(task.id) does not exist")
                
                return false
            }
            
            taskToEdit.content = task.content
            taskToEdit.dueDate = task.dueDate
            taskToEdit.isCompleted = task.isCompleted
            
            try context.save()
            
            print("Task edited")
            
            return true
        } catch {
            print(error.localizedDescription)
            
            return false
        }
    }
    
    func deleteTask(id: UUID) -> Bool {
        let request = Task.fetchRequest()
        
        request.predicate = NSPredicate(format: "id = \"\(id)\"")
        
        do {
            let fetchedTasks = try context.fetch(request)
            
            guard let taskToDelete = fetchedTasks.first else{
                print("Failed to delete task: Task with id \(id) does not exist")
                
                return false
            }
            
            context.delete(taskToDelete)
            
            try context.save()
            
            print("Task edited")
            
            return true
        } catch {
            print(error.localizedDescription)
            
            return false
        }
    }
    
    private func getSubtasks(for task: Task) -> [SubtaskEntity]? {
        return []
    }
    
    func getTasks() -> [TaskEntity]? {
        do {
            let tasks = try context.fetch(Task.fetchRequest())
            var taskEntities: [TaskEntity] = []
            
            for task in tasks {
                guard let subtasks = getSubtasks(for: task) else {
                    return nil
                }
                
                let taskEntity = TaskEntity(from: task, with: subtasks)
                
                
                taskEntities.append(taskEntity)
            }
            
            
            return taskEntities
        } catch {
            print(error.localizedDescription)
            
            return nil
        }
    }
    
    func createSubtask(newSubtask: CreateSubtaskEntity) -> SubtaskEntity? {
        return nil
    }
    
    func editSubtask(subtask: SubtaskEntity) -> Bool {
        return false
    }
    
    func deleteSubtask(id: UUID) -> Bool {
        return false
    }
    
    func getSubtasks(for taskEntity: TaskEntity) -> [SubtaskEntity]? {
        return [] //TODO!!!
    }
}
