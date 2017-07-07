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
        
        
        store = CNContactStore()
        //checkContactsAccess()
        
        //getContacts()
        
        
        
        DispatchQueue.main.async {
            //self.notifyFunction()
            
            var onboardingVC: OnboardingViewController?
            
            
            // Configure view controller
            let firstPage = OnboardingContentViewController(title: "", body: "", image: UIImage(named: "onboard_screen1"), buttonText: "Next") { () -> Void in
                // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
                
                
                onboardingVC?.moveNextPage()
                
            }
            
           // Configure view controller
            let secondPage = OnboardingContentViewController(title: "", body: "", image: UIImage(named: "onboard_screen2"), buttonText: "Get Started") { () -> Void in
                // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
                
                // ************ Set up a postnotification to the VC to dismiss onboardingVC ******************
                // Then perform segue to the create profile
                
                
                
                //onboardingVC?.performSegue(withIdentifier: "createProfileSegue", sender: self)
                
            }
            
            // Add Content controller to the main VC
            onboardingVC = OnboardingViewController(backgroundImage: UIImage(named: "backgroundGradient"), contents: [firstPage, secondPage])
            
            // Present the content controller
            self.present(onboardingVC!, animated: true, completion: nil)
            
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

