//
//  BackgroundViewController.swift
//  FamilyCheckIn
//
//  Created by Lauren Wong on 3/11/18.
//  Copyright © 2018 MenloHacks. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase

class ResponsesViewController: UITableViewController {
    
    var notificationDisplays = [NotificationEvent]()
    var ref = Database.database().reference(withPath: "activeNotifications")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref.observe(.value, with: { snapshot in
            // 2
            var newItems: [NotificationEvent] = []
            
            // 3
            for item in snapshot.children {
                // 4
                let notificationItem = NotificationEvent(snapshot: item as! DataSnapshot)
                
                if(notificationItem.receiver == UIDevice.current.identifierForVendor!.uuidString) {
                    newItems.append(notificationItem)
                }
            }
            
            // 5
            self.notificationDisplays = newItems
            self.tableView.reloadData()
            //print(snapshot)
        }) {(error) in
            print(error.localizedDescription)
        }
    }
}
