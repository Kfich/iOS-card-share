//
//  EditProfileViewController.swift
//  Unify
//
//  Created by Kevin Fich on 5/31/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit
import Eureka
import MBPhotoPicker

class EditProfileViewController: UIViewController {
    
    // Properties
    // ----------------------------------
    var currentUser = User()
    
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
        
        // Set Manager intent switch to true 
        ContactManager.sharedManager.userSelectedEditCard = true
        
        
        // Nav out the view
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    
    
    // Page Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign current user
        currentUser = ContactManager.sharedManager.currentUser
        
        // Check for image, set to imageview
        if currentUser.profileImages.count > 0{
            profileImageView.image = UIImage(data: currentUser.profileImages[0]["image_data"] as! Data)
        }
        
        // Do any additional setup after loading the view.
        //firstNameTextField.inputAccessoryView = doneButton
        
        // Configure done button in nav bar 
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEditingProfile))
        
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
