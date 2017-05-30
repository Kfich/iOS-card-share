//
//  ContactProfileViewController.swift
//  Unify
//
//  Created by Kevin Fich on 5/24/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit

class ContactProfileViewController: UIViewController {
    
    // Properties
    // --------------------------------------------
    
    var active_card_unify_uuid: String?
    
    
    // IBOutlets
    // --------------------------------------------
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var companyLabel: UILabel!
    
    @IBOutlet var emailLabel: UILabel!
    
    @IBOutlet var phoneLabel: UILabel!
    
    @IBOutlet var contactImageView: UIImageView!
    
    @IBOutlet var smsButton: UIButton!
    
    @IBOutlet var emailButton: UIButton!
    
    @IBOutlet var callButton: UIButton!
    
    
    
    // IBActions / Buttons Pressed
    // --------------------------------------------
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        
        //dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func smsSelected(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "QuickShareVC")
        self.present(controller, animated: true, completion: nil)
        
    }
    
    @IBAction func emailSelected(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "QuickShareVC")
        self.present(controller, animated: true, completion: nil)
        
    }
    @IBAction func callSelected(_ sender: AnyObject) {
        
        // configure call 
    }
    
    
    
    // Page Setup

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
 
        // Do any additional setup after loading the view.
        
        // Hide nav bar 
        
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        self.navigationController?.navigationBar.isHidden = false 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
