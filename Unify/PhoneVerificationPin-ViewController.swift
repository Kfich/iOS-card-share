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
    
    @IBOutlet var indicator: InstagramActivityIndicator!
    
    var uuid_token: String?
    
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
        
        
        
        
        phoneNumberDisplay.text = global_phone
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)

        //pinCodeArea.delegate = self
        pinCodeArea.keyboardType = .numberPad
        
        DispatchQueue.main.async {
           self.indicator.stopAnimating()
            
            print("Passed Token... \(self.uuid_token)")

            global_uuid = self.uuid_token
            
            
            //self.pinCodeArea.becomeFirstResponder()
        }
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
    }
    
    
    
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
    
    
    

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
         let nextScene =  segue.destination as! CreateAccountViewController
        
       
        
    }

    
    
    func processPin()
    {
        
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
        
       
        
    }
    
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
