//
//  CardRecipientListViewController.swift
//  Unify
//


import UIKit
import Contacts
import MessageUI

class CardRecipientListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate{
    
    
    // Properties
    // ---------------------------------
    var cellReuseIdentifier = "ContactListCell"
    var searchController = UISearchController()
    
    var contactStore = CNContactStore()
    
    var contactList = [CNContact]()
    let formatter = CNContactFormatter()
    
    var selectedContact = CNContact()
    var currentUserContact = CNContact()
    var currentUser = User()
    
    // Progress hud
    var progressHUD = KVNProgress()
    
    // Selected Card
    var selectedUserCard = ContactCard()
    var transaction = Transaction()
    
    
    // IBOutlets
    // ---------------------------------
    @IBOutlet var contactListTableView: UITableView!
    
    
    // Page Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set Current user object
        self.currentUser = ContactManager.sharedManager.currentUser
        
        // Set Contact formatter style
        formatter.style = .fullName
        
        // Add loading indicator
        
        
        // Parse for contacts in contact list
        if ContactManager.sharedManager.phoneContactList.isEmpty{
            // Make call to get contacts
            ContactManager.sharedManager.getContacts()
            // Show progress
            KVNProgress.show(withStatus: "Syncing Contacts...")
        }else{
            // Refresh table
            print("Contacts should be set")
        }
        
        // Observers for notifications
        addObservers()
        
        // Do any additional setup after loading the view.
        
        // Tableview config
        // Index tracking strip
        contactListTableView.sectionIndexBackgroundColor = UIColor.white
        contactListTableView.sectionIndexColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        
        
        // Search controller
        searchController = UISearchController(searchResultsController: nil)
        searchController.view.backgroundColor = UIColor.white
        searchController.searchBar.backgroundColor = UIColor.white
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = NSLocalizedString("Search", comment: "")
        
        // Add the search bar
        contactListTableView.tableHeaderView = self.searchController.searchBar
        definesPresentationContext = true
        searchController.searchBar.sizeToFit()
        
        // Style search bar
        //searchController.searchBar.barStyle = UIBarStyle.
        //searchController.searchBar.changeSearchBarColor(color: UIColor.white)
        //searchController.searchBar.backgroundColor = UIColor.white
        
        
        
        // Reload Data
        contactListTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions / Buttons pressed
    // ---------------------------------------
    
