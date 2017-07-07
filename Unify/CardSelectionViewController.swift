//
//  CardSelectionViewController.swift
//  Unify
//
//  Created by Kevin Fich on 6/28/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit
import MessageUI

class CardSelectionViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    // Properties
    // --------------------------------------------
    
    var selectedCard = ContactCard()
    
    var active_card_unify_uuid: String?
    
    // IBOutlets
    // --------------------------------------------
    @IBOutlet var followupActionToolbar: UIToolbar!
    @IBOutlet var socialMediaToolbar: UIToolbar!
    @IBOutlet var cardWrapperView: UIView!
    @IBOutlet var cardShadowView: UIView!
    @IBOutlet var contactOutreachToolbar: UIToolbar!
    
    // Outreach toolbar
    @IBOutlet var outreachChatButton: UIBarButtonItem!
    @IBOutlet var outreachCallButton: UIBarButtonItem!
    @IBOutlet var outreachMailButton: UIBarButtonItem!
    
    
    // Tableview
    @IBOutlet var profileInfoTableView: UITableView!
    
    // Card info outlets
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var contactImageView: UIImageView!
    @IBOutlet var smsButton: UIBarButtonItem!
    @IBOutlet var emailButton: UIBarButtonItem!
    @IBOutlet var callButton: UIBarButtonItem!
    
    
    
    // IBActions / Buttons Pressed
    // --------------------------------------------
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        
        //dismiss(animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func smsSelected(_ sender: AnyObject) {
        
        let composeVC = MFMessageComposeViewController()
        
        if(MFMessageComposeViewController .canSendText()){
            
            composeVC.messageComposeDelegate = self
            
            // 6468251231
            
            // Configure the fields of the interface.
            composeVC.recipients = ["6463597308"]
            composeVC.body = "Hi, I'd like to connect with you. Here's my information \n\n\(String(describing: selectedCard.cardHolderName))\n\(String(describing: selectedCard.cardProfile.emails[0]["email"]))\n\(String(describing: selectedCard.cardProfile.title)))"
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func emailSelected(_ sender: AnyObject) {
        // Create instance of controller
        let mailComposeViewController = configuredMailComposeViewController()
        
        // Check if deviceCanSendMail
        if MFMailComposeViewController.canSendMail() {
            
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }
    @IBAction func callSelected(_ sender: AnyObject) {
        
        // configure call
        
    }
    
    @IBAction func sendTextBtn_click(_ sender: Any) {
        
        /*
         let composeVC = MFMessageComposeViewController()
         if(MFMessageComposeViewController .canSendText())
         {
         
         composeVC.messageComposeDelegate = self
         
         // Configure the fields of the interface.
         composeVC.recipients = ["6468251231"]
         composeVC.body = "Follow up from Unify!"
         
         // Present the view controller modally.
         self.present(composeVC, animated: true, completion: nil)
         
         }
         */
    }
    
    @IBAction func sendEmailBtn_click(_ sender: Any) {
        
        /*
         let mailClass:AnyClass?=NSClassFromString("MFMailComposeViewController")
         if(mailClass != nil)
         {
         if((mailClass?.canSendMail()) != nil)
         {
         displayComposerSheet()
         }
         else
         {
         launchMailAppOnDevice()
         }
         }
         else
         {
         launchMailAppOnDevice()
         }
         
         */
    }

    
    // Email Composer Delegate Methods
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
        // Create Instance of controller
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        // Create Message
        mailComposerVC.setToRecipients(["kfich7@gmail.com"])
        mailComposerVC.setSubject("Greetings - Let's Connect")
        mailComposerVC.setMessageBody("Hi, I'd like to connect with you. Here's my information \n\n\(String(describing: selectedCard.cardHolderName))\n\(String(describing: selectedCard.cardProfile.emails[0]["email"]))\n\(String(describing: selectedCard.cardProfile.title)))", isHTML: false)
        
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
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // Page Setup
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Do any additional setup after loading the view.
        
        // Config Views
        configureViews()
        
        // Populate the cardviewer
        populateCards()
        
        // Configure background image graphics
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "backgroundGradient")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
        
        
        // Config navigation bar
        self.navigationController?.navigationBar.barTintColor = UIColor(red: Int(0.0/255.0), green: Int(97.0/255.0), blue: Int(140.0/255.0))
        
        // Set color to nav bar
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor(red: 28/255.0, green: 52/255.0, blue: 110/255.0, alpha: 1.0)]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        
        /* if contactsHits.count == 0
         {
         return Int(view.bounds.height/SelectRecipientViewController.kRowHeight) + 1
         
         } else {
         
         return contactsHits.count
         }*/
        
        return 8
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        //var cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath)
        
        
        cell = tableView.dequeueReusableCell(withIdentifier: "BioInfoCell", for: indexPath)
        
        
        return cell
    }
    
    // Message Composer Delegate
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        // Make checks here for
        controller.dismiss(animated: true) { 
            print("Message composer dismissed")
        }
    }

    
    
    // Custom Methods
    // -------------------------------------------
    
    func populateCards(){
        // Senders card config
        
        // Populate image view
        let imageData = selectedCard.cardProfile.images[0]["image_data"]
        contactImageView.image = UIImage(data: imageData as! Data)
        // Populate label fields
        nameLabel.text = selectedCard.cardHolderName
        phoneLabel.text = selectedCard.cardProfile.phoneNumbers[0]["phone"]
        emailLabel.text = selectedCard.cardProfile.emails[0]["email"]
        titleLabel.text = selectedCard.cardProfile.title
        
        // Here, parse data to populate tableview
    }
    
    func configureViews(){
        // Round out the vards here
        // Configure cards
        self.cardWrapperView.layer.cornerRadius = 12.0
        self.cardWrapperView.clipsToBounds = true
        self.cardWrapperView.layer.borderWidth = 2.0
        self.cardWrapperView.layer.borderColor = UIColor.white.cgColor
        
        self.profileInfoTableView.layer.cornerRadius = 12.0
        self.profileInfoTableView.clipsToBounds = true
        self.profileInfoTableView.layer.borderWidth = 2.0
        self.profileInfoTableView.layer.borderColor = UIColor.white.cgColor
        
        // Set shadow on the container view
                
        
        // Toolbar button config
        
        outreachChatButton.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir", size: 13)!], for: UIControlState.normal)
        
        outreachMailButton.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir", size: 13)!], for: UIControlState.normal)
        
        outreachCallButton.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir", size: 13)!], for: UIControlState.normal)
        
        
        
        // Config buttons
        // ** Email and call inverted
        smsButton.image = UIImage(named: "btn-chat-blue")
        callButton.image = UIImage(named: "btn-message-blue")
        
        // Hide call button
        emailButton.image = UIImage(named: "")
        emailButton.isEnabled = false
        outreachCallButton.isEnabled = false
        outreachCallButton.title = ""
        
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
