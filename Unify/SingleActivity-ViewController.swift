//
//  SingleActivity-ViewController.swift
//  Unify
//
//  Created by Ryan Hickman on 4/5/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit
import PopupDialog
import UIDropDown


class SingleActivityViewController: UIViewController {
    
    // Properties
    // ------------------------------------------
    
    var active_card_unify_uuid: String?
    

    
    // IBOutlets
    // ------------------------------------------
    
    @IBOutlet var businessCardView: BusinessCardView!
    
    @IBOutlet var contactCardView: ContactCardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Background view configuration
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
        
        // View configuration 
        configureViews()
        }
    
    

    // IBOActions / Buttons Pressed
    // ------------------------------------------
    
    @IBAction func followUpBtn_click(_ sender: Any) {
        
        
        self.performSegue(withIdentifier: "activityFollowUpSegue", sender: self)

    }

    
    // Custom Methods
    
    func configureViews(){
        
        // Configure cards
        self.businessCardView.layer.cornerRadius = 10.0
        self.businessCardView.clipsToBounds = true
        self.businessCardView.layer.borderWidth = 2.0
        self.businessCardView.layer.borderColor = UIColor.lightGray.cgColor
        
        self.contactCardView.layer.cornerRadius = 10.0
        self.contactCardView.clipsToBounds = true
        self.contactCardView.layer.borderWidth = 2.0
        self.contactCardView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        
    }

    
    // Navigation 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        print(">Passed Contact Card ID")
        print(sender!)
        
        if segue.identifier == "activityFollowUpSegue"
        {
            
            let nextScene =  segue.destination as! FollowUpViewController
            
            nextScene.active_card_unify_uuid = "\(self.active_card_unify_uuid!)" as! String?
            
        }
    }
    


}
