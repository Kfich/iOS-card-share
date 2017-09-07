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
    var verifiedCards = [ContactCard]()
    
    var hiddenCardIds = [String]()
    
    // IBOutlets
    // ---------------------------------
    @IBOutlet var viewTitleLabel: UILabel!
    @IBOutlet var optionsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set title 
        if ContactManager.sharedManager.hideCardsSelected {
            // Set titleview
            self.viewTitleLabel.text = "Manage Cards"
        }else{
            // Set titleview
            self.viewTitleLabel.text = "Manage Badges"
        }

        
    }
    
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
        
        // Parse for verified cards 
        for val in ContactManager.sharedManager.viewableUserCards{
            // Check if verified
            if val.isVerified {
                // Add to list
                self.verifiedCards.append(val)
            }
        }
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        ContactManager.sharedManager.hideCardsSelected = false
        ContactManager.sharedManager.hideBadgesSelected = false
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
        
    /*
        for i in 0 ..< ContactManager.sharedManager.viewableUserCards.count - 1{
            // Init card
            let card = ContactManager.sharedManager.viewableUserCards[i]
            // Check if hidden
            if card.isHidden == true{
                // Append to hidden list
                //hiddenCards.append(card.cardId!)
                print("This card is hidden >> \(card.cardId) \n\(card.profileDictionary)")
            }else{
                print("Card is visible >> \(card.cardId)")
            }
        }

        
        
        
        
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
        //UDWrapper.setArray("hidden_cards", value: hiddenCards as NSArray)*/
        
        // Drop vc
        dismiss(animated: true, completion: nil)
    }
    
    
    
    // TableView DataSource && Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if ContactManager.sharedManager.hideCardsSelected {
            // Return count
             return ContactManager.sharedManager.currentUserCards.count
            
        }else{
            // Set titleview
             return ContactManager.sharedManager.currentUser.userProfile.badgeList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        // Init cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsViewCell
        self.configureSelectedImageView(imageView: cell.badgeImageView)
        // Set text
        //cell.textLabel?.text = currentUserCards[indexPath.row].cardName
        // Set text
        
        if ContactManager.sharedManager.hideCardsSelected {
            // Set current card
            cell.currentCard = ContactManager.sharedManager.currentUserCards[indexPath.row]
            
            // Toggle switch based on value
            //cell.toggleSwitchOnInit()
            
            // Return count
            cell.badgeName.text = cell.currentCard.cardName//ContactManager.sharedManager.viewableUserCards[indexPath.row].cardName
            cell.badgeToggleSwitch.isOn = !(cell.currentCard.isHidden)//ContactManager.sharedManager.viewableUserCards[indexPath.row].isHidden
            
            
            if ContactManager.sharedManager.currentUserCards[indexPath.row].cardProfile.images.count > 0{
                // Add card image
                cell.badgeImageView.image =  UIImage(data:ContactManager.sharedManager.currentUserCards[indexPath.row].cardProfile.images[0]["image_data"] as! Data)
            }else{
                // Set user prof image
                if ContactManager.sharedManager.currentUser.profileImages.count > 0{
                    cell.badgeImageView.image = UIImage(data: ContactManager.sharedManager.currentUser.profileImages[0]["image_data"] as! Data)
                }

            }
            
            
        }else{
            // Set titleview
            cell.currentBadge = ContactManager.sharedManager.currentUser.userProfile.badgeList[indexPath.row]
            cell.badgeName.text = cell.currentBadge.website
            let fileUrl = NSURL(string: cell.currentBadge.pictureUrl)
            cell.badgeImageView.setImageWith(fileUrl! as URL)
            cell.badgeToggleSwitch.isOn = !(cell.currentBadge.isHidden ?? false)//ContactManager.sharedManager.currentUser.userProfile.badgeList[indexPath.row].isHidden ?? false
            
        }
        
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
    func configureSelectedImageView(imageView: UIImageView) {
        // Config imageview
        
        // Configure borders
        imageView.layer.borderWidth = 1
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 17    // Create container for image and name

    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
