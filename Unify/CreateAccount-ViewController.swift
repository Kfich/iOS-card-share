//
//  CreateAccount-ViewController.swift
//  Unify
//
//  Created by Ryan Hickman on 4/4/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//


import Onboard
import UIKit
import PopupDialog
import Contacts
import MBPhotoPicker
import Alamofire

class CreateAccountViewController: UIViewController {
    
    // Properties
    // -----------------------------------------------
    
    var store: CNContactStore!
    var hasProfilePic = false
    lazy var photo = MBPhotoPicker()
    
    // User object to assign form fields
    var newUser = User()
    var card = ContactCard()
    
    // To track image ids
    var idString = ""

    
    // IBOutlets
    // -----------------------------------------------
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var addProfilePictureBtn: UIButton!
    
    @IBOutlet weak var createAccountBtn: UIButton!
    
    @IBOutlet weak var profileImageContainerView: UIImageView!
    
    @IBOutlet var cardWrapperView: UIView!
    
    
    // View Prep
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set button on top of keyboard
        self.email.inputAccessoryView = createAccountBtn
        
        // error here
        //firstName.becomeFirstResponder()
        
        // Config Photo Picker
        configurePhotoPicker()
        
        // Configure views 
        configureViews()
        
        
        // Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        
    }
    
    
    
    // IBActions
    // -----------------------------------------------
    
    
    @IBAction func AddProfilePicture_click(_ sender: Any) {
        
        photo.onPhoto = { (image: UIImage?) -> Void in
            print("Selected image")
            
            /*
            self.firstName.becomeFirstResponder()
            
            self.hasProfilePic = true
            
            
            self.profileImageContainerView.image = image
            global_image = image*/
            
            print("Selected image")
            
            // Change button text
            self.addProfilePictureBtn.titleLabel?.text = "Change"
            
            // Set image to view
            self.profileImageContainerView.image = image
            
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
    
    
    @IBAction func createAccountBtn_click(_ sender: Any) {
        
        
        print(firstName.text!)
        print(lastName.text!)
        // Assign form values to user object
        newUser.emails.append(["profile_email": email.text!])
        newUser.firstName = firstName.text!
        newUser.lastName = lastName.text!
        newUser.setName(first: firstName.text!, last: lastName.text!)
        newUser.fullName = newUser.getName()
        
        // Pull image data
        
        // Image data png
        //let imageData = UIImagePNGRepresentation(self.profileImageContainerView.image!, 0.5)
        let imageData = UIImageJPEGRepresentation(self.profileImageContainerView.image!, 0.5)
        print(imageData!)
        
        // Generate id string for image
        idString = newUser.randomString(length: 20)
        
        // Set id string to user object for image
        newUser.profileImageId = idString
        
        // Assign asset name and type
        let fname = idString
        let mimetype = "image/png"
        
        // Create image dictionary
        let imageDict = ["image_id": idString, "image_data": imageData!, "file_name": fname, "type": mimetype] as [String : Any]
        
        // Add image to user profile images
        self.newUser.setImages(imageRecords: imageDict)
        
        
        // Upload to Server
        // Save card to DB
        let parameters = imageDict
        print(parameters)
        
        // Create URL For Prod
        //let prodURL = "https://project-unify-node-server-stag.herokuapp.com/uploadcdn"
        
        // Create URL For Test
        let testURL = "https://project-unify-node-server.herokuapp.com/image/uploadcdn"
        
        
        // Show progress HUD
        KVNProgress.show(withStatus: "Generating profile..")
        
        // Upload image with Alamo
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData!, withName: "files", fileName: "\(fname).jpg", mimeType: "image/jpg")
            
            print("Multipart Data >>> \(multipartFormData)")
            /*for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }*/
            
            // Currently Set to point to Prod Server
        }, to:testURL)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print("\n\n\n\n success...")
                    print(response.result.value ?? "Successful upload")
                    
                    // Dismiss hud
                    KVNProgress.dismiss()
                }
                
            case .failure(let encodingError):
                print("\n\n\n\n error....")
                print(encodingError)
                // Show error message
                KVNProgress.showError(withStatus: "There was an error generating your profile. Please try again.")
            }
        }
        
        
        // Send to server
        
        /*Connection(configuration: nil).uploadImageCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Card Created Response ---> \(String(describing: response))")
                
                // Store profile image id after response from network
                // Store image locally
                UDWrapper.setString("profile_image_id", value: self.idString as NSString)
                
                // Hide HUD
                KVNProgress.show(withStatus: "Profile generated")
                
            } else {
                print("Card Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.show(withStatus: "There was an error with your follow up. Please try again.")
                
            }
            // Hide indicator
            KVNProgress.dismiss()
        }*/

        
        // Test if image stored
        print(self.newUser.profileImages)
        
        // Assign a temp uuid
        newUser.userId = newUser.randomString(length: 15)
        
        // Print to test
        newUser.printUser()
        
        // Create first card here
        createFirstCard()
    
        
        // Pass segue
        performSegue(withIdentifier: "phoneVerificationSegue", sender: self)
        
        
    }
    
    func createFirstCard() {
        // Assign image for card
        // Image data png
        let imageData = UIImagePNGRepresentation(self.profileImageContainerView.image!)
        print(imageData!)
        
        // Assign asset name and type
        //idString = newUser.randomString(length: 20)
        
        
        // Name image with id string
        let fname = self.idString
        let mimetype = "image/png"
        
        // Create image dictionary
        let imageDict = ["image_id":idString, "image_data": imageData!, "file_name": fname, "type": mimetype] as [String : Any]
        
        // ***** Send image to server ****
        
        
        // Assign name, cardname, email and phone values to card
        card.cardName = "Default"
        card.cardProfile.setEmailRecords(emailRecords: ["email" : email.text!])
        card.cardHolderName = newUser.fullName
        // Assign card image id
        card.cardProfile.imageIds.append(["card_image_id": idString])
        
        // Add card to current user object card suite
        newUser.cards.append(card)
        
        // Set ownerid on card
        card.ownerId = newUser.userId
        
        // Add image to contact card profile images
        self.card.cardProfile.setImages(imageRecords: imageDict)
        print(imageDict)
        
        // Set user name to card
        
        // Print card to see if generated
        card.printCard()
        //card.cardProfile.printProfle()
        
        
        
        //Set the selected card on manager
        ContactManager.sharedManager.selectedCard = card
        //
    }
    
    // Status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    // Keyboard Notifications
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0{
                let height = keyboardSize.height
                
                //print("\n\n", self.createAccountBtn.frame.origin.y)
                //print(height)
                
               // self.createAccountBtn.frame.origin.y = self.view.frame.height - self.createAccountBtn.frame.height - height
            }
            
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y != 0 {
                let height = keyboardSize.height
                //self.createAccountBtn.frame.origin.y = self.view.frame.height - self.createAccountBtn.frame.height - height
            }
            
        }
    }
    
    
    // Custom Methods
    // ----------------------------------------
    
    func configureViews() {
        
        // Configure cards
        self.cardWrapperView.layer.cornerRadius = 12.0
        self.cardWrapperView.clipsToBounds = true
        self.cardWrapperView.layer.borderWidth = 2.0
        self.cardWrapperView.layer.borderColor = UIColor.white.cgColor

    }
    
    
    
    func processProfile(fileUrl: String){
        
        // 1. Validate the textbox values
        
        // 2. Show loading indicator
        
        // 3. Upload to /user/create
        
        // 4. if success, perform the segue
        
        
    }
    
    
    func createRequestBodyWith(parameters:[String:NSObject], filePathKey:String, boundary:String) -> NSData{
        
        let body = NSMutableData()
        
        for (key, value) in parameters {
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString(string: "\(value)\r\n")
        }
        
        body.appendString(string: "--\(boundary)\r\n")
        
        let mimetype = "image/jpg"
        
        let defFileName = "yourImageName.jpg"
        
        let yourImage = UIImage(named: "logo")
        
        let imageData = UIImageJPEGRepresentation(yourImage!, 1)
        
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(defFileName)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageData!)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    // Photo Picker Config
    
    func configurePhotoPicker(){
        
        //Initial setup
        photo.disableEntitlements = false // If you don't want use iCloud entitlement just set this value True
        photo.alertTitle = "Select Profile Image"
        photo.alertMessage = ""
        photo.resizeImage = CGSize(width: profileImageContainerView.frame.width, height: profileImageContainerView.frame.height)
        photo.allowDestructive = false
        photo.allowEditing = false
        photo.cameraDevice = .front
        photo.cameraFlashMode = .auto
        
        photo.alertTitle = "Select Profile Image"
        photo.alertMessage = ""
        photo.resizeImage = CGSize(width: profileImageContainerView.frame.width, height: profileImageContainerView.frame.height)
        photo.allowDestructive = false
        photo.allowEditing = false
        photo.cameraDevice = .front
        
        photo.actionTitleLibrary = "Photo Library"
        photo.actionTitleLastPhoto = "Last Photo"
        photo.actionTitleTakePhoto = "Take Photo"
        
        photo.actionTitleOther = "Import From..."
        
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    // Navigation 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "phoneVerificationSegue" {
            
            let next = segue.destination as! PhoneVerificationViewController
            // Pass user obj
            next.currentUser = self.newUser
            next.firstCard = self.card
            print("Segue Performed for phone verif")
        }
    }
    

}



