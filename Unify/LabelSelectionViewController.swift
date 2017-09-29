//
//  LabelSelectionViewController.swift
//  Unify
//
//  Created by Kevin Fich on 9/13/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit
import Eureka

class LabelSelectionViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Multivalued examples"
        form +++
            Section("Select Label")
            <<< ButtonRow(){
                $0.title = "home"
                
                }.cellUpdate { cell, row in
                    cell.textLabel?.textAlignment = .left
                    cell.textLabel?.textColor = UIColor.black
                
                }.onCellSelection({ (cell, row) in
                    
                    // Set path
                    ContactManager.sharedManager.labelPathWithIntent["label_value"] = "home"
                    
                    print("Manager label path with intent", ContactManager.sharedManager.labelPathWithIntent)
                    
                    // Post notif
                    self.postNotificationForUpdate()
                    
                
                    self.dismiss(animated: true, completion: {
                    // Print to test
                    print("Home selected")
                    
                })
            })
            <<< ButtonRow(){
                $0.title = "work"
                }.cellUpdate { cell, row in
                    cell.textLabel?.textAlignment = .left
                    cell.textLabel?.textColor = UIColor.black
                    
                }.onCellSelection({ (cell, row) in
                    // Set path
                    ContactManager.sharedManager.labelPathWithIntent["label_value"] = "work"
                    
                    print("Manager label path with intent", ContactManager.sharedManager.labelPathWithIntent)
                    
                    // Post notif
                    self.postNotificationForUpdate()
                    
                    self.dismiss(animated: true, completion: {
                        // Print to test
                        print("Work selected")
                        
                    })
                })
            /*
            <<< ButtonRow(){
                $0.title = "Personal"
                
                }.cellUpdate { cell, row in
                    cell.textLabel?.textAlignment = .left
                    
                }.onCellSelection({ (cell, row) in
                    
                    // Set path
                    ContactManager.sharedManager.labelPathWithIntent["label_value"] = "personal"
                    
                    print("Manager label path with intent", ContactManager.sharedManager.labelPathWithIntent)
                    
                    // Post notif
                    self.postNotificationForUpdate()
                    
                    self.dismiss(animated: true, completion: {
                        // Print to test
                        print("Personal selected")
                    })
                })*/
            <<< ButtonRow(){
                $0.title = "mobile"
        
                }.cellUpdate { cell, row in
                    cell.textLabel?.textAlignment = .left
                    cell.textLabel?.textColor = UIColor.black
                    
                }.onCellSelection({ (cell, row) in
                    
                    // Set path
                    ContactManager.sharedManager.labelPathWithIntent["label_value"] = "mobile"
                    
                    print("Manager label path with intent", ContactManager.sharedManager.labelPathWithIntent)
                    
                    // Post notif
                    self.postNotificationForUpdate()
                    
                    self.dismiss(animated: true, completion: {
                        // Print to test
                        print("Mobile selected")
                    })
                })
            <<< ButtonRow(){
                $0.title = "Other"
                
                }.cellUpdate { cell, row in
                    cell.textLabel?.textAlignment = .left
                    cell.textLabel?.textColor = UIColor.black
                    
                }.onCellSelection({ (cell, row) in
                    
                    // Set path
                    ContactManager.sharedManager.labelPathWithIntent["label_value"] = "other"
                    
                    print("Manager label path with intent", ContactManager.sharedManager.labelPathWithIntent)
                    
                    // Post notif
                    self.postNotificationForUpdate()
                    
                    self.dismiss(animated: true, completion: {
                        // Print to test
                        print("Other selected")
                    })
                })

    }
    
    func postNotificationForUpdate() {
        
        // Notification for radar screen
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Update Labels"), object: self)
        
        //UpdateCurrentUserProfile
        
    }
    
    
}

