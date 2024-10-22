//
//  RemoteNotificationsService.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 22.10.2024.
//

import Foundation
import UserNotifications

class RemoteNotificationsService {
    struct Const {
        static let category = "AddTaskCategory"
        static let addAction = "AddAction"
        static let cancelAction = "CancelAction"
        static let taskContentField = "taskContent"
        static let dueDateField = "dueDate"
    }
    
    static let shared = RemoteNotificationsService()
    
    private init() {}
    
    func registerNotificationCategories() {
        let addAction = UNNotificationAction(
            identifier: Const.addAction,
            title: "Add"
        )

        let cancelAction = UNNotificationAction(
            identifier: Const.cancelAction,
            title: "Cancel"
        )

        let taskCategory = UNNotificationCategory(
            identifier: Const.category,
            actions: [addAction, cancelAction],
            intentIdentifiers: []
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([taskCategory])
    }
    
    private func createTask(from createTaskEntity: CreateTaskEntity) {
        let createdTask = SettingsProvider.currentDbManager.createTask(newTask: createTaskEntity)
        
        guard let createdTask else {
            print("Failed to create a task from a remote notification")
            
            return
        }
        
        Task {
            await LocalNotificationsService.shared.scheduleNotification(
                createdTask.id,
                on: createdTask.dueDate,
                title: "The following task is due now",
                body: createdTask.content
            )
        }
    }
    
    private func saveNotification(for createTaskEntity: CreateTaskEntity, isAccepted: Bool) {
        let newNotification = CreateNotificationEntity(content: createTaskEntity.content, dueDate: createTaskEntity.dueDate, isAccepted: isAccepted)
        
        let createdNotification = RealmNotificationsService.shared.createNotification(newNotification: newNotification)
        
        guard let _ = createdNotification else {
            print("Failed to create a notification")
            
            return
        }
    }
    
    private func parseUserInfo(_ userInfo: [AnyHashable : Any]) -> CreateTaskEntity? {
        guard
            let taskContent = userInfo[Const.taskContentField] as? String,
            let dueDateString = userInfo[Const.dueDateField] as? String,
            let dueDate = ISO8601DateFormatter().date(from: dueDateString)
        else {
            print("Failed to parse userInfo in push notification for creating a task")
            return nil
        }
        
        return CreateTaskEntity(content: taskContent, dueDate: dueDate, notificationsOn: true)
    }
    
    private func handleAddTaskAction(userInfo: [AnyHashable : Any]) {
        guard let createTaskEntity = parseUserInfo(userInfo)
        else {
            return
        }
        
        createTask(from: createTaskEntity)
        saveNotification(for: createTaskEntity, isAccepted: true)
    }
    
    private func handleCancelAction(userInfo: [AnyHashable : Any]) {
        guard let createTaskEntity = parseUserInfo(userInfo)
        else {
            return
        }
        
        saveNotification(for: createTaskEntity, isAccepted: false)
    }
    
    func defineAction(for response: UNNotificationResponse) {
        let actionIdentifier = response.actionIdentifier
        let userInfo = response.notification.request.content.userInfo
                
        switch actionIdentifier {
        case Const.addAction:
            handleAddTaskAction(userInfo: userInfo)
        case Const.cancelAction:
            handleCancelAction(userInfo: userInfo)
        case UNNotificationDefaultActionIdentifier:
            handleAddTaskAction(userInfo: userInfo)
        default:
            break
        }
    }
}
