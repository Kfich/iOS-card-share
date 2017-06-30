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
            
            
            
            let firstPage = OnboardingContentViewController(title: "", body: "", image: UIImage(named: "onboard_screen1"), buttonText: "Next") { () -> Void in
                // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
                
                
                onboardingVC?.moveNextPage()
                
            }
            
           
            
            let secondPage = OnboardingContentViewController(title: "", body: "", image: UIImage(named: "onboard_screen2"), buttonText: "Next") { () -> Void in
                // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
                
                onboardingVC?.moveNextPage()
            }
            
            let thirdPage = OnboardingContentViewController(title: "", body: "", image: UIImage(named: "onboard_screen3"), buttonText: "Next") { () -> Void in
                // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
                
                onboardingVC?.moveNextPage()
            }
            
            
            let forthPage = OnboardingContentViewController(title: "", body: "", image: UIImage(named: "onboard_screen4"), buttonText: "Get Started") { () -> Void in
                // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
                
                
                
                onboardingVC?.dismiss(animated: true, completion: { () -> Void in
                 
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "phoneVerificationSegue", sender: self)
                    }
                    
                })
                
               
                
               
                
                
            }
            
            
            firstPage.actionButton.backgroundColor =  UIColor(rgb: 0x29AAAA)
            firstPage.actionButton.layer.cornerRadius = 8

            secondPage.actionButton.backgroundColor =  UIColor(rgb: 0x29AAAA)
            secondPage.actionButton.layer.cornerRadius = 8

            
            thirdPage.actionButton.backgroundColor =  UIColor(rgb: 0x29AAAA)
            thirdPage.actionButton.layer.cornerRadius = 8

            
            forthPage.actionButton.backgroundColor =  UIColor(rgb: 0x29AAAA)
            forthPage.actionButton.layer.cornerRadius = 8

            
            onboardingVC = OnboardingViewController(backgroundImage: UIImage(named: "backgroundGradient"), contents: [firstPage, secondPage, thirdPage, forthPage])
            
            
            self.present(onboardingVC!, animated: true, completion: nil)
            
        }

      
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        //let nextScene =  segue.destination as! PhoneVerificationViewController
        
        
        
       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
       
    private func checkContactsAccess() {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        // Update our UI if the user has granted access to their Contacts
        case .authorized:
            self.accessGrantedForContacts()
            
        // Prompt the user for access to Contacts if there is no definitive answer
        case .notDetermined :
            self.requestContactsAccess()
            
        // Display a message if the user has denied or restricted access to Contacts
        case .denied,
             .restricted:
            let alert = UIAlertController(title: "Privacy Warning!",
                                          message: "Permission was not granted for Contacts.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    
    
    private func requestContactsAccess() {
        
        store.requestAccess(for: .contacts) {granted, error in
            if granted {
                DispatchQueue.main.async {
                    self.accessGrantedForContacts()
                    return
                }
            }
        }
    }
    
    
    
    // This method is called when the user has granted access to their address book data.
    private func accessGrantedForContacts() {
        //Update UI for grated state.
        //...
        getContacts()
    }
    
    
    
    
    
    func uploadContactRecords(contacts: [CNContact])
    {
        print(contacts)
        
        let json = [ "uid":"12345" , "contacts": contacts ] as [String : Any]
        
        let data = [AnyObject]()
        
     
        
        /*
        for contact in contacts
        {
           
            print("----------------------------")
            
            print(contact.givenName)
            
            data.append(givenName: givenName)
            
            for email in contact.emailAddresses
            {
                
                
                
                print(email.label!)
                print(email.value)
                
            }
            
            print("----------------------------")

        }
        */
       
        
        /*
        for contact in contacts as! [CNContact] {
         
        }
        */
        
        
        
        /*
        do {
            
        
        let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) as! [String:Any]

           print(jsonData)
            
        } catch let error as NSError {
    
            print(error)
    
        }
    
      
        
        
        let url:URL = URL(string: "https://unifyalphaapi.herokuapp.com/importContactRecords")!
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        //let paramString = "fileUrl=\(fileUrl)&employeeId=hickmanTest&moveId=12345&notes=\(globalNotes!)&barcodeId=\(globalCode!)"
        
        //request.httpBody = contacts.data(using: String.Encoding.utf8)
        
        request.httpBody = jsonData

        
        let task = session.dataTask(with: request as URLRequest) {
            (
            data, response, error) in
            
            guard let data = data, let _:URLResponse = response, error == nil else {
                print("error")
                return
            }
            
            let dataString =  String(data: data, encoding: String.Encoding.utf8)
            print(dataString)
            
            
           
            
            
        }
        
        task.resume()
        */
    }
    

    
    // Pull contacts and sync to server
    
    func retrieveContactsWithStore(store: CNContactStore) {
        do {
            let groups = try store.groups(matching: nil)
            let predicate = CNContact.predicateForContactsInGroup(withIdentifier: groups[0].identifier)
            //let predicate = CNContact.predicateForContactsMatchingName("John")
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactEmailAddressesKey] as [Any]
            
            let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
            
                self.uploadContactRecords(contacts: (contacts as AnyObject) as! [CNContact])
            
            
        } catch {
            print(error)
        }
    }
    
    
    
    func getContacts() {
        let store = CNContactStore()
        
        if CNContactStore.authorizationStatus(for: .contacts) == .notDetermined {
            store.requestAccess(for: .contacts, completionHandler: { (authorized: Bool, error: NSError?) -> Void in
                if authorized {
                    self.retrieveContactsWithStore(store: store)
                }
            } as! (Bool, Error?) -> Void)
        } else if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
            self.retrieveContactsWithStore(store: store)
        }
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

