//
//  AddContactViewController.swift
//  Unify
//
//  Created by Kevin Fich on 8/7/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit
import MBPhotoPicker
import Contacts


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
        
        // Config imageview
        self.configureSelectedImageView(imageView: self.profileImageView)
        
        // Config picker
        self.configurePhotoPicker()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Custom Methods
    // ----------------------------------
    
    func configureSelectedImageView(imageView: UIImageView) {
        // Config imageview
        
        // Configure borders
        imageView.layer.borderWidth = 1.5
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 35    // Create container for image and name
        
    }
    
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
        //self.contact = ContactManager.sharedManager.newContact
        
        // Parse vals
        if let first = firstNameTextField.text {
            // Assign to contact
            ContactManager.sharedManager.newContact.first = first
        }else{
            print("No first")
        }
        // Parse vals
        if let last = lastNameTextField.text {
            // Assign to contact
            ContactManager.sharedManager.newContact.last = last
        }else{
            print("No last")
        }
        
        // Set contact full name
        ContactManager.sharedManager.newContact.name = "\(ContactManager.sharedManager.newContact.first) \(ContactManager.sharedManager.newContact.last)"
        
        // Set ContactManager Nav bool
        ContactManager.sharedManager.userCreatedNewContact = true
        
        // Store contact to list
        self.syncContact()
        
        // Upload record
        self.uploadContactRecord()
    }

    
    
    
    func configurePhotoPicker() {
        //Initial setup
        self.photo.disableEntitlements = false // If you don't want use iCloud entitlement just set this value True
        photo.alertTitle = "Select Contact Image"
        photo.alertMessage = ""
        photo.resizeImage = CGSize(width: 150, height: 150)
        photo.allowDestructive = false
        photo.allowEditing = false
        // Set front facing camera
        photo.cameraDevice = .front
        photo.cameraFlashMode = .auto
        
        photo.actionTitleLibrary = "Photo Library"
        photo.actionTitleLastPhoto = "Last Photo"
        photo.actionTitleTakePhoto = "Take Photo"
        photo.actionTitleCancel = "Cancel"
        photo.actionTitleOther = "Import From..."
    }
    
    // Send to server
    func uploadContactRecord() {
        
        // Assign contact object
        self.contact = ContactManager.sharedManager.newContact
        
        // Show HUD
        KVNProgress.show(withStatus: "Saving new contact..")
        
        // Send to server
        let parameters = ["data" : contact.toAnyObject(), "uuid": self.currentUser.userId] as [String : Any]
        print("\n\nContact Params")
        print(parameters)
        
        // Show HUD
        KVNProgress.show(withStatus: "Uploading new contact..")
        
        // Establish connection
        Connection(configuration: nil).uploadContactCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Contact Created Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                let dictionary : NSArray = response as! NSArray
                print(dictionary)
                
                // Hide HUD
                KVNProgress.showSuccess(withStatus: "Contact added successfully!")
                
                // Sync contact to list and sort
                
                
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
    
    func syncContact() {
        
        // Init CNContact Object 
        //let temp = CNContact()
        //temp.emailAddresses.append(CNLabeledValue<NSString>)
        let tempContact = ContactManager.sharedManager.newContact
        
        // Append to list of existing contacts
        let store = CNContactStore()
        
        // Set text for name
        let contactToAdd = CNMutableContact()
        contactToAdd.givenName = self.firstNameTextField.text ?? ""
        contactToAdd.familyName = self.lastNameTextField.text ?? ""
        
        // Parse for mobile
        let mobileNumber = CNPhoneNumber(stringValue: (tempContact.phoneNumbers[0]["phone"] ?? ""))
        let mobileValue = CNLabeledValue(label: CNLabelPhoneNumberMobile, value: mobileNumber)
        contactToAdd.phoneNumbers = [mobileValue]
        
        // Parse for emails
        let email = CNLabeledValue(label: CNLabelWork, value: tempContact.emails[0]["email"] as! NSString ?? "")
        contactToAdd.emailAddresses = [email]
        
        if let image = self.profileImageView.image {
            contactToAdd.imageData = UIImagePNGRepresentation(image)
        }
        
        if tempContact.titles.count > 0 {
            // Add to contact
            contactToAdd.jobTitle = tempContact.titles[0]["title"]!
        }
        if tempContact.organizations.count > 0 {
            // Add to contact
            contactToAdd.organizationName = tempContact.organizations[0]["organization"]!
        }
    
        // Save contact to phone
        let saveRequest = CNSaveRequest()
        saveRequest.add(contactToAdd, toContainerWithIdentifier: nil)
        
        do {
            try store.execute(saveRequest)
        } catch {
            print(error)
        }
    
        // Init contact object
        let newContact : CNContact = contactToAdd
        
        print("New Contact >> \(newContact)")
        
        // Append to contact list
        ContactManager.sharedManager.phoneContactList.append(newContact)
        
        // Post notification for refresh
        self.postRefreshNotification()

    }
    
    func postRefreshNotification() {
        // Notification for list refresh
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshContactsTable"), object: self)
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
