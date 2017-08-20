//
//  PinAuthViewController.swift
//  Unify
//
//  Created by Kevin Fich on 8/20/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit

class PinAuthViewController: UIViewController, UITextFieldDelegate {
    
    // Properties
    // =========================================
    
    var counter = 0
    var testPin = "1111"
    var usePin: Bool = false
    
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
    
    // pin Variable is where initial PIN entry stored
    // Once set, the variable itself calls the verification stage (step 2) of the PIN process
    
    var pin: String!{
        didSet {
            updatePins(count: pin.characters.count)
            if pin.characters.count == 4 {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    // your code here
                    self.onPin(pin: self.pin)
                }
                
            }
        }
    }
    
    
    var attempt2: String! {
        didSet {
            updatePins(count: pin.characters.count)
            if (attempt2.characters.count == 4) {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    // your code here
                    self.onPin(pin: self.attempt2)
                }
                
            }
        }
    }
    
    var attempt3: String! {
        didSet {
            updatePins(count: pin.characters.count)
            if (attempt3.characters.count == 4) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    // your code here
                    self.onPin(pin: self.attempt3)
                }
                
                
            }
        }
    }
    var attempt4: String! {
        didSet {
            updatePins(count: pin.characters.count)
            if (attempt4.characters.count == 4) {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    // your code here
                    self.onPin(pin: self.attempt4)
                }
                
                
            }
        }
    }
    
    
    
    
    var stage: Stage = .Pin {
        didSet {
            updatePins(count: 0)
            
        }
    }
    
    
    
    // ---------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        textField.delegate = self
        
        // Hide pins to start
        firstPinView.isHidden = true
        secondPinView.isHidden = true
        thirdPinView.isHidden = true
        fourthPinView.isHidden = true
        
        
        /*let when = DispatchTime.now() + 5 // change 2 to desired number of seconds
         DispatchQueue.main.asyncAfter(deadline: when) {
         // Your code with delay
         
         self.dismiss(animated: true, completion: nil)
         }*/
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
        //   textField.inputAccessoryView = keyboardCancelButton
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        attempt = 1
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // IBOutets
    // =========================================
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var fourthPin: UIButton!
    @IBOutlet var fourthPinView: UIView!
    
    @IBOutlet weak var thirdPin: UIButton!
    @IBOutlet var thirdPinView: UIView!
    
    @IBOutlet weak var secondPin: UIButton!
    @IBOutlet var secondPinView: UIView!
    
    @IBOutlet weak var firstPin: UIButton!
    @IBOutlet var firstPinView: UIView!
    
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet var keyboardCancelButton: UIButton!
    
    // Custom Methods
    // ========================================
    
    // Validate pin entry
    func onPin(pin: String) {
        
        if pin == testPin {
            attempt = 1
            view.endEditing(true)
            //goHome()
            
            self.view.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC")
            self.view.window?.makeKeyAndVisible()
            
            
            
        } else {
            
            
            print("Wrong pin")
            updatePins(count: 0)
            
            if attempt < totalAttempt {
                print("This printed !")
                
                showOKAlertView(title: nil, message: "Incorrect PIN\nAttempt \(attempt) of \(totalAttempt)")
                
                attempt = attempt + 1
                
                pinEntry = ""
                textField.text = ""
                counter = 0
                
            } else {
                resetPin()
                // self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    // Reset pin entry
    func resetPin() {
        usePin = false
        
        // Reset pin logics
    }
    
    // Update pin as entred in keyboard
    
    func updatePins(count: Int) {
        firstPin.isSelected = count >= 1
        
        secondPin.isSelected = count >= 2
        thirdPin.isSelected = count >= 3
        fourthPin.isSelected = count >= 4
    }
    
    // Alert Controllers
    func showOKAlertView(title: String?, message: String?) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertView, animated: true, completion: nil)
    }
    
    
    // Delegate Methods / Protocols
    // =========================================
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        pinEntry = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        print(pinEntry)//to the console
        
        counter = counter + 1
        
        // Show pins accordingly
        switch counter {
        case 1:
            firstPin.isHidden = false
            firstPinView.isHidden = true
        case 2:
            secondPin.isHidden = false
            secondPinView.isHidden = true
            
        case 3:
            thirdPin.isHidden = false
            thirdPinView.isHidden = true
            
        case 4:
            fourthPin.isHidden = false
            fourthPinView.isHidden = true
            
        default:
            print("All pins hidden")
        }
        
        // Update counter
        if counter > 4 {
            return false
        }
        
        // Update stage value in auth process
        switch stage {
        case .Pin:
            pin = pinEntry
        case .Pin2:
            attempt2 = pinEntry
        case .Pin3:
            attempt3 = pinEntry
        case .Pin4:
            attempt4 = pinEntry
        default:
            pinEntry = ""
        }
        
        if (pinEntry.characters.count == 4) { return false }
        
        return true
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
