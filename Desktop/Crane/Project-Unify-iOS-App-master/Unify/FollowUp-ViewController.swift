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
    
    
    
    // Page Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
        
        // View config 
        configureViews()
        
        
    }
    
    // IBActions / Buttons Pressed
    // ---------------------------------------
    
    @IBAction func scheduleMeeting_click(_ sender: Any) {
        
        print("open calendar app with as much pre-populated data possible")
    }
    

    @IBAction func sendTextBtn_click(_ sender: Any) {
        
        
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
        
    }
    
    @IBAction func sendEmailBtn_click(_ sender: Any) {
        
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
    }
    
    // Custom Methods
    // --------------------------------
    
    // Custom Methods
    
    func configureViews(){
        
        // Configure cards
        self.contactCardView.layer.cornerRadius = 10.0
        self.contactCardView.clipsToBounds = true
        self.contactCardView.layer.borderWidth = 2.0
        self.contactCardView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult){
        
        print(result)
        
        self.dismiss(animated: true) { () -> Void in
            
        }
    }
    
    func launchMailAppOnDevice()
    {
        let recipients:NSString="";
        let body:NSString="follow up"
        var email:NSString="example@unifiy.demo"
        email=email.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
        UIApplication.shared.openURL(NSURL(string: email as String)! as URL)
    }
    
    
    func displayComposerSheet()
    {
        let picker: MFMailComposeViewController=MFMailComposeViewController()
        picker.mailComposeDelegate=self;
        picker .setSubject("follow up")
        picker.setMessageBody("follow up", isHTML: true)
        let data: NSData = UIImagePNGRepresentation(UIImage(named: "images.jpg")!)! as NSData
        picker.addAttachmentData(data as Data, mimeType: "image/png", fileName: "images.png")
        self.present(picker, animated: true, completion: nil)
    }
    
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError?)
    {
        
        print(result)

        self.dismiss(animated: false, completion: nil)
    }
    
    
    // Navigation


}
