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
           
            self.indicator.stopAnimating()
            
            //print("Passed Token... \(self.uuid_token)")

            global_uuid = self.uuid_token
            
            
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
        
        if indicator.isAnimating {
            indicator.stopAnimating()
        } else {
            indicator.startAnimating()
        }
        
        
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
        
        
        if userPin == pin {
            // Set CurrentUser to ContactManager
            ContactManager.sharedManager.currentUser = currentUser
            
            
            // Show Home Tab
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeTabView") as!
            TabBarViewController
            self.view.window?.rootViewController = homeViewController
            
        }
        
        /*
         let url:URL = URL(string: "https://unifyalphaapi.herokuapp.com/verifiyPin")!
         let session = URLSession.shared
         
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
         
         let paramString = "pin=1234&token="+self.uuid_token!
         
         request.httpBody = paramString.data(using: String.Encoding.utf8)
         
         let task = session.dataTask(with: request as URLRequest) {
         (
         data, response, error) in
         
         guard let data = data, let _:URLResponse = response, error == nil else {
         print("error")
         return
         }
         
         let dataString =  String(data: data, encoding: String.Encoding.utf8)
         print(dataString)
         
         let preferences = UserDefaults.standard
         preferences.set(self.uuid_token, forKey: "uuid")
         preferences.set(true, forKey: "isUserLoggedIn")
         
         
         DispatchQueue.main.async {
         self.indicator.startAnimating()
         }
         
         let delayInSeconds = 4.0
         DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
         
         self.indicator.stopAnimating()
         
         DispatchQueue.main.async {
         self.performSegue(withIdentifier: "createProfileSegue", sender: nil)
         }
         }
         }
         task.resume()
         */
    }
    
    
    
}


/*
extension PhoneVerificationPinViewController: PinCodeTextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: PinCodeTextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: PinCodeTextField) {
        
    }
    
    func textFieldShouldEndEditing(_ textField: PinCodeTextField) -> Bool {
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: PinCodeTextField) -> Bool {
        return true
    }
}
*/
