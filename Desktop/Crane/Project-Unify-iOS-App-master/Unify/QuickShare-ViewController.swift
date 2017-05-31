//
//  QuickShare-ViewController.swift
//  Unify
//
//  Created by Ryan Hickman on 4/4/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//


import UIKit
import MapKit
import CoreLocation



class QuickShareViewController: UIViewController {
    
    // Properties
    // ------------------------------------------

    
    // IBOutlets
    // ------------------------------------------
    
    @IBOutlet var businessCardView: BusinessCardView!
    
    @IBOutlet var saveToContactsSwitch: UISwitch!

    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var indicator: InstagramActivityIndicator!
    
    @IBOutlet var cardView: UIView!
    
    
    // Text fields
    
    @IBOutlet var recipientTextField: UITextField!
    
    @IBOutlet var firstNameTextField: UITextField!
    
    @IBOutlet var lastNameTextField: UITextField!
    
    @IBOutlet var emailTextField: UITextField!
    
    
    // Page configuration
    // ------------------------------------------

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
        
        self.indicator.stopAnimating()

    }
    
    // IBActions / Buttons pressed
    // ------------------------------------------
    
    @IBAction func saveToContactsSelected(_ sender: AnyObject) {
        
        // Configure saving logics
        
        print("\n\nSAVE TO CONTACTS\n\n")
    }
    
    

    
    @IBAction func saveBtn_click(_ sender: Any) {
        
        // Here, configure form validation 
        
        if (recipientTextField.text == nil || firstNameTextField.text == nil || lastNameTextField.text == nil || emailTextField.text == nil) {
            
            // form invalid 
            
            let message = "Please enter valid contact information"
            
            //showOKAlertView("", message: message)
            
            
        }else{
            
            // Configure the actual send actions
            
            DispatchQueue.main.async {
                self.indicator.startAnimating()
                
                // send the data
            }
            
            let delayInSeconds = 3.0
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
                
                self.indicator.stopAnimating()
                
                self.dismiss(animated: true, completion: nil)
                
            }

            
        }
    }
    
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // Custom Methods
    
    

    
    
}
