//
//  RecipientOptionsViewController.swift
//  Unify
//
//  Created by Kevin Fich on 7/27/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit
import CoreLocation
import Contacts
import MessageUI


class RecipientOptionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate  {
    
    // Properties
    // --------------------------
    var currentUser = User()
    var transaction = Transaction()
    var radarContactList = [User]()
    var selectedUserIds = [String]()
    var selectedContactList = [User]()
    var segmentedControl = UISegmentedControl()
    var selectedCells = [NSIndexPath]()
    
    // If contact created from form
    var selectedContactPhone : String = ""
    var selectedEmail : String = ""
    
    // Contact Object 
    var contact = Contact()
    
    // Location 
    var lat : Double = 0.0
    var long : Double = 0.0
    var address = String()
    var updateLocation_tick = 5
    let locationManager = CLLocationManager()

    var cellReuseIdentifier = "ContactListCell"
    
    // Radar 
    var radarStatus: Bool = false
    let formatter = CNContactFormatter()
    
    
    // IBOutlets
    // ----------------------------------------
    @IBOutlet var navigationBar: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var radarSwitch: UISwitch!
    
    
    @IBOutlet var phoneLabel: UITextField!
    @IBOutlet var emailLabel: UITextField!
    
    @IBOutlet var firstNameLabel: UITextField!
    @IBOutlet var lastNameLabel: UITextField!
    
    @IBOutlet var tagsLabel: UITextField!
    @IBOutlet var notesLabel: UITextField!

    

