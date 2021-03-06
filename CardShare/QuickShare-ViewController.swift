//
//  QuickShare-ViewController.swift
//  Unify



import UIKit
import MapKit
import CoreLocation
import MessageUI
import Contacts
import ACFloatingTextfield_Swift


class QuickShareViewController: UIViewController, MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Properties
    // ---------------------------------------
    var currentUser = User()
    var transaction = Transaction()
    let formatter = CNContactFormatter()
    var contact = Contact()
    var selectedCard = ContactCard()
    var selectedEmail = ""
    var selectedPhone = ""
    
    var tokenField = KSTokenView()
    
    // Arrays to hold contact info
    var phoneNumbers = [String]()
    var emailAddresses = [String]()
    
    //
    var usersHaveEmails = false
    var usersHavePhoneNumbers = false
    // Contact Sync
    var syncToContactsSelected = false
    
    // Store image icons
    var socialLinkBadges = [[String : Any]]()
    var links = [String]()
    var socialBadges = [UIImage]()
    var socialLinks = [String]()
    
    // IBOutlets
    // ---------------------------------------
    @IBOutlet var tokenView: UIView!
    
    @IBOutlet var cardWrapperView: UIView!
    
   // @IBOutlet var profileCardWrapperView: UIView!
    
    
    // Labels
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var socialMediaToolBar: UIToolbar!
    
    @IBOutlet var phoneImageView: UIImageView!
    @IBOutlet var emailImageView: UIImageView!
    
    
    // Buttons on social toolbar
    
    
    @IBOutlet var syncToContactsSwitch: UISwitch!
    
    // Text fields
    
    //@IBOutlet var recipientTextField: UITextField!
    
    @IBOutlet var firstNameTextField: ACFloatingTextfield!
    
    @IBOutlet var lastNameTextField: ACFloatingTextfield!
    
    @IBOutlet var emailTextField: ACFloatingTextfield!
    
    @IBOutlet var notesTextField: ACFloatingTextfield!
    
    @IBOutlet var socialBadgeCollectionView: UICollectionView!
    
    @IBOutlet var tagsTextField: ACFloatingTextfield!
    @IBOutlet var locationTextField: ACFloatingTextfield!
    
    @IBOutlet var emailIcon: UIImageView!
    
    @IBOutlet var phoneIcon: UIImageView!
    
    
    @IBOutlet var phoneTextField: ACFloatingTextfield!
    
    @IBOutlet var shadowView: YIInnerShadowView!
    
    @IBOutlet var badgeIcon: UIImageView!
    
    @IBOutlet var cardNameLabel: UILabel!
    
    
    // Page configuration
    // ------------------------------------------

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set target for location field
        locationTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidBegin)
        
        // Set token view
        tokenField = KSTokenView(frame: self.tokenView.bounds)//CGRect(x: 10, y: 250, width: 300, height: 40))
        tokenField.delegate = self as? KSTokenViewDelegate
        tokenField.promptText = " "
        tokenField.font = UIFont.systemFont(ofSize: 18)
        tokenField.placeholder = "Tags"
        tokenField.descriptionText = ""
        tokenField.activityIndicatorColor = UIColor.green
        tokenField.maxTokenLimit = 5
        tokenField.style = .squared
        tokenField.shouldHideSearchResultsOnSelect = true
        tokenField.searchResultSize = CGSize()
        tokenField.direction = .horizontal
        
        // Swift 3
        let modelName = UIDevice.current.modelName
        
        print("Model Name \(modelName)")
        
        
        var containerView = UIView()
        
        if modelName == "iPhone 6 Plus" || modelName == "iPhone 6s Plus" || modelName == "iPhone 7 Plus"{
            print("Now entering iphone plus landia my friend to tread light")
            //standard device
            
            // Config container view
            containerView = UIView(frame: CGRect(x: tokenField.frame.origin.x + 6, y: tokenField.frame.height - 0.5, width: self.emailTextField.frame.size.width + 40,  height: 0.50))
            containerView.backgroundColor = UIColor.white
            
        }else{
            
            // Config container view
            containerView = UIView(frame: CGRect(x: tokenField.frame.origin.x + 6, y: tokenField.frame.height - 0.5, width: self.emailTextField.frame.size.width,  height: 0.50))
            containerView.backgroundColor = UIColor.white
            
        }
        
       
        // Add to token field
        self.tokenView.addSubview(containerView)
        
        
        // Add to view
        self.tokenView.addSubview(tokenField)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Reset nav
        //self.resetNavigationBooleans()
        
        // Set contact card
        selectedCard = ContactManager.sharedManager.selectedCard
        
        // Set current user
        currentUser = ContactManager.sharedManager.currentUser
        
        // Parse for social badges
        self.parseForSocialIcons()
        
        // View setup
        configureViews()
        populateCards()
        
        // Textfield config
        firstNameTextField.disableFloatingLabel = true
        lastNameTextField.disableFloatingLabel = true
        emailTextField.disableFloatingLabel = true
        //notesTextField.disableFloatingLabel = true
        //tagsTextField.disableFloatingLabel = true
        phoneTextField.disableFloatingLabel = true
        locationTextField.disableFloatingLabel = true
        
        // Set shadow
        self.shadowView.shadowRadius = 2
        self.shadowView.shadowMask = YIInnerShadowMaskTop
        
        if ContactManager.sharedManager.userArrivedFromLocationVC{
            // Set textfield text
            self.locationTextField.text = ContactManager.sharedManager.selectedLocation
        }
        

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        // Reset nav
        self.resetNavigationBooleans()
    }
    
    // Collection view Delegate && Data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /* if self.socialBadges.count != 0 {
         // Return the count
         return self.socialBadges.count
         }else{
         return 1
         }*/
        return (self.socialBadges.count + selectedCard.cardProfile.badgeDictionaryList.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileBadgeCell", for: indexPath)
        
        //cell.contentView.backgroundColor = UIColor.red
        self.configureBadges(cell: cell)
        
        // Configure corner radius
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        if indexPath.row < socialBadges.count {
            // Init media badge
            let image = self.socialBadges[indexPath.row]
            
            // Set image
            imageView.image = image
        }else{
            
            print("THIS IS WHERE THE URL GOES \(indexPath.row)")
            // Init image from
            //let fileUrl = NSURL(string: selectedCard.cardProfile.badgeDictionaryList[abs(indexPath.row - selectedCard.cardProfile.badgeDictionaryList.count)].value(forKey: "image") as! String)
            //imageView.setImageWith(fileUrl! as URL)
        }
        
        // Add subview
        cell.contentView.addSubview(imageView)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //performSegue(withIdentifier: "showSocialMediaOptions", sender: self)
        
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
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
    
    
    // IBActions / Buttons pressed
    // ------------------------------------------
    
    @IBAction func saveToContactsSelected(_ sender: AnyObject) {
        
        // Execute call
        //self.uploadContactRecord()
        
        if syncToContactsSwitch.isOn == true {
            // Set sync to true
            self.syncToContactsSelected = true
        }else{
            // Set sync to false
            self.syncToContactsSelected = false
        }
        
    }
    
    
    @IBAction func shareContactCard(_ sender: Any) {
        
        // Execute call follow through 
        self.validateForm()
    }
    
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // Textfield delegate
    func textFieldDidChange(_ textField: UITextField) {
        
        // Show location
        self.showLocationVC()
        
    }
    
    // Keyboard Delegate
    
    func keyboardWillHide(notification: NSNotification) {
    
        /*
        // Check if user arrived from location
        if ContactManager.sharedManager.userArrivedFromLocationVC{
            // Drop vc
            self.dismiss(animated: true, completion: nil)
        }*/
    }

    
    // Custom Methods
    
    // Show location 
    
    func showLocationVC(){
    
        // Call the viewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LocationVC")
        self.present(controller, animated: true, completion: nil)
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
        
        // Create list containing link info
        self.initializeBadgeList()
        
        // Remove all items from badges
        self.socialBadges.removeAll()
        self.socialLinks.removeAll()
        
        print("Looking for social icons on card selection view")
        
        // Assign currentuser
        //self.currentUser = ContactManager.sharedManager.currentUser
        
        // Parse socials links
        if selectedCard.cardProfile.socialLinks.count > 0{
            for link in selectedCard.cardProfile.socialLinks{
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
                    
                    //print(item.first?.value as! UIImage)
                    print("Social Count from Quick Share")
                    print(self.socialBadges.count)
                    
                    
                }
            }
            
            
            // Reload table
            self.socialBadgeCollectionView.reloadData()
        }
        
        // Add image to the end of list
        //let image = UIImage(named: "icn-plus-blue")
        //self.socialBadges.append(image!)
        
        // Reload table
        self.socialBadgeCollectionView.reloadData()
        
    }
    
    
    func resetNavigationBooleans() {
        // ContactManager 
        ContactManager.sharedManager.quickshareSMSSelected = false
        ContactManager.sharedManager.quickshareEmailSelected = false
    }
    
    func configureViews(){
        
        // Configure cards
        self.cardWrapperView.layer.cornerRadius = 12.0
        self.cardWrapperView.clipsToBounds = true
        self.cardWrapperView.layer.borderWidth = 1
        self.cardWrapperView.layer.borderColor = UIColor.clear.cgColor
        
        // Config image
        self.configureSelectedImageView(imageView: self.profileImageView)
        
        // Assign media buttons
        /*mediaButton1.image = UIImage(named: "social-blank")
        mediaButton2.image = UIImage(named: "social-blank")
        mediaButton3.image = UIImage(named: "social-blank")
        mediaButton4.image = UIImage(named: "social-blank")
        mediaButton5.image = UIImage(named: "social-blank")
        mediaButton6.image = UIImage(named: "social-blank")
        mediaButton7.image = UIImage(named: "social-blank")*/
        /*
        if ContactManager.sharedManager.quickshareEmailSelected {
            // Set placeholder
            self.phoneTextField.placeholder = "Email"
            self.phoneIcon.image = UIImage(named: "icn-mail-white")
            self.emailTextField.placeholder = "Phone"
            self.emailIcon.image = UIImage(named: "icn-phone-white")
        }*/
        
    }
    
    func configureSelectedImageView(imageView: UIImageView) {
        // Config imageview
        
        // Configure borders
        imageView.layer.borderWidth = 1
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 45    // Create container for image and name
        
    }
    
    
    
    func populateCards(){
        // Senders card config
        
        print("Selected card count", selectedCard.cardProfile.images.count, selectedCard.cardProfile.images)
        
        // Populate image view
        if selectedCard.cardProfile.images.count > 0{
            // Set to card pic
            profileImageView.image = UIImage(data: selectedCard.cardProfile.images[0]["image_data"] as! Data)
        
        }else if selectedCard.cardProfile.imageIds.count > 0{
            
            print("Profile image id not nil")
            
            // Init id
            let idString = selectedCard.cardProfile.imageIds[0]["card_image_id"] as? String ?? ""
            // Set image for contact
            let url = URL(string: "\(ImageURLS.sharedManager.getFromDevelopmentURL)\(idString ).jpg")!
            let placeholderImage = UIImage(named: "profile")!
            
            // Set image from url
            profileImageView.setImageWith(url, placeholderImage: placeholderImage)
        }else{
            print("Profile met neither")
            
            profileImageView.image = UIImage(data: ContactManager.sharedManager.currentUser.profileImages[0]["image_data"] as! Data)
            print(selectedCard.cardProfile.imageId)
            print(selectedCard.imageId)
        }
        
        
        // Different set for verified
        if selectedCard.isVerified{
            profileImageView.image = UIImage(data: ContactManager.sharedManager.currentUser.profileImages[0]["image_data"] as! Data)
            
        }
        
        // Populate label fields
        if let name = selectedCard.cardName{
            cardNameLabel.text = name
        }
        // Populate label fields
        if let name = selectedCard.cardHolderName{
            nameLabel.text = name
        }
        if selectedCard.cardProfile.phoneNumbers.count > 0{
            numberLabel.text = self.format(phoneNumber: selectedCard.cardProfile.phoneNumbers[0].values.first!)
        }else{
            // Hide icon 
            phoneImageView.isHidden = true
        }
        if selectedCard.cardProfile.emails.count > 0{
            emailLabel.text = selectedCard.cardProfile.emails[0]["email"]
        }else{
            // Hide icon
            emailImageView.isHidden = true
        }
        if selectedCard.cardProfile.titles.count > 0{
            titleLabel.text = selectedCard.cardProfile.titles[0]["title"]
        }
        // Here, parse data to populate tableview
    }
    
    func validateForm() {
        
        // Here, configure form validation
        
        if (firstNameTextField.text == "" || lastNameTextField.text == "" || (emailTextField.text == "" && ContactManager.sharedManager.quickshareEmailSelected) || (phoneTextField.text == "" && ContactManager.sharedManager.quickshareSMSSelected)) {
            
            // Init message
            var message = ""
            
            if (emailTextField.text == "" && ContactManager.sharedManager.quickshareEmailSelected) {
                // Config message for email missing
                message = "Please enter a valid email address"
                
            }else if (phoneTextField.text == "" && ContactManager.sharedManager.quickshareSMSSelected){
                // Config message for sms missing
                message = "Please enter a valid phone number"
            }else{
                
                // Config
                message = "Please enter a valid first and last name"
            }
            
            // form invalid
            //let message = "Please enter valid contact information"
            let title = "There was an error"
            
            // Configure alertview
            let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                
            })
            
            // Add action to alert
            alertView.addAction(cancel)
            self.present(alertView, animated: true, completion: nil)
            
        }else{
            
            // Pass form values into contact object 
            contact.name = "\(firstNameTextField.text!) \(lastNameTextField.text!)"
            
            if tokenField.text != ""{
            
                print("The Tokens", tokenField.text)
            
                contact.setTags(tag: tokenField.text ?? "")
            }
            
            // Set notes
           /* if tagsTextField.text != nil{
                
                let fullString = tagsTextField.text!
                
                let tokenArray = fullString.components(separatedBy: " ")
                
                print("Token Array\n\(tokenArray)")
                
                for item in tokenArray {
                    // Iterate and set
                    contact.setTags(tag: item)
                }

                //contact.setTags(tag: tagsTextField.text!)
            }*/
            
            
            
            // Execute send actions
            
            // Check for user intent
            if ContactManager.sharedManager.quickshareSMSSelected {
                // Set the number to contact
                contact.phoneNumbers.append(["phone": phoneTextField.text ?? ""])
                contact.emails.append(["email": emailTextField.text ?? ""])
                // Show sms
                self.showSMSCard()
            }else{
                // Set email
                contact.phoneNumbers.append(["phone": phoneTextField.text ?? ""])
                contact.emails.append(["email": emailTextField.text ?? ""])
                
                
                self.selectedEmail = emailTextField.text ?? ""
                self.selectedPhone = phoneTextField.text ?? ""
                
                print(contact.emails)
                print(contact.phoneNumbers)
                // Show email 
                self.showEmailCard()
            }

        }
    }
    
    func syncContact() {
        
        // Init CNContact Object
        //let temp = CNContact()
        //temp.emailAddresses.append(CNLabeledValue<NSString>)
        //let tempContact = ContactManager.sharedManager.newContact
        
        // Append to list of existing contacts
        let store = CNContactStore()
        
        // Set text for name
        let contactToAdd = CNMutableContact()
        contactToAdd.givenName = self.contact.name 
        //contactToAdd.familyName = self.lastNameLabel.text ?? ""
        
        // Parse for mobile
        let mobileNumber = CNPhoneNumber(stringValue: (self.contact.phoneNumbers[0].values.first ?? ""))
        let mobileValue = CNLabeledValue(label: CNLabelPhoneNumberMobile, value: mobileNumber)
        contactToAdd.phoneNumbers = [mobileValue]
        
        // Parse for emails
        let email = CNLabeledValue(label: CNLabelWork, value: self.emailTextField.text as NSString? ?? "")
        contactToAdd.emailAddresses = [email]
        
        // Set organizations
        if self.contact.organizations.count > 0 {
            // Add to contact
            contactToAdd.organizationName = self.contact.organizations[0]["organization"]!
        }
        
        // Format location
        var noteString = "Unify Location:\n\(self.locationTextField.text ?? "") "
        noteString += "\nUnify Tags:\n\(self.tokenField.text ?? "")"
        
        
        // Set notes to contact
        contactToAdd.note = noteString//self.locationTextField.text ?? ""
        
        //contactToAdd.note += self.tokenField.text ?? ""
        
        // **** Make a scheme for adding tags to contact **** //
        
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
    
 
    func createTransaction(type: String) {
        // Set type & Transaction data
        transaction.type = type
        transaction.setTransactionDate()
        transaction.senderName = ContactManager.sharedManager.currentUser.getName()
        transaction.senderId = ContactManager.sharedManager.currentUser.userId
        transaction.scope = "transaction"
        transaction.senderCardId = ContactManager.sharedManager.selectedCard.cardId!
        transaction.recipientNames = [String]()
        transaction.recipientNames?.append(contact.name)
        print("APPENDING NAME \(self.contact.name)")
        transaction.location = self.locationTextField.text ?? ""
        
        print("Printing Transaction")
        transaction.printTransaction()
        
        /*transaction.latitude = self.lat
        transaction.longitude = self.long
        transaction.recipientList = selectedUserIds
        transaction.location = self.address*/
        // Attach card id
        
        
        // Show progress hud
        
        /*let conf = KVNProgressConfiguration.default()
        conf?.isFullScreen = true
        conf?.statusColor = UIColor.white
        conf?.successColor = UIColor.white
        conf?.circleSize = 170
        conf?.lineWidth = 10
        conf?.statusFont = UIFont(name: ".SFUIText-Medium", size: CGFloat(25))
        conf?.circleStrokeBackgroundColor = UIColor.white
        conf?.circleStrokeForegroundColor = UIColor.white
        conf?.backgroundTintColor = UIColor(red: 0.173, green: 0.263, blue: 0.856, alpha: 0.4)
        KVNProgress.setConfiguration(conf)*/
        
        KVNProgress.show(withStatus: "Sending your card...")
        
        // Save card to DB
        let parameters = ["data": self.transaction.toAnyObject()]
        print(parameters)

        
        // Send to server
        
        Connection(configuration: nil).createTransactionCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Card Created Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                /*let dictionary : Dictionary = response as! [String : Any]
                self.transaction.transactionId = (dictionary["uuid"] as? String)!*/
                
                // Hide HUD
                KVNProgress.showSuccess(withStatus: "Card send succesfully")
                
                // Dismiss VC
                self.dismiss(animated: true, completion: nil)
                
            } else {
                print("Card Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error with your connection request. Please try again.")
                
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
    }
    
    func uploadContactRecord(){
        
        // Assign contact
        let contact = self.contact
        
        // Show progress hud
        
        /*let conf = KVNProgressConfiguration.default()
        conf?.isFullScreen = true
        conf?.statusColor = UIColor.white
        conf?.successColor = UIColor.white
        conf?.circleSize = 170
        conf?.lineWidth = 10
        conf?.statusFont = UIFont(name: ".SFUIText-Medium", size: CGFloat(25))
        conf?.circleStrokeBackgroundColor = UIColor.white
        conf?.circleStrokeForegroundColor = UIColor.white
        conf?.backgroundTintColor = UIColor(red: 0.173, green: 0.263, blue: 0.856, alpha: 0.4)
        KVNProgress.setConfiguration(conf!)*/
        
        // Set text to HUD
        KVNProgress.show(withStatus: "Saving to your contacts...")
        
        
        // Create dictionary
        let parameters = ["data" : contact.toAnyObject(), "uuid" : ContactManager.sharedManager.currentUser.userId] as [String : Any]
        print(parameters)
        
        // Send to server
        Connection(configuration: nil).uploadContactCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                // Call successful
                print("Transaction Created Response ---> \(String(describing: response))")
                
                // Parse array for 
                let array = response as! NSArray
                print("Array List >> \(array)")
                
                // Set recipient list to transaction 
                self.transaction.recipientList = array as! [String]
                // Test
                print("Transaction List Count >> \(self.transaction.recipientList.count)")
                print("Transaction List >> \(self.transaction.recipientList)")
                
                // Create transaction
                self.createTransaction(type: "quick_share")
                
                // Check if user wants contacts syncing
                if self.syncToContactsSwitch.isOn == true {
                    // Set sync to true
                   self.syncContact()
                }else{
                    // Set sync to false
                    self.syncToContactsSelected = false
                    print("Not synced")
                }
                
                
                // Hide HUD
                KVNProgress.showSuccess(withStatus: "Contact saved")
                
            } else {
                // Error occured
                print("Transaction Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error with your connection request. Please try again.")
                
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
        
    }
    
    // Format textfield for phone numbers
    func format(phoneNumber sourcePhoneNumber: String) -> String? {
        
        // Remove any character that is not a number
        let numbersOnly = sourcePhoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let length = numbersOnly.characters.count
        let hasLeadingOne = numbersOnly.hasPrefix("1")
        
        // Check for supported phone number length
        guard /*length == 7 ||*/ length == 10 || (length == 11 && hasLeadingOne) else {
            return nil
        }
        
        let hasAreaCode = (length >= 10)
        var sourceIndex = 0
        
        // Leading 1
        var leadingOne = ""
        if hasLeadingOne {
            leadingOne = "1 "
            sourceIndex += 1
        }
        
        // Area code
        var areaCode = ""
        if hasAreaCode {
            let areaCodeLength = 3
            guard let areaCodeSubstring = numbersOnly.characters.substring(start: sourceIndex, offsetBy: areaCodeLength) else {
                return nil
            }
            areaCode = String(format: "(%@) ", areaCodeSubstring)
            sourceIndex += areaCodeLength
        }
        
        // Prefix, 3 characters
        let prefixLength = 3
        guard let prefix = numbersOnly.characters.substring(start: sourceIndex, offsetBy: prefixLength) else {
            return nil
        }
        sourceIndex += prefixLength
        
        // Suffix, 4 characters
        let suffixLength = 4
        guard let suffix = numbersOnly.characters.substring(start: sourceIndex, offsetBy: suffixLength) else {
            return nil
        }
        
        return leadingOne + areaCode + prefix + "-" + suffix
    }

    
    // Message Composer Functions
    
    func showEmailCard() {
        
        print("EMAIL CARD SELECTED")
        
        // Send post notif
        // Create instance of controller
        let mailComposeViewController = configuredMailComposeViewController()
        
        // Check if deviceCanSendMail
        if MFMailComposeViewController.canSendMail() {
            
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }
    
    func showSMSCard() {
        // Set Selected Card
        
        //selectedCardIndex = cardCollectionView.inde
        
        
        print("SMS CARD SELECTED")
        // Send post notif
        
        let composeVC = MFMessageComposeViewController()
        if(MFMessageComposeViewController .canSendText()){
            
            composeVC.messageComposeDelegate = self
            
            
            // Set contacts name
            let name = contact.name //"\(firstNameTextField.text!) \(lastNameTextField.text!)"
            
            let fullName = contact.name
            var fullNameArr = fullName.components(separatedBy: " ")
            let firstName: String = fullNameArr[0]
            var lastName: String = fullNameArr.count > 1 ? fullNameArr[1] : ""
            
            /*if contact.phoneNumbers.count > 0 {
                // Set contact phone
                let contactPhone = contact.phoneNumbers[0]["phone"]
                
                // Launch text client
                composeVC.recipients = [contactPhone!]
            }*/
            // Get phone
            let contactPhone = self.phoneTextField.text ?? ""
            
            // Set recipient
            composeVC.recipients = [contactPhone]
            
            // Set card link from cardID
            let cardLink = "https://project-unify-node-server.herokuapp.com/card/render/\(selectedCard.cardId!)"
            
            let str = "Hi \(firstName), it was great meeting you today. Looking forward to continuing our conversation.\n\n\(cardLink)"
            
            
            // Test String
            //let str = string
            
            // Set string as message body
            composeVC.body = str
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }
        
    }
    
    
    // Email Composer Delegate Methods
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
        // Create Instance of controller
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        // Init variables
        var emailContact = ""
        let contactName = contact.name //"\(firstNameTextField.text!) \(lastNameTextField.text!)"
        
        let fullName = contact.name
        var fullNameArr = fullName.components(separatedBy: " ")
        let firstName: String = fullNameArr[0]
        var lastName: String = fullNameArr.count > 1 ? fullNameArr[1] : ""
        
        // Check for nil values
        /*if contact.emails.count > 0{
            // Set email string
            let contactEmail = contact.emails[0]["email"]
            
            // Set variable
            emailContact = contactEmail!
        }*/
        // Set recipient
        let contactEmail = self.emailTextField.text ?? ""
        
        // Create Message
        
        // Set card link from cardID
        let cardLink = "https://project-unify-node-server.herokuapp.com/card/render/\(selectedCard.cardId!)"
        
        // Test String
       // let str = "\n\n\n\(cardLink)"
        
        let str = "Hi \(firstName), it was great meeting you today. Looking forward to continuing our conversation. \n\n\(cardLink)"
        
        // Create Message
        mailComposerVC.setToRecipients([self.selectedEmail])
        mailComposerVC.setSubject("\(currentUser.getName()) - Nice to meet you!")
        mailComposerVC.setMessageBody(str, isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    
    // Message Composer Delegate
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        
        if result == .cancelled {
            // User cancelled
            print("User cancelled")
            
        }else if result == .sent{
            
            // Upload the contact record
            self.uploadContactRecord()
            

            
        }else{
            // There was an error
            KVNProgress.showError(withStatus: "There was an error sending your message. Please try again.")
            
        }
        
        // Make checks here for
        controller.dismiss(animated: true) {
            print("Message composer dismissed")
        }
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if result == .cancelled {
            // User cancelled
            print("User cancelled")
            
        }else if result == .sent{
            
            // Upload the contact record
            self.uploadContactRecord()
            
            
        }else{
            // There was an error
            KVNProgress.showError(withStatus: "There was an error sending your message. Please try again.")
            
        }
        
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    
}
