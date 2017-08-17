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
    var transaction = Transaction()
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
    
    @IBOutlet var cancelIntroButton: UIButton!
    
    
    // Page Config
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        //self.contactCard.awakeFromNib()
        //self.recipientCard.awakeFromNib()
        
        // Add Obersvers
        addObservers()
        
        // Check if user came from contact list 
        if ContactManager.sharedManager.userArrivedFromContactList {
            // Execute call to configure views
            self.configureViewForContact()
            
            // Reset Manager value to false 
            ContactManager.sharedManager.userArrivedFromContactList = false
        }
        
        // Configure imageviews
        self.configureSelectedImageView(imageView: contactImageView)
        self.configureSelectedImageView(imageView: recipientImageView)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set current User object
        currentUser = ContactManager.sharedManager.currentUser
        
        // Add Tap Gesture to imageviews
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showContactList))
        
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        // Hide cancel button
        cancelIntroButton.isHidden = true
        
        //
        
        
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
        
        // Create Transaction and send 
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
            var recipientName = ""
            var phone = ""
            var email = ""
            //var title = ""
            
            
            // CNContact Objects
            let contact = ContactManager.sharedManager.contactToIntro
            let recipient = ContactManager.sharedManager.recipientToIntro
            
            // Check if they both have email
            name = formatter.string(from: contact) ?? "No Name"
            recipientName = formatter.string(from: recipient) ?? ""
            
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
            
            // Configure message
            let str = "Hi \(name), Please meet \(recipientName). Thought you should connect. You are both doing some cool projects and thought you might be able to work together. \n\nYou two can take it from here! \n\nBest, \n\(currentUser.getName()) \n\n"
            
            composeVC.body = str
            
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
        var recipientName = ""
        var phone = ""
        var emailContact = ""
        var emailRecipient = ""
        //var title = ""
        
        
        // CNContact Objects
        let contact = ContactManager.sharedManager.contactToIntro
        let recipient = ContactManager.sharedManager.recipientToIntro
        
        // Check if they both have email
        name = formatter.string(from: contact) ?? "No Name"
        recipientName = formatter.string(from: recipient) ?? "No Name"
        
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
        
        let str = "Hi \(name), Please meet \(recipientName). Thought you should connect. You are both doing some cool projects and thought you might be able to work together. \n\nYou two can take it from here! \n\nBest, \n\(currentUser.fullName) \n\n"
        
        // Create Message
        mailComposerVC.setToRecipients([emailContact, emailRecipient])
        mailComposerVC.setSubject("Unify Intro - \(name) meet \(recipientName)")
        mailComposerVC.setMessageBody(str, isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    
    // Custom Methods
    
    func createTransaction(type: String) {
        
        // Set type & Transaction data
        transaction.type = type
        transaction.setTransactionDate()
        transaction.senderName = ContactManager.sharedManager.currentUser.getName()
        transaction.senderId = ContactManager.sharedManager.currentUser.userId
        transaction.type = "introduction"
        transaction.scope = "transaction"
        transaction.senderCardId = ContactManager.sharedManager.selectedCard.cardId!
        
        // Show progress hud
        KVNProgress.show(withStatus: "Making the introduction...")
        
        // Save card to DB
        let parameters = ["data": self.transaction.toAnyObject()]
        print(parameters)
        
        // Send to server
        
        Connection(configuration: nil).createTransactionCall(parameters as! [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Card Created Response ---> \(response)")
                
                // Set card uuid with response from network
                /*let dictionary : Dictionary = response as! [String : Any]
                self.transaction.transactionId = (dictionary["uuid"] as? String)!*/
                
                // Insert to manager card array
                //ContactManager.sharedManager.currentUserCardsDictionaryArray.insert([card.toAnyObjectWithImage()], at: 0)
                
                // Hide HUD
                KVNProgress.dismiss()
                
            } else {
                print("Card Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error with your introduction. Please try again.")
                
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
    }

    
    // For sending notifications to the default center for other VC's that are listening
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(IntroViewController.configureViewForContact), name: NSNotification.Name(rawValue: "ContactSelected"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(IntroViewController.configureViewForRecipient), name: NSNotification.Name(rawValue: "RecipientSelected"), object: nil)
    }
    
    func showContactList() {
        // Perform seggy
        // Sync up with main queue
        
        
        if ContactManager.sharedManager.userArrivedFromIntro != true{
            DispatchQueue.main.async {
                // Set selected tab
                self.performSegue(withIdentifier: "showIntroContactList", sender: self)
            }
        }else{
            self.performSegue(withIdentifier: "showRecipientOptions", sender: self)
        }
    }
    
    func resetViews() {
        
        // Set Label
        self.addRecipientLabel.text = "Add Contact"
        self.addContactLabel.text = "Add Contact"
        
        // Reset Images 
        contactImageView.image = UIImage(named: "intro-white")
        recipientImageView.image = UIImage(named: "intro-white")
        
        // Reset Contact Managers
        ContactManager.sharedManager.contactToIntro = CNContact()
        ContactManager.sharedManager.recipientToIntro = CNContact()
        
        // Reset Navigation Bool
        ContactManager.sharedManager.userArrivedFromIntro = false
    }
    
    func configureViewForContact(){
        
        // Show cancel button 
        cancelIntroButton.isHidden = false
        
        // Set selected contact
        let selected = ContactManager.sharedManager.contactToIntro
        // Check if image data available
        
         if selected.imageDataAvailable {
         
            print("Has IMAGE")
         // Create image var
            let image = UIImage(data: selected.imageData!)
            
            let view = self.resizeImageView(selectedImage: image!)
            
            
            // Set image for contact
            contactImageView.image = view.image
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
    
    func configureSelectedImageView(imageView: UIImageView) {
        // Config imageview
        
        // Set image to imageview
        //let imageView = UIImageView()
        
        // Configure borders
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.layer.borderWidth = 1
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 65    // Create container for image and name
        
        // Changed the image rendering size
        //imageView.frame = CGRect(x: 10, y: 0 , width: 40, height: 40)
        
    }
    
    func resizeImageView(selectedImage: UIImage) -> UIImageView{
        // Config imageview
        
        // Set image to imageview
        let imageView = UIImageView(image: selectedImage)
        
        // Configure borders
        imageView.layer.borderColor = UIColor.blue.cgColor
        imageView.layer.borderWidth = 1
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 75    // Create container for image and name
        
        // Changed the image rendering size
        imageView.frame = CGRect(x: 10, y: 0 , width: 125, height: 125)
        
        return imageView
    }


    
    // MARK: MFMailComposeViewControllerDelegate Method
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if result == .cancelled {
            // User cancelled
            print("User cancelled")
            
        }else if result == .sent{
            // User sent
            self.createTransaction(type: "connection")
            // Dimiss vc
            self.dismiss(animated: true, completion: nil)
            
        }else{
            // There was an error
            KVNProgress.showError(withStatus: "There was an error sending your message. Please try again.")
            
        }
        
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    // Message Composer Delegate
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        if result == .cancelled {
            // User cancelled
            print("Cancelled")
            
        }else if result == .sent{
            // User sent
            // Create transaction
            self.createTransaction(type: "connection")
            // Dismiss VC
            self.dismiss(animated: true, completion: nil)
            
        }else{
            // There was an error
            KVNProgress.showError(withStatus: "There was an error sending your message. Please try again.")
            
        }

        
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
