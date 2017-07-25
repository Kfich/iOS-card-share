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
    
    @IBOutlet var syncContactsSwitch: UISwitch!

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
        
        if incongnitoSwitch.isOn == false {
            // Do
            print("Toggled off")
            // Set currentUser incognito to flase 
            
        }else{
            // Post notification
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "IncognitoToggled"), object: self)
        }
        
    }
    
    
    @IBAction func syncContactsToggled(_ sender: Any) {
        
        if syncContactsSwitch.isOn == false {
            // Do nothing
            print("Toggled off")
            // Set currentUser incognito to flase
            
        }else{
            // Post notification
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SyncContacts"), object: self)
        }
    }
    

}
