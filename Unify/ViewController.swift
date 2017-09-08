//
//  ViewController.swift
//  Unify
//
//  Created by Ryan Hickman on 4/2/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import Onboard
import UIKit
import PopupDialog
import Contacts

class ViewController: UIViewController {

    var store: CNContactStore!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Notification observers
        addObservers()
        
        store = CNContactStore()
        //checkContactsAccess()
        
        //getContacts()
        
        
        // Set background gradient
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "backgroundGradient")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)

        
        // Configure onboarding vcs
        DispatchQueue.main.async {
            //self.notifyFunction()
            
            var onboardingVC: OnboardingViewController?
            
            
            // Configure view controller
            let firstPage = OnboardingContentViewController(title: "", body: "", image: UIImage(named: "onboard"), buttonText: "") { () -> Void in
                // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
                
                //onboardingVC?.backgroundImage = UIImage(named: "onboard")
                //onboardingVC?.moveNextPage()
                
            }
            
           // Configure view controller
            let secondPage = OnboardingContentViewController(title: "", body: "", image: UIImage(named: "onboard-second"), buttonText: "Get Started") { () -> Void in
                // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
                
                // ************ Set up a postnotification to the VC to dismiss onboardingVC ******************
                // Then perform segue to the create profile
                
                // Notification for radar screen
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CreateProfileNotification"), object: self)

                
                //onboardingVC?.backgroundImage = UIImage(named: "onboard-second")
                
            
                //onboardingVC?.performSegue(withIdentifier: "createProfileSegue", sender: self)
                
            }
            
            // Add Content controller to the main VC
            onboardingVC = OnboardingViewController(backgroundImage: UIImage(named: "backgroundGradient"), contents: [firstPage, secondPage])
            
            
            onboardingVC?.shouldMaskBackground = false
            
            //let images = [UIImage(named: "onboard"), UIImage(named: "onboard_bg")]
            
            
            // Present the content controller
            self.present(onboardingVC!, animated: true, completion: nil)
            
        }
    }

    
    // Notification Center
    func addObservers() {
        // Notif for nav
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.dismissPresentation), name: NSNotification.Name(rawValue: "CreateProfileNotification"), object: nil)
        
        // Notif for comments
        //NotificationCenter.default.addObserver(self, selector: #selector(PresentationViewController.showCommentAlert), name: NSNotification.Name(rawValue: "ShowCommentBox"), object: nil)
        
    }
    
    func dismissPresentation(){
        // Drop onboarding and push segue
        
        self.dismiss(animated: true) { 
            // Hit segue 
            self.performSegue(withIdentifier: "phoneVerificationSegue", sender: self)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let nextScene =  segue.destination as! PhoneVerificationViewController
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


}



extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

