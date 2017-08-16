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
            
            // 6468251231
            
            // Check for nil vals
            
            var name = ""
            var recipientName = ""
            var phone = ""
            var email = ""
            //var title = ""
            
            
            // CNContact Objects
            let contact = ContactManager.sharedManager.contactToIntro
            let recipient = ContactManager.sharedManager.recipientToIntro
            
            // Check if they both have email
            name = formatter.string(from: contact) ?? "No Name"
            recipientName = formatter.string(from: recipient) ?? ""
            
            if contact.phoneNumbers.count > 0 && recipient.phoneNumbers.count > 0 {
                
                let contactPhone = (contact.phoneNumbers[0].value).value(forKey: "digits") as? String
                // Set contact phone number
                phone = contactPhone!
                
                let recipientPhone = (recipient.phoneNumbers[0].value).value(forKey: "digits") as? String
                
                // Launch text client
                composeVC.recipients = [contactPhone!, recipientPhone!]
            }
            
            if contact.emailAddresses.count > 0 {
                email = (contact.emailAddresses[0].value as String)
            }
            // Set card link from cardID
            let cardLink = "https://project-unify-node-server.herokuapp.com/card/render/\(ContactManager.sharedManager.selectedCard.cardId!)"
            
            // Configure message
            let str = "Hi \(name), Please meet \(recipientName). Thought you should connect. You are both doing some cool projects and thought you might be able to work together. \n\nYou two can take it from here! \n\nBest, \n\(currentUser.getName()) \n\n\(cardLink)"
            
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
    
    
    func validateForm() {
        
        // Here, configure form validation
        
        if (firstNameLabel.text == nil || lastNameLabel.text == nil || emailLabel.text == nil && phoneLabel.text == nil) {
            
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
            
        }else{
            
            // Pass form values into contact object
            contact.name = "\(firstNameLabel.text!) \(lastNameLabel.text!)"
            
            // Set notes
            if notesLabel.text != nil{
                contact.setNotes(note: notesLabel.text!)
            }
            
            // Execute send actions
            
            // ***** Figure out how the user navigation/intent here *** //
            // The check may be if one is nil, then check for the other 
            // Phones and emails
            
            // Check for user intent
            if ContactManager.sharedManager.quickshareSMSSelected {
                // Set the number to contact
                contact.phoneNumbers.append(["phone": emailLabel.text!])
                // Show sms
                self.showSMSCard()
            }else{
                // Set email
                contact.emails.append(["email": emailLabel.text!])
                // Show email
                self.showEmailCard()
            }
            
            // Create Transaction
            //self.createTransaction(type: "connection")
            
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
    
    
    func createTransaction(type: String) {
        // Set type & Transaction data 
        transaction.type = type
        //transaction.recipientList = selectedUserIds
        transaction.setTransactionDate()
        transaction.senderName = ContactManager.sharedManager.currentUser.getName()
        transaction.senderId = ContactManager.sharedManager.currentUser.userId
        transaction.type = "connection"
        transaction.scope = "transaction"
        transaction.latitude = self.lat
        transaction.longitude = self.long
        transaction.location = self.address
        // Attach card id
        transaction.senderCardId = ContactManager.sharedManager.selectedCard.cardId!
        
        
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
                print("Card Created Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                /*let dictionary : Dictionary = response as! [String : Any]
                self.transaction.transactionId = (dictionary["uuid"] as? String)!*/
                
                // Insert to manager card array
                //ContactManager.sharedManager.currentUserCardsDictionaryArray.insert([card.toAnyObjectWithImage()], at: 0)
                
                // Hide HUD
                //KVNProgress.dismiss()
                KVNProgress.showSuccess(withStatus: "You are now connected!")
                
                
                
            } else {
                print("Card Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error. Please try again.")
                
            }
            
            
            // Clear List of recipients
            self.radarContactList.removeAll()
        }
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if result == .cancelled {
            // User cancelled
            print("User cancelled")
            
        }else if result == .sent{
            // User sent
            self.createTransaction(type: "connection")
            // Dimiss vc
            self.dismiss(animated: true, completion: nil)
            
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
            // User sent
            // Create transaction
            self.createTransaction(type: "connection")
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
