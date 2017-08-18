//
//  PhoneVerificationPin-ViewController.swift
//  Unify
//
//  Created by Ryan Hickman on 4/4/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit
import PopupDialog
import PinCodeTextField

class PhoneVerificationPinViewController: UIViewController {
    
    
    // Properties
    // --------------------------------
    
    var currentUser = User()
    var uuid_token: String?
    var pin = "1111"
    var userPin = ""
    
    // Bool check for user existance
    var isCurrentUser = false
    
    // IBOutlets
    // --------------------------------
    
    @IBOutlet var indicator: InstagramActivityIndicator!
    
    @IBOutlet weak var pinCodeArea: PinCodeTextField!
    
    @IBOutlet weak var phoneNumberDisplay: UILabel!
    
    @IBOutlet weak var verifyBtn: UIButton!
    
    @IBOutlet weak var termBox: UIView!
    
    @IBOutlet weak var modalFadeBox: UIView!
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //set height to zero so assets move to bottom for smoother transaition
        let height = CGFloat(0)
        
        //hide the assets
        self.verifyBtn.layer.opacity = 0
        self.termBox.layer.opacity = 0
        
        
        //hide the assets
        self.verifyBtn.frame.origin.y = self.view.frame.height - self.verifyBtn.frame.height
        self.termBox.frame.origin.y = self.verifyBtn.frame.origin.y - (self.verifyBtn.frame.height) + 20
        
        
        
