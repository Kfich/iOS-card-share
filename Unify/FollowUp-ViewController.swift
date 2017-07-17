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
    
    var recipientIds = [String]()
    var recipientObjects = [User]()
    
    var selectedUserCard = ContactCard()

    var active_card_unify_uuid: String?
    
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
    }
    

    @IBAction func sendTextBtn_click(_ sender: Any) {
        
        self.showSMSCard()
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
        mediaButton1.image = UIImage(named: "icn-social-twitter.png")
        mediaButton2.image = UIImage(named: "icn-social-facebook.png")
        mediaButton3.image = UIImage(named: "icn-social-harvard.png")
        mediaButton4.image = UIImage(named: "icn-social-instagram.png")
        mediaButton5.image = UIImage(named: "icn-social-pinterest.png")
        mediaButton6.image = UIImage(named: "icn-social-twitter.png")
        mediaButton7.image = UIImage(named: "icn-social-facebook.png")
        
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
        // Set Type
        self.transaction.type = type
        // Show progress hud
        KVNProgress.show(withStatus: "Saving your follow up...")
        
        // Save card to DB
        let parameters = ["data": self.transaction.toAnyObject()]
        print(parameters)
        
        // Send to server
        
        Connection(configuration: nil).createTransactionCall(parameters as! [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Card Created Response ---> \(response)")
                
                // Set card uuid with response from network
                let dictionary : Dictionary = response as! [String : Any]
                self.transaction.transactionId = (dictionary["uuid"] as? String)!
                
                // Insert to manager card array
                //ContactManager.sharedManager.currentUserCardsDictionaryArray.insert([card.toAnyObjectWithImage()], at: 0)
                
                // Hide HUD
                KVNProgress.dismiss()
                
            } else {
                print("Card Created Error Response ---> \(error)")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error with your follow up. Please try again.")
                
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
    }
    
    func launchMailAppOnDevice()
    {
        /*
        let recipients:NSString="";
        let body:NSString="follow up"
        var email:NSString="example@unifiy.demo"
        email=email.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
        UIApplication.shared.openURL(NSURL(string: email as String)! as URL)*/
    }
    
    
    func displayComposerSheet(){}
    

    
    
    // Mail Delegate
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
        
        //selectedUserCard = The card associated with the trans
        
        print("SMS CARD SELECTED")
        // Send post notif
        
        let composeVC = MFMessageComposeViewController()
        if(MFMessageComposeViewController .canSendText()){
            
            composeVC.messageComposeDelegate = self
            
            // 6468251231
            // Configure the fields of the interface.
            composeVC.recipients = ["6463597308"]
            
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
            
            
            selectedUserCard.printCard()
            
            composeVC.body = "Hi, I'd like to connect with you. Here's my information \n\n\(name)\n\(title)\n\(email)\n\(title)"
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
            
        }
        
    }
    
    
    // Email Composer Delegate Methods
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
        // Set Selected Card
        //selectedUserCard = The one associated with the trans
        
        // Create Instance of controller
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
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
        
        
        // Create Message
        mailComposerVC.setToRecipients(["kfich7@gmail.com"])
        mailComposerVC.setSubject("Greetings - Let's Connect")
        mailComposerVC.setMessageBody("Hi, I'd like to connect with you. Here's my information \n\n\(name)\n\(title)\n\(email)\n\(title)", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
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


}
