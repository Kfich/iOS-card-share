//
//  SettingsViewController.swift
//  Unify
//
//  Created by Kevin Fich on 7/25/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit
import MBPhotoPicker
import Alamofire

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RSKImageCropViewControllerDelegate{
    
    // Properties 
    // ------------------------------
    var currentUser = User()
    var photoPicker = MBPhotoPicker()
    var imagePicker = UIImagePickerController()
    var selectedImage = UIImage()
    var selectedName = ""
    var synced = false
    var hidden = false
    
    var alert = SCLAlertView()
    
    // Toggle switch
    var editImageSelected = false
    var editNameSelected = false
    
    // IBOutlets
    // ------------------------------

    @IBOutlet var settingsTableView: UITableView!
    
    
    // Page setup
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Add observers for notification
        addObservers()
        
        // Set currentUser object
        currentUser = ContactManager.sharedManager.currentUser
        
        // Config picker 
        self.configurePhotoPicker()
        
        // Find out if contacts synced
        let synced = UDWrapper.getBool("contacts_synced")
        print(synced)
        // Toggle bool
        self.synced = synced
        
        // Find out if contacts synced
        let incognito = UDWrapper.getBool("contacts_synced")
        self.hidden = incognito
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions
    // ------------------------------
    
    @IBAction func backButtonSelected(_ sender: Any) {
        
        // Pop view 
        self.navigationController?.popViewController(animated: true)
    }
    
    // Custom Methods
    func addObservers() {
        // Call to show options
        NotificationCenter.default.addObserver(self, selector: #selector(SettingsViewController.showIncognitoOptions), name: NSNotification.Name(rawValue: "IncognitoToggled"), object: nil)
        
        // Call Contacts sync
        NotificationCenter.default.addObserver(self, selector: #selector(SettingsViewController.syncContactList), name: NSNotification.Name(rawValue: "SyncContacts"), object: nil)
        
        
    }
    
    func syncContactList() {
        // Execute contact manager call 
        ContactManager.sharedManager.getContacts()
    }

    func showIncognitoOptions() {
        // Show alertview with option
        self.configureAndShowIncognitoAlert()
        
    }
    
    func configureAndShowIncognitoAlert(){
        // 
        // Example of using the view to add two text fields to the alert
        // Create the subview
        var appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue-Bold", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue", size: 18)!,
            showCloseButton: false
        )
        
        // Set height and width
        appearance.kWindowWidth = self.view.frame.width - 20
        appearance.setkWindowHeight(self.view.frame.height - 20)
        appearance.showCircularIcon = false
        
        
        // Initialize SCLAlertView using custom Appearance
        alert = SCLAlertView(appearance: appearance)
        
        
        // Creat the subview
        let subview = UIView(frame: CGRect(0,0,self.view.frame.width - 20,self.view.frame.height - 20))
        let x = (subview.frame.width - 180) / 3
        // Test to see subview
        //subview.backgroundColor = UIColor.gray
        
        // Add textfield 1
        let label1 = UILabel(frame: CGRect(x,30,300,25))
        label1.text = "Here is how people will see you:"
        //label1.textAlignment = NSTextAlignment.center
        
        // Add textfield 2
        let label2 = UILabel(frame: CGRect(x,325, 300, 25))
        label2.text = "Your incognito mode is active"

        // Add subviews
        subview.addSubview(label1)
        subview.addSubview(label2)
        
        
        
        // Config imageview
        var image = UIImage()
        
        // Check if user has selected an image to edit
        
        if editImageSelected {
            // Set to image selected by user
            image = selectedImage
        }else{
            
            // Check if user has an image
            if ContactManager.sharedManager.currentUser.profileImages.count > 0 {
                image = UIImage(data: currentUser.profileImages[0]["image_data"] as! Data)!
            }else{
                image = UIImage(named: "search")!
            }

        }
        
        // Set image to imageview
        let imageView = UIImageView(image: image)

        imageView.layer.borderColor = UIColor.red.cgColor
        imageView.layer.borderWidth = 1.5
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 59    // Create container for image and name
        let containerView = UIView()
        containerView.backgroundColor = UIColor.clear
        
        // Changed the image rendering size
        containerView.frame = CGRect(x: (subview.frame.width - 180) / 1.9, y: 100, width: 150, height: 150)
        // Test container view 
        //containerView.backgroundColor = UIColor.green
        
        // Changed the image rendering size
        imageView.frame = CGRect(x: 10, y: 0 , width: 125, height: 125)
        
        // Add label to the view
        let lbl = UILabel(frame: CGRect(0, containerView.frame.height - 15, containerView.frame.width, 20))
       
        
        if editNameSelected {
            // Set to selected name
            lbl.text = self.selectedName
        }else{
            // Set name to label
            lbl.text = currentUser.getName() // Set to current user name
        }
        
        // Config lable
        lbl.textAlignment = .center
        lbl.textColor = UIColor.black
        lbl.font = UIFont(name: "HelveticaNeue", size: CGFloat(16))
        
        // Add action tap gesture to view object
        let labelAction = UITapGestureRecognizer(target: self, action: #selector(showAlertWithTextField))
        // Config label for action
        lbl.isUserInteractionEnabled = true
        lbl.addGestureRecognizer(labelAction)
        
        // Add action tap gesture to view object
        let imageAction = UITapGestureRecognizer(target: self, action: #selector(editImageSelected(sender:)))
        
        // Add action to imageView
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(imageAction)
        
        // Assign tag to image to identify what index in the array user lies
        //containerView.tag = tag
        
        // Add subviews
        containerView.addSubview(lbl)
        containerView.addSubview(imageView)
        
        
        // Add image to subview
        subview.addSubview(containerView)
        
        // Add the subview to the alert's UI property
        alert.customSubview = subview
        
        // Add buttons to alert
        alert.addButton("Save") {
            print("Keep On")
            
            // Toggle the isIncognito on
            self.currentUser.userIsIncognito = true
            ContactManager.sharedManager.userIsIncognito = true
            
            // Init incognito
            self.currentUser.publicProfile = User.IncognitoData()
            
            // Set incognito data
            self.currentUser.publicProfile?.image = self.selectedImage
            self.currentUser.publicProfile?.name = self.selectedName
            
            // Test to see if working
            self.currentUser.printIncognito()
            
            // Upload photos & update profile
            let dictionary = self.prepareImageForUpload() // image id is set here
            
            // Send it
            self.uploadImage(imageDictionary: dictionary)
            
            // Set dictionary
            UDWrapper.setBool("incognito", value: true)
            
        }
        
        /*alert.addButton("Off") {
            print("Turn off")
            // Toggle the isIncognito off
            self.currentUser.userIsIncognito = false
            ContactManager.sharedManager.userIsIncognito = false
            
            // Set dictionary
            UDWrapper.setBool("incognito", value: false)
            
            // Toggle switch off 
            self.postNotificationForUpdate()
            
        }*/
        
        // Change background color for views
        //alert.buttons[0].customBackgroundColor = UIColor.clear
        //alert.buttons[1].customBackgroundColor = UIColor.clear
        
        //alert.buttons[0].customTextColor = UIColor(red: 28/255.0, green: 28/255.0, blue: 28/255.0)
        
        //alert.buttons[0].customTextColor =  UIColor(red: )
        
        //alert.buttons.first?.backgroundColor = UIColor.clear
        //alert.buttons.last?.backgroundColor = UIColor.clear
        
        // Show Alert
        alert.showInfo("You Are Incognito", subTitle: "", closeButtonTitle: "Close")
    }
    
    func prepareImageForUpload() -> NSDictionary {
        // Prepare image for upload
        
        var imageData = Data()
        
        if editImageSelected {
            // prepare the selected image
            imageData = UIImageJPEGRepresentation(self.selectedImage, 0.75)!
            print(imageData)
        }else{
            
            if ContactManager.sharedManager.currentUser.profileImages.count > 0 {
                self.selectedImage = UIImage(data: currentUser.profileImages[0]["image_data"] as! Data)!
                
                imageData = UIImageJPEGRepresentation(self.selectedImage, 0.75)!
            }else{
                self.selectedImage = UIImage(named: "search")!
                imageData = UIImageJPEGRepresentation(self.selectedImage, 0.75)!
            }

            
        }
        
        // Generate id string for image
        self.currentUser.publicProfile?.setImageId()
        
        // Assign asset name and type
        let fname = self.currentUser.publicProfile?.imageId
        let mimetype = "image/png"
        
        // Create image dictionary
        let imageDict = ["image_id": self.currentUser.publicProfile?.imageId, "image_data": imageData, "file_name": fname!, "type": mimetype] as [String : Any]
        
        return imageDict as NSDictionary
    }
    
    func postNotificationForUpdate() {
        
        // Notification for radar screen
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "IncognitoOff"), object: self)
        
        //UpdateCurrentUserProfile
    }

    
    func uploadImage(imageDictionary: NSDictionary) {
        // Link to endpoint and send 
        // Create URL For Test
        //let testURL = ImageURLS().uploadToDevelopmentURL
        let prodURL = ImageURLS().uploadToDevelopmentURL
        
        // Parse dictionary
        let imageData = imageDictionary["image_data"] as! Data
        let fname = imageDictionary["file_name"] as! String
        
        // Show progress HUD
        KVNProgress.show(withStatus: "Generating profile..")
        
        // Upload image with Alamo
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "files", fileName: "\(fname).jpg", mimeType: "image/jpg")
            
            print("Multipart Data >>> \(multipartFormData)")
            /*for (key, value) in parameters {
             multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
             }*/
            
            // Currently Set to point to Prod Server
        }, to:prodURL)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print("\n\n\n\n success...")
                    print(response.result.value ?? "Successful upload")
                    
                    // update profile
                    self.updateCurrentUser()
                   
                }
                
            case .failure(let encodingError):
                print("\n\n\n\n error....")
                print(encodingError)
                // Show error message
                KVNProgress.showError(withStatus: "There was an error generating your profile. Please try again.")
            }
        }
    }
    
    func updateCurrentUser() {
        // Configure to send to server
        
        // Send to server
        let parameters = ["data" : ContactManager.sharedManager.currentUser.toAnyObject(), "uuid" : ContactManager.sharedManager.currentUser.userId] as [String : Any]
        print("\n\nTHE CARD TO ANY - PARAMS")
        print(parameters)
        
        
        // Connect to server
        Connection(configuration: nil).updateUserCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Card Created Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                let dictionary : Dictionary = response as! [String : Any]
                print(dictionary)
                
                
                // Store user to device
                UDWrapper.setDictionary("user", value: ContactManager.sharedManager.currentUser.toAnyObjectWithImage())
                
                // Hide HUD
                KVNProgress.showSuccess()
                
                // Upload the image
                
                
                
            } else {
                print("Card Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error creating your card. Please try again.")
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
    }
    
    // Alert Controller to Add CardName
    
    func showAlertWithTextField(){
        
        // Dismiss the incognito popover
        self.alert.hideView()
        
        // Init alert
        let alertVC = PMAlertController(title: "", description: "Enter your incognito name", image: nil, style: .alert)
        
        alertVC.addTextField { (textField) in
            textField?.placeholder = "Name"
        }
        
        // Add 'done' action
        alertVC.addAction(PMAlertAction(title: "Done", style: .default, action: { () in
            print("Capture action OK")
            if alertVC.textFields[0].text != nil{
                
                // Toggle switch to indicate option selected 
                self.editNameSelected = true
                
                // Set selected name 
                self.selectedName = alertVC.textFields[0].text!
                
                // Show popover again
                self.configureAndShowIncognitoAlert()
            }
        }))
        
        // Add 'cancel' action
        alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
            print("Capture action Cancel")
            
            // Show popover again
            self.configureAndShowIncognitoAlert()
            
        }))
        
        
        // Show VC
        self.present(alertVC, animated: true, completion: nil)
    }

    
    // Handle tap gesture
    func editImageSelected(sender:UITapGestureRecognizer) {
        
        
        // Dismiss the incognito popover
        self.alert.hideView()
        
        // Add code to edit photo here
        photoPicker.onPhoto = { (image: UIImage?) -> Void in
            print("Selected image")
            
            // Set selectedImage
            self.selectedImage = image!
            
            // Toggle new image switch
            self.editImageSelected = true
            
            // Set image to view
            let selectedImageView = self.configureSelectedImageView(selectedImage: image!)
            
            // Show ingonito popover again
            self.configureAndShowIncognitoAlert()
            
            // Set image view to sender view 
            sender.view?.addSubview(selectedImageView)
            
            // ************ YOU LEFT OFF HERE >> SHOW CROPPER AND RECONFIG IMAGE THING *********
            
            // Show Cropper
            //self.showCropper(withImage: image!)
            
            
            
        }
        
        photoPicker.onCancel = {
            print("Cancel Pressed")
        }
        photoPicker.onError = { (error) -> Void in
            print("Photo selection Error")
            print("Error: \(error.rawValue)")
        }
        
        photoPicker.present(self)
        
    
    }
    
    
    // When user selects from photoPicker, config image and set to sender view
    func configureSelectedImageView(selectedImage: UIImage) -> UIImageView{
        // Config imageview
        
        // Set image to imageview
        let imageView = UIImageView(image: selectedImage)
        
        // Configure borders
        imageView.layer.borderColor = UIColor.red.cgColor
        imageView.layer.borderWidth = 1.5
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 59    // Create container for image and name
        
        // Changed the image rendering size
        imageView.frame = CGRect(x: 10, y: 0 , width: 125, height: 125)
        
        return imageView
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
        self.selectedImage = croppedImage
        
        // Test
        print("Cropped Image >> \n\(croppedImage)")
        
        //self.profileImageContainerView.addSubview(self.configureSelectedImageView(selectedImage: croppedImage))
        // Dismiss vc
        dismiss(animated: true, completion: nil)
        
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, willCropImage originalImage: UIImage) {
        
        // Set image to view
        //self.profileImageContainerView.image = originalImage
        
        // Test
        print("Selected Image >> \n\(originalImage)")
    }
    

    
    func configurePhotoPicker() {
        //Initial setup
        photoPicker.disableEntitlements = false // If you don't want use iCloud entitlement just set this value True
        photoPicker.alertTitle = "Select Incognito Image"
        photoPicker.alertMessage = ""
        photoPicker.resizeImage = CGSize(width: 150, height: 150)
        photoPicker.allowDestructive = false
        photoPicker.allowEditing = false
        // Set front facing camera
        photoPicker.cameraDevice = .front
        photoPicker.cameraFlashMode = .auto
        
        photoPicker.actionTitleLibrary = "Photo Library"
        photoPicker.actionTitleLastPhoto = "Last Photo"
        photoPicker.actionTitleTakePhoto = "Take Photo"
        photoPicker.actionTitleCancel = "Cancel"
        //photoPicker.actionTitleOther = "Import From..."
    }
    
    func showLogoutAlert() {
        // Configure alertview 
        let alertView = UIAlertController(title: "", message: "Are you sure you want to logout?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Forget it", style: .default, handler: { (alert) in
            
            // Dismiss alert 
            self.dismiss(animated: true, completion: nil)
            
        })
        
        let logout = UIAlertAction(title: "Yes", style: .default, handler: { (alert) in
            // Execute logout function
            self.logout()
        })

        alertView.addAction(cancel)
        alertView.addAction(logout)
        self.present(alertView, animated: true, completion: nil)
    }
    
    // Logout 
    func logout() {
        // Set bool for auth to false
        ContactManager.sharedManager.currentUser.setVerificationPhoneStatus(status: false)
        
        // Clear manager
        ContactManager.sharedManager.currentUserCards.removeAll()
        ContactManager.sharedManager.currentUserCardsDictionaryArray.removeAll()
        ContactManager.sharedManager.viewableUserCards.removeAll()
        //ContactManager.sharedManager.currentUser = User()
        
        // Store user to device
        UDWrapper.setDictionary("user", value: ContactManager.sharedManager.currentUser.toAnyObjectWithImage())
        
        // Send to verification screen
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let phoneVerificationController = mainStoryboard.instantiateViewController(withIdentifier: "phoneVerificationSegue") as!
        PhoneVerificationViewController
        self.view.window!.rootViewController = phoneVerificationController
        
    }
    
    // Show privacy webview
    func showPrivacy() {
        // Call segue
        performSegue(withIdentifier: "showPrivacy", sender: self)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7 // your number of cell here
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // your cell coding
        
        
        //var cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsViewCell
        // Init cell
        var cell = UITableViewCell()
        
        if indexPath.row == 0 {
            // Show incognito cell
            let incognitoCell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsViewCell
            incognitoCell.incongnitoSwitch.isOn = self.hidden
            // Hide and disable switch
            incognitoCell.incongnitoSwitch.isHidden = true
            incognitoCell.incongnitoSwitch.isEnabled = false
            
            // Set accessory view
            incognitoCell.accessoryType = .disclosureIndicator
            
        }else if indexPath.row == 1 {
            // Show incognito cell
            let syncCell = tableView.dequeueReusableCell(withIdentifier: "SyncCell", for: indexPath) as! SettingsViewCell
            
            // Toggle based on sync status
            syncCell.syncContactsSwitch.isOn = self.synced
            
        }else if indexPath.row == 2 {
            // Show contact us cell
            cell = tableView.dequeueReusableCell(withIdentifier: "HideCardsCell", for: indexPath) as! SettingsViewCell
            
        }else if indexPath.row == 3{
            // Show privacy cell
            cell = tableView.dequeueReusableCell(withIdentifier: "HideBadgesCell", for: indexPath) as! SettingsViewCell
            
        }else if indexPath.row == 4{
            // Show privacy cell
            cell = tableView.dequeueReusableCell(withIdentifier: "ContactUsCell", for: indexPath) as! SettingsViewCell
            
        }else if indexPath.row == 5{
            // Show privacy cell
            cell = tableView.dequeueReusableCell(withIdentifier: "PrivacyCell", for: indexPath) as! SettingsViewCell
            
        }else if indexPath.row == 6{
            // Show logout cell
            cell = tableView.dequeueReusableCell(withIdentifier: "LogoutCell", for: indexPath) as! SettingsViewCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell selected code here
         
        // Deselect cell
        //Change the selected background view of the cell.
        settingsTableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            // Show incognito options
            self.showIncognitoOptions()
            
        }else if indexPath.row == 2  {
            // Set nav status
            ContactManager.sharedManager.hideCardsSelected = true
            // Show contact us segue
            performSegue(withIdentifier: "showCardToggleVC", sender: self)
        }else if indexPath.row == 3{
            // Set nav status
            ContactManager.sharedManager.hideBadgesSelected = true
            // Show contact us segue
            performSegue(withIdentifier: "showCardToggleVC", sender: self)
        }else if indexPath.row == 4 {
            // Show contact us segue
            performSegue(withIdentifier: "showContactUs", sender: self)
        }else if indexPath.row == 5{
            // Show privacy webview
            showPrivacy()
            
        }else if indexPath.row == 6{
            // Log user out
            self.showLogoutAlert()
        }
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
