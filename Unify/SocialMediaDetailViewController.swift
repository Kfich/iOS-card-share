//
//  SocialMediaDetailViewController.swift
//  Unify
//
//  Created by Kevin Fich on 8/3/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit

class SocialMediaDetailViewController: UIViewController {
    
    // Properties
    // -------------------------------------
    var currentUser = User()
    var selectedMediaLink = ""
    
    // IBOutlets
    // -------------------------------------
    @IBOutlet var mediaTextField: UITextField!
    
    
    
    // Page setup
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set selected link to the box 
        mediaTextField.text = self.selectedMediaLink
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions
    // -------------------------------------
    
    @IBAction func doneEditing(_ sender: Any) {
        
        // Check for nils
        if mediaTextField.text == ""{
            
            // Show Alert
            
            // form invalid
            let message = "Please make sure to enter valid media information"
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
            // No error 
            // Assign value to profile
            currentUser.userProfile.setSocialLinks(socialRecords: ["link" : mediaTextField.text!])
            
            // Reassign object to manager
            ContactManager.sharedManager.currentUser = self.currentUser
            
            currentUser.printUser()
            
            // Update user 
            //self.updateCurrentUser()
        }
        
        // Post notif
        self.postNotification()
        
        // Dismiss VC
        dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        // Dismiss VC 
        dismiss(animated: true, completion: nil)
    }
    
    
    // Custom methods 
    
    func postNotification() {
        
        // Notification for radar screen
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Media Selected"), object: self)
        
    }

    
    func updateCurrentUser() {
        // Configure to send to server
        
        
        // Send to server
        let parameters = ["data" : currentUser.toAnyObject(), "uuid" : currentUser.userId] as [String : Any]
        print("\n\nTHE CARD TO ANY - PARAMS")
        print(parameters)
        
        // Store current user cards to local device
        //let encodedData = NSKeyedArchiver.archivedData(withRootObject: ContactManager.sharedManager.currentUserCards)
        //UDWrapper.setData("contact_cards", value: encodedData)
        
        
        // Show progress hud
        KVNProgress.show(withStatus: "Updating your account...")
        
        Connection(configuration: nil).updateUserCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Card Created Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                let dictionary : Dictionary = response as! [String : Any]
                print(dictionary)
                
                
                // Store user to device
                //UDWrapper.setDictionary("user", value: self.currentUser.toAnyObjectWithImage())
                
                // Hide HUD
                KVNProgress.dismiss()
                
                // Nav out the view
                self.navigationController?.popViewController(animated: true)
                
                
            } else {
                print("Card Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error creating your card. Please try again.")
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
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
