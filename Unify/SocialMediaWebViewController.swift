//
//  SocialMediaWebViewController.swift
//  Unify
//
//  Created by Kevin Fich on 8/14/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit

class SocialMediaWebViewController:  UIViewController {
    
    // Properties
    // ----------------------------
    
    // IBOutlets
    // ----------------------------
    
    @IBOutlet var webViewer: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Show webview
        showMedia()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions
    // ----------------------------
    
    @IBAction func dismissView(_ sender: Any) {
        // Drop viewcontroller
        dismiss(animated: true, completion: nil)
    }
    
    // Custom Methods
    
    // Show privacy webview
    func showMedia() {
        
        let viewLink = ContactManager.sharedManager.selectedSocialMediaLink
        print(viewLink)
        // Show view
        webViewer.loadRequest(URLRequest(url: URL(string: viewLink)!))
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
