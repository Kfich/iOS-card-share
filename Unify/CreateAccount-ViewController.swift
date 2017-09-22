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
import ACFloatingTextfield_Swift

class CreateAccountViewController: UIViewController, RSKImageCropViewControllerDelegate, UITextFieldDelegate{
    
    // Properties
    // -----------------------------------------------
    
    var store: CNContactStore!
    var hasProfilePic = false
    lazy var photo = MBPhotoPicker()
    
    // User object to assign form fields
    var newUser = User()
    var card = ContactCard()
    var selectedImage = UIImage()
    
    // To track image ids
    var idString = ""
    //var imageDictionary = [String : Any]

    
    // IBOutlets
    // -----------------------------------------------
    
    @IBOutlet weak var firstName: ACFloatingTextfield!
    
    @IBOutlet weak var lastName: ACFloatingTextfield!
    
    @IBOutlet weak var email: ACFloatingTextfield!
    
    @IBOutlet weak var addProfilePictureBtn: UIButton!
    
    @IBOutlet weak var createAccountBtn: UIButton!
    
    @IBOutlet weak var profileImageContainerView: UIImageView!
    
    @IBOutlet var cardWrapperView: UIView!
    
    @IBOutlet var shadowView: YIInnerShadowView!
    
    
    
    
    
    // View Prep
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set button on top of keyboard
        self.email.inputAccessoryView = createAccountBtn
        
        // error here
        //firstName.becomeFirstResponder()
        
        // Set textfield delegates
        firstName.delegate = self
        lastName.delegate = self
        email.delegate = self
        
        // Config Photo Picker
        configurePhotoPicker()
        
        // Configure views 
        configureViews()
        
        /*let conf = KVNProgressConfiguration.default()
        conf?.isFullScreen = true
        conf?.statusColor = UIColor.white
        conf?.successColor = UIColor.white
        conf?.circleSize = 170
        conf?.lineWidth = 10
        conf?.statusFont = UIFont(name: ".SFUIText-Medium", size: CGFloat(20))
        conf?.circleStrokeBackgroundColor = UIColor.white
        conf?.circleStrokeForegroundColor = UIColor.white
        conf?.backgroundTintColor = UIColor(red: 0.173, green: 0.263, blue: 0.856, alpha: 0.4)
        KVNProgress.setConfiguration(conf)*/
        
        // Config textfields
        firstName.disableFloatingLabel = true
        lastName.disableFloatingLabel = true
        email.disableFloatingLabel = true
        
        // Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        
        // Set user object 
        self.newUser = ContactManager.sharedManager.currentUser
        
        // Configure imageview 
        //self.profileImageContainerView = self.configureSelectedImageView(selectedImage: UIImage(named: "user")!)
        
        self.configureSelectedImageView(imageView: self.profileImageContainerView)
        
        // Set shadow 
        self.shadowView.shadowRadius = 3
        self.shadowView.shadowMask = YIInnerShadowMaskTop
        
        
       // ContactManager.sharedManager.application.registerForRemoteNotifications()
        
        UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
        
        //application.registerForRemoteNotifications()
        
        // Det image to default to acoid crash on no select 
        self.selectedImage = self.profileImageContainerView.image!
        
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
            self.addProfilePictureBtn.titleLabel?.text = "  change"
            
            
            // Previous location for image assignment to user object
            
            
            self.selectedImage = image!
            // Show cropper view 
            
            //self.profileImageContainerView.layer.borderColor = UIColor.clear as! CGColor
            
            self.dismiss(animated: true, completion: {
                self.showCropper(withImage: self.selectedImage)
            })
            
            //self.profileImageContainerView.image = image
            
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
        
        
        
        var isValid = false
        
        
        if firstName.text! == ""
        {
            self.alertMessageOk(title: "Error", message: "Please add a first name")
            return
        }
        
        if lastName.text! == ""
        {
            self.alertMessageOk(title: "Error", message: "Please add a last name")
            return
        }
        
        if email.text! == ""
        {
            self.alertMessageOk(title: "Error", message: "Please add an email address")
            return
        } else {
            
            //since we have email let's validate it and throw error alert up if its bad
             let isEmailAddressValid = isValidEmailAddress(emailAddressString: email.text!)
            
            if !isEmailAddressValid
            {
                self.alertMessageOk(title: "Error", message: "Please add a valid email address")
                return
            }
            
        }
      
        
        //passed all tests setting to true to submit for profile creation
        isValid = true
        
