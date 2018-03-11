//
//  ContactsViewController.swift
//  FamilyCheckIn
//
//  Created by Lauren Wong on 3/10/18.
//  Copyright © 2018 MenloHacks. All rights reserved.
//

import UIKit
import Firebase

class NotificationsViewController: UITableViewController {
    
    var notificationDisplays = [Notification]()
    let ref = Database.database().reference(withPath: "activeNotifications")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref.observe(.value, with: { snapshot in
            // 2
            var newItems: [Notification] = []
            
            // 3
            for item in snapshot.children {
                // 4
                let notificationItem = Notification(snapshot: item as! DataSnapshot)
                newItems.append(notificationItem)
            }
            
            // 5
            self.notificationDisplays = newItems
            self.tableView.reloadData()
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "NotificationsTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NotificationsTableViewCell  else {
            fatalError("The dequeued cell is not an instance of RequestTableViewCell.")
        }
        
        let notification = notificationDisplays[indexPath.row]
        cell.nameLabel.text = notification.notifier
        let numberOfTimes = String(notification.numberOf)
        cell.infoLabel.text = numberOfTimes + " times, once every " + notification.intervalHour + ":" + notification.intervalMin + "hours starting at " + notification.startHour + ":" + notification.startMin + " on " + notification.date
    }
    
    @IBAction func addNotificationPressed(_ sender: UIBarButtonItem) {
    }
    
    
}
