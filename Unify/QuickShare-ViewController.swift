//
//  QuickShare-ViewController.swift
//  Unify
//
//  Created by Ryan Hickman on 4/4/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//


import UIKit
import MapKit
import CoreLocation
import MessageUI
import Contacts



class QuickShareViewController: UIViewController, MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Properties
    // ---------------------------------------
    var currentUser = User()
    var transaction = Transaction()
    let formatter = CNContactFormatter()
    var contact = Contact()
    var selectedCard = ContactCard()
    
    
    // Arrays to hold contact info
    var phoneNumbers = [String]()
    var emailAddresses = [String]()
    
    //
    var usersHaveEmails = false
    var usersHavePhoneNumbers = false
    // Contact Sync
    var syncToContactsSelected = false
    
    // Store image icons
    var socialLinkBadges = [[String : Any]]()
    var links = [String]()
    var socialBadges = [UIImage]()
    var socialLinks = [String]()
    
    // IBOutlets
    // ---------------------------------------
    @IBOutlet var contactCardView: ContactCardView!
    
    @IBOutlet var cardWrapperView: UIView!
    
   // @IBOutlet var profileCardWrapperView: UIView!
    
    
    // Labels
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var socialMediaToolBar: UIToolbar!
    
    @IBOutlet var phoneImageView: UIImageView!
    @IBOutlet var emailImageView: UIImageView!
    
    
    // Buttons on social toolbar
    
    @IBOutlet var mediaButton1: UIBarButtonItem!
    @IBOutlet var mediaButton2: UIBarButtonItem!
    @IBOutlet var mediaButton3: UIBarButtonItem!
    
    @IBOutlet var mediaButton4: UIBarButtonItem!
    @IBOutlet var mediaButton5: UIBarButtonItem!
    @IBOutlet var mediaButton6: UIBarButtonItem!
    @IBOutlet var mediaButton7: UIBarButtonItem!
    
    @IBOutlet var syncToContactsSwitch: UISwitch!
    
    // Text fields
    
    //@IBOutlet var recipientTextField: UITextField!
    
    @IBOutlet var firstNameTextField: UITextField!
    
    @IBOutlet var lastNameTextField: UITextField!
    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var notesTextField: UITextField!
    
    @IBOutlet var socialBadgeCollectionView: UICollectionView!
    
    
    
    // Page configuration
    // ------------------------------------------

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Reset nav
        //self.resetNavigationBooleans()
        
        // Set contact card
        selectedCard = ContactManager.sharedManager.selectedCard
        
        // Set current user
        currentUser = ContactManager.sharedManager.currentUser
        
        // Parse for social badges
        self.parseForSocialIcons()
        
        // View setup
        configureViews()
        populateCards()
        
        

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        // Reset nav
        self.resetNavigationBooleans()
    }
    
    // Collection view Delegate && Data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /* if self.socialBadges.count != 0 {
         // Return the count
         return self.socialBadges.count
         }else{
         return 1
         }*/
        return self.socialBadges.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileBadgeCell", for: indexPath)
        
        //cell.contentView.backgroundColor = UIColor.red
        self.configureBadges(cell: cell)
        
        // Configure corner radius
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let image = self.socialBadges[indexPath.row]
        
        // Set image
        imageView.image = image
        
        // Add subview
        cell.contentView.addSubview(imageView)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //performSegue(withIdentifier: "showSocialMediaOptions", sender: self)
        
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
    }
    
    func configureBadges(cell: UICollectionViewCell){
        // Add radius config & border color
        
        cell.contentView.layer.cornerRadius = 20.0
        cell.contentView.clipsToBounds = true
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.borderColor = UIColor.blue.cgColor
        
        // Set shadow on the container view
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowOffset = CGSize.zero
        cell.layer.shadowRadius = 0.5
        
    }
    
    
    // IBActions / Buttons pressed
    // ------------------------------------------
    
    @IBAction func saveToContactsSelected(_ sender: AnyObject) {
        
        // Execute call
        //self.uploadContactRecord()
        
        if syncToContactsSwitch.isOn == true {
            // Set sync to true
            self.syncToContactsSelected = true
        }else{
            // Set sync to false
            self.syncToContactsSelected = false
        }
        
    }
    
    
    @IBAction func shareContactCard(_ sender: Any) {
        
        // Execute call follow through 
        self.validateForm()
    }
    
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // Custom Methods
    
    func initializeBadgeList() {
        // Image config
        let img1 = UIImage(named: "icn-social-facebook.png")
        let img2 = UIImage(named: "icn-social-twitter.png")
        let img3 = UIImage(named: "icn-social-instagram.png")
        let img4 = UIImage(named: "icn-social-harvard.png")
        let img5 = UIImage(named: "icn-social-pinterest.png")
        let img6 = UIImage(named: "icn-social-pinterest.png")
        let img7 = UIImage(named: "icn-social-facebook.png")
        let img8 = UIImage(named: "icn-social-facebook.png")
        let img9 = UIImage(named: "icn-social-facebook.png")
        let img10 = UIImage(named: "icn-social-facebook.png")
        
        // Hash images
        self.socialLinkBadges = [["facebook" : img1!], ["twitter" : img2!], ["instagram" : img3!], ["harvard" : img4!], ["pinterest" : img5!]]/*, ["pinterest" : img6!], ["reddit" : img7!], ["tumblr" : img8!], ["myspace" : img9!], ["googleplus" : img10!]]*/
        
        
        // let fb : NSDictionary = ["facebook" : img1!]
        // self.socialLinkBadges.append([fb])
        
        
    }
    
    
    
    func parseForSocialIcons() {
        
        // Create list containing link info
        self.initializeBadgeList()
        
        // Remove all items from badges
        self.socialBadges.removeAll()
        self.socialLinks.removeAll()
        
        print("Looking for social icons on card selection view")
        
        // Assign currentuser
        //self.currentUser = ContactManager.sharedManager.currentUser
        
        // Parse socials links
        if selectedCard.cardProfile.socialLinks.count > 0{
            for link in selectedCard.cardProfile.socialLinks{
                socialLinks.append(link["link"]!)
                // Test
                print("Count >> \(socialLinks.count)")
            }
        }
        
        // Add plus icon to list
        
        // Iterate over links[]
        for link in self.socialLinks {
            // Check if link is a key
            print("Link >> \(link)")
            for item in self.socialLinkBadges {
                // Test
                //print("Item >> \(item.first?.key)")
                // temp string
                let str = item.first?.key
                //print("String >> \(str)")
                // Check if key in link
                if link.lowercased().range(of:str!) != nil {
                    print("exists")
                    
                    // Append link to list
                    self.socialBadges.append(item.first?.value as! UIImage)
                    
                    /*if !socialBadges.contains(item.first?.value as! UIImage) {
                     print("NOT IN LIST")
                     // Append link to list
                     self.socialBadges.append(item.first?.value as! UIImage)
                     }else{
                     print("ALREADY IN LIST")
                     }*/
                    // Append link to list
                    //self.socialBadges.append(item.first?.value as! UIImage)
                    
                    
                    
                    //print("THE IMAGE IS PRINTING")
                    //print(item.first?.value as! UIImage)
                    print("SOCIAL BADGES COUNT")
                    print(self.socialBadges.count)
                    
                    
                }
            }
            
            
            // Reload table
            self.socialBadgeCollectionView.reloadData()
        }
        
        // Add image to the end of list
        //let image = UIImage(named: "icn-plus-blue")
        //self.socialBadges.append(image!)
        
        // Reload table
        self.socialBadgeCollectionView.reloadData()
        
    }
    
    
    func resetNavigationBooleans() {
        // ContactManager 
        ContactManager.sharedManager.quickshareSMSSelected = false
        ContactManager.sharedManager.quickshareEmailSelected = false
    }
    
    func configureViews(){
        
        // Configure cards
        self.cardWrapperView.layer.cornerRadius = 12.0
        self.cardWrapperView.clipsToBounds = true
        self.cardWrapperView.layer.borderWidth = 1.5
        self.cardWrapperView.layer.borderColor = UIColor.clear.cgColor
        
        // Config image
        self.configureSelectedImageView(imageView: self.profileImageView)
        
        // Assign media buttons
        /*mediaButton1.image = UIImage(named: "social-blank")
        mediaButton2.image = UIImage(named: "social-blank")
        mediaButton3.image = UIImage(named: "social-blank")
        mediaButton4.image = UIImage(named: "social-blank")
        mediaButton5.image = UIImage(named: "social-blank")
        mediaButton6.image = UIImage(named: "social-blank")
        mediaButton7.image = UIImage(named: "social-blank")*/
        
        if ContactManager.sharedManager.quickshareSMSSelected {
            // Set placeholder
            self.emailTextField.placeholder = "Phone number"
        }
        
    }
    
    func configureSelectedImageView(imageView: UIImageView) {
        // Config imageview
        
        // Configure borders
        imageView.layer.borderWidth = 1.5
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 59    // Create container for image and name
        
    }
    
    
    
    func populateCards(){
        // Senders card config
        
        // Populate image view
        if selectedCard.cardProfile.images.count > 0{
            profileImageView.image = UIImage(data: selectedCard.cardProfile.images[0]["image_data"] as! Data)
        }
        // Populate label fields
        if let name = selectedCard.cardHolderName{
            nameLabel.text = name
        }
        if selectedCard.cardProfile.phoneNumbers.count > 0{
            numberLabel.text = selectedCard.cardProfile.phoneNumbers[0]["phone"]!
        }else{
            // Hide icon 
            phoneImageView.isHidden = true
        }
        if selectedCard.cardProfile.emails.count > 0{
            emailLabel.text = selectedCard.cardProfile.emails[0]["email"]
        }else{
            // Hide icon
            emailImageView.isHidden = true
        }
        if selectedCard.cardProfile.titles.count > 0{
            titleLabel.text = selectedCard.cardProfile.titles[0]["title"]
        }
        // Here, parse data to populate tableview
    }
    
    func validateForm() {
        
        // Here, configure form validation
        
        if (firstNameTextField.text == nil || lastNameTextField.text == nil || emailTextField.text == nil) {
            
            // form invalid
            let message = "Please enter valid contact information"
            let title = "There was an error"
            
            // Configure alertview
            let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                
                // Dismiss alert
                self.dismiss(animated: true, completion: nil)
                
            })
            
            // Add action to alert
            alertView.addAction(cancel)
            self.present(alertView, animated: true, completion: nil)
            
        }else{
            
            // Pass form values into contact object 
            contact.name = "\(firstNameTextField.text!) \(lastNameTextField.text!)"
            
            // Set notes
            if notesTextField.text != nil{
                contact.setNotes(note: notesTextField.text!)
            }
            
            // Execute send actions
            
            // Check for user intent
            if ContactManager.sharedManager.quickshareSMSSelected {
                // Set the number to contact
                contact.phoneNumbers.append(["phone": emailTextField.text!])
                // Show sms
                self.showSMSCard()
            }else{
                // Set email
                contact.emails.append(["email": emailTextField.text!])
                // Show email 
                self.showEmailCard()
            }

            
            
            
            
            // Create Transaction 
            //self.createTransaction(type: "connection")
            
        }
    }
    

    
    func createTransaction(type: String) {
        // Set type & Transaction data
        transaction.type = type
        transaction.setTransactionDate()
        transaction.senderName = ContactManager.sharedManager.currentUser.getName()
        transaction.senderId = ContactManager.sharedManager.currentUser.userId
        transaction.scope = "transaction"
        transaction.senderCardId = ContactManager.sharedManager.selectedCard.cardId!
        transaction.recipientNames = [String]()
        transaction.recipientNames?.append(contact.name)
        print("APPENDING NAME \(self.contact.name)")
        
        print("Printing Transaction")
        transaction.printTransaction()
        
        /*transaction.latitude = self.lat
        transaction.longitude = self.long
        transaction.recipientList = selectedUserIds
        transaction.location = self.address*/
        // Attach card id
        
        
        // Show progress hud
        
        let conf = KVNProgressConfiguration.default()
        conf?.isFullScreen = true
        conf?.statusColor = UIColor.white
        conf?.successColor = UIColor.white
        conf?.circleSize = 170
        conf?.lineWidth = 10
        conf?.statusFont = UIFont(name: ".SFUIText-Medium", size: CGFloat(25))
        conf?.circleStrokeBackgroundColor = UIColor.white
        conf?.circleStrokeForegroundColor = UIColor.white
        conf?.backgroundTintColor = UIColor(red: 0.173, green: 0.263, blue: 0.856, alpha: 0.4)
        KVNProgress.setConfiguration(conf)
        
        KVNProgress.show(withStatus: "Sending your card...")
        
        // Save card to DB
        let parameters = ["data": self.transaction.toAnyObject()]
        print(parameters)

        
        // Send to server
        
        Connection(configuration: nil).createTransactionCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Card Created Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                /*let dictionary : Dictionary = response as! [String : Any]
                self.transaction.transactionId = (dictionary["uuid"] as? String)!*/
                
                // Hide HUD
                KVNProgress.dismiss()
                
                // Dismiss VC
                self.dismiss(animated: true, completion: nil)
                
            } else {
                print("Card Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error with your connection request. Please try again.")
                
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
    }
    
    func uploadContactRecord(){
        
        // Assign contact
        let contact = self.contact
        
        // Show progress hud
        
        let conf = KVNProgressConfiguration.default()
        conf?.isFullScreen = true
        conf?.statusColor = UIColor.white
        conf?.successColor = UIColor.white
        conf?.circleSize = 170
        conf?.lineWidth = 10
        conf?.statusFont = UIFont(name: ".SFUIText-Medium", size: CGFloat(25))
        conf?.circleStrokeBackgroundColor = UIColor.white
        conf?.circleStrokeForegroundColor = UIColor.white
        conf?.backgroundTintColor = UIColor(red: 0.173, green: 0.263, blue: 0.856, alpha: 0.4)
        KVNProgress.setConfiguration(conf!)
        
        // Set text to HUD
        KVNProgress.show(withStatus: "Saving to your contacts...")
        
        
        // Create dictionary
        let parameters = ["data" : contact.toAnyObject(), "uuid" : ContactManager.sharedManager.currentUser.userId] as [String : Any]
        print(parameters)
        
        // Send to server
        Connection(configuration: nil).uploadContactCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                // Call successful
                print("Transaction Created Response ---> \(String(describing: response))")
                
                // Parse array for 
                let array = response as! NSArray
                print("Array List >> \(array)")
                
                // Set recipient list to transaction 
                self.transaction.recipientList = array as! [String]
                // Test
                print("Transaction List Count >> \(self.transaction.recipientList.count)")
                print("Transaction List >> \(self.transaction.recipientList)")
                
                // Create transaction
                self.createTransaction(type: "quick_share")
                
                
                // Hide HUD
                KVNProgress.dismiss()
                
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
            
            
            // Set contacts name
            let name = contact.name //"\(firstNameTextField.text!) \(lastNameTextField.text!)"
            
            if contact.phoneNumbers.count > 0 {
                // Set contact phone
                let contactPhone = contact.phoneNumbers[0]["phone"]
                
                // Launch text client
                composeVC.recipients = [contactPhone!]
            }
            
            // Set card link from cardID
            let cardLink = "https://project-unify-node-server.herokuapp.com/card/render/\(selectedCard.cardId!)"
            
            // Test String
            let str = "Hi \(name), I'd like to connect with you. Here's my information: \(String(describing: currentUser.getName()))\nBest, \n\(currentUser.fullName) \n\n\(cardLink)"
            
            // Set string as message body
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
        
        // Init variables
        var emailContact = ""
        let contactName = contact.name //"\(firstNameTextField.text!) \(lastNameTextField.text!)"
        
        // Check for nil values
        if contact.emails.count > 0{
            // Set email string
            let contactEmail = contact.emails[0]["email"]
            
            // Set variable
            emailContact = contactEmail!
        }
        
        // Create Message
        
        //let str = "Hi, I'd like to connect with you. Here's my information \n\n\(String(describing: card.cardHolderName))\n\(String(describing: card.cardProfile.emails[0]["email"]))\n\(String(describing: card.cardProfile.title))\n\nBest, \n\(currentUser.getName()) \n\n"
        
        // Set card link from cardID
        let cardLink = "https://project-unify-node-server.herokuapp.com/card/render/\(selectedCard.cardId!)"
        
        // Test String
        let str = "Hi \(contactName), I'd like to connect with you. Here's my information \n\(String(describing: currentUser.getName()))\nBest, \n\(currentUser.getName()) \n\n\(cardLink)"
        
        // Create Message
        mailComposerVC.setToRecipients([emailContact])
        mailComposerVC.setSubject("Unify Connection - I'd like to connect with you")
        mailComposerVC.setMessageBody(str, isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    
    // Message Composer Delegate
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        
        if result == .cancelled {
            // User cancelled
            print("User cancelled")
            
        }else if result == .sent{
            
            // Upload the contact record
            self.uploadContactRecord()
            

            
        }else{
            // There was an error
            KVNProgress.showError(withStatus: "There was an error sending your message. Please try again.")
            
        }
        
        // Make checks here for
        controller.dismiss(animated: true) {
            print("Message composer dismissed")
        }
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if result == .cancelled {
            // User cancelled
            print("User cancelled")
            
        }else if result == .sent{
            
            // Upload the contact record
            self.uploadContactRecord()
            
            
        }else{
            // There was an error
            KVNProgress.showError(withStatus: "There was an error sending your message. Please try again.")
            
        }
        
        
        controller.dismiss(animated: true, completion: nil)
    }
    


    
    
}
