//
//  LocalNotificationsService.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 16.10.2024.
//

import Foundation
import UserNotifications

class LocalNotificationsService {
    static let shared = LocalNotificationsService()
    
    private init() {}
    
    private var notificationCenter: UNUserNotificationCenter {
        UNUserNotificationCenter.current()
    }
    
    func scheduleNotification(_ id: UUID, on date: Date, repeats: Bool = false, title: String, body: String) async {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
        let dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)
                
        do {
            try await notificationCenter.add(request)
            print("Local notification scheduled")
        } catch {
            print("Failed to send local notification: \(error.localizedDescription)")
        }
    }
    
    func removeNotification(_ id: UUID) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [id.uuidString])
        
        print("Notification removed")
    }
    
    func requestNotificationAuthorisation() async -> Bool{
        do {
            print("Will request authorisation")
            try await notificationCenter.requestAuthorization(options: [.alert, .badge, .sound])
            print("Did request authorisation")
        } catch {
            print("No authorisation for local notifications: \(error.localizedDescription)")
            return false
        }
        
        return true
    }
    
//    var notificationsAllowed: Bool? {
//        get async {
//            let authorisationStatus = await notificationCenter.notificationSettings().authorizationStatus
//            
//            if authorisationStatus == .notDetermined {
//                return nil
//            }
//            
//            return authorisationStatus == .authorized
//        }
//    }
    
    func cancelAllNotifications() {
        print("Will remove all pending notifications")
        
        notificationCenter.removeAllPendingNotificationRequests()
    }
}
