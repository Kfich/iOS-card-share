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
    
    
    // For checking intent
    var addContactAttempts = 0
    var addRecipientAttempts = 0
    
    
    // Check for edit attempts
    var editRecipient = false
    var editContact = false
    
    // Check if objects have been added
    var contactAdded = false
    var recipientAdded = false
    
    // Toggle on selection
    var addContactSelected = false
    var addRecipientSelected = false
    
    // Links
    var contactVCardLink = ""
    var recipientVCardLink = ""
    
    
    
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
        
        print("Contact Added", addContactSelected)
        print("Recipient Added", addRecipientSelected)
        
        print("Edit Contact", editContact)
        print("Edit Recipient", editRecipient)
        
        print("Add Contact Attempts", addContactAttempts)
        print("Add Recipient Attempts", addRecipientAttempts)
        
        // Resize images based on device sice
        let modelName = UIDevice.current.modelName
        
        print("Model Name \(modelName)")
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set current User object
        currentUser = ContactManager.sharedManager.currentUser
        
        // Add Tap Gesture to imageviews
        let addContactGesture = UITapGestureRecognizer(target: self, action: #selector(showAddContact))
        let addRecipientGesture = UITapGestureRecognizer(target: self, action: #selector(showAddRecipient))
        
        //self.view.addGestureRecognizer(tapGestureRecognizer)
        
        // Add gesture to views
        self.contactWrapperView.isUserInteractionEnabled = true
        self.contactWrapperView.addGestureRecognizer(addContactGesture)
        self.recipientWrapperView.isUserInteractionEnabled = true
        self.recipientWrapperView.addGestureRecognizer(addRecipientGesture)
        
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
        
        // Resize images based on device sice
        let modelName = UIDevice.current.modelName
        
        print("Model Name \(modelName)")
        
        // Resize images for the ipad
        if modelName == "iPhone 6" || modelName == "iPhone 6s" || modelName == "iPhone 7" {
            print("Iphone 6 landia my friend")
            //plus device
            
            
            //radarLogoImage.frame.origin.y = radarLogoImage.frame.origin.y + 100
            
            
        }else if modelName == "iPhone 6 Plus" || modelName == "iPhone 6s Plus" || modelName == "iPhone 7 Plus"{
            print("Now entering iphone plus landia my friend to tread light")
            //standard device
            
        }else{
            
            // Set the frames for imageviews to minimum
            self.contactWrapperView.frame = CGRect(self.contactWrapperView.frame.origin.x, self.contactWrapperView.frame.origin.y, self.contactWrapperView.frame.width, 200)
            
            self.recipientWrapperView.frame = CGRect(self.recipientWrapperView.frame.origin.x, self.recipientWrapperView.frame.origin.y, self.recipientWrapperView.frame.width, 200)
            
            self.recipientImageView.frame = CGRect(self.recipientImageView.frame.origin.x, self.recipientImageView.frame.origin.y, 120, 120)
            self.contactImageView.frame = CGRect(self.contactImageView.frame.origin.x, self.contactImageView.frame.origin.y, 120, 120)
            
            
            // Center the image
            //self.contactImageView.center = self.contactWrapperView.center
            // Center the image
            //self.recipientImageView.center = self.recipientWrapperView.center
            
            // Layout subviews
            // Reload views
            self.view.layoutSubviews()
            self.view.layoutIfNeeded()
            
        }

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // Resize images based on device sice
        let modelName = UIDevice.current.modelName
        
        print("Model Name \(modelName)")
        
        // Resize images for the ipad
        if modelName == "iPhone 6" || modelName == "iPhone 6s" || modelName == "iPhone 7" {
            print("Iphone 6 landia my friend")
            //plus device
            
            
            //radarLogoImage.frame.origin.y = radarLogoImage.frame.origin.y + 100
            
            
        }else if modelName == "iPhone 6 Plus" || modelName == "iPhone 6s Plus" || modelName == "iPhone 7 Plus"{
            print("Now entering iphone plus landia my friend to tread light")
            //standard device
            
        }else{
            
            /*
            
            // Set the frames for imageviews to minimum
            self.contactWrapperView.frame = CGRect(self.contactWrapperView.frame.origin.x, self.contactWrapperView.frame.origin.y, self.contactWrapperView.frame.width, 200)
            
            self.recipientWrapperView.frame = CGRect(self.recipientWrapperView.frame.origin.x, self.recipientWrapperView.frame.origin.y, self.recipientWrapperView.frame.width, 200)
            
            self.recipientImageView.frame = CGRect(self.recipientImageView.frame.origin.x, self.recipientImageView.frame.origin.y, 100, 100)
            self.contactImageView.frame = CGRect(self.contactImageView.frame.origin.x, self.contactImageView.frame.origin.y, 100, 100)
            
            
            // Center the image
            //self.contactImageView.center = self.contactWrapperView.center
            // Center the image
            //self.recipientImageView.center = self.recipientWrapperView.center
            
            // Layout subviews
            // Reload views
            self.view.layoutSubviews()
            self.view.layoutIfNeeded()*/
            
        }
        
        

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
            
            
            if contact.emailAddresses.count > 0 && recipient.emailAddresses.count > 0 {
                
                let contactEmail = contact.emailAddresses[0].value as String
                let recipientEmail = recipient.emailAddresses[0].value as String
                
                
                // Launch Email client
                showEmailCard()
                
            } else if contact.phoneNumbers.count > 0 && recipient.phoneNumbers.count > 0 {
                
                let contactPhone = (contact.phoneNumbers[0].value).value(forKey: "digits") as? String
                let recipientPhone = (recipient.phoneNumbers[0].value).value(forKey: "digits") as? String
                
                // Launch text client
                showSMSCard()
                
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
            var name = ""
            var recipientName = ""

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
                
                // Set names
                name = formatter.string(from: introContact) ?? "No Name"
                recipientName = contact.name
                
                
                
            }else{
                
                // CNContact Objects
                let contact = ContactManager.sharedManager.contactToIntro
                let recipient = ContactManager.sharedManager.recipientToIntro
                
                // Set names
                name = formatter.string(from: contact) ?? "No Name"
                recipientName = formatter.string(from: recipient) ?? "No Name"
                
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
            
            
            let fullName = name
            var fullNameArr = fullName.components(separatedBy: " ")
            let firstName: String = fullNameArr[0]
            
            let recipientFullName = recipientName
            var recipientFullNameArr = recipientFullName.components(separatedBy: " ")
            let recipientFirstName: String = recipientFullNameArr[0]
            
            
            // Set card link from cardID
            let cardLink = "https://project-unify-node-server.herokuapp.com/card/render/\(ContactManager.sharedManager.selectedCard.cardId!)"
            
            // Configure message
            let str = "Hi \(firstName), please meet \(recipientFirstName). Thought you should connect. You are both doing some cool projects and thought you might be able to work together. \n\nYou two can take it from here! \n\nBest, \n\(currentUser.getName()) \n\n\(firstName)'s Contact Information\n\n\(contactVCardLink)\n\n\(recipientFirstName)'s Contact Information\n\n\(recipientVCardLink)"
            
            
            // Configure message
            //let str = "\n\n\n\(cardLink)"
            
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
        
        let fullName = name
        var fullNameArr = fullName.components(separatedBy: " ")
        let firstName: String = fullNameArr[0]
        
        let recipientFullName = recipientName
        var recipientFullNameArr = recipientFullName.components(separatedBy: " ")
        let recipientFirstName: String = recipientFullNameArr[0]
        
        
        
        
        // Configure message
        let str = "Hi \(firstName), please meet \(recipientFirstName). Thought you should connect. You are both doing some cool projects and thought you might be able to work together. \n\nYou two can take it from here! \n\nBest, \n\(currentUser.getName())\n\n\(firstName)'s Contact Information\n\n\(contactVCardLink)\n\n\(recipientFirstName)'s Contact Information\n\n\(recipientVCardLink)"
        
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
    
    func createContactRecords(phoneContactList: [CNContact]) -> [Contact] {
        // Create array of contacts
        var contactObjectList = [Contact]()
        
        // Init formatter
        let formatter = CNContactFormatter()
        formatter.style = .fullName
        
        // Iterate over list and itialize contact objects
        for contact in phoneContactList{
            
            // Init temp contact object
            let contactObject = Contact()
            
            // Set name
            contactObject.name = formatter.string(from: contact) ?? "No Name"
            
            // Check for count
            if contact.phoneNumbers.count > 0 {
                // Iterate over items
                for number in contact.phoneNumbers{
                    // print to test
                    //print("Number: \((number.value.value(forKey: "digits" )!))")
                    
                    // Init the number
                    let digits = number.value.value(forKey: "digits") as! String
                    
                    // Append to object
                    contactObject.setPhoneRecords(phoneRecord: digits)
                }
                
            }
            if contact.emailAddresses.count > 0 {
                // Iterate over array and pull value
                for address in contact.emailAddresses {
                    // Print to test
                    print("Email : \(address.value)")
                    
                    // Append to object
                    contactObject.setEmailRecords(emailAddress: address.value as String)
                }
            }
            if contact.imageDataAvailable {
                // Print to test
                //print("Has IMAGE Data")
                
                // Create ID and add to dictionary
                // Image data png
                
                // **** Check here if contact image valid --> This caused lyss' phone to crash ***** \\
                
                if let imageData = contact.imageData{
                    // Set to contact object
                    contactObject.imageData = imageData
                    
                    // Assign asset name and type
                    let idString = contactObject.randomString(length: 20)
                    
                    // Name image with id string
                    let fname = idString
                    let mimetype = "image/png"
                    
                    // Create image dictionary
                    let imageDict = ["image_id":idString, "image_data": imageData, "file_name": fname, "type": mimetype] as [String : Any]
                    
                    
                    // Append to object
                    contactObject.setContactImageId(id: idString)
                    contactObject.imageDictionary = imageDict
                    
                    /*
                     if self.synced != true {
                     // Upload Record
                     ImageURLS.sharedManager.uploadImageToDev(imageDict: imageDict)
                     }else{
                     //
                     print("The users image has been uploaded already")
                     }*/
                    
                }
                
                
            }
            if contact.urlAddresses.count > 0{
                // Iterate over items
                for address in contact.urlAddresses {
                    // Print to test
                    print("Website : \(address.value as String)")
                    
                    // Append to object
                    contactObject.setWebsites(websiteRecord: address.value as String)
                }
                
            }
            if contact.socialProfiles.count > 0{
                // Iterate over items
                for profile in contact.socialProfiles {
                    // Print to test
                    print("Social Profile : \((profile.value.value(forKey: "urlString") as! String))")
                    
                    // Create temp link
                    let link = profile.value.value(forKey: "urlString")  as! String
                    
                    // Append to object
                    contactObject.setSocialLinks(socialLink: link)
                }
                
            }
            
            if contact.jobTitle != "" {
                //Print to test
                print("Job Title: \(contact.jobTitle)")
                
                // Append to object
                contactObject.setTitleRecords(title: contact.jobTitle)
            }
            if contact.organizationName != "" {
                //print to test
                print("Organization : \(contact.organizationName)")
                
                // Append to object
                contactObject.setOrganizations(organization: contact.organizationName)
            }
            if contact.note != "" {
                //print to test
                print(contact.note)
                
                // Append to object
                contactObject.setNotes(note: contact.note)
                
            }
            
            if contact.postalAddresses.count > 0{
                
                print("The postal address")
                let address = contact.postalAddresses.first?.value
                
                let formatter = CNPostalAddressFormatter()
                formatter.style = .mailingAddress
                
                let city = contact.postalAddresses.first?.value.city ?? ""
                let state = contact.postalAddresses.first?.value.state ?? ""
                let street = contact.postalAddresses.first?.value.street ?? ""
                let zip = contact.postalAddresses.first?.value.postalCode ?? ""
                let country = contact.postalAddresses.first?.value.country ?? ""
                
                
                let addy = "\(street), \(city) \(state) \(zip), \(country)"
                
                //let formattedAddress = formatter.string(from: address!)
                
                //let trimmed = String(formattedAddress.characters.filter { !"\n\t\r".characters.contains($0) })
                
                
                
                print("The address is \(addy)")
                
                
                // Append to object
                contactObject.setAddresses(address: addy)
                
            }
            
            // Test object
            //print("Contact >> \n\(contactObject.toAnyObject()))")
            
            // Parse own record
            contactObject.parseContactRecord()
            
            // Append object to contactObjectList
            contactObjectList.append(contactObject)
            
            
            // Print count
            print("List Count ... \(contactObjectList.count)")
        }
        
        return contactObjectList
    }
    
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
        let lastName: String = fullNameArr.count > 1 ? fullNameArr.last! : ""
        
        // Add names
        contactToAdd.givenName = firstName
        contactToAdd.familyName = lastName
        
        /*
         // Parse for mobile
         let mobileNumber = CNPhoneNumber(stringValue: (contact.phoneNumbers[0].values.first ?? ""))
         let mobileValue = CNLabeledValue(label: CNLabelPhoneNumberMobile, value: mobileNumber)
         contactToAdd.phoneNumbers = [mobileValue]*/
        
        
        // Set organizations
        if contact.organizations.count > 0 {
            // Add to contact
            contactToAdd.organizationName = contact.organizations[0]["organization"]!
        }
        
        
        
        // Check for count
        if contact.phoneNumbers.count > 0 {
            
            var mobiles = [CNLabeledValue<CNPhoneNumber>]()
            // Iterate over items
            for number in contact.phoneNumbers{
                // print to test
                //print("Number: \((number.value.value(forKey: "digits" )!))")
                
                // Parse for mobile
                let mobileNumber = CNPhoneNumber(stringValue: (number.values.first ?? ""))
                let mobileValue = CNLabeledValue(label: CNLabelPhoneNumberMobile, value: mobileNumber)
                
                // Add objects to phone list
                mobiles.append(mobileValue)
            }
            // Add phones as value
            contactToAdd.phoneNumbers = mobiles
            
            
        }
        
        
        
        // Parse for emails
        if contact.emails.count > 0 {
            
            var emails = [CNLabeledValue<NSString>]()
            // Iterate over array and pull value
            for address in contact.emails {
                // Print to test
                print("Email : \(address["email"]!)")
                
                // Parse for emails
                let email = CNLabeledValue(label: address["type"] ?? CNLabelWork, value: address["email"] as NSString? ?? "")
                emails.append(email)
            }
            
            // Add array as value
            contactToAdd.emailAddresses = emails
            
        }
        
        /*
         // Parse for image data
         if contact.imageId != "" {
         // Assign
         contactToAdd.imageData = contact.imageData
         }*/
        
        
        
        // Parse sites
        if contact.websites.count > 0{
            // Add sites
            for site in contact.websites {
                // Format labeled value
                contactToAdd.urlAddresses.append(CNLabeledValue(
                    label: "url", value: site["website"]! as NSString))
            }
        }
        
        // Parse sites
        if contact.socialLinks.count > 0{
            
            // Init list
            var socials = [CNLabeledValue<CNSocialProfile>]()
            
            // Add sites
            for site in contact.socialLinks {
                
                let profile = CNLabeledValue(label: "social", value: CNSocialProfile(urlString: site["link"]!, username: "", userIdentifier: "", service: nil))
                
                // Add to prof list
                socials.append(profile)
                
                print("printing social link", site["link"]!)
                
                
            }
            
            // Append to object
            contactToAdd.socialProfiles = socials
        }
        
        
        
        // Parse badges
        if contact.badgeDictionaryList.count > 0{
            // Add badge links as sites
            // Parse for corp
            for corp in contact.badgeDictionaryList {
                
                // Init badge
                //let badge = Contact.Bagde(snapshot: corp)
                
                print("The badge on contact convert", corp)
                
                if corp["website"] is String {
                    
                    // Add to list
                    contactToAdd.urlAddresses.append(CNLabeledValue(
                        label: "badge", value: corp["url"] as? NSString ?? ""))
                    
                    // Add to list
                    contactToAdd.urlAddresses.append(CNLabeledValue(
                        label: "imageURL", value: corp["image"] as? NSString ?? ""))
                }else{
                    
                    let websiteArray = corp["image"] as? NSArray ?? NSArray()
                    
                    for item in websiteArray {
                        // Append items individually
                        // Add to list
                        contactToAdd.urlAddresses.append(CNLabeledValue(
                            label: "badgeURL", value: item as? NSString ?? ""))
                    }
                    
                    let imageArray = corp["url"] as? NSArray ?? NSArray()
                    
                    for item in imageArray {
                        // Append items individually
                        // Add to list
                        contactToAdd.urlAddresses.append(CNLabeledValue(
                            label: "imageURL", value: item as? NSString ?? ""))
                        
                    }
                    
                    
                    
                }
                
                
                
            }
        }
        
        // Parse company info
        if contact.organizations.count > 0 {
            // add company
            contactToAdd.organizationName = contact.organizations[0]["organization"] ?? ""
        }
        
        // Parse titles
        if contact.titles.count > 0 {
            // add title
            contactToAdd.jobTitle = contact.titles[0]["title"] ?? ""
            
        }
        
        // Format a notes string to hold extra data
        var notesString = ""
        
        // Parse notes
        if contact.notes.count > 0 {
            
            // Add label to notes string
            notesString += "Unify Notes:"
            
            // Format notes field
            for note in contact.notes {
                // Add note to string
                notesString += "\n\(note["note"] ?? "")"
                
            }
        }
        
        // Parse notes
        if contact.tags.count > 0 {
            // Format notes field
            // Add label to notes string
            notesString += "\nUnify Tags:"
            
            // Format notes field
            for tag in contact.tags {
                // Add note to string
                notesString += "\n\(tag["tag"] ?? "")"
                
            }
        }
        
        // Parse notes
        if contact.bioList != "" {
            // Format notes field
            // Add label to notes string
            notesString += "\nUnify Bios:"
            
            // Append value to string
            notesString += "\n\(contact.bioList)"
            
        }
        
        // Parse notes
        if contact.isVerified == "1" {
            // Format notes field
            // Add label to notes string
            notesString += "\nUnify Verified: 1"
            
            
        }
        
        // Add note to contact object
        contactToAdd.note = notesString
        
        
        // Parse address info
        if contact.addresses.count > 0 {
            // Format in notes field
            
            for address in contact.addresses {
                
                // Parse address
                let postal = CNMutablePostalAddress()
                postal.street = address["street"] ?? ""
                postal.city = address["city"] ?? ""
                postal.state = address["state"] ?? ""
                postal.postalCode = address["zip"] ?? ""
                postal.country = address["country"] ?? ""
                
                let home = CNLabeledValue<CNPostalAddress>(label:CNLabelHome, value:postal)
                
                contactToAdd.postalAddresses = [home]
                
            }
            
            
        }
        
        
        // Cast mutable contact back to regular contact
        //cnObject = contactToAdd as CNContact
        
        print("Immutable Copy \(contactToAdd)")
        print("Immutable Copy Phones \(contactToAdd.phoneNumbers)")
        print("Immutable Copy Emails \(contactToAdd.emailAddresses)")
        print("Immutable Copy URLs \(contactToAdd.urlAddresses)")
        print("Immutable Copy Notes \(contactToAdd.note)")
        print("Immutable Copy address \(contactToAdd.postalAddresses)")
        print("Immutable Copy Company \(contactToAdd.organizationName)")
        
        
        // Return the non mutable copy
        return contactToAdd
        
    }

    
    /*
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
    */
    
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
    
    // Get VCards
    
    func getConatctVCards(contact: Contact){
        
        // Create dictionary
        let parameters = ["data" : contact.toAnyObject()]
        print(parameters)
        
        // Send to server
        Connection(configuration: nil).getContactVCardsCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                // Call successful
                print("VCard Created Response --->\n \(String(describing: response))")
                
               
                // Get response object
                let dict = response as! NSDictionary
                
                // Set the link
                self.contactVCardLink = dict["url"] as! String
                
                
                
                /* // Parse array for
                let array = response as! NSArray
                print("Array List >> \(array)")
                
                // Set recipient list to transaction
                self.transaction.recipientList = array as! [String]
                // Test
                print("Transaction List Count >> \(self.transaction.recipientList.count)")
                print("Transaction List >> \(self.transaction.recipientList)")
                
                // Create transaction
                self.createTransaction(type: "introduction")*/
                
                
                // Hide HUD
                //KVNProgress.dismiss()
                
            } else {
                // Error occured
                print("Transaction Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error with your connection request. Please try again.")
                
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
        
    }

    func getRecipientVCards(contact: Contact){
        
        // Create dictionary
        let parameters = ["data" : contact.toAnyObject()]
        print(parameters)
        
        // Send to server
        Connection(configuration: nil).getContactVCardsCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                // Call successful
                print("VCard Created Response --->\n \(String(describing: response))")
                
                
                // Get response object
                let dict = response as! NSDictionary
                
                // Set the link
                self.recipientVCardLink = dict["url"] as! String
                
                
                /* // Parse array for
                 let array = response as! NSArray
                 print("Array List >> \(array)")
                 
                 // Set recipient list to transaction
                 self.transaction.recipientList = array as! [String]
                 // Test
                 print("Transaction List Count >> \(self.transaction.recipientList.count)")
                 print("Transaction List >> \(self.transaction.recipientList)")
                 
                 // Create transaction
                 self.createTransaction(type: "introduction")*/
                
                
                // Hide HUD
                //KVNProgress.dismiss()
                
            } else {
                // Error occured
                print("Transaction Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error with your connection request. Please try again.")
                
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
                //self.performSegue(withIdentifier: "showIntroContactList", sender: self)
                self.performSegue(withIdentifier: "showContactOptions", sender: self)
            }
        }else if ContactManager.sharedManager.userSelectedNewContactForIntro && ContactManager.sharedManager.userArrivedFromIntro{
            //self.performSegue(withIdentifier: "showRecipientOptions", sender: self)
            self.performSegue(withIdentifier: "showIntroList", sender: self)
        }else{
            // Show recipient options again bacuse they
            self.performSegue(withIdentifier: "showContactOptions", sender: self)
        }
    }
    
    func showAddRecipient() {
        
        // Increment attempts
        addRecipientAttempts = addRecipientAttempts + 1
        
        // Toggle Selection
        addRecipientSelected = true
        
        // Check which attempt this is
        if addRecipientAttempts > 1 {
            // Toggle Edit
            editRecipient = true
            
            // Send to options screen
            self.performSegue(withIdentifier: "showRecipientOptions", sender: self)
            
            
        }else if ContactManager.sharedManager.userSelectedNewRecipientForIntro && ContactManager.sharedManager.userArrivedFromIntro{
            
            // Check manager nav intents
            self.performSegue(withIdentifier: "showIntroContactList", sender: self)
            
        }else{
            
            // Show recipient options again bacuse they
            self.performSegue(withIdentifier: "showRecipientOptions", sender: self)
            
        }
        
    }
    
    func showAddContact() {
        
        
        // Increment attempts
        addContactAttempts = addContactAttempts + 1
        
        // Toggle Selection
        addContactSelected = true
        
        // Check which attempt this is
        if addContactAttempts > 1 {
            // Toggle Edit
            editContact = true
            // Set manager toggle
            ContactManager.sharedManager.editContact = true
            
            
            // Send to options screen
            self.performSegue(withIdentifier: "showContactOptions", sender: self)
            
            
        }else if ContactManager.sharedManager.userSelectedNewContactForIntro && ContactManager.sharedManager.userArrivedFromIntro{
            
            // Check manager nav intents
            self.performSegue(withIdentifier: "showIntroList", sender: self)
        
        }else{
            
            // Show recipient options again bacuse they
            self.performSegue(withIdentifier: "showContactOptions", sender: self)
            
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
        
        // Clear nav intents
        editContact = false
        editRecipient = false
        
        // Clear attempts
        addContactAttempts = 0
        addRecipientAttempts = 0
        
        
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
        
        
        if ContactManager.sharedManager.userSelectedNewContactForIntro {
            
            // Get VCard
            self.getConatctVCards(contact: ContactManager.sharedManager.contactObjectForIntro)
        
            //let cnContact = contactToCNContact(contact: ContactManager.sharedManager.contactObjectForIntro)
            
            //let vcard = CNContactVCardSerialization.data(with: [cnContact])
            
            
            
            
            
            
        }else{
            
            // Convert from cncontact to contact
            let contactList = [ContactManager.sharedManager.contactToIntro]
            
            // Init contact object
            let newContact = self.createContactRecords(phoneContactList: contactList)
            
            // Upload new record
            self.getConatctVCards(contact: newContact[0])
            
        }
        
        
        
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
        
        
        if ContactManager.sharedManager.userSelectedNewRecipientForIntro {
            
            // Get VCard
            self.getRecipientVCards(contact: ContactManager.sharedManager.contactObjectForIntro)
            
            //let cnContact = contactToCNContact(contact: ContactManager.sharedManager.contactObjectForIntro)
            
            //let vcard = CNContactVCardSerialization.data(with: [cnContact])
            
            
        }else{
            
            // Convert from cncontact to contact
            let contactList = [ContactManager.sharedManager.recipientToIntro]
            
            // Init contact object
            let newContact = self.createContactRecords(phoneContactList: contactList)
            
            // Upload new record
            self.getRecipientVCards(contact: newContact[0])
            
        }
        
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
