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


class ActivtiyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    // Properties
    // ----------------------------------------
    var currentUser = User()
    var transactions = [Transaction]()
    
    // Individual lists for segments
    var connections = [Transaction]()
    var introductions = [Transaction]()
    
    var selectedUsers = [User]()
    var selectedIndex = Int()
    var selectedTransaction = Transaction()
    var segmentedControl = UISegmentedControl()
    
    @IBOutlet var navigationBar: UINavigationItem!
    // IBOutlets
    // ----------------------------------------
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    // Page Config
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        // Add observers 
        self.addObservers()
        
        // Set currentUser object 
        currentUser = ContactManager.sharedManager.currentUser
        
        // Fetch the users transactions 
        getTranstactions()
        
        // Configure tableview
        tableView.dataSource = self
        tableView.delegate = self
        
        // Set delegate for empty state 
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        // View to remove separators
        tableView.tableFooterView = UIView()
        
        
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
        // Init index
        segmentedControl.selectedSegmentIndex = 0
        
        // Add target action method
        segmentedControl.addTarget(self, action: #selector(ActivtiyViewController.reloadTableWithList(sender:)), for: .valueChanged)
        
        
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
        //self.selectedTransaction = self.transactions[indexPath.row]
        
        // Get users in transaction
        //self.fetchUsersForTransaction()
        
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
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return self.transactions.count
        case 1:
            return self.connections.count
        case 2:
            return self.introductions.count
        default:
            return 0
        }

        //return 5 //self.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Check what cell is needed
        //var cell = UITableViewCell()
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "CellD") as! ActivityCardTableCell
        
        // config cell
            // Set to all transactions list 
            
            // Init transaction
            let trans = transactions[indexPath.row]
             
             if trans.type == "connection" {
                // Configure Cell
                cell = tableView.dequeueReusableCell(withIdentifier: "CellDb") as! ActivityCardTableCell
                // Execute func
                configureViewsForConnection(cell: cell , index: indexPath.row)
                
                // Add tap gesture to cell labels
                self.addGestureToLabel(label: cell.connectionApproveButton, index: indexPath.row, intent: "approve")
                self.addGestureToLabel(label: cell.connectionRejectButton, index: indexPath.row, intent: "reject")
             
             }else if trans.type == "intro"{
             
                // Configure Cell
                cell = tableView.dequeueReusableCell(withIdentifier: "CellD") as! ActivityCardTableCell
                // Execute func
                configureViewsForIntro(cell: cell , index: indexPath.row)
                
                // Add tap gesture to cell labels
                self.addGestureToLabel(label: cell.approveButton, index: indexPath.row, intent: "approve")
                self.addGestureToLabel(label: cell.rejectButton, index: indexPath.row, intent: "reject")
             }

        if segmentedControl.selectedSegmentIndex == 0 {
            // norhing
        }/*else if segmentedControl.selectedSegmentIndex == 1 {
            // Config for connections
            //let trans = connections[indexPath.row]
            // Configure Cell
            cell = tableView.dequeueReusableCell(withIdentifier: "CellDb") as! ActivityCardTableCell
            // Execute func
            configureViewsForConnection(cell: cell as! ActivityCardTableCell, index: indexPath.row)

        }else if segmentedControl.selectedSegmentIndex == 2{
            // Config for intro 
            //let trans = introductions[indexPath.row]
            // Configure Cell
            cell = tableView.dequeueReusableCell(withIdentifier: "CellD") as! ActivityCardTableCell
            // Execute func
            configureViewsForIntro(cell: cell as! ActivityCardTableCell, index: indexPath.row)
        }*/
        
        

        
        return cell
    }
    
    // Custom Methods
    
    // Event handler for segment control
    func reloadTableWithList(sender: UISegmentedControl) {
        
        print("Change color handler is called.")
        print("Changing Color to ")
        
        switch sender.selectedSegmentIndex {
        case 1:
            self.view.backgroundColor = UIColor.green
            print("Green")
            self.tableView.reloadData()
        case 2:
            self.view.backgroundColor = UIColor.blue
            print("Blue")
            self.tableView.reloadData()
        default:
            self.view.backgroundColor = UIColor.purple
            print("Purple")
            self.tableView.reloadData()
        }
    }

    
    func addObservers() {
        // Call to show options
        NotificationCenter.default.addObserver(self, selector: #selector(ActivtiyViewController.setSelectedTransaction(sender:)), name: NSNotification.Name(rawValue: "Approve Connection"), object: nil)
        
        // Call Contacts sync
        NotificationCenter.default.addObserver(self, selector: #selector(ActivtiyViewController.setSelectedTransaction(sender:)), name: NSNotification.Name(rawValue: "Reject Connection"), object: nil)
        
        
    }
    
    func addGestureToLabel(label: UILabel, index: Int, intent: String) {
        // Init tap gesture
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(setSelectedTransaction(sender:)))
        label.isUserInteractionEnabled = true
        // Add gesture to image
        label.addGestureRecognizer(tapGestureRecognizer)
        // Set image index
        label.tag = index
        
        // Set description to view 
        //label.
    }
    
    func setSelectedTransaction(sender: UITapGestureRecognizer){
        
        let label = sender.view as! UILabel
        let intent = label.text!
        
        print("Sender Index: \((sender.view?.tag)!)")
        print("Intent : \(intent)")
        
        // Set index 
        self.selectedIndex = (sender.view?.tag)!
        // Set selected transaction using tag
        self.selectedTransaction = self.transactions[(sender.view?.tag)!]
        
        // Post notification
        if intent == "Approve" {
            // Approve transaction 
            self.approveTransaction()
            
        }else{
            // Reject transaction 
            self.rejectTransaction()
        }
    }
    
    
    func approveTransaction() {
        // Test
        print("Approving transaction")
        
        // Export transaction
        let parameters = ["uuid" : self.selectedTransaction.transactionId]
        
        // Show HUD 
        KVNProgress.show(withStatus: "Approving the connection...")
        
        // Send to sever
        
        Connection(configuration: nil).approveTransactionCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Approval Response ---> \(String(describing: response))")
                
                // Set response from network
                let dictionary : Dictionary = response as! [String : Any]
                // Test callback
                print("THE DICTIONARY OF APPROVAL", dictionary)
                
                // Change status for trans
                self.transactions[self.selectedIndex].approved = true
                
                // Reload table
                self.tableView.reloadData()
                // Hide HUD
                KVNProgress.showSuccess(withStatus: "Approved.")
                
            } else {
                print("Approval Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error with your introduction. Please try again.")
                
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
    }
    
    func rejectTransaction() {
        
        print("Rejecting transaction")
        
        // Set selected transaction 
        //self.selectedTransaction = self.transactions[]
        
        // Export transaction
        let parameters = ["uuid" : self.selectedTransaction.transactionId]
        
        // Show HUD
        KVNProgress.show(withStatus: "Rejecting the connection...")
        
        // Send to sever
        
        Connection(configuration: nil).rejectTransactionCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Rejection Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                let dictionary : Dictionary = response as! [String : Any]
                // Test callback 
                print("THE DICTIONARY OF DENIAL" , dictionary)
                
                // Change status for trans
                self.transactions[self.selectedIndex].approved = false
                
                // Reload table 
                self.tableView.reloadData()
                
                // Hide HUD
                KVNProgress.showSuccess(withStatus: "Rejected.")
                
            } else {
                print("Rejection Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error with your introduction. Please try again.")
                
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
    }
    
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
                    
                    // Parse lists for segment control 
                    self.parseTransactionList(transactionList: self.transactions)
                    
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
    
    // Retrieve lists from all transactions
    func parseTransactionList(transactionList : [Transaction]) {
        // Iterate over list
        for transaction in transactionList {
            // Check for tran type
            switch transaction.type {
            case "connection":
                // Print to test
                print(transaction.type)
                // Append to connection list
                self.connections.append(transaction)
                // Exit
                break
                
            case "introduction":
                // Print to test
                print(transaction.type)
                // Append to connection list
                self.introductions.append(transaction)
                // Exit
                break
                
            default:
                print("No transaction type")
            }
        }
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
                    let user = User(snapshotWithLiteProfile: item as! NSDictionary)
                
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
            if contact.userProfile.phoneNumbers[0]["phone"] != nil{
                let phone = contact.userProfile.phoneNumbers[0]["phone"]
                
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
        // Set type & Transaction data
        selectedTransaction.type = type
        selectedTransaction.setTransactionDate()
        selectedTransaction.senderId = ContactManager.sharedManager.currentUser.userId
        selectedTransaction.type = "connection"
        selectedTransaction.scope = "transaction"
        selectedTransaction.senderCardId = ContactManager.sharedManager.selectedCard.cardId!
        
        // Show progress hud
        KVNProgress.show(withStatus: "Following up..")
        
        // Save card to DB
        let parameters = ["data": self.selectedTransaction.toAnyObject()]
        print(parameters)
        
        // Send to server
        
        Connection(configuration: nil).createTransactionCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Card Created Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                /*let dictionary : Dictionary = response as! [String : Any]
                self.selectedTransaction.transactionId = (dictionary["uuid"] as? String)!*/
                
                // Insert to manager card array
                //ContactManager.sharedManager.currentUserCardsDictionaryArray.insert([card.toAnyObjectWithImage()], at: 0)
                
                // Hide HUD
                KVNProgress.dismiss()
                
            } else {
                print("Card Created Error Response ---> \(String(describing: error))")
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
        cell.descriptionLabel.text = "You introduced \(trans.recipientList?[0]) to \(trans.recipientList?[1])"
        
        // Set location
        cell.locationLabel.text = trans.location
        
        
        // Hide buttons if already approved
        if trans.approved {
            // Hide and replace
            cell.rejectButton.isHidden = true
            cell.rejectButton.isEnabled = false
            
            // Change the label
            //cell.approveButton.setTitle("Follow up", for: .normal)
            
        }else{
            // Show
            cell.rejectButton.isHidden = false
            cell.rejectButton.isEnabled = true
        }
        
        // Add tag to view
        cell.cardWrapperView.tag = index
        cell.approveButton.tag = index
        // Make rejection tag index + 1 to identify the users action intent
        cell.rejectButton.tag = index
        
    }
    
    
    func configureViewsForConnection(cell: ActivityCardTableCell, index: Int){
        // Set transaction values for cell
        let trans = transactions[index]
        
        // Assign user objects
        //let user1 = selectedUsers[0]
        let name = trans.recipientCard?.cardHolderName
        
        // See if image ref available
        let image = UIImage(named: "contact")
        cell.connectionOwnerProfileImage.image = image
        // Set description text
        cell.connectionDescriptionLabel.text = "You connected with \(trans.recipientCard?.cardHolderName!)"
        
        print("recipientCard", trans.recipientCard )
        
        //print("img", trans.recipientCard.imageURL)
        
        
        // Set location
        cell.connectionLocationLabel.text = trans.location
        
        
        // Hide buttons if already approved
        if trans.approved {
            // Hide and replace
            cell.connectionRejectButton.isHidden = true
            cell.connectionRejectButton.isEnabled = false
            
            // Change the label
            //cell.connectionApproveButton.setTitle("Follow up", for: .normal)
            
        }else{
            // Show
            //cell.connectionRejectButton.isHidden = false
            //cell.connectionRejectButton.isEnabled = true
        }
        
        // Add tag to view
        //cell.connectionCardWrapperView.tag = index
        //cell.connectionApproveButton.tag = index
        // Make rejection tag index + 1 to identify the users action intent
        //cell.connectionRejectButton.tag = index
        
        
    }

    
    
    // Empty State Delegate Methods 
    
    // Settings
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        
        /*if self.transactions.count > 0 {
            // Hide empty
            return false
        }else{
            // Show empty
            return true
        }*/
        return true
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        // Lock scroll
        return false
    }
    
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        // Configure string 
        
        let emptyString = "No Transactions Found"
        let attrString = NSAttributedString(string: emptyString)
        
        return attrString
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        // Config Message for user
        
        let emptyString = ""
        let attrString = NSAttributedString(string: emptyString)
        
        return attrString

    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControlState) -> NSAttributedString? {
        // Config button for data set
        
        let emptyString = "Tap to Start Unifying"
        
        let blue = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        let attributes = [ NSForegroundColorAttributeName: blue ]
        
        let attrString = NSAttributedString(string: emptyString, attributes: attributes)
        
        return attrString
    }

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        // Set to height of header bar
        return -64
    }

    func emptyDataSet(_ scrollView: UIScrollView, didTap view: UIView) {
        // Configure action for tap
        print("The View Was tapped")
    }
    
    func emptyDataSet(_ scrollView: UIScrollView, didTap button: UIButton) {
        // Configure action for button tap 
        print("The Button Was tapped")
        
        // Post notification for radar to turn on
        self.postNotification()
        
        // Sync up with main queue
        DispatchQueue.main.async {
            // Set selected tab
            self.tabBarController?.selectedIndex = 2
        }
        
    }
    
    // Notifications
    
    func postNotification() {
        
        // Notification for radar screen
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TurnOnRadar"), object: self)
        
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
        
        // Dismiss controller
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
