//
//  SettingsViewController.swift
//  Unify
//
//  Created by Kevin Fich on 7/25/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit
import MBPhotoPicker

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Properties 
    // ------------------------------
    var currentUser = User()
    var photoPicker = MBPhotoPicker()
    var imagePicker = UIImagePickerController()
    var selectedImage = UIImage()
    var selectedName = ""
    
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
        //
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
            if currentUser.profileImages.count > 0 {
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
        alert.addButton("On") {
            print("Keep On")
             // Toggle the isIncognito on
            self.currentUser.userIsIncognito = true
            ContactManager.sharedManager.userIsIncognito = true
            
            // Set incognito data
            self.currentUser.incognitoData.image = self.selectedImage
            self.currentUser.incognitoData.name = self.selectedName
            
            // Test to see if working
            self.currentUser.printIncognito()
        }
        
        alert.addButton("Off") {
            print("Turn off")
            // Toggle the isIncognito off
            self.currentUser.userIsIncognito = false
            ContactManager.sharedManager.userIsIncognito = false
        }
        
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
            
            // Set as temp image
            
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
        self.currentUser.setVerificationPhoneStatus(status: true)
        
        // Store user to device
        UDWrapper.setDictionary("user", value: self.currentUser.toAnyObjectWithImage())
        
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
        return 5 // your number of cell here
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // your cell coding
        
        
        //var cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsViewCell
        // Init cell
        var cell = UITableViewCell()
        
        if indexPath.row == 0 {
            // Show incognito cell
            cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsViewCell
            
        }else if indexPath.row == 1 {
            // Show incognito cell
            cell = tableView.dequeueReusableCell(withIdentifier: "SyncCell", for: indexPath) as! SettingsViewCell
            
        }else if indexPath.row == 2 {
            // Show contact us cell
            cell = tableView.dequeueReusableCell(withIdentifier: "ContactUsCell", for: indexPath) as! SettingsViewCell
            
        }else if indexPath.row == 3{
            // Show privacy cell
            cell = tableView.dequeueReusableCell(withIdentifier: "PrivacyCell", for: indexPath) as! SettingsViewCell
            
        }else if indexPath.row == 4{
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
        
        if indexPath.row == 2 {
            // Show contact us segue
            performSegue(withIdentifier: "showContactUs", sender: self)
        }else if indexPath.row == 3{
            // Show privacy webview
            showPrivacy()
            
        }else if indexPath.row == 4{
            // Log user out
            self.showLogoutAlert()
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
