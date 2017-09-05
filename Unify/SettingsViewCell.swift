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
    var currentCard = ContactCard()
    var currentBadge = CardProfile.Bagde()
    var cardIndex = 0
    
    
    // IBOutlets
    // ------------------------
    @IBOutlet var badgeImageView: UIImageView!
    
    @IBOutlet var incongnitoSwitch: UISwitch!
    
    @IBOutlet var syncContactsSwitch: UISwitch!
    
    // For card/badges vc
    @IBOutlet var badgeToggleSwitch: UISwitch!
    @IBOutlet var badgeName: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Check for status of switch
        //self.toggleSwitchOnInit()
        
        addObservers()
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
    
    // Handle badge toggles
    
    @IBAction func badgeToggleSelected(_ sender: Any) {
        // Init status
        var boolStatus = Bool()
        
        print("View tag >> \(String(describing: (sender as AnyObject).view?.tag))")
        
        // Check for swicth
        if badgeToggleSwitch.isOn == false {
            // Test
            print("Toggled off")
            // Set bool
            boolStatus = false
            
            // Toggle card value
            //currentCard.isHidden = false
            
            //print("Current Card Hidden? : \(currentCard.isHidden)")
            
        }else{
            // Test
            print("Toggled on")
            
            // Set status 
            boolStatus = true
            
            // Toggle card value
            //currentCard.isHidden = true
            
            //print("Current Card Hidden? : \(currentCard.isHidden)")
        }
        
        if ContactManager.sharedManager.hideCardsSelected {
            // Follow hide card flow
            // Update card & Send to server
            self.toggleCardVisibility(card: currentCard, status: boolStatus)
        }else{
            // Follow badge flow
            self.toggleBadgeVisibility(badge: currentBadge, status: boolStatus)
            
        }
        
    }
    
    // Custom Methods
    // ---------------------------------
    func toggleSwitchOnInit() {
        // Check for the status
        if currentCard.isHidden{
            // Set to false
            badgeToggleSwitch.isOn = false
        }else{
            // Toggle true
            badgeToggleSwitch.isOn = true
        }

    }

    func toggleBadgeVisibility(badge: CardProfile.Bagde, status: Bool) {
        // Check original status
        print("Badge Toggle Original >> \(badge.isHidden)")
        
        // Set status
        badge.isHidden = status
        
        // Check post status
        print("Badge Toggle Changed >> \(badge.isHidden)")
        
        // Post Refresh
        postNotificationForBadgeRefresh()
       
       /*
        var viewableIndex = 0
        
        // Viewable cards
        for viewable in 0..<ContactManager.sharedManager.viewableUserCards.count{
            
            let viewableCard = ContactManager.sharedManager.viewableUserCards[viewableIndex]
            
            print("Viewable card List isHidden: \(viewableCard.cardId) \(viewableCard.isHidden)")
            
            
            // Increment
            viewableIndex = viewableIndex + 1
        }
        
        // Contact manager set status
        ContactManager.sharedManager.setCardToVisible(cardIdString: currentCard.cardId!, status: status)*/
        
    }
    
    
    func toggleCardVisibility(card: ContactCard, status: Bool) {
        // Check original status
        print("Card Toggle Original >> \(card.isHidden)")
        
        // Set status
        card.isHidden = status
        
        // Check post status
        print("Card Toggle Changed >> \(card.isHidden)")
        
        
        var viewableIndex = 0
        
        // Viewable cards
        for viewable in 0..<ContactManager.sharedManager.viewableUserCards.count{
            
            let viewableCard = ContactManager.sharedManager.viewableUserCards[viewableIndex]
            
            print("Viewable card List isHidden: \(viewableCard.cardId) \(viewableCard.isHidden)")
            
            
            // Increment
            viewableIndex = viewableIndex + 1
        }
        
        // Contact manager set status
        ContactManager.sharedManager.setCardToVisible(cardIdString: currentCard.cardId!, status: status)

    }
    
    
    
    func updateSelectedCard(card: ContactCard) {
        
        // Print card to see if generated
        card.printCard()
        
        // Set card copy to selected
        self.currentCard = card
        
        // Overwrite card to current user object card suite
        
        // Remove original from array
        ContactManager.sharedManager.deleteCardFromArray(cardIdString: card.cardId!)
        
        // Insert to manager card array
        ContactManager.sharedManager.currentUserCardsDictionaryArray.insert([self.currentCard.toAnyObjectWithImage()], at: 0)
        
        // Set array to defualts
        UDWrapper.setArray("contact_cards", value: ContactManager.sharedManager.currentUserCardsDictionaryArray as NSArray)
        
        // Send to server
        let parameters = ["data" : self.currentCard.toAnyObject(), "uuid" : self.currentCard.cardId!] as [String : Any]
        print("\n\nTHE CARD TO ANY - PARAMS")
        print(parameters)
        
        // Connection to DB
        Connection(configuration: nil).updateCardCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Card Created Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                let dictionary : Dictionary = response as! [String : Any]
                self.currentCard.cardId = dictionary["uuid"] as? String
                
                // Hide HUD
                KVNProgress.showSuccess(withStatus: "Card Status Updated!")
                
                // Post notif for other views to refresh
                self.postNotificationForCardRefresh()
                
            } else {
                print("Card Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error creating your card. Please try again.")
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
    }
    
    func postNotificationForCardRefresh() {
        // Notify other VC's to update cardviews
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshViewable"), object: self)
        
        
        //RefreshViewable
    }
    
    func postNotificationForBadgeRefresh() {
        print("Refresh badges!")
        // Notify other VC's to update cardviews
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshBadges"), object: self)
        
        
        //RefreshViewable
    }
    
    func addObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(SettingsViewCell.toggleSwitch), name: NSNotification.Name(rawValue: "IncognitoOff"), object: nil)
        
    }

    func toggleSwitch() {
        // Toggle
        self.incongnitoSwitch.isOn = false
    }
    
    

}
