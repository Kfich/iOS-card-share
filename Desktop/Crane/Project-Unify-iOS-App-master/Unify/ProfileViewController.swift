//
//  ProfileViewController.swift
//  Unify
//
//  Created by Kevin Fich on 5/31/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    // Properties
    // ===================================
    
    
    // IBOutlets
    // ===================================
    // Labels
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    
    // Buttons
    
    @IBOutlet var mediaButton1: UIButton!
    @IBOutlet var mediaButton2: UIButton!
    @IBOutlet var mediaButton3: UIButton!
    
    @IBOutlet var mediaButton4: UIButton!
    @IBOutlet var mediaButton5: UIButton!
    @IBOutlet var mediaButton6: UIButton!
    
    @IBOutlet var viewCardsButton: UIButton!
    

    // Page Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set up views 
        configureViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // IBActions / Buttons Pressed
    // ===================================
    

    // Custom Methods
    // -----------------------------------
    
    func configureViews(){
        // Add radius config & border color
        self.mediaButton1.layer.cornerRadius = 10.0
        self.mediaButton1.clipsToBounds = true
        self.mediaButton1.layer.borderWidth = 1.0
        self.mediaButton1.layer.borderColor = UIColor.lightGray.cgColor
        
        // Add radius config & border color
        self.mediaButton2.layer.cornerRadius = 10.0
        self.mediaButton2.clipsToBounds = true
        self.mediaButton2.layer.borderWidth = 1.0
        self.mediaButton2.layer.borderColor = UIColor.lightGray.cgColor
        
        // Add radius config & border color
        self.mediaButton3.layer.cornerRadius = 10.0
        self.mediaButton3.clipsToBounds = true
        self.mediaButton3.layer.borderWidth = 1.0
        self.mediaButton3.layer.borderColor = UIColor.lightGray.cgColor
        
        // Add radius config & border color
        self.mediaButton4.layer.cornerRadius = 10.0
        self.mediaButton4.clipsToBounds = true
        self.mediaButton4.layer.borderWidth = 1.0
        self.mediaButton4.layer.borderColor = UIColor.lightGray.cgColor
        
        // Add radius config & border color
        self.mediaButton5.layer.cornerRadius = 10.0
        self.mediaButton5.clipsToBounds = true
        self.mediaButton5.layer.borderWidth = 1.0
        self.mediaButton5.layer.borderColor = UIColor.lightGray.cgColor
        
        // Add radius config & border color
        self.mediaButton6.layer.cornerRadius = 10.0
        self.mediaButton6.clipsToBounds = true
        self.mediaButton6.layer.borderWidth = 1.0
        self.mediaButton6.layer.borderColor = UIColor.lightGray.cgColor
        
        

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