        UIView.animate(withDuration: 0.25, delay: 1, animations: { () -> Void in
            
            self.verifyBtn.layer.opacity = 1
            self.termBox.layer.opacity = 1
            
        }) { (Bool) -> Void in
            
            //in case we need callback
        }
        

        
    }
    
    func textFieldDidEndEditing(_ textField: PinCodeTextField) {
        //set height to zero so assets move to bottom for smoother transaition
        let height = CGFloat(0)
        
        //hide the assets
        self.verifyBtn.layer.opacity = 0
        self.termBox.layer.opacity = 0
        
        
        //hide the assets
        self.verifyBtn.frame.origin.y = self.view.frame.height - self.verifyBtn.frame.height
        self.termBox.frame.origin.y = self.verifyBtn.frame.origin.y - (self.verifyBtn.frame.height) + 20
        
        print("pin done")
        

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Test to see if user passed successfully 
        currentUser.printUser()
        
        
        // Set display to phone given prior
        phoneNumberDisplay.text = global_phone
 
        //pinCodeArea.delegate = self
        pinCodeArea.keyboardType = .numberPad
        
        
        DispatchQueue.main.async {
           
           self.pinCodeArea.becomeFirstResponder()
        }
        
        
        // Notifications for keyboard delegate
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        // Clear array to avoid duplicate card
        ContactManager.sharedManager.currentUserCardsDictionaryArray.removeAll()
    }
    
    
    // IBActions
    // -----------------------------------
    @IBAction func verify_tap(_ sender: Any) {
        
        // May be a mistake, test it tho
        self.verifyBtn.isHidden = true
        
        // Also test
        self.verifyBtn.isEnabled = false
        
        
        UIView.animate(withDuration: 0.25, animations: {
            self.modalFadeBox.alpha = 0.8
        })

        // Send pin to endpoint for match
        processPin()
        


    }
    
    // Keyboard Delegate Methods
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0{
                let height = keyboardSize.height
                
                print("-----------------------------------")
                print("\n\n", self.verifyBtn.frame.height, self.verifyBtn.frame.origin.y, self.view.frame.height)
                
                
                self.verifyBtn.frame.origin.y = self.view.frame.height - self.verifyBtn.frame.height - height
                
                
                
                self.termBox.frame.origin.y = self.verifyBtn.frame.origin.y - (self.verifyBtn.frame.height) + 20
                
                self.view.layoutSubviews()
                self.view.layoutIfNeeded()
                
                print("verify")
                print("\n\n", self.verifyBtn.frame.origin.y)
                print(height)
                
                
            }
            
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y != 0 {
                let height = keyboardSize.height
                self.verifyBtn.frame.origin.y = self.view.frame.height - self.verifyBtn.frame.height
                 self.termBox.frame.origin.y = self.verifyBtn.frame.origin.y - (self.verifyBtn.frame.height) + 20
                print("no keyboard")
            }
            
        }
    }
    
    // Custom Methods
    
    // Process Pin on confirmation
    
    func processPin(){
        
        userPin = pinCodeArea.text!
        
        // Set Params
        let parameters = ["pin": userPin, "token": currentUser.userId]
        
        // Show Progress HUD
        KVNProgress.show(withStatus: "Creating your account...")
        
        Connection(configuration: nil).verifyPinCall(parameters, completionBlock: { response, error in
            if error == nil {
                
                print("\n\nConnection - Create User Response: \(String(describing: response))\n\n")
                
                Countly.sharedInstance().recordEvent("phone verification successful")

                // If here, that means we matched
        
                // Show indicator
                KVNProgress.showSuccess(withStatus: "Preparing profile.. ")

                
                self.currentUser.setVerificationPhoneStatus(status: true)

                
                // Assign current user to manager object
                //ContactManager.sharedManager.currentUser = self.currentUser

                // Store user to device
                //UDWrapper.setDictionary("user", value: self.currentUser.toAnyObjectWithImage())
                
                
                // Check if current user 
                self.checkForExisitingAccount()
                
                
                
            } else {
                print(error ?? "Error Occured Processing pin")
                
                self.verifyBtn.isEnabled = true
                
                // Show user popup of error message
                print("\n\nConnection - Create User Error: \(String(describing: error))\n\n")
                KVNProgress.showError(withStatus: "Your pin is incorrect. Please try again")
            }
            
        })
        
        
    }
    
    func checkForExisitingAccount()  {
        // Bool check 
        if isCurrentUser {
            // Set to manager 
            //ContactManager.sharedManager.currentUser = self.currentUser
            
            // Fetch data 
            self.fetchCurrentUser()
            
        }else{
            // Send to create profile
            performSegue(withIdentifier: "createProfileSegue", sender: self)
        }
    }
    
    func fetchCurrentUser() {
        // Fetch cards from server
        let parameters = ["uuid" : currentUser.userId]
        
        print("\n\nTHE CARD TO ANY - PARAMS")
        print(parameters)
        
        
        // Show progress hud
        KVNProgress.show(withStatus: "Fetching profile...")
        
        // Save card to DB
        //let parameters = ["data": card.toAnyObject()]
        
        Connection(configuration: nil).getUserCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Get User Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                let dictionary : Dictionary = response as! [String : Any]
                print("\n\nUser from get call")
                print(dictionary)
                
                let profileDict = dictionary["data"]
                
                let user = User(snapshot: profileDict as! NSDictionary)
                
                //let user = //User(snapshot: dictionary as NSDictionary)
                print("PRINTING USER")
                user.printUser()
                
                // Set current user
                ContactManager.sharedManager.currentUser = user
                
                // Show homepage
                DispatchQueue.main.async {
                    // Update UI
                    // Show Home Tab
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeTabView") as!
                    TabBarViewController
                    self.view.window?.rootViewController = homeViewController
                }

                
                // Fetch cards
                //self.fetchUserCards()
                
                
                
            } else {
                print("Card Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error retrieving your account info. Please try again.")
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
        
    }

    
    /*func createFirstCard() {
        // Create the card 
        let card = ContactManager.sharedManager.selectedCard
        
        // Add card ownerId
        card.ownerId = currentUser.userId
        
        // Process image for card
        
        
        // Show progress hud
        KVNProgress.show(withStatus: "Creating your first card...")
        
        // Save card to DB
        let parameters = ["data": card.toAnyObject()]
        print(parameters)
        
        // Send to server
        
         Connection(configuration: nil).createCardCall(parameters as [AnyHashable : Any]){ response, error in
         if error == nil {
            print("Card Created Response ---> \(String(describing: response))")
         
            // Set card uuid with response from network
            let dictionary : Dictionary = response as! [String : Any]
            card.cardId = dictionary["uuid"] as? String
         
            
            // Insert to manager card array
            ContactManager.sharedManager.currentUserCardsDictionaryArray.insert([card.toAnyObjectWithImage()], at: 0)
         
            // Set array to defualts
            UDWrapper.setArray("contact_cards", value: ContactManager.sharedManager.currentUserCardsDictionaryArray as NSArray)
            
         
         // Hide HUD
            KVNProgress.dismiss()
         
            /*
            // Show homepage
            DispatchQueue.main.async {
                // Update UI
                // Show Home Tab
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeTabView") as!
                TabBarViewController
                self.view.window?.rootViewController = homeViewController
            }*/
            
            // Perfom createProfileSegue if user doesnt have account
            
            
            // else send to home screen 
         
         
        } else {
            print("Card Created Error Response ---> \(String(describing: error))")
            // Show user popup of error message
            KVNProgress.showError(withStatus: "There was an error creating your card. Please try again.")
        
            }
         // Hide indicator
            KVNProgress.dismiss()
         }
    }*/
    
}



