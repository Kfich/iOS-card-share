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
import Alamofire
import ACFloatingTextfield_Swift

class AddContactViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
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
    
    // Store image icons
    var socialLinkBadges = [[String : Any]]()
    var links = [String]()
    var socialBadges = [UIImage]()
    
    var uploadContactSelected = false
    
    // IBOutlets
    // ----------------------------------
    
    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet var selectProfileImageButton: UIButton!
    
    @IBOutlet var firstNameTextField: ACFloatingTextfield!
    @IBOutlet var lastNameTextField: ACFloatingTextfield!
    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var socialBadgeCollectionView: UICollectionView!
    
    @IBOutlet var formWrapperView: UIView!
    
    @IBOutlet var shadowView: YIInnerShadowView!
    
    
    
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
        
        // Reset new contact 
        ContactManager.sharedManager.newContact = Contact()
        
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
        
        // Init badge list
        initializeBadgeList()
        
        // Config textfields 
        self.firstNameTextField.disableFloatingLabel = true
        self.lastNameTextField.disableFloatingLabel = true
        
        // Configure views
        self.configureViews()
        
        // Get icons
        self.parseForSocialIcons()
        
        // Set image
        let image = UIImage(named: "profile-placeholder")
        self.profileImageView.image = image
        
        // Config imageview
        self.configureSelectedImageView(imageView: self.profileImageView)
        
        // Config picker
        self.configurePhotoPicker()
        
        // Set shadow
        self.shadowView.shadowRadius = 2
        self.shadowView.shadowMask = YIInnerShadowMaskTop
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // Collection view Delegate && Data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.socialBadges.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BadgeCell", for: indexPath)
        //cell.backgroundColor = UIColor.green
        //self.configureBadges(cell: cell)
       
        // Configure badge image
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        var image = UIImage()
        image = self.socialBadges[indexPath.row]
        // Set image
        imageView.image = image

        
        if indexPath.row != self.socialBadges.count - 1 {
            
            // Delete
            let deleteIconView = UIImageView(frame: CGRect(x: 20, y: 5, width: 20, height: 20))
            let deleteImage = UIImage(named: "icn-minus-red")
            deleteIconView.image = deleteImage
            
            // Add to imageview
            imageView.addSubview(deleteIconView)
            
            // Add subview
            cell.contentView.addSubview(imageView)
            
        }else{
            
            print("Last image index")
            
            // Configure badge image
            let imageView = UIImageView(frame: CGRect(x: 2, y: 10, width: 20, height: 20))
            var image = UIImage()
            image = self.socialBadges[indexPath.row]
            // Set image
            imageView.image = image
            
            // Add subview
            cell.contentView.addSubview(imageView)
        }

        
        
        
        /*
        if collectionView == self.socialBadgeCollectionView{
         
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BadgeCell", for: indexPath)
            
            ///cell.contentView.backgroundColor = UIColor.red
            self.configureBadges(cell: cell)
            
            // Configure corner radius
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            let image = self.socialBadges[indexPath.row]
            
            // Set image
            imageView.image = image
            
            // Add subview
            cell.contentView.addSubview(imageView)
        }*/
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row !=  self.socialBadges.count - 1{
            // Delete the card
            self.removeBadgeFromProfile(index: indexPath.row)
        }else{
            // Add new badge
            performSegue(withIdentifier: "showContactMediaSelection", sender: self)
        }

        
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        // Init view
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: "CollectionHeader",
                                                                         for: indexPath)
        return headerView
    }

    
    
    
    
    
    // Custom Methods
    // ----------------------------------
    
    func removeBadgeFromProfile(index: Int) {
        
        print("Initial list count \(ContactManager.sharedManager.currentUser.userProfile.socialLinks.count)")
        // Remove item at index
        ContactManager.sharedManager.newContact.socialLinks.remove(at: index)
        print("Post delete list count \(ContactManager.sharedManager.newContact.socialLinks.count)")
        // Reload table data
        parseForSocialIcons()
    }
    
    func configureBadges(cell: UICollectionViewCell){
        // Add radius config & border color
        
        cell.contentView.layer.cornerRadius = 20.0
        cell.contentView.clipsToBounds = true
        cell.contentView.layer.borderWidth = 0.5
        //cell.contentView.layer.borderColor = UIColor.blue.cgColor
        
        // Set shadow on the container view
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowOffset = CGSize.zero
        cell.layer.shadowRadius = 0.5
        
    }
    
    func configureViews(){
        
        // Round out the card view and set the background colors
        // Configure cards
        self.formWrapperView.layer.cornerRadius = 12.0
        self.formWrapperView.clipsToBounds = true
        self.formWrapperView.layer.borderWidth = 0.5
        self.formWrapperView.layer.borderColor = UIColor.white.cgColor
        
    }

    
    func configureSelectedImageView(imageView: UIImageView) {
        // Config imageview
        
        // Configure borders
        imageView.layer.borderWidth = 1
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 45    // Create container for image and name
        
    }
    
    func doneEditingProfile() {
        // Bring a manager here to handle setting the inputs back and forth
        
        print("Done editing")
    }
    
    // Custom Methods
    func addObservers() {
        // Call to refresh table
        NotificationCenter.default.addObserver(self, selector: #selector(AddContactViewController.setContact), name: NSNotification.Name(rawValue: "NewContactAdded"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddContactViewController.parseForSocialIcons), name: NSNotification.Name(rawValue: "RefreshContactEditProfile"), object: nil)
        
        //RefreshContactEditProfile
        
        
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
        //self.syncContact()
        
        // Upload record
        self.uploadContactRecord()
        
        
    }
    
    func initializeBadgeList() {
        // Image config
        // Test data config
        let img1 = UIImage(named: "Facebook.png")
        let img2 = UIImage(named: "Twitter.png")
        let img3 = UIImage(named: "instagram.png")
        let img4 = UIImage(named: "Pinterest.png")
        let img5 = UIImage(named: "Linkedin.png")
        let img6 = UIImage(named: "GooglePlus.png")
        let img7 = UIImage(named: "Crunchbase.png")
        let img8 = UIImage(named: "Youtube.png")
        let img9 = UIImage(named: "Soundcloud.png")
        let img10 = UIImage(named: "Flickr.png")
        let img11 = UIImage(named: "AboutMe.png")
        let img12 = UIImage(named: "Angellist.png")
        let img13 = UIImage(named: "Foursquare.png")
        let img14 = UIImage(named: "Medium.png")
        let img15 = UIImage(named: "Tumblr.png")
        let img16 = UIImage(named: "Quora.png")
        let img17 = UIImage(named: "Reddit.png")
        let img18 = UIImage(named: "Snapchat.png")
        let img19 = UIImage(named: "social-blank")
        // Hash images
        
        self.socialLinkBadges = [["facebook" : img1!], ["twitter" : img2!], ["instagram" : img3!], ["pinterest" : img4!], ["linkedin" : img5!], ["plus.google" : img6!], ["crunchbase" : img7!], ["youtube" : img8!], ["soundcloud" : img9!], ["flickr" : img10!], ["about.me" : img11!], ["angel.co" : img12!], ["foursquare" : img13!], ["medium" : img14!], ["tumblr" : img15!], ["quora" : img16!], ["reddit" : img17!], ["snapchat" : img18!], ["other" : img19!]]
        
        
    }

    
    func parseForSocialIcons() {
        
        
        print("PARSING for icons from add contact vc")
        // Remove all items from badges
        self.socialBadges.removeAll()
        self.socialLinks.removeAll()
        
        // Assign currentuser
        //self.currentUser = ContactManager.sharedManager.currentUser
        
        // Parse socials links
        if ContactManager.sharedManager.newContact.socialLinks.count > 0{
            for link in ContactManager.sharedManager.newContact.socialLinks{
                socialLinks.append(link["link"]!)
                // Test
                print("Count >> \(socialLinks.count)")
            }
        }
        
        // Add plus icon to list
        
        // Iterate over links[]
        for link in self.socialLinks {
            // Check if link is a key
            print("Link >> \(link)")
            for item in self.socialLinkBadges {
                // Test
                //print("Item >> \(item.first?.key)")
                // temp string
                let str = item.first?.key
                //print("String >> \(str)")
                // Check if key in link
                if link.lowercased().range(of:str!) != nil {
                    print("exists")
                    
                    // Append link to list
                    self.socialBadges.append(item.first?.value as! UIImage)
                    
                    /*if !socialBadges.contains(item.first?.value as! UIImage) {
                     print("NOT IN LIST")
                     // Append link to list
                     self.socialBadges.append(item.first?.value as! UIImage)
                     }else{
                     print("ALREADY IN LIST")
                     }*/
                    // Append link to list
                    //self.socialBadges.append(item.first?.value as! UIImage)
                    
                    
                    
                    //print("THE IMAGE IS PRINTING")
                    //print(item.first?.value as! UIImage)
                    print("SOCIAL BADGES COUNT")
                    print(self.socialBadges.count)
                    
                    
                }
            }
            
            
            // Reload table
            self.socialBadgeCollectionView.reloadData()
        }
        
        // Add image to the end of list
        let image = UIImage(named: "Green-1")
        self.socialBadges.append(image!)
        
        // Reload table
        self.socialBadgeCollectionView.reloadData()
        
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
        
        print("The new contacts social media")
        contact.printContact()
        
        
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
                
                // Post notification for refresh
                self.postRefreshNotification()
                
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
        
        if tempContact.phoneNumbers.count > 0{
           
            // Parse for mobile
            let mobileNumber = CNPhoneNumber(stringValue: (tempContact.phoneNumbers[0]["phone"] ?? ""))
            let mobileValue = CNLabeledValue(label: CNLabelPhoneNumberMobile, value: mobileNumber)
            contactToAdd.phoneNumbers = [mobileValue]
        }
        
        if tempContact.emails.count > 0 {
            
            // Parse for emails
            let email = CNLabeledValue(label: CNLabelWork, value: tempContact.emails[0]["email"] as! NSString ?? "")
            contactToAdd.emailAddresses = [email]
        }
        
        
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
        //self.postRefreshNotification()

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
                    
                }
                
            case .failure(let encodingError):
                print("\n\n\n\n error....")
                print(encodingError)
                // Show error message
                KVNProgress.showError(withStatus: "There was an error generating your profile. Please try again.")
            }
        }
    }
    
    func postRefreshNotification() {
        // Notification for list refresh
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshContactsTable"), object: self)
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
