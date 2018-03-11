//
//  User.swift
//  FamilyCheckIn
//
//  Created by Lauren Wong on 3/11/18.
//  Copyright © 2018 MenloHacks. All rights reserved.
//

import UIKit
import Firebase

class User {
    var uuid: String
    let key: String
    
    init?(uuid: String, key: String = "") {
        if (uuid.isEmpty) {
            return nil
        }
        
        self.key = key
        self.uuid = uuid
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        uuid = snapshotValue["uuid"] as! String
    }
    
    func toAnyObject() -> Any {
        return [
            "uuid": uuid
        ]
    }
}
