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
        
        // Senders card
        profileImageView.image = UIImage(named: "throwback.png")
        nameLabel.text = "Harold Fich"
        numberLabel.text = "1+ (123)-345-6789"
        emailLabel.text = "Kev.fich12@gmail.com"
        titleLabel.text = "Founder & CEO, CleanSwipe"
    }

    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult){
        
        print(result)
        
        self.dismiss(animated: true) { () -> Void in
            
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
    
    
    func displayComposerSheet()
    {
        /*
        let picker: MFMailComposeViewController=MFMailComposeViewController()
        picker.mailComposeDelegate=self;
        picker .setSubject("follow up")
        picker.setMessageBody("follow up", isHTML: true)
        let data: NSData = UIImagePNGRepresentation(UIImage(named: "images.jpg")!)! as NSData
        picker.addAttachmentData(data as Data, mimeType: "image/png", fileName: "images.png")
        self.present(picker, animated: true, completion: nil)*/
    }
    
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError?)
    {
        
        print(result)

        self.dismiss(animated: false, completion: nil)
    }
    
    
    // Navigation


}
