//
//  Notification.swift
//  FamilyCheckIn
//
//  Created by Lauren Wong on 3/10/18.
//  Copyright © 2018 MenloHacks. All rights reserved.
//

import UIKit
import Firebase

class Notification {
    var notifier: String
    var reciever: String
    var date: String
    var numberOf: Int
    var startHour: Int
    var startMin: Int
    var intervalHour: Int
    var intervalMin: Int
    let ref: DatabaseReference?
    let key: String
    
    init?(notifier: String, reciever: String, date: String, numberOf: Int, startHour: Int, startMin: Int, intervalHour: Int, intervalMin: Int, key: String = "") {
        if(notifier.isEmpty || reciever.isEmpty || date.isEmpty || key.isEmpty) {
            return nil
        }
        self.key = key
        self.notifier = notifier
        self.reciever = reciever
        self.date = date
        self.numberOf = numberOf
        self.startHour = startHour
        self.startMin = startMin
        self.intervalHour = intervalHour
        self.intervalMin = intervalMin
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        notifier = snapshotValue["notifier"] as! String
        reciever = snapshotValue["reciever"] as! String
        date = snapshotValue["date"] as! String
        numberOf = snapshotValue["numberOf"] as! Int
        startHour = snapshotValue["startTime"] as! Int
        startMin = snapshotValue["startMin"] as! Int
        intervalHour = snapshotValue["intervalHour"] as! Int
        intervalMin = snapshotValue["intervalMin"] as! Int
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "notifier": notifier,
            "receiver": reciever,
            "date": date,
            "numberOf": numberOf,
            "startHour": startHour,
            "startMin": startMin,
            "intervalHour": intervalHour,
            "intervalMin": intervalMin
        ]
    }
}
