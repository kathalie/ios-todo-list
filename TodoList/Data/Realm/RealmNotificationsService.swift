//
//  RealmNotificationsService.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 22.10.2024.
//

import Foundation
import RealmSwift

class RealmNotificationsService {
    static let shared = RealmNotificationsService()
    
    let realm = try! Realm()
    
    private init() {}
    
    private func getNotification(with id: UUID) -> NotificationRealmModel? {
        return realm.object(ofType: NotificationRealmModel.self, forPrimaryKey: id)
    }
    
    func createNotification(newNotification: CreateNotificationEntity) -> NotificationEntity? {
        let notification = NotificationRealmModel(
            content: newNotification.content,
            dueDate: newNotification.dueDate,
            isAccepted: newNotification.isAccepted
        )
        
        do {
            try realm.write {
                realm.add(notification)
            }
            
            return NotificationEntity(from: notification)
        } catch {
            print(error.localizedDescription)
            
            return nil
        }
    }
    
    func editNotification(notification: NotificationEntity) -> Bool {
        guard let notificationToEdit = getNotification(with: notification.id) else {
            return false
        }
        
        do {
            try realm.write {
                notificationToEdit.content = notification.content
                notificationToEdit.dueDate = notification.dueDate
                notificationToEdit.isAccepted = notification.isAccepted
            }
            
            return true
        } catch {
            print(error.localizedDescription)
            
            return false
        }
    }
    
    func deleteNotification(id: UUID) -> Bool {
        guard let notificationToDelete = getNotification(with: id) else {
            return false
        }
        
        do {
            try realm.write {
                realm.delete(notificationToDelete)
            }
            
            return true
        } catch {
            print(error.localizedDescription)
            
            return false
        }
    }
    
    func getNotifications() -> [NotificationEntity]? {
        let notifications = realm.objects(NotificationRealmModel.self)
        let notificationEntities = notifications.map{notification in NotificationEntity(from: notification)}
        
        return notificationEntities.dropLast(0) // Just to make it return an array instead of LazySequence
    }
}
