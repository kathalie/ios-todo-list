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
    
    func sendNotification(on date: Date, repeats: Bool = false, title: String, body: String) async {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
        let dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let uuid = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        
        do {
            try await notificationCenter.add(request)
            print("Local notification sent")
        } catch {
            print("Failed to send local notification: \(error.localizedDescription)")
        }
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
}
