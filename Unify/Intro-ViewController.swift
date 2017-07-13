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
import MessageUI
import Contacts


class IntroViewController: UIViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate  {
    
    // Properties
    // ----------------------------------------

    var currentUser = User()
    var active_card_unify_uuid: String?
    
    // Bool checks to config share intraction 
    var shouldSendEmail = false
    var shouldSendSMS = false
    
    // Check to toggle share button
    var contactAndRecipientSelected = false
    
    
    // Contact formatter
    let formatter = CNContactFormatter()
    
    // IBOutlets
    // ----------------------------------------
    
    @IBOutlet var contactImageView: UIImageView!
    @IBOutlet var recipientImageView: UIImageView!
    
    @IBOutlet var contactWrapperView: UIView!
    @IBOutlet var recipientWrapperView: UIView!
    
    @IBOutlet var addContactLabel: UILabel!
    @IBOutlet var addRecipientLabel: UILabel!
    
    
    // Page Config
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        //self.contactCard.awakeFromNib()
        //self.recipientCard.awakeFromNib()
        
        // Add Obersvers
        addObservers()
        
        //
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populate cards 
        
        // Add Tap Gesture to imageviews
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showContactList))
        
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        /*self.contactImageView.isUserInteractionEnabled = true
        self.contactImageView.addGestureRecognizer(tapGestureRecognizer)
        
        self.recipientImageView.isUserInteractionEnabled = true
        self.recipientImageView.addGestureRecognizer(tapGestureRecognizer)
        
        // Set recognizer to wrapper views
        self.contactWrapperView.isUserInteractionEnabled = true
        self.contactWrapperView.addGestureRecognizer(tapGestureRecognizer)
        
        self.recipientWrapperView.isUserInteractionEnabled = true
        self.recipientWrapperView.addGestureRecognizer(tapGestureRecognizer)*/
        
    }
    
    
    // IBActions / Buttons Pressed
    // ----------------------------------------
    
    @IBAction func makeIntroduction(_ sender: Any) {
        
        // Check if both contacts selected
        
        // CNContact Objects
        let contact = ContactManager.sharedManager.contactToIntro
        let recipient = ContactManager.sharedManager.recipientToIntro
        
        // Check if they both have email 
        
        if contact.phoneNumbers.count > 0 && recipient.phoneNumbers.count > 0 {
         
            let contactPhone = (contact.phoneNumbers[0].value).value(forKey: "digits") as? String
            let recipientPhone = (recipient.phoneNumbers[0].value).value(forKey: "digits") as? String
            
            // Launch text client
            showSMSCard()
            
         }else if contact.emailAddresses.count > 0 && recipient.emailAddresses.count > 0 {
            
            let contactEmail = contact.emailAddresses[0].value as String
            let recipientEmail = recipient.emailAddresses[0].value as String
            
            
            // Launch Email client
            showEmailCard()
            
        }else{
            // No mutual way to connect
            // Pick default based on what the contact object has populated
            
            // ***** Handle this off case tomorrow ****
            print("No Mutual Info")
        }
        
        
        // Else check if they both have phones
        
        // If no match, chose a defualt method and send
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        // Clear the user objects from manager
        // Refresh Views
        self.resetViews()
    }
    
    // Message Composer Functions
    
    func showEmailCard() {
        
        print("EMAIL CARD SELECTED")
        
        // Send post notif
        // Create instance of controller
        let mailComposeViewController = configuredMailComposeViewController()
        
        // Check if deviceCanSendMail
        if MFMailComposeViewController.canSendMail() {
            
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }
    
    func showSMSCard() {
        // Set Selected Card
        
        //selectedCardIndex = cardCollectionView.inde
        
        
        print("SMS CARD SELECTED")
        // Send post notif
        
        let composeVC = MFMessageComposeViewController()
        if(MFMessageComposeViewController .canSendText()){
            
            composeVC.messageComposeDelegate = self
            
            // 6468251231
            
            // Check for nil vals
            
            var name = ""
            var phone = ""
            var email = ""
            //var title = ""
            
            
            // CNContact Objects
            let contact = ContactManager.sharedManager.contactToIntro
            let recipient = ContactManager.sharedManager.recipientToIntro
            
            // Check if they both have email
            name = formatter.string(from: contact) ?? "No Name"
            
            if contact.phoneNumbers.count > 0 && recipient.phoneNumbers.count > 0 {
                
                let contactPhone = (contact.phoneNumbers[0].value).value(forKey: "digits") as? String
                // Set contact phone number
                phone = contactPhone!
                
                let recipientPhone = (recipient.phoneNumbers[0].value).value(forKey: "digits") as? String
                
                // Launch text client
                composeVC.recipients = [contactPhone!, recipientPhone!]
            }
    
            if contact.emailAddresses.count > 0 {
                email = (contact.emailAddresses[0].value as String)
            }
            
            composeVC.body = "Hi, I'd like to connect the two of you. Here's \(name)'s information \n\n\(name)\n\(phone)\n\(email)\n\n\n Link to download Unify!"
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
            
        }
        
    }
    
    
    // Email Composer Delegate Methods
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
        // Create Instance of controller
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        // Check for nil vals
        
        var name = ""
        var phone = ""
        var emailContact = ""
        var emailRecipient = ""
        //var title = ""
        
        
        // CNContact Objects
        let contact = ContactManager.sharedManager.contactToIntro
        let recipient = ContactManager.sharedManager.recipientToIntro
        
        // Check if they both have email
        name = formatter.string(from: contact) ?? "No Name"
        
        if contact.emailAddresses.count > 0 && recipient.emailAddresses.count > 0 {
            
            let contactEmail = contact.emailAddresses[0].value as String
            let recipientEmail = recipient.emailAddresses[0].value as String
            
            // Set variable 
            emailContact = contactEmail
            emailRecipient = recipientEmail
            
        }
        
        if contact.phoneNumbers.count > 0 {
            phone = (contact.emailAddresses[0].value as String)
        }

        
        
        // Create Message
        mailComposerVC.setToRecipients([emailContact, emailRecipient])
        mailComposerVC.setSubject("Introduction - Let's Connect")
        mailComposerVC.setMessageBody("Hi, I'd like to connect the two of you. Here's \(name)'s information \n\n\(name)\n\(phone)\n\(emailContact)\n\n\n Link to download Unify!", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    
    // Custom Methods
    
    // For sending notifications to the default center for other VC's that are listening
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(IntroViewController.configureViewForContact), name: NSNotification.Name(rawValue: "ContactSelected"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(IntroViewController.configureViewForRecipient), name: NSNotification.Name(rawValue: "RecipientSelected"), object: nil)
    }
    
    func showContactList() {
        // Perform seggy
        performSegue(withIdentifier: "showIntroContactList", sender: self)
    }
    
    func resetViews() {
        
        // Set Label
        self.addRecipientLabel.text = "Add Contact"
        self.addContactLabel.text = "Add Contact"
        
        // Reset Images 
        contactImageView.image = UIImage(named: "icn-user")
        recipientImageView.image = UIImage(named: "icn-user")
        
        // Reset Contact Managers
        ContactManager.sharedManager.contactToIntro = CNContact()
        ContactManager.sharedManager.recipientToIntro = CNContact()
        
        // Reset Navigation Bool
        ContactManager.sharedManager.userArrivedFromIntro = false
    }
    
    func configureViewForContact(){
        
        let selected = ContactManager.sharedManager.contactToIntro
        // Check if image data available
        
         if selected.imageDataAvailable {
         
            print("Has IMAGE")
         // Create image var
            let image = UIImage(data: selected.imageData!)
            // Set image for contact
            contactImageView.image = image
         }else{
         // Set to placeholder image
            contactImageView.image = UIImage(named: "profile")
         }
        
        // Set Label w name
        let name = formatter.string(from: selected) ?? "No Name"
        self.addContactLabel.text = name
        
    }
    func configureViewForRecipient(){
        
        let selected = ContactManager.sharedManager.recipientToIntro
        // Check if image data available
        
        if selected.imageDataAvailable {
            
            print("Has IMAGE")
            // Create image var
            let image = UIImage(data: selected.imageData!)
            // Set image for contact
            recipientImageView.image = image
        }else{
            // Set to placeholder image
            recipientImageView.image = UIImage(named: "profile")
        }
        
        // Set Label w name
        let name = formatter.string(from: selected) ?? "No Name"
        self.addRecipientLabel.text = name
        
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // Message Composer Delegate
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        // Make checks here for
        controller.dismiss(animated: true) {
            print("Message composer dismissed")
        }
    }
    

    
    
    // Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print(">Passed Contact Card ID")
        //print(sender)
                
    }

}
