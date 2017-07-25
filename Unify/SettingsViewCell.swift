//
//  SettingsViewCell.swift
//  Unify
//
//  Created by Kevin Fich on 7/25/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit

class SettingsViewCell: UITableViewCell {
    
    // Properties 
    // ------------------------
    
    
    // IBOutlets
    // ------------------------
    @IBOutlet var incongnitoSwitch: UISwitch!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // IBActions
    // --------------------------
    @IBAction func incognitoSwitchToggled(_ sender: Any) {
        
        // Post notification
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "IncognitoToggled"), object: self)
        
    }
    

}
