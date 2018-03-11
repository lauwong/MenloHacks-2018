//
//  Notification.swift
//  FamilyCheckIn
//
//  Created by Lauren Wong on 3/10/18.
//  Copyright © 2018 MenloHacks. All rights reserved.
//

import UIKit
import Firebase

class NotificationEvent {
    var notifier: String
    var reciever: String
    var date: String
    var numberOf: Int
    var startTime: String
    var interval: String
    let ref: DatabaseReference?
    let key: String
    
    init?(notifier: String, reciever: String, date: String, numberOf: Int, startTime: String, interval: String, key: String = "") {
        if(notifier.isEmpty || reciever.isEmpty || date.isEmpty || startTime.isEmpty || interval.isEmpty) {
            return nil
        }
        self.key = key
        self.notifier = notifier
        self.reciever = reciever
        self.date = date
        self.numberOf = numberOf
        self.startTime = startTime
        self.interval = interval
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        notifier = snapshotValue["notifier"] as! String
        reciever = snapshotValue["reciever"] as! String
        date = snapshotValue["date"] as! String
        numberOf = snapshotValue["numberOf"] as! Int
        startTime = snapshotValue["startTime"] as! String
        interval = snapshotValue["intervalTime"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "notifier": notifier,
            "receiver": reciever,
            "date": date,
            "numberOf": numberOf,
            "startTime": startTime,
            "interval": interval
        ]
    }
}