    // Page setup 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Init and configure segment controller
        segmentedControl = UISegmentedControl(frame: CGRect(x: 10, y: 5, width: self.view.frame.width - 20, height: 30))
        // Set tint
        segmentedControl.tintColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        
        segmentedControl.insertSegment(withTitle: "Tools", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Contacts", at: 1, animated: false)
        
        
        // Set segment
        segmentedControl.selectedSegmentIndex = 0
        
        // Add target action method
        segmentedControl.addTarget(self, action: #selector(RecipientOptionsViewController.toggleViews(sender:)), for: .valueChanged)
        
        // Add segment control to navigation bar
        self.navigationBar.titleView = segmentedControl
        
        // Hide table
        self.tableView.isHidden = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions
    // --------------------------
    
    @IBAction func radarSwitchSelected(_ sender: Any) {
        // Turn on location service
        if radarSwitch.isOn == false {
            // Hide tableview
            //self.tableView.isHidden = true
            // Toggle radar status
            self.radarStatus = false
        }else{
            // Show table
            //self.tableView.isHidden = false
            
            // Toggle radar status 
            //self.radarStatus = true
            
            // Start updating location
            //self.updateLocation()
        }
    }
    
    @IBAction func dismissViewController(_ sender: Any) {
        
        // Pop view 
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func shareWithContact(_ sender: Any) {
        
        // Check if contact list is in view
        if self.tableView.isHidden{
            //Check if form valid
            let isValidForm = self.validateForm()
            
            if isValidForm {
                // Configure and create transaction
                
            }
            
        }else{
            
        }
        
        
        // if presented, set contact to selection
        
        // Parse for details
        
        // Show vc according to values in account
        
        
        // else
        
        // Validate form for values
        
        // Parse form to create contact object
        
        // Upload contact
        
        // Check if save to conatcts switch active to set bool on object
        
        
        
        
        // Create transaction
        
        
        
        
        self.validateForm()
        
        /*
        // Create the transaction and share
        //self.createTransaction(type: "connection", uuid: currentUser.userId)
        // Check if both contacts selected
        
        
        if ContactManager.sharedManager.userSelectedRecipient {
            
        }
        // CNContact Objects
        let contact = ContactManager.sharedManager.contactToIntro
        let recipient = ContactManager.sharedManager.recipientToIntro
        
        // Check if they both have email
        
        if contact.emailAddresses.count > 0 && recipient.emailAddresses.count > 0 {
            
            let contactEmail = contact.emailAddresses[0].value as String
            let recipientEmail = recipient.emailAddresses[0].value as String
            
            
            // Launch Email client
            showEmailCard()
            
        }else if contact.phoneNumbers.count > 0 && recipient.phoneNumbers.count > 0 {
            
            let contactPhone = (contact.phoneNumbers[0].value).value(forKey: "digits") as? String
            let recipientPhone = (recipient.phoneNumbers[0].value).value(forKey: "digits") as? String
            
            // Launch text client
            showSMSCard()
            
        }else{
            // No mutual way to connect
            // Pick default based on what the contact object has populated
            
            // ***** Handle this off case tomorrow ****
            print("No Mutual Info")
        }
        
        
        // Else check if they both have phones
        
        // If no match, chose a defualt method and send
        
        // Create Transaction and send*/
        
    }
    
    
    // Tableview delegate methods
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ContactManager.sharedManager.phoneContactList.count //contactList.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ContactListCell!
        // Create var with current contact in array
        let contact = ContactManager.sharedManager.phoneContactList[indexPath.row]
        
        // Set name formatted
        cell?.contactNameLabel?.text = formatter.string(from: contact) ?? "No Name"
        
        
        // If image data avilable, set image
        if contact.imageDataAvailable {
            print("Has IMAGE")
            let image = UIImage(data: contact.imageData!)
            // Set image for contact
            cell?.contactImageView?.image = image
        }else{
            cell?.contactImageView.image = UIImage(named: "profile")
        }
        
        // Add tap gesture to follow up button
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell selected code here
        
        // Set Checkmark
        let selectedCell = tableView.cellForRow(at: indexPath)
        
        selectedCells.append(indexPath as NSIndexPath)
        
        if selectedCell?.accessoryType == .checkmark {
            
            selectedCell?.accessoryType = .none
            
            selectedCells = selectedCells.filter {$0 as IndexPath != indexPath}
            
            // Remove from list
            selectedContactList.remove(at: indexPath.row)
            
        } else {
            
            selectedCell?.accessoryType = .checkmark
            
            // Append to list
            //self.selectedContactList.append(radarContactList[indexPath.row])
            
            // Append id to selectedList
           // self.selectedUserIds.append(radarContactList[indexPath.row].userId)
            
            // Set recipient
            ContactManager.sharedManager.recipientToIntro = ContactManager.sharedManager.phoneContactList[indexPath.row]
            
            // Toggle BOOL 
            ContactManager.sharedManager.userSelectedRecipient = true
        }
        
        
    }
    
    // Location Managment
    
    func updateLocation(){
        
        // Update location tick
        updateLocation_tick = updateLocation_tick + 1
    
        print(updateLocation_tick)
        
        // Check is list should be refreshed
        
        
        if updateLocation_tick >= 5  && radarStatus == true{
            
            // Reset Ticker
            updateLocation_tick = 0
            
            
            // Hit endpoint for updates on users nearby
            let parameters = ["uuid": ContactManager.sharedManager.currentUser.userId, "location": ["latitude": self.lat, "longitude": self.long]] as [String : Any]
            
            print(">>> SENT PARAMETERS >>>> \n\(parameters))")
            
            // Create User Objects
            Connection(configuration: nil).startRadarCall(parameters, completionBlock: { response, error in
                if error == nil {
                    
                    //print("\n\nConnection - Radar Response: \n\n>>>>>> \(response)\n\n")
                    
                    let dictionary : NSArray = response as! NSArray
                    
                    print("data length", dictionary.count)
            
                    
                    for item in dictionary {
                        
                        //print(item)
                        
                        let userDict = item as? NSDictionary
                        
                        // Init user objects from array
                        let user = User(withRadarSnapshot: userDict!)
                        
                        // Test user
                        user.printUser()
                        
                        // Append users to radarContacts array
                        self.radarContactList.append(user)
                        print("Radar List Count >>>> \(self.radarContactList.count)")
                    
                    }
                    
                    // Reload table 
                    self.tableView.reloadData()
                    
                    
                } else {
                    print(error ?? "")
                    // Show user popup of error message
                    print("\n\nConnection - Radar Error: \n\n>>>>>>>> \(String(describing: error))\n\n")
                    
                }
                
            })
        }
        
        print("Updating location")
        
        
    }
    
    func saveCurrentLocation(_ center:CLLocationCoordinate2D){
        // Create location message
        let message = "THIS IS THE CURRENT \(center.latitude) , \(center.longitude)"
        
        // Test
        print(message)
        
        // Set lat and long
        self.lat = center.latitude
        self.long = center.longitude
        //print(message)
        
        
        // Get Location
        let location = CLLocation(latitude: center.latitude, longitude: center.longitude)
        
        
        // Geocode Location
        let geocoder = CLGeocoder()
        
        /* let paramString = "latitude=\(center.latitude)&longitude=\(center.longitude)&uuid=\(global_uuid!)"*/
        
        
        // Upload location to sever
        self.updateLocation()
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            // Process Response
            if let placemarks = placemarks, let placemark = placemarks.first {
                //print( placemark.compactAddress)
                // Set placemark address
                self.address = placemark.compactAddress!
            }
        }
        
        
        // self.lable.text = message
        //myLocation = center
    }
    
    
    func centerMap(_ center:CLLocationCoordinate2D){
        self.saveCurrentLocation(center)
        
    }
    
    // Location delegate method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        self.centerMap(locValue)
        
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
        
            
            // Check intent
            if self.tableView.isHidden == false{
                
                
                
            }
            
            
        }
        
    }
    
    
    // Email Composer Delegate Methods
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
        // Create Instance of controller
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        // Check for nil vals
        
        var name = ""
        var recipientName = ""
        var phone = ""
        var emailContact = ""
        var emailRecipient = ""
        //var title = ""
        
        
        // CNContact Objects
        let contact = ContactManager.sharedManager.contactToIntro
        let recipient = ContactManager.sharedManager.recipientToIntro
        
        // Check if they both have email
        name = formatter.string(from: contact) ?? "No Name"
        recipientName = formatter.string(from: recipient) ?? "No Name"
        
        if contact.emailAddresses.count > 0 && recipient.emailAddresses.count > 0 {
            
            let contactEmail = contact.emailAddresses[0].value as String
            let recipientEmail = recipient.emailAddresses[0].value as String
            
            // Set variable
            emailContact = contactEmail
            emailRecipient = recipientEmail
            
        }
        
        if contact.phoneNumbers.count > 0 {
            phone = (contact.emailAddresses[0].value as String)
        }
        
        // Create Message
        // Set card link from cardID
        let cardLink = "https://project-unify-node-server.herokuapp.com/card/render/\(ContactManager.sharedManager.selectedCard.cardId!)"
        
        let str = "Hi \(name), Please meet \(recipientName). Thought you should connect. You are both doing some cool projects and thought you might be able to work together. \n\nYou two can take it from here! \n\nBest, \n\(currentUser.getName()) \n\n\(cardLink)"
        
        // Create Message
        mailComposerVC.setToRecipients([emailContact, emailRecipient])
        mailComposerVC.setSubject("Unify Intro - \(name) meet \(recipientName)")
        mailComposerVC.setMessageBody(str, isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    

    // Custom Methods
    
    
    func validateForm() -> Bool {

        // Here, configure form validation
        
        if ((firstNameLabel.text == nil || lastNameLabel.text == nil) || (emailLabel.text == nil && phoneLabel.text == nil)) {
            
            // form invalid
            let message = "Please enter valid contact information"
            let title = "There was an error"
            
            // Configure alertview
            let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                
                // Dismiss alert
                self.dismiss(animated: true, completion: nil)
                
            })
            
            // Add action to alert
            alertView.addAction(cancel)
            self.present(alertView, animated: true, completion: nil)
            
            // Form not valid
            return false
            
        }else{
            
            // Pass form values into contact object
            contact.name = "\(firstNameLabel.text!) \(lastNameLabel.text!)"
            
            // Set notes
            if notesLabel.text != nil{
                contact.setNotes(note: notesLabel.text!)
            }
            
            // Set notes
            if tagsLabel.text != nil{
                // Add tag to object
                contact.setTags(tag: tagsLabel.text!)
                
            }
            
            // Check for phone
            if phoneLabel.text != nil {
                // Set the number to contact
                contact.phoneNumbers.append(["phone": emailLabel.text!])
            }
            // Check for email
            if emailLabel.text != nil{
                // Set email
                contact.emails.append(["email": emailLabel.text!])
            }
            
            // Check for match in contact info
            let introContact = ContactManager.sharedManager.contactToIntro
            
            if introContact.emailAddresses.count > 0 && contact.emails.count > 0 {
                
                //
                self.selectedEmail = introContact.emailAddresses[0].value as String
                
                //let recipientEmail = recipient.emailAddresses[0].value as String
 
                
                // Launch Email client
                showEmailCard()
                
            }else if introContact.phoneNumbers.count > 0 && contact.phoneNumbers.count > 0 {
                // Set selected phone
                self.selectedContactPhone = ((introContact.phoneNumbers[0].value).value(forKey: "digits") as? String)!
                
                // Launch text client
                showSMSCard()
                
            }else{
                // Users don't have things in common
                // form invalid
                let message = "The two people have no contact info in common"
                let title = "Unable to Connect"
                
                // Configure alertview
                let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                    
                    // Dismiss alert
                    self.dismiss(animated: true, completion: nil)
                    
                })
                
                // Add action to alert
                alertView.addAction(cancel)
                self.present(alertView, animated: true, completion: nil)
            
            }
            
            // Form valid
            return true
            
        }
    }
    
    

    
    func toggleViews(sender: UISegmentedControl) {
        
        print("Toggling views for selection")
        
        switch(sender.selectedSegmentIndex) {
        case 0:
            // Test
            print("Segment One")
            // Hide view 
            self.tableView.isHidden = true
            
        case 1:
            // Test
            print("Segment Two")
            // Hide view
            self.tableView.isHidden = false

        default:
            // Test
            print("Segment One")
            // Hide view
            self.tableView.isHidden = true

        }
    }
    
    func uploadFormContactRecord(){
        
        // Check user intent
        /*if self.tableView.isHidden == false{
            // Use introContact from manager
            /*let temp = ContactManager.sharedManager.recipientToIntro
            
            self.contact = self.createContactRecord(contact: temp)*/
            
            // Parse contact
        }else{
            // User filled out form
            
            
        }*/
        
        // Assign contact
        let contact = self.contact
        
        // Show progress hud
        
        let conf = KVNProgressConfiguration.default()
        conf?.isFullScreen = true
        conf?.statusColor = UIColor.white
        conf?.successColor = UIColor.white
        conf?.circleSize = 170
        conf?.lineWidth = 10
        conf?.statusFont = UIFont(name: ".SFUIText-Medium", size: CGFloat(25))
        conf?.circleStrokeBackgroundColor = UIColor.white
        conf?.circleStrokeForegroundColor = UIColor.white
        conf?.backgroundTintColor = UIColor(red: 0.173, green: 0.263, blue: 0.856, alpha: 0.4)
        KVNProgress.setConfiguration(conf!)
        
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
                self.createTransaction(type: "introduction")
                
                
                // Hide HUD
                KVNProgress.dismiss()
                
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
    
    func createContactRecord(contact: CNContact) -> Contact {
        // Create CNContact
        //let contact = CNContact()
        
        // Init formatter
        let formatter = CNContactFormatter()
        formatter.style = .fullName
        
        // Iterate over list and itialize contact objects
        
            
            // Init temp contact object
            let contactObject = Contact()
            
            // Set name
            contactObject.name = formatter.string(from: contact) ?? "No Name"
            
            // Check for count
            if contact.phoneNumbers.count > 0 {
                // Iterate over items
                for number in contact.phoneNumbers{
                    // print to test
                    print("Number: \((number.value.value(forKey: "digits" )!))")
                    
                    // Init the number
                    let digits = number.value.value(forKey: "digits") as! String
                    
                    // Append to object
                    contactObject.setPhoneRecords(phoneRecord: digits)
                }
                
            }
            if contact.emailAddresses.count > 0 {
                // Iterate over array and pull value
                for address in contact.emailAddresses {
                    // Print to test
                    print("Email : \(address.value)")
                    
                    // Append to object
                    contactObject.setEmailRecords(emailAddress: address.value as String)
                }
            }
            if contact.imageDataAvailable {
                // Print to test
                print("Has IMAGE Data")
                
                // Create ID and add to dictionary
                // Image data png
                let imageData = contact.imageData!
                print(imageData)
                
                // Assign asset name and type
                let idString = contactObject.randomString(length: 20)
                
                // Name image with id string
                let fname = idString
                let mimetype = "image/png"
                
                // Create image dictionary
                let imageDict = ["image_id":idString, "image_data": imageData, "file_name": fname, "type": mimetype] as [String : Any]
                
                // Upload image to amazon?
                
                
                // Append to object
                contactObject.setContactImageId(id: idString)
                contactObject.imageDictionary = imageDict
                
            }
            if contact.urlAddresses.count > 0{
                // Iterate over items
                for address in contact.urlAddresses {
                    // Print to test
                    print("Website : \(address.value as String)")
                    
                    // Append to object
                    contactObject.setWebsites(websiteRecord: address.value as String)
                }
                
            }
            if contact.socialProfiles.count > 0{
                // Iterate over items
                for profile in contact.socialProfiles {
                    // Print to test
                    print("Social Profile : \((profile.value.value(forKey: "urlString") as! String))")
                    
                    // Create temp link
                    let link = profile.value.value(forKey: "urlString")  as! String
                    
                    // Append to object
                    contactObject.setSocialLinks(socialLink: link)
                }
                
            }
            
            if contact.jobTitle != "" {
                //Print to test
                print("Job Title: \(contact.jobTitle)")
                
                // Append to object
                contactObject.setTitleRecords(title: contact.jobTitle)
            }
            if contact.organizationName != "" {
                //print to test
                print("Organization : \(contact.organizationName)")
                
                // Append to object
                contactObject.setOrganizations(organization: contact.organizationName)
            }
            if contact.note != "" {
                //print to test
                print(contact.note)
                
                // Append to object
                contactObject.setNotes(note: contact.note)
                
            }
            
            // Test object
            print("Contact >> \n\(contactObject.toAnyObject()))")
        
        
        return contactObject
    }

    
    
    func createTransaction(type: String) {
        // Configure trans for CNContact
        // Set type & Transaction data
        transaction.type = type
        //transaction.recipientList = selectedUserIds
        transaction.setTransactionDate()
        transaction.senderName = ContactManager.sharedManager.currentUser.getName()
        transaction.senderId = ContactManager.sharedManager.currentUser.userId
        transaction.type = "introduction"
        transaction.scope = "transaction"
        // Attach card id
        transaction.senderCardId = ContactManager.sharedManager.selectedCard.cardId!
        
        
        if self.tableView.isHidden == false {
            
            // Set names
            let recipient = ContactManager.sharedManager.recipientToIntro
            let introContact = ContactManager.sharedManager.contactToIntro
            
            let recipientName = formatter.string(from: recipient) ?? "No Name"
            let contactName = formatter.string(from: introContact) ?? "No Name"
            // Init list
            transaction.recipientNames = [String]()
            transaction.recipientNames?.append(recipientName)
            transaction.recipientNames?.append(contactName)
            
            
        }else{
            
            // Set names
            let introContact = ContactManager.sharedManager.contactToIntro
            let contactName = formatter.string(from: introContact) ?? "No Name"
            
            // Set recipient names
            transaction.recipientNames = [String]()
            transaction.recipientNames?.append(self.contact.name)
            transaction.recipientNames?.append(contactName)

        }
        
        
        // Show progress hud
        
        let conf = KVNProgressConfiguration.default()
        conf?.isFullScreen = true
        conf?.statusColor = UIColor.white
        conf?.successColor = UIColor.white
        conf?.circleSize = 170
        conf?.lineWidth = 10
        conf?.statusFont = UIFont(name: ".SFUIText-Medium", size: CGFloat(25))
        conf?.circleStrokeBackgroundColor = UIColor.white
        conf?.circleStrokeForegroundColor = UIColor.white
        conf?.backgroundTintColor = UIColor(red: 0.173, green: 0.263, blue: 0.856, alpha: 0.4)
        KVNProgress.setConfiguration(conf)
        
        KVNProgress.show(withStatus: "Sending your card...")
        
        // Save card to DB
        let parameters = ["data": self.transaction.toAnyObject()]
        print(parameters)
        
        // Send to server
        
        Connection(configuration: nil).createTransactionCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Transaction Created Response ---> \(String(describing: response))")
                

                // Show success indicator
                KVNProgress.showSuccess(withStatus: "You are now connected!")
                
                
            } else {
                print("Transaction Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error. Please try again.")
                
            }
            
            // Clear List of recipients
            //self.radarContactList.removeAll()
        }
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if result == .cancelled {
            // User cancelled
            print("User cancelled")
            
        }else if result == .sent{
            // User sent
            
            if self.tableView.isHidden {
                // User filled out form
                self.uploadFormContactRecord()
            }else{
                // Chose from list
                self.createTransaction(type: "introduction")
                // Dimiss vc
                self.dismiss(animated: true, completion: nil)
            }
            
        }else{
            // There was an error
            KVNProgress.showError(withStatus: "There was an error sending your message. Please try again.")
            
        }
        
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    // Message Composer Delegate
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        if result == .cancelled {
            // User cancelled
            print("Cancelled")
            
        }else if result == .sent{
            // User sent message
            
            if self.tableView.isHidden {
                // User filled out form
                self.uploadFormContactRecord()
            }else{
                
                // Create transaction
                self.createTransaction(type: "introduction")
            }
            // Dismiss VC
            self.dismiss(animated: true, completion: nil)
            
        }else{
            // There was an error
            KVNProgress.showError(withStatus: "There was an error sending your message. Please try again.")
            
        }
        
        
        // Make checks here for
        controller.dismiss(animated: true) {
            print("Message composer dismissed")
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
