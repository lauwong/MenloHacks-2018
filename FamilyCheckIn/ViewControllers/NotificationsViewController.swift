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
    
    var notificationDisplays = [NotificationEvent]()
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference(withPath: "activeNotifications")
        ref.observe(.value, with: { snapshot in
            // 2
            var newItems: [NotificationEvent] = []
            
            // 3
            for item in snapshot.children {
                // 4
                let notificationItem = NotificationEvent(snapshot: item as! DataSnapshot)
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
        let interval = String(notification.interval)
        let startTime = String(notification.startTime)
        let date = notification.date
        cell.infoLabel.text = numberOfTimes + " times, once every " + interval + "hours starting at " + startTime + " on " + date
        return cell
    }
    
    @IBAction func addNotificationPressed(_ sender: UIBarButtonItem) {
    }
    
    
}
