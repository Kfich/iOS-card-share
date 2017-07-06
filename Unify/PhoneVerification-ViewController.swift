//
//  PhoneVerification-ViewController.swift
//  Unify
//
//  Created by Ryan Hickman on 4/4/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//


import UIKit
import PopupDialog
import UIDropDown


class PhoneVerificationViewController: UIViewController, UITextFieldDelegate {
    
    // Properties
    // --------------------------------
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    // IBOutlets
    // --------------------------------

    @IBOutlet weak var termsBox: UIView!
    
    @IBOutlet weak var phoneVerBox: UIView!
    
    @IBOutlet weak var phoneNumberInput: UITextField!
    
    @IBOutlet weak var sendConfirmationBtn: UIButton!
    
    @IBOutlet weak var UsePhoneTxtBox: UILabel!

    @IBOutlet weak var modalFadeBox: UIView!
    
    
    // Page Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        UIView.animate(withDuration: 1.5, animations: {
            self.modalFadeBox.alpha = 0.7
        })
        
        
        // Set Input Delegate to self
        self.phoneNumberInput.delegate = self
        
        // Present keyboard on pageload
        phoneNumberInput.becomeFirstResponder()
        
        // Add Action to textfield
        phoneNumberInput.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        
        // Add Oberservers for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
    }
    
    
    // Keyboard Delegate Methods
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0{
                let height = keyboardSize.height
                
                print("\n\n", self.sendConfirmationBtn.frame.origin.y)

                
                self.sendConfirmationBtn.frame.origin.y = self.view.frame.height - self.sendConfirmationBtn.frame.height - height
                
                self.termsBox.frame.origin.y = self.sendConfirmationBtn.frame.origin.y - (self.sendConfirmationBtn.frame.height) + 20

                self.phoneVerBox.frame.origin.y = self.termsBox.frame.origin.y - (self.phoneVerBox.frame.height)

             
                self.UsePhoneTxtBox.frame.origin.y =  self.phoneVerBox.frame.origin.y - 40
                
                print("\n\n", self.sendConfirmationBtn.frame.origin.y)
                print(self.termsBox.frame.origin.y )
                print(self.phoneVerBox.frame.origin.y)
                

                
                
            }
            
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y != 0 {
                let height = keyboardSize.height
                self.sendConfirmationBtn.frame.origin.y = self.view.frame.height - self.sendConfirmationBtn.frame.height - height
                
                self.termsBox.frame.origin.y = self.view.frame.height - (self.sendConfirmationBtn.frame.height - height) - (self.termsBox.frame.height - height)
                
                self.phoneVerBox.frame.origin.y = self.view.frame.height - (self.sendConfirmationBtn.frame.height - height) - (self.phoneVerBox.frame.height - height) - (self.termsBox.frame.height - height)
                

            }
            
        }
    }
    
    // Add formatting action to textfield
    func textFieldDidChange(_ textField: UITextField) {
        
        
        if format(phoneNumber: textField.text! ) != nil
        {
            textField.text = format(phoneNumber: textField.text! )!
        }
        
    }
    
    
    
    // IBActions
    // ----------------------------------------
    

    @IBAction func sendConfirmationBtn_click(_ sender: Any) {
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "sendConfirmationSegue", sender: self)
        }
        
        
        /*
        print(  validate(value: phoneNumberInput.text!) )
        
       if (phoneNumberInput.text!.isPhoneNumber == true)
       {
        
            sendConfirmationBtn.isEnabled = false
        
            issuePinConfirmation()

        
       } else {
        
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(phoneNumberInput.center.x - 10, phoneNumberInput.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(phoneNumberInput.center.x + 10, phoneNumberInput.center.y))
        phoneNumberInput.layer.add(animation, forKey: "position")
        
        }
        */
    }
    
    // Custom Methods
    
    func validate(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    func issuePinConfirmation(){
        
        let url:URL = URL(string: "https://unifyalphaapi.herokuapp.com/issuePin")!
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let paramString = "phone="+phoneNumberInput.text!
        
        global_phone = phoneNumberInput.text!

        
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
            
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "sendConfirmationSegue", sender: dataString! )
            }
            
        }
        
        task.resume()
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        print(">Passed Token")
        print(sender)
        
        let nextScene =  segue.destination as! PhoneVerificationPinViewController
        
        
            nextScene.uuid_token = sender as! String?
    }
    
}





func format(phoneNumber sourcePhoneNumber: String) -> String? {
    
    // Remove any character that is not a number
    let numbersOnly = sourcePhoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    let length = numbersOnly.characters.count
    let hasLeadingOne = numbersOnly.hasPrefix("1")
    
    // Check for supported phone number length
    guard length == 7 || length == 10 || (length == 11 && hasLeadingOne) else {
        return nil
    }
    
    let hasAreaCode = (length >= 10)
    var sourceIndex = 0
    
    // Leading 1
    var leadingOne = ""
    if hasLeadingOne {
        leadingOne = "1 "
        sourceIndex += 1
    }
    
    // Area code
    var areaCode = ""
    if hasAreaCode {
        let areaCodeLength = 3
        guard let areaCodeSubstring = numbersOnly.characters.substring(start: sourceIndex, offsetBy: areaCodeLength) else {
            return nil
        }
        areaCode = String(format: "(%@) ", areaCodeSubstring)
        sourceIndex += areaCodeLength
    }
    
    // Prefix, 3 characters
    let prefixLength = 3
    guard let prefix = numbersOnly.characters.substring(start: sourceIndex, offsetBy: prefixLength) else {
        return nil
    }
    sourceIndex += prefixLength
    
    // Suffix, 4 characters
    let suffixLength = 4
    guard let suffix = numbersOnly.characters.substring(start: sourceIndex, offsetBy: suffixLength) else {
        return nil
    }
    
    return leadingOne + areaCode + prefix + "-" + suffix
}

extension String.CharacterView {
    /// This method makes it easier extract a substring by character index where a character is viewed as a human-readable character (grapheme cluster).
    internal func substring(start: Int, offsetBy: Int) -> String? {
        guard let substringStartIndex = self.index(startIndex, offsetBy: start, limitedBy: endIndex) else {
            return nil
        }
        
        guard let substringEndIndex = self.index(startIndex, offsetBy: start + offsetBy, limitedBy: endIndex) else {
            return nil
        }
        
        return String(self[substringStartIndex ..< substringEndIndex])
    }
}

extension String {
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.characters.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.characters.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}