        if isValid {
        // Assign form values to user object
        newUser.userProfile.emails.append(["email": email.text!])
        newUser.firstName = firstName.text!
        newUser.lastName = lastName.text!
        newUser.setName(first: firstName.text!, last: lastName.text!)
        newUser.fullName = newUser.getName()
        newUser.deviceToken = ContactManager.sharedManager.deviceToken
        
        
        
        
        // Pull image data
        
        // Image data png
        //let imageData = UIImagePNGRepresentation(self.profileImageContainerView.image!, 0.5)
        let imageData = UIImageJPEGRepresentation(self.selectedImage, 0.5)
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
        
        // Init imageURLS
        let urls = ImageURLS()
            
        // Create URL For Prod
        //let prodURL = urls.uploadToStagingURL
        
        // Create URL For Test
        let testURL = urls.uploadToDevelopmentURL
        
        
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
                    //KVNProgress.dismiss()
                }
                
            case .failure(let encodingError):
                print("\n\n\n\n error....")
                print(encodingError)
                // Show error message
                KVNProgress.showError(withStatus: "There was an error generating your profile. Please try again.")
            }
        }
        
        
        // Test if image stored
        print(self.newUser.profileImages)
        
        
        // Print to test
        newUser.printUser()
            
        // Store user to device
        //UDWrapper.setDictionary("user", value: self.newUser.toAnyObjectWithImage())
        
        // Create first card here
        createFirstCard()
            
        // Replaced with pinVerification Logics 
            
        // Pass segue
        //performSegue(withIdentifier: "phoneVerificationSegue", sender: self)
        }
        
    }
    
    // Text Field Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
        //
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        // Kill placeholders
        /*if textField == firstName {
            // Execute
            firstName.label = ""
        }*/
        
        
        
    }
    
    
    // Custom Methods
    // --------------------------
    
    func createFirstCard() {
        // Create the card
        ///let card = ContactManager.sharedManager.selectedCard
        
        // Add card ownerId
        card.ownerId = newUser.userId
        card.cardProfile.setPhoneRecords(phoneRecords: ["phone": newUser.userProfile.phoneNumbers[0]["phone"]!])
        
        // Populate card 
        self.populateFirstCard()
        
        // Process image for card
        
        
        // Show progress hud
        KVNProgress.show(withStatus: "Creating your first card...")
        
        // Save card to DB
        let parameters = ["data": card.toAnyObject()]
        print(parameters)
        
        // Send to server
        
        Connection(configuration: nil).createCardCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Card Created Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                let dictionary : Dictionary = response as! [String : Any]
                self.card.cardId = dictionary["uuid"] as? String
                
                
                // Insert to manager card array
                ContactManager.sharedManager.currentUserCardsDictionaryArray.insert([self.card.toAnyObjectWithImage()], at: 0)
                
                // Set array to defualts
                UDWrapper.setArray("contact_cards", value: ContactManager.sharedManager.currentUserCardsDictionaryArray as NSArray)
                
                
                // Hide HUD
                KVNProgress.showSuccess()
                
                // Update user
                self.updateCurrentUser()
                
                
                
            } else {
                print("Card Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error creating your card. Please try again.")
                
            }
            // Hide indicator
            //KVNProgress.dismiss()
        }
    }
    
    
    func populateFirstCard() {
        // Assign image for card
        // Image data png
        let imageData = UIImagePNGRepresentation(self.selectedImage)
        print(imageData!)
        
        // Assign asset name and type
        //idString = newUser.randomString(length: 20)
        
        
        // Name image with id string
        let fname = self.idString
        let mimetype = "image/png"
        
        // Create image dictionary
        let imageDict = ["image_id":idString, "image_data": imageData!, "file_name": fname, "type": mimetype] as [String : Any]
    
        // Assign name, cardname, email and phone values to card
        card.cardName = "Default"
        card.cardProfile.setEmailRecords(emailRecords: ["email" : email.text!])
        card.cardHolderName = newUser.fullName
        // Assign card image id
        card.cardProfile.imageIds.append(["card_image_id": idString])
        
        // Add card to current user object card suite
        newUser.cards.append(card)
        
        
        // Add image to contact card profile images
        self.card.cardProfile.setImages(imageRecords: imageDict)
        print(imageDict)
        
        // Set user name to card
        
        // Print card to see if generated
        card.printCard()
        //card.cardProfile.printProfle()
        
        
        
        //Set the selected card on manager
        ContactManager.sharedManager.selectedCard = card
        
    }
    
    func updateCurrentUser() {
        // Configure to send to server
        
        
        // Send to server
        let parameters = ["data" : newUser.toAnyObject(), "uuid" : newUser.userId] as [String : Any]
        print("\n\nUPDATE USER - PARAMS")
        print(parameters)
        
        // Connect to server
        Connection(configuration: nil).updateUserCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("User Updated Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                let dictionary : Dictionary = response as! [String : Any]
                print(dictionary)
                
                
                // Store user to device
                UDWrapper.setDictionary("user", value: self.newUser.toAnyObjectWithImage())
                
                // Hide HUD
                KVNProgress.showSuccess()
                
                // Show homepage
                DispatchQueue.main.async {
                    // Update UI
                    // Show Home Tab
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeTabView") as!
                    TabBarViewController
                    self.view.window?.rootViewController = homeViewController
                }
                
                
            } else {
                print("Card Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error creating your card. Please try again.")
            }
            // Hide indicator
            //KVNProgress.dismiss()
        }
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
    
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
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
    
    // Image Cropper Delegates
    
    func showCropper(withImage: UIImage) {
        // Show image cropper
        let cropper = RSKImageCropViewController()
        // Set Cropper Image
        cropper.originalImage = withImage
        // Set mode
        cropper.cropMode = RSKImageCropMode.circle
        // Set Delegate
        cropper.delegate = self
        
        self.present(cropper, animated: true, completion: nil)
    }
    
    /*
     func imageCropViewControllerCustomMaskRect(_ controller: RSKImageCropViewController) -> CGRect {
     // Configure custom rect
     var size = CGSize()
     // Set size
     size.height = 150
     size.width = 150
     
     // Config view size
     let viewWidth = self.view.frame.width
     let viewHeight = self.view.frame.height
     
     // Make rect
     let rect = CGRect(x: (viewWidth - size.width) * 0.5, y: (viewHeight - size.height) * 0.5, width: size.width, height: size.height)
     
     return rect
     
     }*/
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        // Drop vc
        self.dismiss(animated: true, completion: nil)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        
        // Set image to view
        //self.profileImageContainerView.image = croppedImage
        
        // Test
        print("Cropped Image >> \n\(croppedImage)")
        let imageView = configureSelectedImageView(selectedImage: croppedImage)
        //self.profileImageContainerView.isHidden = true
        self.profileImageContainerView.addSubview(imageView)
        
        // Set cropped image 
        self.selectedImage = croppedImage

        // Dismiss vc
        dismiss(animated: true, completion: nil)
        
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, willCropImage originalImage: UIImage) {
        
        // Set image to view
        //self.profileImageContainerView.image = originalImage
        
        // Test
        print("Selected Image >> \n\(originalImage)")
    }
    
    
    
    func configureSelectedImageView(selectedImage: UIImage) -> UIImageView{
        // Config imageview
        
        // Set image to imageview
        let imageView = UIImageView(image: selectedImage)
        
        // Configure borders
        //imageView.layer.borderColor = UIColor.blue.cgColor
        imageView.layer.borderWidth = 1.0
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 45    // Create container for image and name
        
        // Changed the image rendering size
        imageView.frame = CGRect(x: 0, y: 0 , width: 90, height: 90)
        
        return imageView
    }
    
    func configureSelectedImageView(imageView: UIImageView) {
        // Config imageview
        
        // Configure borders
        imageView.layer.borderWidth = 1.0
        //imageView.layer.borderColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0) as! CGColor
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 45// Create container for image and name
        
    }

    
    
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    // Navigation 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        /*if segue.identifier == "phoneVerificationSegue" {
            
            let next = segue.destination as! PhoneVerificationViewController
            // Pass user obj
            next.currentUser = self.newUser
            next.firstCard = self.card
            print("Segue Performed for phone verif")
        }*/
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}



extension UIViewController {
    func alertMessageOk(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

