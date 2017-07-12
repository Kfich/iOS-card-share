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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Test to see if user passed successfully 
        currentUser.printUser()
        
        
        // Set display to phone given prior
        phoneNumberDisplay.text = global_phone
 
        //pinCodeArea.delegate = self
        pinCodeArea.keyboardType = .numberPad
        
        
        DispatchQueue.main.async {
           
            //self.indicator.stopAnimating()
            
            //print("Passed Token... \(self.uuid_token)")

            //global_uuid = self.uuid_token
            
            
            //self.pinCodeArea.becomeFirstResponder()
        }
        
        
        // Notifications for keyboard delegate
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
    }
    
    
    // IBActions
    // -----------------------------------
    @IBAction func verify_tap(_ sender: Any) {
        
        //self.verifyBtn.isHidden = true
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
                
                print("no keyboard")
            }
            
        }
    }
    
    // Custom Methods
    
    // Process Pin on confirmation
    
    func processPin(){
        
        userPin = pinCodeArea.text!
        
        let parameters = ["pin": userPin, "token": currentUser.userId]
        
        Connection(configuration: nil).verifyPinCall(parameters, completionBlock: { response, error in
            if error == nil {
                
                print("\n\nConnection - Create User Response: \(response)\n\n")
                
                // If here, that means we matched
        
                // Show indicator
                KVNProgress.showSuccess(withStatus: "Profile Creation Complete. Welcome to Unify.")
                // Assign current user to manager object
                ContactManager.sharedManager.currentUser = self.currentUser

                // Store user to device 
                UDWrapper.setDictionary("user", value: self.currentUser.toAnyObjectWithImage())
                
                // Show homepage
                DispatchQueue.main.async {
                    // Update UI
                    // Show Home Tab
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeTabView") as!
                    TabBarViewController
                    self.view.window?.rootViewController = homeViewController
                }
                
                
                
                
            } else {
                print(error)
                // Show user popup of error message
                print("\n\nConnection - Create User Error: \(error)\n\n")
                KVNProgress.show(withStatus: "There was an issue with your pin. Please try again.")
            }
            
        })
        
        
    }
    
}

