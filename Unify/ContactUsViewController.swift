//
//  ContactUsViewController.swift
//  Unify
//
//  Created by Kevin Fich on 7/25/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController {
    
    // Properties
    // -----------------------------
    
    
    // IBOutlets
    // -----------------------------
    @IBOutlet var contactTextView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let contactString = "Please visit: \n\n\twww.GoUnify.com"
        
        // Set to text view 
        contactTextView.text = contactString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions
    // -----------------------------
    
    @IBAction func backButtonSelected(_ sender: Any) {
        // Pop view controller 
        self.navigationController?.popViewController(animated: true)
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
