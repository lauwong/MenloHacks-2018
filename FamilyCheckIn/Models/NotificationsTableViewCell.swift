//
//  ContactsTableViewCell.swift
//  FamilyCheckIn
//
//  Created by Lauren Wong on 3/10/18.
//  Copyright © 2018 MenloHacks. All rights reserved.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell  {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
