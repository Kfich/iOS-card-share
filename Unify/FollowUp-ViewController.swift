//
//  FollowUp-ViewController.swift
//  Unify
//
//  Created by Ryan Hickman on 4/5/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//


import UIKit
import PopupDialog
import UIDropDown
import Social
import MessageUI


class FollowUpViewController: UIViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    // Properties 
    // ---------------------------------------
    var currentUser = User()
    var transaction = Transaction()
    
    // Arrays to hold contact info
    var phoneNumbers = [String]()
    var emailAddresses = [String]()
    
    // Bool checks to see which medium to use
    var useEmails = false
    var usePhones = false
    
    var recipientIds = [String]()
    var selectedUsers = [User]()
    var selectedUserCard = ContactCard()
    var active_card_unify_uuid: String?
    
    //
    var usersHaveEmails = false
    var usersHavePhoneNumbers = false
    
    // IBOutlets
    // ---------------------------------------
    @IBOutlet var contactCardView: ContactCardView!
    
    @IBOutlet var cardWrapperView: UIView!
    
    @IBOutlet var profileCardWrapperView: UIView!
    
    
    // Labels
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var socialMediaToolBar: UIToolbar!
    
    
    // Buttons on social toolbar
    
    @IBOutlet var mediaButton1: UIBarButtonItem!
    @IBOutlet var mediaButton2: UIBarButtonItem!
    @IBOutlet var mediaButton3: UIBarButtonItem!
    
    @IBOutlet var mediaButton4: UIBarButtonItem!
    @IBOutlet var mediaButton5: UIBarButtonItem!
    @IBOutlet var mediaButton6: UIBarButtonItem!
    @IBOutlet var mediaButton7: UIBarButtonItem!
    
    // Buttons on contact bar 
    
    @IBOutlet var chatButton: UIBarButtonItem!
    @IBOutlet var callButton: UIBarButtonItem!
    @IBOutlet var emailButton: UIBarButtonItem!
    
    
    // Page Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Configure background color with image
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "backgroundGradient")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
        
        // View config 
        configureViews()
        
        // Test data for cards 
        populateCards()
        
        
    }
    
    // IBActions / Buttons Pressed
    // ---------------------------------------
    
    @IBAction func scheduleMeeting_click(_ sender: Any) {
        
        print("open calendar app with as much pre-populated data possible")
        // Configure calendar
        UIApplication.shared.openURL(NSURL(string: "calshow://")! as URL)
    }
    

    @IBAction func sendTextBtn_click(_ sender: Any) {
        
        // Parse user objects to retrieve phone numbers 
        let phoneList = self.retrievePhoneForUsers(contactsArray: self.selectedUsers)
        // Show SMS client with phone number list
        self.showSMSCard(recipientList: phoneList)
    }
    
    @IBAction func sendEmailBtn_click(_ sender: Any) {
        
        self.showEmailCard()
    
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        // Handle navigation on button press 
        navigationController?.popViewController(animated: true)
    }
    
    
    // Custom Methods
    // --------------------------------
    
    // Custom Methods
    
    func configureViews(){
        
        // Configure cards
        self.profileCardWrapperView.layer.cornerRadius = 12.0
        self.profileCardWrapperView.clipsToBounds = true
        self.profileCardWrapperView.layer.borderWidth = 1.5
        self.profileCardWrapperView.layer.borderColor = UIColor.clear.cgColor
        
        // Assign media buttons 
        mediaButton1.image = UIImage(named: "social-blank")
        mediaButton2.image = UIImage(named: "social-blank")
        mediaButton3.image = UIImage(named: "social-blank")
        mediaButton4.image = UIImage(named: "social-blank")
        mediaButton5.image = UIImage(named: "social-blank")
        mediaButton6.image = UIImage(named: "social-blank")
        mediaButton7.image = UIImage(named: "social-blank")
        
        // Config buttons for chat, call, email
        chatButton.image = UIImage(named: "btn-chat-blue")
        emailButton.image = UIImage(named: "btn-message-blue")
        callButton.image = UIImage(named: "btn-call-blue")
    }
    
    func populateCards(){
        
        // Check for nil vals
        
        var name = ""
        var phone = ""
        var email = ""
        var title = ""
        
        // Populate label fields
        if selectedUserCard.cardHolderName != "" || selectedUserCard.cardHolderName != nil{
            name = selectedUserCard.cardHolderName!
        }
        if selectedUserCard.cardProfile.phoneNumbers.count > 0{
            phone = selectedUserCard.cardProfile.phoneNumbers[0]["phone"]!
        }
        if selectedUserCard.cardProfile.emails.count > 0{
            email = selectedUserCard.cardProfile.emails[0]["email"]!
        }
        if selectedUserCard.cardProfile.title != "" || selectedUserCard.cardProfile.title != nil{
            title = self.selectedUserCard.cardProfile.title ?? ""
        }
        
        if selectedUserCard.cardProfile.images.count > 0 {
            // Populate image view
            let imageData = selectedUserCard.cardProfile.images[0]["image_data"]
            profileImageView.image = UIImage(data: imageData as! Data)
        }
        
        // Senders card
        nameLabel.text = name
        numberLabel.text = phone
        emailLabel.text = email
        titleLabel.text = title
 
    }

    func createTransaction(type: String) {
        
        // Set type & Transaction data
        transaction.type = type
        transaction.setTransactionDate()
        transaction.senderName = ContactManager.sharedManager.currentUser.getName()
        transaction.senderId = ContactManager.sharedManager.currentUser.userId
        transaction.type = "connection"
        transaction.scope = "transaction"
        transaction.senderCardId = ContactManager.sharedManager.selectedCard.cardId!
        // Show progress hud
        KVNProgress.show(withStatus: "Saving your follow up...")
        
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
                
                // Insert to manager card array
                //ContactManager.sharedManager.currentUserCardsDictionaryArray.insert([card.toAnyObjectWithImage()], at: 0)
                
                // Hide HUD
                KVNProgress.dismiss()
                
            } else {
                print("Card Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error with your follow up. Please try again.")
                
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
    }
    
    func getCardForTransaction(type: String) {
        // Show progress HUD
        KVNProgress.show(withStatus: "Fetching the card...")
        
        // Set senderCardId to params
        let parameters = ["uuid": self.transaction.senderCardId]
        print(parameters)
        
        // Send to server
        
        Connection(configuration: nil).getSingleCardCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Card Fetched Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                let dictionary : Dictionary = response as! [String : Any]
                // Init temp card
                let card = ContactCard(snapshot: dictionary as NSDictionary)
                
                // Set selected card
                self.selectedUserCard = card
                
                // Populate the card rendering with info
                self.populateCards()
                
                // Make call to get users associated
                self.fetchUsersForTransaction()
                
                // Hide HUD
                KVNProgress.dismiss()
                
            } else {
                print("Card Fetched Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error fecthing your card. Please try again.")
                
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
    }
    
    
    func fetchUsersForTransaction() {
        // Fetch the user data associated with users
        
        // Hit endpoint for updates on users nearby
        let parameters = ["data": self.transaction.recipientList]
        
        print(">>> SENT PARAMETERS >>>> \n\(parameters))")
        // Show progress
        KVNProgress.show(withStatus: "Fetching users for follow up ...")
        
        // Create User Objects
        Connection(configuration: nil).getUserListCall(parameters, completionBlock: { response, error in
            
            if error == nil {
                
                //print("\n\nConnection - Radar Response: \n\n>>>>>> \(response)\n\n")
                
                // Init dictionary to capture response
                let userArray = response as? NSDictionary
                // // Parse dictionary for array of trans
                print(userArray ?? "")
                
                // Create temp user list
                let userList = userArray?["data"] as! NSArray
                
                // Iterate over array, append trans to list
                for item in userList{
                    
                    // Init user objects from array
                    let user = User(snapshot: item as! NSDictionary)
                    
                    // Append users to Selected array
                    self.selectedUsers.append(user)
                }
                
                // Show sucess
                KVNProgress.showSuccess()
                
            } else {
                print(error ?? "")
                // Show user popup of error message
                print("\n\nConnection - User Fetch Error: \n\n>>>>>>>> \(String(describing: error))\n\n")
                KVNProgress.showError(withStatus: "There was an issue getting users. Please try again.")
            }
            // Regardless, hide hud
            KVNProgress.dismiss()
        })
        
    }
    
    func retrievePhoneForUsers(contactsArray: [User]) -> [String] {
        
        // Init email array
        var phoneList = [String]()
        
        // Iterate through email list for contact emails
        for contact in contactsArray {
            // Check for phone number
            if contact.userProfile.phoneNumbers[0]["phone"] != nil{
                let phone = contact.userProfile.phoneNumbers[0]["phone"]
                
                // Add phone to list
                phoneList.append(phone!)
                
                // Print to test phone
                print("PHONE !!!! PHONE")
                print("\n\n\(String(describing: phone))")
                print(phoneList.count)
            }
            
        }
        // Append emails to a list of emails
        
        // Return the list of emails
        return phoneList
        
    }
    
    func retrieveEmailsForUsers(contactsArray: [User]) -> [String] {
        
        // Init email array
        var emailList = [String]()
        
        // Iterate through email list for contact emails
        for contact in contactsArray {
            
            // Check for phone number
            if contact.userProfile.emails[0]["email"] != nil{
                let email = contact.userProfile.emails[0]["email"]
                
                // Add phone to list
                emailList.append(email!)
                
                // Print to test phone
                print("PHONE !!!! PHONE")
                print("\n\n\(String(describing: email))")
                print(emailList.count)
            }else{
                // Set all have emails switch to false
                
            }
            
        }
        // Append emails to a list of emails
        
        // Return the list of emails
        return emailList
    }
    
    
    
    func parseUserList(){
        
        // Get emails 
        self.emailAddresses = self.retrieveEmailsForUsers(contactsArray: self.selectedUsers)
        
        // Get phoneNumbers
        self.phoneNumbers = self.retrievePhoneForUsers(contactsArray: self.selectedUsers)
        
        // Check which medium to use
        if emailAddresses.count >= selectedUsers.count {
            // This means they all have emails 
            self.useEmails = true
        }else{
            // Default to use the phones
            self.usePhones = true
        }
        
    }
    
    
    func displayComposerSheet(){}
    

    
    
    // Mail Delegate
    func showEmailCard() {
        
        print("EMAIL CARD SELECTED")
        
        // Parse user list for emails
        let mailsList = self.retrieveEmailsForUsers(contactsArray: self.selectedUsers)
        
        // Create instance of controller
        let mailComposeViewController = configuredMailComposeViewController(recipientList: mailsList)
        
        // Check if deviceCanSendMail
        if MFMailComposeViewController.canSendMail() {
            
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }
    
    func showSMSCard(recipientList: [String]) {
        
        print("SMS CARD SELECTED")
        // Send post notif
        
        let composeVC = MFMessageComposeViewController()
        if(MFMessageComposeViewController .canSendText()){
            
            composeVC.messageComposeDelegate = self
            
            // Configure message
            let str = "Hi,\n\nIt was a pleasure connecting with you. Looking to continuing our conversation.\n\nBest, \n\(currentUser.getName()) \n\n"
            
            // Set message string
            composeVC.body = str
            // Set recipient list
            composeVC.recipients = recipientList
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
            
        }
        
    }
    
    
    // Email Composer Delegate Methods
    
    func configuredMailComposeViewController(recipientList: [String]) -> MFMailComposeViewController {
        
        // Set Selected Card
        //selectedUserCard = The one associated with the trans
        
        // Create Instance of controller
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        
        // Create Message
        mailComposerVC.setToRecipients(recipientList)
        mailComposerVC.setSubject("\(currentUser.getName()) - Nice to meet you")
        mailComposerVC.setMessageBody("Hi,\n\nIt was a pleasure connecting with you. Looking to continuing our conversation.\n\nBest, \n\(currentUser.getName()) \n\n", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
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
        
        // Dimiss controller
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


}
