//
//  Intro-ViewController.swift
//  Unify
//
//  Created by Ryan Hickman on 4/4/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//


import UIKit
import PopupDialog
import UIDropDown


class IntroViewController: UIViewController {
    
    // Properties
    // ----------------------------------------

    var active_card_unify_uuid: String?
    
    
    
    // IBOutlets
    // ----------------------------------------
    
    
    @IBOutlet weak var addContactBtn: UIButton!
    @IBOutlet var addContactView: UIView!
    
    @IBOutlet weak var addRecBtn: UIButton!
    @IBOutlet var addRecipientView: UIView!
    
    // Custom Views pulled from xib
    @IBOutlet var contactCard: BusinessCardView!
    @IBOutlet var recipientCard: ContactCardView!
    
    // Nav
    @IBOutlet var backButton: UIButton!
    
    
    // Labels
    
    @IBOutlet var cardTypeLabel: UILabel!
    
    @IBOutlet var cardViewNameLabel: UILabel!
    
    @IBOutlet var cardViewPhoneLabel: UILabel!
    
    @IBOutlet var cardViewEmailLabel: UILabel!
    
    @IBOutlet var cardViewOptionLabel: UILabel!
    
    @IBOutlet var phoneIconImage: UIImageView!
    
    @IBOutlet var emailIconImage: UIImageView!
    
    @IBOutlet var optionalIconImage: UIImageView!
    
    
    
    // Page Config
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        // Bool to track navigation patterns to dictate views appropriately from contact list
        
        self.contactCard.awakeFromNib()
        self.recipientCard.awakeFromNib()
        
        
        if ContactManager.sharedManager.userArrivedFromContactList {
            
            contactCard.isHidden = false
            backButton.isHidden = false
        }else{
            contactCard.isHidden = true
            backButton.isHidden = true
            
        }
        
        // Bool to track navigation patterns to dictate views appropriately from recipient list
        
        if ContactManager.sharedManager.userArrivedFromRecipients {
            
            recipientCard.isHidden = false
            
        }else{
            recipientCard.isHidden = true
            
        }
        
        
        // Configure views on load
        
        configureViews()
        populateCards()
        
        // Configure background image graphics
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
        
        
        // Check if uuid active
        
        print("passed token \(active_card_unify_uuid)")
        
        if active_card_unify_uuid != nil
        {
            contactCard.isHidden = false

        }
        
    }
    
    
    // IBActions / Buttons Pressed
    // ----------------------------------------
    
    
    @IBAction func addContactBtn_click(_ sender: Any) {
        
        //self.performSegue(withIdentifier: "addContactSegue", sender: nil)
        
        // Notify contact manager that the user arrived from into screen
        // So we need to add the drop controller action on contact selection
        
        ContactManager.sharedManager.userArrivedFromIntro = true
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ContactListVC")
        self.present(controller, animated: true, completion: nil)
        
        // for test purposes 
        
        //contactCard.isHidden = false
        
    }
    
    @IBAction func addRecipientSelected(_ sender: AnyObject) {
        
       /* // Set global nav bool to true on addRecipient
        ContactManager.sharedManager.userArrivedFromIntro = true
        
        // Bool to track navigation and user intent
        if ContactManager.sharedManager.userArrivedFromContactList {
            
            // show the radar screen OR screen with list of nearby users
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "NearbyContactListVC")
            self.present(controller, animated: true, completion: nil)
            
        }else{
            
            // show the contact list
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ContactListVC")
            self.present(controller, animated: true, completion: nil)

        }*/
        
        print("~~ hey ~~")
        
    }
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    // Custom Methods
    
    func configureViews(){
        
        // Add radius config & border color
        self.addContactView.layer.cornerRadius = 10.0
        self.addContactView.clipsToBounds = true
        self.addContactView.layer.borderWidth = 2.0
        self.addContactView.layer.borderColor = UIColor.lightGray.cgColor
        
        // Add radius config & border color
        self.addRecipientView.layer.cornerRadius = 10.0
        self.addRecipientView.clipsToBounds = true
        self.addRecipientView.layer.borderWidth = 2.0
        self.addRecipientView.layer.borderColor = UIColor.lightGray.cgColor

        
        
        
    }
    
    // Custom Methods
    //
    
    func populateCards(){
        
        self.contactCard.cardTypeLabel.text = "PERSONAL"
        self.contactCard.contactImageView.image = UIImage(named: "throwback.jpg")
        self.contactCard.nameLabel.text = "Harold Fich"
        self.contactCard.phoneNumberLabel.text = "1+ (123)-345-6789"
        self.contactCard.emailLabel.text = "harold.fich12@gmail.com"
        self.contactCard.optionalLabel.text = "1+ (123)-345-6789"
        
        
        self.recipientCard.infoLabel.text = "PERSONAL"
        self.recipientCard.contactImageView.image = UIImage(named: "throwback.jpg")
        self.contactCard.nameLabel.text = "Harold Fich"
        self.recipientCard.phoneNumberLabel.text = "1+ (123)-345-6789"
        self.recipientCard.emailLabel.text = "harold.fich12@gmail.com"
        

        
    }
    
    
    
    // Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        /*print(">Passed Contact Card ID")
        print(sender)
        
        if segue.identifier == "addContactSegue"
        {
            
            _ =  segue.destination as! ContactsTableViewController
            
            //nextScene.active_card_unify_uuid = "\(sender!)" as! String?
            
        }*/
                
    }

}
