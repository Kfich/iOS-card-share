//
//  RadarContactSelectionViewController.swift
//  Unify
//

import UIKit
import Contacts
import MessageUI

class RadarContactSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    // Properties
    // --------------------------------------------
    
    var active_card_unify_uuid: String?
    
    var selectedContact = CNContact()
    var selectedUser = User()
    let formatter = CNContactFormatter()
    
    // This contact card is really a transaction object
    var card = ContactCard()
    var transaction = Transaction()
    var lat : Double = 0.0
    var long : Double = 0.0
    var address : String = ""
    var selectedUserIds = [String]()
    
    
    
    var currentUser = User()
    
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
    
    // Bools to check if array contents empty
    var biosPopulated = false
    var workInformationPopulated = false
    var organizationsPopulated = false
    var titlesPopulated = false
    var phoneNumbersPopulated = false
    var emailsPopulated = false
    var websitesPopulated = false
    var socialLinksPopulated = false
    var notesPopulated = false
    var tagsPopulated = false
    
    
    
    // IBOutlets
    // --------------------------------------------
    @IBOutlet var followupActionToolbar: UIToolbar!
    @IBOutlet var socialMediaToolbar: UIToolbar!
    @IBOutlet var cardWrapperView: UIView!
    @IBOutlet var cardShadowView: UIView!
    @IBOutlet var contactOutreachToolbar: UIToolbar!
    
    // Outreach toolbar
    @IBOutlet var outreachChatButton: UIBarButtonItem!
    @IBOutlet var outreachCallButton: UIBarButtonItem!
    @IBOutlet var outreachMailButton: UIBarButtonItem!
    
    
    // Tableview
    @IBOutlet var profileInfoTableView: UITableView!
    
    // Card info outlets
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var contactImageView: UIImageView!
    @IBOutlet var smsButton: UIBarButtonItem!
    @IBOutlet var emailButton: UIBarButtonItem!
    @IBOutlet var callButton: UIBarButtonItem!
    
    @IBOutlet var phoneImageView: UIImageView!
    @IBOutlet var emailImageView: UIImageView!
    
    
    
    
    
    // IBActions / Buttons Pressed
    // --------------------------------------------
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        
        //dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func smsSelected(_ sender: AnyObject) {
        /*
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let controller = storyboard.instantiateViewController(withIdentifier: "QuickShareVC")
         self.present(controller, animated: true, completion: nil)*/
        
    }
    
    @IBAction func emailSelected(_ sender: AnyObject) {
        /*
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let controller = storyboard.instantiateViewController(withIdentifier: "QuickShareVC")
         self.present(controller, animated: true, completion: nil)*/
        
    }
    @IBAction func callSelected(_ sender: AnyObject) {
        
        // configure call
        
    }
    
    
    
    
    // Page Setup
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Do any additional setup after loading the view.
        // Test is segue passed properly
        
        print("Selected Contact -> \(selectedContact)")
        
        // Set format style
        formatter.style = .fullName
        
        // Parse card for profile info
        
        // Parse bio info
        if selectedUser.userProfile.bios.count > 0{
            // Iterate throught array and append available content
            for bio in currentUser.userProfile.bios{
                bios.append(bio["bio"]!)
            }
        }
        // Parse work info
        if selectedUser.userProfile.workInformationList.count > 0{
            for info in currentUser.userProfile.workInformationList{
                workInformation.append(info["work"]!)
            }
        }
        // Parse work info
        if selectedUser.userProfile.titles.count > 0{
            for info in currentUser.userProfile.titles{
                titles.append((info["title"])!)
            }
        }
        
        // Parse phone numbers
        if selectedUser.userProfile.phoneNumbers.count > 0{
            for number in currentUser.userProfile.phoneNumbers{
                phoneNumbers.append(number["phone"]!)
            }
        }
        // Parse emails
        if selectedUser.userProfile.emails.count > 0{
            for email in currentUser.userProfile.emails{
                emails.append(email["email"]!)
            }
        }
        // Parse websites
        if selectedUser.userProfile.websites.count > 0{
            for site in currentUser.userProfile.websites{
                websites.append(site["website"]!)
            }
        }
        // Parse organizations
        if selectedUser.userProfile.organizations.count > 0{
            for org in currentUser.userProfile.organizations{
                organizations.append(org["organization"]!)
            }
        }
        // Parse Tags
        if selectedUser.userProfile.tags.count > 0{
            for hashtag in currentUser.userProfile.tags{
                tags.append(hashtag["tag"]!)
            }
        }
        // Parse notes
        if selectedUser.userProfile.notes.count > 0{
            for note in currentUser.userProfile.notes{
                notes.append(note["note"]!)
            }
        }
        // Parse socials links
        if selectedUser.userProfile.socialLinks.count > 0{
            for link in currentUser.userProfile.socialLinks{
                socialLinks.append(link["link"]!)
            }
        }
        
        
        // Config Views
        configureViews()
        
        // Populate the cardviewer
        populateCards()
        
        // Configure background image graphics
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "backgroundGradient")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
        
        
        // Config navigation bar
        self.navigationController?.navigationBar.barTintColor = UIColor(red: Int(0.0/255.0), green: Int(97.0/255.0), blue: Int(140.0/255.0))
        
        // Set color to nav bar
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor(red: 28/255.0, green: 52/255.0, blue: 110/255.0, alpha: 1.0)]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        
        
        // reload table data
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        //if biosPopulated && titlesPopulated && workInformationPopulated && emailsPopulated && titlesPopulated && organizationsPopulated && websitesPopulated
        
        /*var count = 0
         // Iterate through arrays and see if populated
         switch count {
         case 0:
         
         return bios.count
         case 1:
         return workInformation.count
         case 2:
         return titles.count
         case 3:
         return emails.count
         case 4:
         return phoneNumbers.count
         case 5:
         return socialLinks.count
         case 6:
         return websites.count
         case 7:
         return organizations.count
         default:
         return 0
         }
         */
        return 8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return bios.count
        case 1:
            return workInformation.count
        case 2:
            return titles.count
        case 3:
            return emails.count
        case 4:
            return phoneNumbers.count
        case 5:
            return socialLinks.count
        case 6:
            return websites.count
        case 7:
            return organizations.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Bios"
        case 1:
            return "Work Information"
        case 2:
            return "Titles"
        case 3:
            return "Emails"
        case 4:
            return "Phone Numbers"
        case 5:
            return "Social Media Links"
        case 6:
            return "Websites"
        case 7:
            return "Organizations"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileBioInfoCell", for: indexPath) as! CardOptionsViewCell
        
        
        switch indexPath.section {
        case 0:
            cell.titleLabel.text = "Bio \(indexPath.row)"
            cell.descriptionLabel.text = bios[indexPath.row]
            return cell
        case 1:
            cell.titleLabel.text = "Work \(indexPath.row)"
            cell.descriptionLabel.text = workInformation[indexPath.row]
            return cell
        case 2:
            cell.titleLabel.text = "Title \(indexPath.row)"
            cell.descriptionLabel.text = titles[indexPath.row]
            return cell
        case 3:
            cell.titleLabel.text = "Email \(indexPath.row)"
            cell.descriptionLabel.text = emails[indexPath.row]
            return cell
        case 4:
            cell.titleLabel.text = "Phone \(indexPath.row)"
            cell.descriptionLabel.text = phoneNumbers[indexPath.row]
            return cell
        case 5:
            cell.titleLabel.text = "Social Media Link \(indexPath.row)"
            cell.descriptionLabel.text = socialLinks[indexPath.row]
            return cell
        case 6:
            cell.titleLabel.text = "Website \(indexPath.row)"
            cell.descriptionLabel.text = websites[indexPath.row]
            return cell
        case 7:
            cell.titleLabel.text = "Organization \(indexPath.row)"
            cell.descriptionLabel.text = organizations[indexPath.row]
            return cell
        default:
            // Set
            cell.titleLabel.text = "No Data"
            return cell
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

        
        // Make checks here for
        controller.dismiss(animated: true) {
            print("Message composer dismissed")
        }
    }
    
    
    
    
    // Custom Methods
    // -------------------------------------------
    
    func createTransaction(type: String) {
        // Set type & Transaction data
        transaction.type = type
        transaction.setTransactionDate()
        transaction.senderName = ContactManager.sharedManager.currentUser.getName()
        transaction.senderId = ContactManager.sharedManager.currentUser.userId
        transaction.type = "connection"
        transaction.scope = "transaction"
        transaction.senderCardId = ContactManager.sharedManager.selectedCard.cardId!
        
        transaction.latitude = self.lat
        transaction.longitude = self.long
        transaction.recipientList = selectedUserIds
        transaction.location = self.address
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
                KVNProgress.showSuccess(withStatus: "Card sent successfully")
                
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
    
    // Message Composer Functions
    
    func showEmailCard(_ sender: Any) {
        
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
    
    func showSMSCard(_ sender: Any) {
        // Set Selected Card
        
        //selectedCardIndex = cardCollectionView.inde
        
        
        print("SMS CARD SELECTED")
        // Send post notif
        
        let composeVC = MFMessageComposeViewController()
        if(MFMessageComposeViewController .canSendText()){
            
            composeVC.messageComposeDelegate = self
            
            // 6468251231
            // Configure the fields of the interface.
            composeVC.recipients = ["6463597308"]
            
            // Check for nil vals
            
            var name = ""
            var phone = ""
            var email = ""
            var title = ""
            
            // Populate label fields
            if selectedUser.fullName != ""{
                name = selectedUser.fullName
            }
            if selectedUser.userProfile.phoneNumbers.count > 0{
                phone = selectedUser.userProfile.phoneNumbers[0].values.first!
            }
            if selectedUser.userProfile.emails.count > 0{
                email = selectedUser.userProfile.emails[0]["email"]! 
            }
            
            if selectedUser.userProfile.titles.count > 0{
                title = selectedUser.userProfile.titles[0]["title"]!
            }
            
            // Test profile
            selectedUser.userProfile.printProfle()
            
            // Set card link from cardID
            let cardLink = "https://project-unify-node-server.herokuapp.com/card/render/\(card.cardId!)"
            
            composeVC.body = "\n\n\n\(cardLink)"
            
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
        var phone = ""
        var email = ""
        var title = ""
        
        // Populate label fields
        if selectedUser.fullName != ""{
            name = selectedUser.fullName
        }
        if selectedUser.userProfile.phoneNumbers.count > 0{
            phone = selectedUser.userProfile.phoneNumbers[0].values.first!
        }
        if selectedUser.userProfile.emails.count > 0{
            email = selectedUser.userProfile.emails[0]["email"]!
        }
        
        if selectedUser.userProfile.titles.count > 0{
            title = selectedUser.userProfile.titles[0]["title"]!
        }
        
        // Test profile
        selectedUser.userProfile.printProfle()
        
        // Set card link from cardID
        let cardLink = "https://project-unify-node-server.herokuapp.com/card/render/\(card.cardId!)"
        
        // Create Message
        mailComposerVC.setToRecipients(["kfich7@gmail.com"])
        mailComposerVC.setSubject("Greetings - Let's Connect")
        mailComposerVC.setMessageBody("\n\n\n\(cardLink)", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    
    
    func checkForArrayLenth(array: Array<Any>) -> Bool {
        var isEmpty = Bool()
        if array.count != 0{
            isEmpty = false
            return isEmpty
        }else{
            isEmpty = true
            return isEmpty
        }
    }
    
    
    func populateCards(){
        
        // Set name label text
        nameLabel.text = selectedUser.fullName
        
        // Populate image view
        if selectedUser.userProfile.images.count > 0{
            contactImageView.image = UIImage(data: selectedUser.userProfile.images[0]["image_data"] as! Data)
        }
        // Populate label fields
        
        if selectedUser.userProfile.phoneNumbers.count > 0{
            phoneLabel.text = selectedUser.userProfile.phoneNumbers[0].values.first!
        }
        if selectedUser.userProfile.emails.count > 0{
            emailLabel.text = selectedUser.userProfile.emails[0]["email"]!
        }
        if let title = selectedUser.userProfile.title{
            titleLabel.text = title
        }
        
    }
    
    func configureViews(){
        // Round out the vards here
        // Configure cards
        self.cardWrapperView.layer.cornerRadius = 12.0
        self.cardWrapperView.clipsToBounds = true
        self.cardWrapperView.layer.borderWidth = 2.0
        self.cardWrapperView.layer.borderColor = UIColor.white.cgColor
        
        self.profileInfoTableView.layer.cornerRadius = 12.0
        self.profileInfoTableView.clipsToBounds = true
        self.profileInfoTableView.layer.borderWidth = 2.0
        self.profileInfoTableView.layer.borderColor = UIColor.white.cgColor
        
        // Set shadow on the container view
        
        addDropShadow()
        
        
        // Toolbar button config
        
        outreachChatButton.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir", size: 14)!], for: UIControlState.normal)
        
        outreachMailButton.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir", size: 14)!], for: UIControlState.normal)
        
        outreachCallButton.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir", size: 14)!], for: UIControlState.normal)
        
        
        
        // Config buttons
        // ** Email and call inverted
        smsButton.image = UIImage(named: "btn-chat-blue")
        callButton.image = UIImage(named: "btn-message-blue")
        emailButton.image = UIImage(named: "btn-call-blue")
    }
    
    func addDropShadow(scale: Bool = true) {
        
        cardShadowView.layer.masksToBounds = false
        cardShadowView.layer.shadowColor = UIColor.black.cgColor
        cardShadowView.layer.shadowOpacity = 0.5
        cardShadowView.layer.shadowOffset = CGSize(width: -1, height: 1)
        cardShadowView.layer.shadowRadius = 1
        
        cardShadowView.layer.shadowPath = UIBezierPath(rect: cardShadowView.bounds).cgPath
        cardShadowView.layer.shouldRasterize = true
        cardShadowView.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
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
