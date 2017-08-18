//
//  HideProfileDataViewController.swift
//  Unify
//
//  Created by Kevin Fich on 8/15/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit

class HideProfileDataViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    // Properties
    // ---------------------------------
    var currentUser = User()
    var currentUserCards = [ContactCard]()
    var currentUserBadges =  [UIImage]()
    var selectedCards = [ContactCard]()
    var editedCard = ContactCard()
    
    var hiddenCardIds = [String]()
    
    // IBOutlets
    // ---------------------------------
    @IBOutlet var viewTitleLabel: UILabel!
    @IBOutlet var optionsTableView: UITableView!
    
    
    // Page Setup
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        // Do any additional setup after loading the view.
        // Set cards array
        self.currentUserCards = ContactManager.sharedManager.currentUserCards
        
        if ContactManager.sharedManager.hideCardsSelected {
            // Set titleview
            self.viewTitleLabel.text = "Manage Cards"
        }else{
            // Set titleview
            self.viewTitleLabel.text = "Manage Badges"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions
    // ---------------------------------
    @IBAction func backButtonPressed(_ sender: Any) {
        // Drop vc
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func doneHidingCards(_ sender: Any) {
        
    
        // Init temp
        var hiddenCards = [String]()
        // Set hidden cards array
        for i in 0 ..< ContactManager.sharedManager.currentUserCards.count - 1{
            // Init card
            let card = ContactManager.sharedManager.currentUserCards[i]
            // Check if hidden
            if card.isHidden == true{
                // Append to hidden list
                hiddenCards.append(card.cardId!)
            }else{
                print("Card is visible >> \(card.cardId)")
            }
        }
        
        // Set hidden list
        UDWrapper.setArray("hidden_cards", value: hiddenCards as NSArray)
        
        // Drop vc
        dismiss(animated: true, completion: nil)
    }
    
    
    
    // TableView DataSource && Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContactManager.sharedManager.currentUserCards.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        // Init cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsViewCell
        
        // Set text
        //cell.textLabel?.text = currentUserCards[indexPath.row].cardName
        // Set text
        
        cell.badgeName.text = ContactManager.sharedManager.currentUserCards[indexPath.row].cardName
        cell.badgeToggleSwitch.isOn = ContactManager.sharedManager.currentUserCards[indexPath.row].isHidden
        
        //cell.swict
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell selected code here
        
        print("Item selected at index : \(indexPath.row), nice...")
    }
    
    // Custom methods
    func fetchHiddenCards() {
        
        if let hiddenArray = UDWrapper.getArray("hidden_cards"){
            
            let count = 0
            
            for value in ContactManager.sharedManager.currentUserCards {
                // Check id against hidden vals
                let id = value.cardId
                
                if hiddenArray.contains(id){
                    // Hard is hidden
                    value.isHidden = true
                }else{
                    print("Card visible")
                }
                
            }
            
        }else{
            print("User has no cards")
        }
    }
    
    
    func postNotificationForCardRefresh() {
        // Notify other VC's to update cardviews
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CardFinishedEditing"), object: self)

        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
