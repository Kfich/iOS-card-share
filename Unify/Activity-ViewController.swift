//
//  Activity-ViewController.swift
//  Unify
//
//  Created by Ryan Hickman on 4/4/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit
import PopupDialog
import UIDropDown
import MessageUI


class ActivtiyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    // Properties
    // ----------------------------------------
    var currentUser = User()
    var transactions = [Transaction]()
    var selectedUsers = [User]()
    var selectedTransaction = Transaction()
    var segmentedControl = UISegmentedControl()
    
    @IBOutlet var navigationBar: UINavigationItem!
    // IBOutlets
    // ----------------------------------------
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    // Page Config
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Set currentUser object 
        currentUser = ContactManager.sharedManager.currentUser
        
        // Fetch the users transactions 
        getTranstactions()
        
        // Configure tableview
        tableView.dataSource = self
        tableView.delegate = self
        //tableView.estimatedSectionHeaderHeight = 8.0
        self.automaticallyAdjustsScrollViewInsets = false
        // Set a header for the table view
       // let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
       // header.backgroundColor = .red
        //tableView.tableHeaderView = header
        
        
        // Init and configure segment controller
        segmentedControl = UISegmentedControl(frame: CGRect(x: 10, y: 5, width: tableView.frame.width - 20, height: 30))
        // Set tint
        segmentedControl.tintColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        
        segmentedControl.insertSegment(withTitle: "All", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Introductions", at: 1, animated: false)
        segmentedControl.insertSegment(withTitle: "Connections", at: 2, animated: false)
        //segmentedControl.insertSegment(withTitle: "Follow Up",at: 3, animated: false)
        
        segmentedControl.selectedSegmentIndex = 0
        
        // Add segment control to navigation bar
        self.navigationBar.titleView = segmentedControl
        
        
        // Set graphics for background of tableview
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "backgroundGradient")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)

        
        // Set tint on main nav bar
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor(red: 28/255.0, green: 52/255.0, blue: 110/255.0, alpha: 1.0)]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        
        
    }
    
    // TableView Delegate & Data Source

    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Set selected transaction
        self.selectedTransaction = self.transactions[indexPath.row]
        
        // Get users in transaction
        self.fetchUsersForTransaction()
        
        // Pass in segue
        //self.performSegue(withIdentifier: "showFollowupSegue", sender: self)
        
        
    }
    
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Config container view
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        containerView.backgroundColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        
        // Create section header buttons
        let imageName = "icn-time.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 10, y: 10, width: 12, height: 12)
        
        // Add label to the view
        let lbl = UILabel(frame: CGRect(30, 9, 100, 15))
        lbl.text = "Recents"
        lbl.textAlignment = .left
        lbl.textColor = UIColor.white
        lbl.font = UIFont(name: "Avenir", size: CGFloat(14))
        
        // Add subviews
        containerView.addSubview(lbl)
        containerView.addSubview(imageView)

        return containerView
    }
   
    
   
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32.0
    }
 
    
    //MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Check what cell is needed
        var cell = UITableViewCell()
        
        // Init transaction 
        let trans = transactions[indexPath.row]
        
        if trans.type == "connection" {
            // Configure Cell
            cell = tableView.dequeueReusableCell(withIdentifier: "CellDb") as! ActivityCardTableCell
            configureViewsForConnection(cell: cell as! ActivityCardTableCell, index: indexPath.row)
        }else if trans.type == "intro"{
            
            // Configure Cell
            cell = tableView.dequeueReusableCell(withIdentifier: "CellD") as! ActivityCardTableCell
            configureViewsForIntro(cell: cell as! ActivityCardTableCell, index: indexPath.row)
        }
 
        // config cell
        

        
        return cell
    }
    
    // Custom Methods
    
    func getTranstactions() {
        
        // Clear array list for fresh start 
        self.transactions.removeAll()
        self.transactions = [Transaction]()
        
        // 
        // Hit endpoint for updates on users nearby
        let parameters = ["uuid": ContactManager.sharedManager.currentUser.userId]
        
        print(">>> SENT PARAMETERS >>>> \n\(parameters))")
        // Show progress 
        KVNProgress.show(withStatus: "Fetching your activity feed...")
        
        // Create User Objects
        Connection(configuration: nil).getTransactionsCall(parameters, completionBlock: { response, error in
            if error == nil {
                
                print("\n\nConnection - Radar Response: \n\n>>>>>> \(response)\n\n")
                
                // Init dictionary to capture response
                if let dictionary = response as? [String : Any] {
                    // // Parse dictionary for array of trans
                    let dictionaryArray = dictionary["transactions"] as! NSArray
                    
                    // Iterate over array, append trans to list
                    for item in dictionaryArray {
                        // Update counter
                        // Init user objects from array
                        let trans = Transaction(snapshot: item as! NSDictionary)
                        trans.printTransaction()
                        
                        
                        // Append users to radarContacts array
                        self.transactions.append(trans)
                    }
                    
                    // Update the table values
                    self.tableView.reloadData()
                    
                    // Show sucess
                    KVNProgress.showSuccess()
                }else{
                    print("Array empty !!!!")
                    // dismiss HUD
                    KVNProgress.dismiss()
                }
                
                
                
            } else {
                print(error)
                // Show user popup of error message
                print("\n\nConnection - Radar Error: \n\n>>>>>>>> \(error)\n\n")
                KVNProgress.showError(withStatus: "There was an issue getting activities. Please try again.")
            }
            // Regardless, hide hud 
            KVNProgress.dismiss()
        })
    
    }
    
    func fetchUsersForTransaction() {
        // Fetch the user data associated with users
        
        // Hit endpoint for updates on users nearby
        let parameters = ["data": selectedTransaction.recipientList]
        
        print(">>> SENT PARAMETERS >>>> \n\(parameters))")
        // Show progress
        KVNProgress.show(withStatus: "Fetching details on the activity...")
        
        // Create User Objects
        Connection(configuration: nil).getUserListCall(parameters, completionBlock: { response, error in
            
            if error == nil {
                
                //print("\n\nConnection - Radar Response: \n\n>>>>>> \(response)\n\n")
                
                // Init dictionary to capture response
                let userArray = response as? NSDictionary
                    // // Parse dictionary for array of trans
                print(userArray)
                    
                let userList = userArray?["data"] as! NSArray
                
                
                // Iterate over array, append trans to list
                for item in userList{
                        
                        // Init user objects from array
                    let user = User(snapshot: item as! NSDictionary)
                
                    // Append users to Selected array
                    self.selectedUsers.append(user)
                }
                
                // Func to parse phone numbers and show sms client
                self.parseAndSend()
                
                
                    
                // Show sucess
                KVNProgress.showSuccess()
                
                
            } else {
                print(error)
                // Show user popup of error message
                print("\n\nConnection - User Fetch Error: \n\n>>>>>>>> \(error)\n\n")
                KVNProgress.showError(withStatus: "There was an issue getting activities. Please try again.")
            }
            // Regardless, hide hud
            KVNProgress.dismiss()
        })

    }
    
    
    func parseAndSend() {
        // Get PhoneNumbers
        let userPhoneNumbers = self.retrievePhoneForUsers(contactsArray: self.selectedUsers)
        
        // Show the message client
        self.showSMSCard(recipientList: userPhoneNumbers)
    }
    
    
    func retrievePhoneForUsers(contactsArray: [User]) -> [String] {
        
        // Init email array 
        var phoneList = [String]()
        
        // Iterate through email list for contact emails
        for contact in contactsArray {
            // Check for phone number
            if contact.phoneNumbers[0]["profile_phone"] != nil{
                let phone = contact.phoneNumbers[0]["profile_phone"]
                
                // Add phone to list
                phoneList.append(phone!)
                
                // Print to test phone
                print("PHONE !!!! PHONE")
                print("\n\n\(String(describing: phone))")
                print(phoneList.count)
            }
            
        }
        // Append emails to a list of emails 
        
        // Return the list of emails
        return phoneList
        
    }
    
    func createTransaction(type: String) {
        // Set Type
        self.selectedTransaction.type = type
        
        // Show progress hud
        KVNProgress.show(withStatus: "Making the introduction...")
        
        // Save card to DB
        let parameters = ["data": self.selectedTransaction.toAnyObject()]
        print(parameters)
        
        // Send to server
        
        Connection(configuration: nil).createTransactionCall(parameters as! [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Card Created Response ---> \(response)")
                
                // Set card uuid with response from network
                let dictionary : Dictionary = response as! [String : Any]
                self.selectedTransaction.transactionId = (dictionary["uuid"] as? String)!
                
                // Insert to manager card array
                //ContactManager.sharedManager.currentUserCardsDictionaryArray.insert([card.toAnyObjectWithImage()], at: 0)
                
                // Hide HUD
                KVNProgress.dismiss()
                
            } else {
                print("Card Created Error Response ---> \(error)")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error with your introduction. Please try again.")
                
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
    }


    // View Configuration


    func configureViewsForIntro(cell: ActivityCardTableCell, index: Int){
        // Set transaction values for cell
        let trans = transactions[index]
        
        // Assign user objects
        
        //let user1 = selectedUsers[0]
        //let user2 = selectedUsers[1]
        
        let name1 = "Frank Smith"
        let name2 = "Fred Jackson"
        
        // See if image ref available
        let image = UIImage(named: "contact")
        cell.profileImage.image = image
        // Set description text
        cell.descriptionLabel.text = "You introduced \(trans.recipientList[0]) to \(trans.recipientList[1])"
        
        // Set location
        cell.locationLabel.text = trans.location
    }

    
    func configureViewsForConnection(cell: ActivityCardTableCell, index: Int){
        // Set transaction values for cell
        let trans = transactions[index]
        
        // Assign user objects
        //let user1 = selectedUsers[0]
        let name = trans.recipientCard.cardHolderName
        
        // See if image ref available
        let image = UIImage(named: "contact")
        cell.connectionOwnerProfileImage.image = image
        // Set description text
        cell.connectionDescriptionLabel.text = "You connected with \(trans.recipientCard.cardHolderName!)"
        
        print("recipientCard", trans.recipientCard )

        print("img", trans.recipientCard.imageURL)
        
        
        // Set location
        cell.connectionLocationLabel.text = trans.location
        
        
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
    
    func showSMSCard(recipientList: [String]) {
        
        print("SMS CARD SELECTED")
        // Send post notif
        
        let composeVC = MFMessageComposeViewController()
        if(MFMessageComposeViewController .canSendText()){
            
            composeVC.messageComposeDelegate = self
            
            // Configure message
            let str = "Hi,\n\nIt was a pleasure connecting with you. Looking to continuing our conversation.\n\nBest, \n\(currentUser.getName()) \n\n"
            
            // Set message string
            composeVC.body = str
            // Set recipient list
            composeVC.recipients = recipientList
            
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
        //name = formatter.string(from: contact) ?? "No Name"
        //recipientName = formatter.string(from: recipient) ?? "No Name"
        
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
        
        let str = "Hi \(name), Please meet \(recipientName). Thought you should connect. You are both doing some cool projects and thought you might be able to work together. \n\nYou two can take it from here! \n\nBest, \n\(currentUser.fullName) \n\n"
        
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
    
    
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // Message Composer Delegate
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        // Make checks here for
        controller.dismiss(animated: true) {
            print("Message composer dismissed")
        }
    }
    
    

    // Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        print(">Passed Contact Card ID")
        print(sender!)
        
        if segue.identifier == "showFollowupSegue"
        {
            
            let nextScene =  segue.destination as! FollowUpViewController
            // Pass the transaction object to nextVC
            nextScene.transaction = self.selectedTransaction
            nextScene.active_card_unify_uuid = "\(sender!)" as String?
            
            
        }
        
    }
    
    
}
