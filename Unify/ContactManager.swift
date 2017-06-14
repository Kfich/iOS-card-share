//
//  ContactManager.swift
//  Unify
//
//  Created by Kevin Fich on 5/24/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import Foundation


class ContactManager{
    
    
    // Properties
    // ================================
    
    static let sharedManager = ContactManager()
    
    var userArrivedFromContactList = false
    var userArrivedFromRadar = false
    var userArrivedFromIntro = false
    
    var userArrivedFromRecipients = false
    
    // Initialize class
    init() {
    }
    
    
    // Custom methods
    
    func reset(){
        
        userArrivedFromIntro = false
        userArrivedFromRadar = false
        userArrivedFromContactList = false
        
    }
    
    
}
