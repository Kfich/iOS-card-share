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

class PhoneVerificationPinViewController: UIViewController, UITextFieldDelegate{
    
    
    // Properties
    // --------------------------------
    
    var currentUser = User()
    var uuid_token: String?
    var pin = "1111"
    var userPin = ""
    var counter = 0
    var attempt = 1 {
        didSet {
            print(attempt)
        }
    }
    var totalAttempt = 5
    
    var pinEntry: String!
    
    enum Stage {
        case Pin
        case Pin2
        case Pin3
        case Pin4
        case Pin5
        
        case Restart
        
    }
    // Handle nav
    var userCancelledEntry = false
    
    
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
    
    @IBOutlet weak var textField: UITextField!
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        //set height to zero so assets move to bottom for smoother transaition
        let height = CGFloat(0)
        
        //self.textField.inputView = self.verifyBtn
        
        DispatchQueue.main.async {
            
            //self.textField.becomeFirstResponder()
            self.pinCodeArea.becomeFirstResponder()
        }

        
        // Notifications for keyboard delegate
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        /*
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
        }*/
        

        
    }
    
    func textFieldDidEndEditing(_ textField: PinCodeTextField) {
        
        /*
        print("This is the execution for editing ending")
        
        //set height to zero so assets move to bottom for smoother transaition
        
        let height = CGFloat(0)
        
        //hide the assets
        self.verifyBtn.layer.opacity = 0
        self.termBox.layer.opacity = 0
        
        
        //hide the assets
        self.verifyBtn.frame.origin.y = self.view.frame.height - self.verifyBtn.frame.height
        self.termBox.frame.origin.y = self.verifyBtn.frame.origin.y - (self.verifyBtn.frame.height) + 20
        
        print("pin done")*/
        

    }
    
    func textFieldDidBeginEditing(_ textField: PinCodeTextField) {
        
        print("Editing!!")
        //set height to zero so assets move to bottom for smoother transaition
        /*
         let height = CGFloat(0)
         
         //hide the assets
         self.verifyBtn.layer.opacity = 0
         self.termBox.layer.opacity = 0
         
         
         //hide the assets
         self.verifyBtn.frame.origin.y = self.view.frame.height - self.verifyBtn.frame.height
         self.termBox.frame.origin.y = self.verifyBtn.frame.origin.y - (self.verifyBtn.frame.height) + 20
         
         print("pin done")*/
        
        
        
    }


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        // Test to see if user passed successfully 
        currentUser.printUser()
        
        
        // Set display to phone given prior
        //phoneNumberDisplay.text = global_phone
 
        //pinCodeArea.delegate = self
        pinCodeArea.keyboardType = .numberPad
        
        // Add button to top of keyboard
        //pinCodeArea.inputAccessoryView = self.verifyBtn
        
        
        
        DispatchQueue.main.async {
           
            //self.textField.becomeFirstResponder()
           self.pinCodeArea.becomeFirstResponder()
        }
        
        
        // Notifications for keyboard delegate
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        // Clear array to avoid duplicate card
        ContactManager.sharedManager.currentUserCardsDictionaryArray.removeAll()
        
        // Drop keyboard
        self.view.endEditing(true)
        
        
        NotificationCenter.default.removeObserver(self)

    }
    
    
    // IBActions
    // -----------------------------------
    @IBAction func verify_tap(_ sender: Any) {
        
        // Return user to previous screen
        self.navigationController?.popViewController(animated: true)
        
        // Set bool
        self.userCancelledEntry = true
        
        ContactManager.sharedManager.userCancelledPinEntry = true
        
        print("Contact Manager Verify Tap \n\(ContactManager.sharedManager.currentUser.toAnyObject())")
        
        self.dismiss(animated: true) {
            // Print   
            print("Drop the vc")
        }
        
        // Execute issue pin call
        //self.issuePin()
        
        
       /* // May be a mistake, test it tho
        self.verifyBtn.isHidden = true
        
        // Also test
        self.verifyBtn.isEnabled = false
        
        
        UIView.animate(withDuration: 0.25, animations: {
            self.modalFadeBox.alpha = 0.8
        })

        // Send pin to endpoint for match
        processPin()*/
        


    }
    
    // Keyboard Delegate Methods
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0{
                let height = keyboardSize.height
                
                print("-----------------------------------")
                print("\n\n", self.verifyBtn.frame.height, self.verifyBtn.frame.origin.y, self.view.frame.height)
                
                
                self.verifyBtn.frame.origin.y = self.view.frame.height - self.verifyBtn.frame.height - height
                
                
                
                //self.termBox.frame.origin.y = self.verifyBtn.frame.origin.y - (self.verifyBtn.frame.height) + 20
                
                self.view.layoutSubviews()
                self.view.layoutIfNeeded()
                
                print("verify")
                print("\n\n", self.verifyBtn.frame.origin.y)
                print(height)
                
                
            }
            
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        print("Maybe call pin on will hide?!?")
        
        // Hide verify btn
        self.verifyBtn.isHidden = true
        
        
        // Process pin
        
        
        if userCancelledEntry != true {
            // Execute verification
            processPin()
        }else{
            // The user needed to resend
            print("User cancelled entry")
        }
       
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y != 0 {
                let height = keyboardSize.height
                self.verifyBtn.frame.origin.y = self.view.frame.height - self.verifyBtn.frame.height
                 self.termBox.frame.origin.y = self.verifyBtn.frame.origin.y - (self.verifyBtn.frame.height) + 20
                print("no keyboard")
                
                // Layout views
                self.view.layoutSubviews()
                self.view.layoutIfNeeded()
            }
            
        }
    }
    
    // Custom Methods
    
    // Process Pin on confirmation
    
    func processPin(){
        
        userPin = pinCodeArea.text ?? ""
        
        print("This is the user pin from area >> \(userPin)")
        
        
        // Set Params
        let parameters = ["pin": userPin, "token": currentUser.userId]
        
        // Show Progress HUD
        KVNProgress.show(withStatus: "Processing your account...")
        
        Connection(configuration: nil).verifyPinCall(parameters, completionBlock: { response, error in
            if error == nil {
                
                print("\n\nConnection - Pin Processing Response: \(String(describing: response))\n\n")
                
                
                let successDict = response as! NSDictionary
                
                let success = successDict["success"] as! Bool
                print("Success status \(success)")
                
                if success{
                    // Pin successful
                    
                    Countly.sharedInstance().recordEvent("phone verification successful")
                    
                    // If here, that means we matched
                    
                    // Show indicator
                    //KVNProgress.showSuccess(withStatus: "Preparing profile.. ")
                    
                    
                    self.currentUser.setVerificationPhoneStatus(status: true)
                    
                    
                    // Assign current user to manager object
                    //ContactManager.sharedManager.currentUser = self.currentUser
                    
                    // Store user to device
                    //UDWrapper.setDictionary("user", value: self.currentUser.toAnyObjectWithImage())
                    
                    // Show success
                    KVNProgress.showSuccess()
                    
                    // Check if current user 
                    self.checkForExisitingAccount()
                    
                }else{
                    
                    // Show user popup of error message
                    print("\n\nConnection - Create User Error: \(String(describing: error))\n\n")
                    KVNProgress.showError(withStatus: "Your pin is incorrect. Please try again")
                    
                    // Clear pin values
                    self.userPin = ""
                    // Clear pin text area
                    self.pinCodeArea.text = ""
                    // Reenable button
                    self.verifyBtn.isEnabled = true
                    self.verifyBtn.isHidden = false
                    
                    // Relaunch keyboard
                    DispatchQueue.main.async {
                        self.pinCodeArea.becomeFirstResponder()
                    }

                    
                }
                
                
                
            } else {
                print(error ?? "Error Occured Processing pin")
                
                self.verifyBtn.isEnabled = true
                self.verifyBtn.isHidden = false
                
                // Show user popup of error message
                print("\n\nConnection - Create User Error: \(String(describing: error))\n\n")
                KVNProgress.showError(withStatus: "An error with the connection occured. Please try again")
         
               
            }
            
        })
        
        
    }
    
    func checkForExisitingAccount()  {
        // Bool check 
        if isCurrentUser && UDWrapper.getDictionary("user") == nil{
            // Set to manager 
            //ContactManager.sharedManager.currentUser = self.currentUser
            
            // Fetch data 
            self.fetchCurrentUser()
            
        }else if self.isCurrentUser && UDWrapper.getDictionary("user") != nil{
            // User should be set in manager already
            print("Should be set in manager >> \n\(ContactManager.sharedManager.currentUser.toAnyObjectWithImage())")
            
            // Show homepage
            DispatchQueue.main.async {
                // Update UI
                // Show Home Tab
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeTabView") as!
                TabBarViewController
                self.view.window?.rootViewController = homeViewController
            }
            
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
        //KVNProgress.show(withStatus: "Fetching profile...")
        
        // Save card to DB
        //let parameters = ["data": card.toAnyObject()]
        
        Connection(configuration: nil).getUserCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Get User Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                let dictionary : Dictionary = response as! [String : Any]
                print("\n\nUser from get call")
                print(dictionary)
                
                print("\n\nIs Current User >> \(self.isCurrentUser)")
                
                if self.isCurrentUser && UDWrapper.getDictionary("user") != nil {
                    
                    // Init user object
                    if let user = UDWrapper.getDictionary("user"){
                        // Init &  Set to manager
                        self.currentUser =  User(withDefaultsSnapshot:user)
                        // Set to manager
                        ContactManager.sharedManager.currentUser = self.currentUser
                        
                        print("Contact Manager Found User On PinVC \n\(self.currentUser.toAnyObjectWithImage())")
                        
                    }
                    // Set status to true
                    self.currentUser.setVerificationPhoneStatus(status: true)
                    
                    // Store user to device
                    UDWrapper.setDictionary("user", value: ContactManager.sharedManager.currentUser.toAnyObjectWithImage())
                    
                    // Print to test
                    //self.currentUser.printUser()
                    
                    // Show homepage
                    DispatchQueue.main.async {
                        // Update UI
                        // Show Home Tab
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeTabView") as!
                        TabBarViewController
                        self.view.window?.rootViewController = homeViewController
                    }

                    
                    
                }else if self.isCurrentUser{
                    // Send to create account
                    print("PhonePinVerifVC \nIsCurrentUser >> \(self.isCurrentUser) && The user dictionary >> Nil")
                    
                    // Test current user manager object
                    print("ContactManager On PinVC \n>> >> \(ContactManager.sharedManager.currentUser.toAnyObject()) ")
                    
                    
                    // Set Manager navigation path
                    ContactManager.sharedManager.userIsRemoteUser = true
                    
                    // Show homepage
                    DispatchQueue.main.async {
                        // Update UI
                        // Show Home Tab
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeTabView") as!
                        TabBarViewController
                        self.view.window?.rootViewController = homeViewController
                    }
                    
                    
                }else{
                    
                    // Send user to create profile
                    DispatchQueue.main.async {
                        // Update UI
                        // Send to create profile
                        self.performSegue(withIdentifier: "createProfileSegue", sender: self)
                     
                    }
                }
                
                // Set user to manager object
                //ContactManager.sharedManager.currentUser = self.currentUser
                
                // Show success
                //KVNProgress.showSuccess(withStatus: "The Code Has Been Sent.")
                
                

                
                
                /*
                
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
                }*/

                
                // Fetch cards
                //self.fetchUserCards()
                
                
                
            } else {
                print("Card Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error retrieving your account info. Please try again.")
            }
            // Hide indicator
           // KVNProgress.dismiss()
        }
        
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // Delegate Methods / Protocols
    // =========================================
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        pinEntry = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        print("Pin code area input", pinEntry)//to the console
        
        counter = counter + 1
        
        // Update counter
        if counter > 4 {
            return false
        }
        
        if (pinEntry.characters.count == 4) {
            
            print("The pin entry output on 4 count .. \(pinEntry)")
            //processPin()
            
            return false
        }
        
        return true
    }

    
    func issuePin()  {
        // 
        
        // Save user to device if callback successful
        
        // Create user dictionary to store to DB
        let parameters = ["data": currentUser.toAnyObject()]
        
        
       // KVNProgress.show(withStatus: "Sending Confirmation Code...")
        
        // Create User Objects
        Connection(configuration: nil).issuePinCall(parameters, completionBlock: { response, error in
            if error == nil {
                
                print("\n\nConnection - Create User Response: \(String(describing: response))\n\n")
                
                // Here you set the id for the user and resubmit the object
                
                let dictionary : Dictionary = response as! [String : Any]
                // Assign uuid to user object
                self.currentUser.userId = dictionary["uuid"] as! String
                
                // Check if current user bool set
                let check = dictionary["isUser"] as! Bool
                
                
                
                // Set bool with result
                if check == false{
                    // False
                    self.isCurrentUser = false
                    print("")
                }else{
                    // True
                    self.isCurrentUser = true
                }
                
                 print("Is CurrentUser On Phone Pin VC > \(self.isCurrentUser)")
                
                
                // Check if user needs to be set
                if self.isCurrentUser && UDWrapper.getDictionary("user") != nil {
                    
                    // Init user object
                    if let user = UDWrapper.getDictionary("user"){
                        // Init &  Set to manager
                        self.currentUser =  User(withDefaultsSnapshot:user)
                        // Set to manager
                        ContactManager.sharedManager.currentUser = self.currentUser
                        
                    }
                    // Set status to true
                    self.currentUser.setVerificationPhoneStatus(status: true)
                    
                    // Store user to device
                    UDWrapper.setDictionary("user", value: ContactManager.sharedManager.currentUser.toAnyObjectWithImage())
                    
                    // Print to test
                    self.currentUser.printUser()
                }else{
                    // Send to create account
                   print("PhonePinVerifVC \nIsCurrentUser >> False && The user dictionary >> Nil")
                    
                }
                
                // Set user to manager object
                //ContactManager.sharedManager.currentUser = self.currentUser
                
                // Show success
                KVNProgress.showSuccess(withStatus: "The Code Has Been Sent.")
                
                
                DispatchQueue.main.async {
                    // Update UI
                    self.performSegue(withIdentifier: "sendConfirmationSegue", sender: self)
                }
                
                
                
            } else {
                print("\n\nConnection - Create User Error: \(String(describing: error))\n\n")
                
                
                // retry again
                /*if self.retryAttempts < 3 {
                    
                    self.sendPhoneVerificationCode()
                    
                } else {
                    
                    KVNProgress.showError(withStatus: "There was an error. Please try again.")
                    
                }*/
                
                
            }
            
        })

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



