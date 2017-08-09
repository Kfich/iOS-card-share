//
//  AddContactViewController.swift
//  Unify
//
//  Created by Kevin Fich on 8/7/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit
import MBPhotoPicker


class AddContactViewController: UIViewController {
    
    // Properties
    // ----------------------------------
    var currentUser = User()
    var contact = Contact()
    
    var photo = MBPhotoPicker()
    
    var profileImage = UIImage()
    
    // Parsed profile arrays
    var bios = [String]()
    var workInformation = [String]()
    var organizations = [String]()
    var titles = [String]()
    var phoneNumbers = [String]()
    var emails = [String]()
    var websites = [String]()
    var socialLinks = [String]()
    var notes = [String]()
    var tags = [String]()
    
    var uploadContactSelected = false
    
    // IBOutlets
    // ----------------------------------
    
    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet var selectProfileImageButton: UIButton!
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var doneButton: UIButton!
    
    
    // IBActions
    // ----------------------------------
    @IBAction func selectProfilePicture(_ sender: AnyObject) {
        
        // Add code to edit photo here
        photo.onPhoto = { (image: UIImage?) -> Void in
            print("Selected image")
            
            /*
             self.firstName.becomeFirstResponder()
             
             self.hasProfilePic = true
             
             
             self.profileImageContainerView.image = image
             global_image = image*/
            
            print("Selected image")
            
            // Change button text
            //self.selectProfileImageButton.titleLabel?.text = "Change"
            
            // Set image to view
            self.profileImageView.image = image
            
            // Previous location for image assignment to user object
            
            
            //self.addProfilePictureBtn.setImage(image, for: UIControlState.normal)
            
        }
        
        photo.onCancel = {
            print("Cancel Pressed")
        }
        photo.onError = { (error) -> Void in
            print("Photo selection Error")
            print("Error: \(error.rawValue)")
        }
        photo.present(self)
        
    }
    
    @IBAction func doneButtonPressed(_ sender: AnyObject) {
        // Drop the keyboard
        self.view.endEditing(true)
        
        ContactManager.sharedManager.userCreatedNewContact = true
        
        // Dismiss view
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        // Set manager to false
        ContactManager.sharedManager.userCreatedNewContact = false
        
        // Dismiss view
        dismiss(animated: true, completion: nil)
        
    }
    
    
    // Page Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign current user
        currentUser = ContactManager.sharedManager.currentUser
        
        
        // Configure done button in nav bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEditingProfile))
        
        // Add observers for notifications
        addObservers()
        
        // Set image
        let image = UIImage(named: "profile-placeholder")
        self.profileImageView.image = image
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Custom Methods
    // ----------------------------------
    
    func doneEditingProfile() {
        // Bring a manager here to handle setting the inputs back and forth
        
        print("Done editing")
    }
    
    // Custom Methods
    func addObservers() {
        // Call to refresh table
        NotificationCenter.default.addObserver(self, selector: #selector(AddContactViewController.setContact), name: NSNotification.Name(rawValue: "NewContactAdded"), object: nil)
        
        
    }
    
    func setContact() {
        // Set contact from manager
        self.contact = ContactManager.sharedManager.newContact
        
        // Parse vals
        if let first = firstNameTextField.text {
            // Assign to contact
            contact.first = first
        }else{
            print("No first")
        }
        // Parse vals
        if let last = lastNameTextField.text {
            // Assign to contact
            contact.last = last
        }else{
            print("No last")
        }
        
        // Set contact full name
        contact.name = "\(contact.first) \(contact.last)"
        
        // Set ContactManager Nav bool
        ContactManager.sharedManager.userCreatedNewContact = true
        
        // Upload record
        self.uploadContactRecord()
    }

    
    // Send to server
    func uploadContactRecord() {
        
        // Show HUD
        KVNProgress.show(withStatus: "Saving new contact..")
        
        // Send to server
        let parameters = ["data" : contact.toAnyObject(), "uuid": self.currentUser.userId] as [String : Any]
        print("\n\nContact Params")
        print(parameters)
        
        // Establish connection
        Connection(configuration: nil).uploadContactCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Contact Created Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                let dictionary : NSArray = response as! NSArray
                print(dictionary)
                
                // Hide HUD
                KVNProgress.dismiss()
                
                // Nav out the view
                self.dismiss(animated: true, completion: nil)
                
                
            } else {
                print("Card Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error creating your contact. Please try again.")
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
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