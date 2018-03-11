//
//  ContactsViewController.swift
//  FamilyCheckIn
//
//  Created by Lauren Wong on 3/10/18.
//  Copyright © 2018 MenloHacks. All rights reserved.
//

import UIKit
import Firebase

class NotificationsViewController: UIViewController {
    
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
                if(notificationItem.approved){
                    newItems.append(notificationItem)
                }
            }
            
            // 5
            self.notificationDisplays = newItems
            self.tableView.reloadData()
        })
    }
    
}
