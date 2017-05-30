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

    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var indicator: InstagramActivityIndicator!
    
    @IBOutlet var cardView: UIView!
    
    @IBOutlet var cardViewContactImage: UIImageView!
    
    
    // Labels

    @IBOutlet var cardTypeLabel: UILabel!
    
    @IBOutlet var cardViewNameLabel: UILabel!
    
    @IBOutlet var cardViewPhoneLabel: UILabel!
    
    @IBOutlet var cardViewEmailLabel: UILabel!
    
    @IBOutlet var cardViewOptionLabel: UILabel!
    
    @IBOutlet var phoneIconImage: UIImageView!
    
    @IBOutlet var emailIconImage: UIImageView!
    
    @IBOutlet var optionalIconImage: UIImageView!
    
    
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

    
    @IBAction func saveBtn_click(_ sender: Any) {
        
        // Configure the actual send actions
        
        DispatchQueue.main.async {
            self.indicator.startAnimating()
        }
        
        let delayInSeconds = 4.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
            
            self.indicator.stopAnimating()
            
            self.dismiss(animated: true, completion: nil)
        
        }
        
    }
    
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
