//
//  Notification.swift
//  FamilyCheckIn
//
//  Created by Lauren Wong on 3/10/18.
//  Copyright © 2018 MenloHacks. All rights reserved.
//

import UIKit

class Notification {
    var notifier: String
    var date: String
    var numberOf: Int
    var startTime: String
    var interval: String
    
    init(notifier: String, date: String, numberOf: Int, startTime: String, interval: String) {
        self.notifier = notifier
        self.date = date
        self.numberOf = numberOf
        self.startTime = startTime
        self.interval = interval
    }
}