    @IBAction func cancelButtonSelected(_ sender: Any) {
        // Dismiss VC
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    // Search Bar Delegate
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
    // TableView Delegates and DataSource
    
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
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Deselect row 
        contactListTableView.deselectRow(at: indexPath, animated: true)
        
        print("You selected Conact --> \(ContactManager.sharedManager.phoneContactList[indexPath.row])")
        // Assign selected contact
        selectedContact = ContactManager.sharedManager.phoneContactList[indexPath.row]
        // Parse contact for info & Call mail or sms accordingly
        self.parseContactsForInfo()
        // Set both navigation switches to false
        ContactManager.sharedManager.userEmailCard = false
        ContactManager.sharedManager.userSMSCard = false
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Config the alphabet
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 19))
        containerView.backgroundColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        
        // Add label to the view
        let lbl = UILabel(frame: CGRect(8, 3, 15, 15))
        lbl.text = ""
        lbl.textAlignment = .left
        
        lbl.textColor = UIColor.white
        lbl.font = UIFont(name: "SanFranciscoRegular", size: CGFloat(16))
        containerView.addSubview(lbl)
        
        return containerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U", "V", "W", "X", "Y", "Z"]
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "G"
    }
    
    
    // Custom Methods
    func addObservers() {
        // Call to refresh table
        NotificationCenter.default.addObserver(self, selector: #selector(CardRecipientListViewController.refreshTableData), name: NSNotification.Name(rawValue: "RefreshContactList"), object: nil)
        
    }
    
    func refreshTableData() {
        // Hide HUD
        KVNProgress.showSuccess()
        
        // Reload contact list
        DispatchQueue.main.async {
            // Update UI
            self.contactListTableView.reloadData()
        }
    }
    // Create when user done sending email or sms
    
    func createTransaction(type: String) {
        // Set Type
        self.transaction.type = type
        
        // Show progress hud
        KVNProgress.show(withStatus: "Making the introduction...")
        
        // Save card to DB
        let parameters = ["data": self.transaction.toAnyObject()]
        print(parameters)
        
        // Send to server
        
        Connection(configuration: nil).createTransactionCall(parameters as! [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Card Created Response ---> \(response)")
                
                // Set card uuid with response from network
                /*let dictionary : Dictionary = response as! [String : Any]
                self.transaction.transactionId = (dictionary["uuid"] as? String)!*/
                
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
    
    
    func parseContactsForInfo(){
        
        // Check where user arrived from
        if ContactManager.sharedManager.userSMSCard{
            // If phone numbers exist
            if selectedContact.phoneNumbers.count > 0{
                // Execute sms call
                self.showSMSCard()
            }else{
                
                // Show alert that info unavailable
                let alertView = UIAlertController(title: "", message: "You do not have a phone number for this user.. Please chose another way to connect.", preferredStyle: .alert)
                 let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                 // Print action
                 print("Action selected")
                 })
                 alertView.addAction(action)
                 self.present(alertView, animated: true, completion: nil)
            }
            
        }
        
        
        // Check where user arrived from
        if ContactManager.sharedManager.userEmailCard{
            // If emails exist
            if selectedContact.emailAddresses.count > 0 {
                // Execute email
                self.showEmailCard()
            }else{
                // Show alert that info unavailable
                let alertView = UIAlertController(title: "", message: "You do not have an email address for this user.. Please chose another way to connect.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                    // Print action
                    print("Action selected")
                })
                alertView.addAction(action)
                self.present(alertView, animated: true, completion: nil)
            }
            
        }
        
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
            
            // Set Delegate
            composeVC.messageComposeDelegate = self
            
            // Init name variable
            var name = ""
            
            // CNContact Objects
            let contact = self.selectedContact
            
            // Set name
            name = formatter.string(from: contact) ?? "No Name"
            
            // Check if they have phone number
            if contact.phoneNumbers.count > 0{
                
                let contactPhone = (contact.phoneNumbers[0].value).value(forKey: "digits") as? String
                // Set contact phone number
                composeVC.recipients = [contactPhone!]
            }
            
            // Set card link from cardID
            let cardLink = "https://project-unify-node-server.herokuapp.com/card/render/\(selectedUserCard.cardId!)"
            
            // Test String
            let str = "\n\n\n\(cardLink)"

            
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
        
        // Create temp vals
        var name = ""
        var emailContact = ""
        
        // CNContact Objects
        let contact = self.selectedContact
        
        // Set name
        name = formatter.string(from: contact) ?? "No Name"
        // Check if they have email
        if contact.emailAddresses.count > 0{
            // Set email string
            let contactEmail = contact.emailAddresses[0].value as String
            
            // Set variable
            emailContact = contactEmail
        }
        
        // Create Message
        
        //let str = "Hi, I'd like to connect with you. Here's my information \n\n\(String(describing: card.cardHolderName))\n\(String(describing: card.cardProfile.emails[0]["email"]))\n\(String(describing: card.cardProfile.title))\n\nBest, \n\(currentUser.getName()) \n\n"
        
        // Set card link from cardID
        let cardLink = "https://project-unify-node-server.herokuapp.com/card/render/\(selectedUserCard.cardId!)"
        
        // Test String
        let str = "\n\n\n\(cardLink)"
        
        // Create Message
        mailComposerVC.setToRecipients([emailContact])
        mailComposerVC.setSubject("Unify Connection - I'd like to connect with you")
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
            print("User cancelled")
            
        }else if result == .sent{
            // User sent
            self.createTransaction(type: "connection")
            
        }else{
            // There was an error
            KVNProgress.showError(withStatus: "There was an error sending your message. Please try again.")
            
        }
        
        // Make checks here for
        controller.dismiss(animated: true) {
            print("Message composer dismissed")
        }
    }

    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showContactProfile"{
            // Find destination
            let destination = segue.destination as! ContactProfileViewController
            // Assign selected contact object
            destination.selectedContact = self.selectedContact
            
            // Test
            print("Contact Passed in Seggy")
        }
        
        
    }
    
    
}
