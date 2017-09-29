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
    
    var selectedEmail = ""
    var selectedPhone = ""
    
    
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
    @IBOutlet var shareButton: UIButton!
    
    
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
        
        // Hide share button
        shareButton.isHidden = true
        
        
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
        
        
        if ContactManager.sharedManager.userSelectedNewContactForIntro || ContactManager.sharedManager.userSelectedNewRecipientForIntro{
            
            // Check for match in contact info
            var introContact = CNContact()//ContactManager.sharedManager.recipientToIntro
            let contact = ContactManager.sharedManager.contactObjectForIntro
            
            if ContactManager.sharedManager.userSelectedNewRecipientForIntro {
                // Set intro contact
                introContact = ContactManager.sharedManager.contactToIntro
            }else{
                // Set intro contact
                introContact = ContactManager.sharedManager.recipientToIntro
            }
            
            print("Contact Object for Intro\n\n\(contact.toAnyObject())")
            print("CNContact Object for Intro\n\n\(introContact.phoneNumbers)")
            
            
            if introContact.emailAddresses.count > 0 && contact.emails.count > 0 {
                
                //
                self.selectedEmail = contact.emails[0]["email"]!//introContact.emailAddresses[0].value as String
                
                //let recipientEmail = recipient.emailAddresses[0].value as String
                
                
                // Launch Email client
                self.showEmailCard()
                
            }else if introContact.phoneNumbers.count > 0 && contact.phoneNumbers.count > 0 {
                // Set selected phone
                self.selectedPhone = contact.phoneNumbers[0].values.first!//((introContact.phoneNumbers[0].value).value(forKey: "digits") as? String)!
                
                // Launch text client
                self.showSMSCard()
                
            }else{
                // Users don't have things in common
                // form invalid
                let message = "The two people have no contact info in common make intro"
                let title = "Unable to Connect"
                
                // Configure alertview
                let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                    
                    // Dismiss alert
                    self.dismiss(animated: true, completion: nil)
                    
                })
                
                // Add action to alert
                alertView.addAction(cancel)
                self.present(alertView, animated: true, completion: nil)
                
            }

        
        
        }else{
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
                
                // Users don't have things in common
                // form invalid
                let message = "The two people have no contact info in common on make intro second check"
                let title = "Unable to Connect"
                
                // Configure alertview
                let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                    
                    // Dismiss alert
                    self.dismiss(animated: true, completion: nil)
                    
                })
                
                // Add action to alert
                alertView.addAction(cancel)
                self.present(alertView, animated: true, completion: nil)
                
            }

            
        }
    
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
            
            var phone = ""

            if ContactManager.sharedManager.userSelectedNewContactForIntro || ContactManager.sharedManager.userSelectedNewRecipientForIntro{
                
                // Check for match in contact info
                var introContact = CNContact()//ContactManager.sharedManager.recipientToIntro
                let contact = ContactManager.sharedManager.contactObjectForIntro
                
                
                if ContactManager.sharedManager.userSelectedNewRecipientForIntro {
                    // Set intro contact
                    introContact = ContactManager.sharedManager.contactToIntro
                }else{
                    // Set intro contact
                    introContact = ContactManager.sharedManager.recipientToIntro
                }
                
        
                if introContact.phoneNumbers.count > 0 && contact.phoneNumbers.count > 0 {
                    
                    
                    // Set selected phone
                    self.selectedPhone = contact.phoneNumbers[0].values.first!//((introContact.phoneNumbers[0].value).value(forKey: "digits") as? String)!
                    phone = ((introContact.phoneNumbers[0].value).value(forKey: "digits") as? String)!
                    
                    // Launch text client
                    composeVC.recipients = [phone, selectedPhone]
                    
                    // Launch text client
                    //self.showSMSCard()
                    
                }
                
                
                
            }else{
                
                // CNContact Objects
                let contact = ContactManager.sharedManager.contactToIntro
                let recipient = ContactManager.sharedManager.recipientToIntro
                
                // Check if they both have email
                //name = formatter.string(from: contact) ?? "No Name"
                //recipientName = formatter.string(from: recipient) ?? ""
                
                if contact.phoneNumbers.count > 0 && recipient.phoneNumbers.count > 0 {
                    
                    // Set contact phone number
                    phone = ((contact.phoneNumbers[0].value).value(forKey: "digits") as? String)!
                    
                    
                    // Set recipient phone
                    let recipientPhone = (recipient.phoneNumbers[0].value).value(forKey: "digits") as? String
                    
                    // Launch text client
                    composeVC.recipients = [phone, recipientPhone!]
                }

                
            }
            
            // Configure message
            //let str = "Hi \(name), Please meet \(recipientName). Thought you should connect. You are both doing some cool projects and thought you might be able to work together. \n\nYou two can take it from here! \n\nBest, \n\(currentUser.getName()) \n\n"
            
            // Set card link from cardID
            let cardLink = "https://project-unify-node-server.herokuapp.com/card/render/\(ContactManager.sharedManager.selectedCard.cardId!)"
            
            // Configure message
            let str = "\n\n\n\(cardLink)"
            
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

        
        // Check if user filled out the form
        if ContactManager.sharedManager.userSelectedNewContactForIntro || ContactManager.sharedManager.userSelectedNewRecipientForIntro {
            
            // Check for match in contact info
            var introContact = CNContact()//ContactManager.sharedManager.recipientToIntro
            let contact = ContactManager.sharedManager.contactObjectForIntro
            
            
            if ContactManager.sharedManager.userSelectedNewRecipientForIntro {
                // Set intro contact
                introContact = ContactManager.sharedManager.contactToIntro
            }else{
                // Set intro contact
                introContact = ContactManager.sharedManager.recipientToIntro
            }
            
            // Set recipient name
            // Check if they both have email
            recipientName = formatter.string(from: introContact) ?? "No Name"
            name = contact.name
            
            if introContact.emailAddresses.count > 0 && contact.emails.count > 0 {
                
                // Set selected email
                self.selectedEmail = contact.emails[0]["email"]!
                let contactEmail = introContact.emailAddresses[0].value as String
                
                // Create Message
                mailComposerVC.setToRecipients([selectedEmail, contactEmail])
                
            }
        }else{
            // Create Message
            mailComposerVC.setToRecipients([emailContact, emailRecipient])
        }
        
        // Create string
        
        // Set card link from cardID
        let cardLink = "https://project-unify-node-server.herokuapp.com/card/render/\(ContactManager.sharedManager.selectedCard.cardId!)"
        
        // Configure message
        let str = "\n\n\n\(cardLink)"
        
        // Create Message
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
        
        if ContactManager.sharedManager.userSelectedNewContactForIntro || ContactManager.sharedManager.userSelectedNewRecipientForIntro{
            
            // Check for match in contact info
            var introContact = CNContact()//ContactManager.sharedManager.recipientToIntro
            let contact = ContactManager.sharedManager.contactObjectForIntro
            
            if ContactManager.sharedManager.userSelectedNewRecipientForIntro {
                // Set intro contact
                introContact = ContactManager.sharedManager.contactToIntro
            }else{
                // Set intro contact
                introContact = ContactManager.sharedManager.recipientToIntro
            }
            
            print("Contact Object for Intro\n\n\(contact.toAnyObject())")
            print("CNContact Object for Intro\n\n\(introContact.givenName)")
            
           // Get name from cncontact
            let contactName = formatter.string(from: introContact) ?? "No Name"
                
            
            // Set recipient names
            
            transaction.recipientNames = [String]()
            transaction.recipientNames?.append(contact.name)
            transaction.recipientNames?.append(contactName)
            
            
            // Parse for emails
            if introContact.emailAddresses.count > 0 && contact.emails.count > 0 {
                
                // Set selected email
                self.selectedEmail = contact.emails[0]["email"]!
                let contactEmail = introContact.emailAddresses[0].value as String
                
                // Add to transaction
                self.transaction.recipientEmails = []
                self.transaction.recipientEmails?.append(contactEmail)
                self.transaction.recipientEmails?.append(selectedEmail)
                
            }
            
            if introContact.phoneNumbers.count > 0 && contact.phoneNumbers.count > 0 {
                
                
                // Set selected phone
                self.selectedPhone = contact.phoneNumbers[0].values.first!//((introContact.phoneNumbers[0].value).value(forKey: "digits") as? String)!
                let phone = ((introContact.phoneNumbers[0].value).value(forKey: "digits") as? String)!
                
                // Add to transaction
                self.transaction.recipientPhones = []
                self.transaction.recipientPhones?.append(phone)
                self.transaction.recipientPhones?.append(selectedPhone)
                
            }
            
            
            // Set location from contact object
            transaction.location = contact.notes[0]["note"] ?? ""

            
            if ContactManager.sharedManager.syncIntroContactSwitch == true {
                
                // Upload sync contact record
                self.syncContact()
                
            }
            
        }else{
            // CNContact Objects
            let contact = ContactManager.sharedManager.contactToIntro
            let recipient = ContactManager.sharedManager.recipientToIntro
            
            // Check if they both have email
            
            if contact.emailAddresses.count > 0 && recipient.emailAddresses.count > 0 {
                
                let contactEmail = contact.emailAddresses[0].value as String
                let recipientEmail = recipient.emailAddresses[0].value as String
                
                // Add to transaction
                self.transaction.recipientEmails = []
                self.transaction.recipientEmails?.append(contactEmail)
                self.transaction.recipientEmails?.append(recipientEmail)
                
            }
            
            if contact.phoneNumbers.count > 0 && recipient.phoneNumbers.count > 0 {
                
                let contactPhone = (contact.phoneNumbers[0].value).value(forKey: "digits") as? String
                let recipientPhone = (recipient.phoneNumbers[0].value).value(forKey: "digits") as? String
                
                // Add to transaction
                self.transaction.recipientPhones = []
                self.transaction.recipientPhones?.append(contactPhone!)
                self.transaction.recipientPhones?.append(recipientPhone!)
                
            }
        
            
            let recipientName = formatter.string(from: recipient) ?? "No Name"
            let contactName = formatter.string(from: contact) ?? "No Name"
            // Init list
            transaction.recipientNames = [String]()
            transaction.recipientNames?.append(recipientName)
            transaction.recipientNames?.append(contactName)

            
        }
        
        
        // Save card to DB
        let parameters = ["data": self.transaction.toAnyObject()]
        print(parameters)
        
        // Send to server
        
        Connection(configuration: nil).createTransactionCall(parameters as! [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Card Created Response ---> \(response)")
                
                // Hide HUD
                KVNProgress.showSuccess(withStatus: "Introduction made successfully!")
                
                // Clear
                self.resetViews()
                
            } else {
                print("Card Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error with your introduction. Please try again.")
                
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
    }
    
    func contactToCNContact(contact: Contact) -> CNMutableContact {
        var cnObject = CNContact()
        
        // Set text for name
        let contactToAdd = CNMutableContact()
        //contactToAdd.givenName = self.firstNameLabel.text ?? ""
        //contactToAdd.familyName = self.lastNameLabel.text ?? ""
        
        // Init formatter
        let formatter = CNContactFormatter()
        formatter.style = .fullName
        
        // Iterate over list and itialize contact objects
        
        // Set name
        //contactObject.name = formatter.string(from: contact) ?? "No Name"
        
        let fullName = contact.name
        var fullNameArr = fullName.components(separatedBy: " ")
        let firstName: String = fullNameArr[0]
        var lastName: String = fullNameArr.count > 1 ? fullNameArr[1] : ""
        
        // Add names
        contactToAdd.givenName = firstName
        contactToAdd.familyName = lastName ?? ""
        
        // Check for count
        if contact.phoneNumbers.count > 0 {
            
            // Iterate over items
            for number in contact.phoneNumbers{
                // print to test
                //print("Number: \((number.value.value(forKey: "digits" )!))")
                
                // Parse for mobile
                let mobileNumber = CNPhoneNumber(stringValue: (number.values.first!))
                let mobileValue = CNLabeledValue(label: CNLabelPhoneNumberMobile, value: mobileNumber)
                contactToAdd.phoneNumbers = [mobileValue]
                
            }
            
            
        }
        if contact.emails.count > 0 {
            
            // Iterate over array and pull value
            for address in contact.emails {
                // Print to test
                print("Email : \(address["email"]!)")
                
                // Parse for emails
                let email = CNLabeledValue(label: CNLabelWork, value: address["email"] as NSString? ?? "")
                contactToAdd.emailAddresses = [email]
                
            }
            
        }
        // Cast mutable contact back to regular contact
        //cnObject = contactToAdd as CNContact
        
        print("Immutable Copy \(cnObject)")
        print("Immutable Copy Phones \(cnObject.phoneNumbers)")
        print("Immutable Copy Emails \(cnObject.emailAddresses)")
        
        
        // Return the non mutable copy
        return contactToAdd
        
    }
    
    
    func syncContact() {
        
        // Init CNContact Object
        //let temp = CNContact()
        //temp.emailAddresses.append(CNLabeledValue<NSString>)
        //let tempContact = ContactManager.sharedManager.newContact
        
        // Append to list of existing contacts
        let store = CNContactStore()
        
        // Set text for name
        var contactToAdd = CNMutableContact()
        // Set contact to save
        contactToAdd = self.contactToCNContact(contact: ContactManager.sharedManager.contactObjectForIntro)
        
        // Save contact to phone
        let saveRequest = CNSaveRequest()
        saveRequest.add(contactToAdd, toContainerWithIdentifier: nil)
        
        do {
            try store.execute(saveRequest)
        } catch {
            print(error)
        }
        
        // Init contact object
        let newContact : CNContact = contactToAdd
        
        print("New Contact >> \(newContact)")
        
        // Append to contact list
        ContactManager.sharedManager.phoneContactList.append(newContact)
        
        // Post notification for refresh
        //self.postRefreshNotification()
        
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
                //self.performSegue(withIdentifier: "showIntroContactList", sender: self)
                self.performSegue(withIdentifier: "showRecipientOptions", sender: self)
            }
        }else if ContactManager.sharedManager.userSelectedNewContactForIntro && ContactManager.sharedManager.userArrivedFromIntro{
            //self.performSegue(withIdentifier: "showRecipientOptions", sender: self)
            self.performSegue(withIdentifier: "showIntroContactList", sender: self)
        }else{
            // Show recipient options again bacuse they
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
        ContactManager.sharedManager.contactObjectForIntro = Contact()
        
        // Reset Navigation Bool
        ContactManager.sharedManager.userArrivedFromIntro = false
        ContactManager.sharedManager.userSelectedNewContactForIntro = false
        ContactManager.sharedManager.userSelectedNewRecipientForIntro = false
        
        
        // Hide shared button
        self.shareButton.isHidden = true
        self.cancelIntroButton.isHidden = true
        
    }
    
    func configureViewForContact(){
        
        // User filled out form on recipients page
        if ContactManager.sharedManager.userSelectedNewContactForIntro{
            
            // Show cancel button
            cancelIntroButton.isHidden = false
            
            // Set selected contact
            let selected = ContactManager.sharedManager.contactObjectForIntro
            // Check if image data available
            
            
            if selected.imageId != "" {
                print("Has IMAGE")
                // Set id
                /*let id = selected.imageId
                
                // Set image for contact
                let url = URL(string: "\(ImageURLS.sharedManager.getFromDevelopmentURL)\(id).jpg")!
                let placeholderImage = UIImage(named: "profile")!
                // Set image
                //contactImageView?.setImageWith(url)
                self.contactImageView.setImageWith(url)*/
                
                // Set from data directly
                self.contactImageView.image = UIImage(data: selected.imageData)
                
            }else{
                contactImageView.image = UIImage(named: "contact-placeholder")
            }

            
            // Set Label w name
            let name = selected.name
            self.addContactLabel.text = name
            
        }else{
            
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
                contactImageView.image = UIImage(named: "contact-placeholder")
            }
            
            // Set Label w name
            let name = formatter.string(from: selected) ?? "No Name"
            self.addContactLabel.text = name
            
        }
        
        // Set nav on manager
        ContactManager.sharedManager.userArrivedFromIntro = true
        
        print("Configured view for contact arrival from intro call \(ContactManager.sharedManager.userArrivedFromIntro)")
        print("Configured view for contact selected new form contact call \(ContactManager.sharedManager.userSelectedNewContactForIntro)")
        
        
        
    }
    
    func configureViewForRecipient(){
        
        // User filled out form on recipients page
        if ContactManager.sharedManager.userSelectedNewRecipientForIntro {
            
            // Show cancel button
            cancelIntroButton.isHidden = false
            
            // Set selected contact
            let selected = ContactManager.sharedManager.contactObjectForIntro
            // Check if image data available
            
            
            if selected.imageId != "" {
                print("Has IMAGE")
                // Set id
                /*let id = selected.imageId
                
                // Set image for contact
                let url = URL(string: "\(ImageURLS.sharedManager.getFromDevelopmentURL)\(id).jpg")!
                let placeholderImage = UIImage(named: "profile")!
                // Set image
                //contactImageView?.setImageWith(url)
                self.recipientImageView.setImageWith(url)*/
                
                // Set from data 
                self.recipientImageView.image = UIImage(data: selected.imageData)
                
            }else{
                recipientImageView.image = UIImage(named: "contact-placeholder")
            }
            
            
            // Set Label w name
            let name = selected.name
            self.addRecipientLabel.text = name
            
        }else{
            
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
                recipientImageView.image = UIImage(named: "contact-placeholder")
            }
            
            // Set Label w name
            let name = formatter.string(from: selected) ?? "No Name"
            self.addRecipientLabel.text = name
        }
        
        // Show share button 
        shareButton.isHidden = false
        
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
        //imageView.layer.borderColor = UIColor.blue.cgColor
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
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print(">Passed Contact Card ID")
        //print(sender)
                
    }

}
