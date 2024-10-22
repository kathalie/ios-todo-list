//
//  SettingsProvider.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 17.10.2024.
//

import Foundation

struct SettingsProvider {
    private init() {}
    
    private enum UserDefaultKeys: String {
        case dbManager, allowLocalNotifications
    }
    
    private static let dbManagers: [DBManagers: DBManager] = [
        .coreData: CoreDataManager.shared,
        .realm: RealmManager.shared
    ]
    
    static var currentDbManagerRaw: String {
        return UserDefaults.standard.string(forKey: UserDefaultKeys.dbManager.rawValue) ?? DBManagers.coreData.rawValue
    }
    
    static var currentDbManager: DBManager {
        let dbManagerRaw = SettingsProvider.currentDbManagerRaw
        
        let dbManagerCase = DBManagers(rawValue: dbManagerRaw) ?? DBManagers.coreData
        
        print("DB Manager: \(dbManagerRaw)")
        
        return dbManagers[dbManagerCase]!
    }
    
    static func updateDbManager(to newDbManager: DBManagers) {
        UserDefaults.standard.set(newDbManager.rawValue, forKey: UserDefaultKeys.dbManager.rawValue)
    }
    
//    static var localNotificationsAllowed: Bool {
//        UserDefaults.standard.bool(forKey: UserDefaultKeys.allowLocalNotifications.rawValue)
//    }
//    
//    static func allowLocalNotifications() async {
//        let allowed = await LocalNotificationsService.shared.requestNotificationAuthorisation()
//        
//        guard allowed else {
//            return
//        }
//        
//        UserDefaults.standard.setValue(true, forKey: UserDefaultKeys.allowLocalNotifications.rawValue)
//        
//        // Schedule notifications for all tasks
//        DispatchQueue.main.async {
//            for dbManager in dbManagers {
//                let tasks = dbManager.value.getTasks() ?? []
//                
//                for task in tasks {
//                    Task {
//                        await LocalNotificationsService.shared.scheduleNotification(
//                            task.id,
//                            on: task.dueDate,
//                            title: "You have a due task!",
//                            body: task.content
//                        )
//                    }
//                }
//            }
//        }
//    }
//    
//    static func denyLocalNotifications() async {
//        UserDefaults.standard.setValue(false, forKey: UserDefaultKeys.allowLocalNotifications.rawValue)
//        
//        // Remove all notifications
//        LocalNotificationsService.shared.cancelAllNotifications()
//    }
}
