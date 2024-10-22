//
//  NotificationsViewController.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 22.10.2024.
//

import UIKit

class NotificationsViewController: UITableViewController {
    struct Const {
        static let cellReuseIdentifier = "notification_cell"
    }
    
    var notificationEntities: [NotificationEntity] = []
    
    func loadNotifications() {
        guard let notificationEntities = RealmNotificationsService.shared.getNotifications()
        else {
            print("Failed to load tasks")
            
            return
        }
        
        self.notificationEntities = notificationEntities
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNotifications()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notificationEntities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.cellReuseIdentifier
        ) as! NotificationTableViewCell
        
        let notificationEntity = notificationEntities[indexPath.row]
        
        cell.config(with: notificationEntity)
        
        return cell
    }
    
    
}
