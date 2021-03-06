//
//  CardSelectionViewController.swift
//  Unify


import UIKit
import MessageUI

class CardSelectionViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Properties
    // --------------------------------------------
    var active_card_unify_uuid: String?
    
    var selectedCard = ContactCard()
    var currentUser = User()
    var transaction = Transaction()
    
    // Parsed profile arrays
    var bios = [String]()
    var workInformation = [String]()
    var organizations = [String]()
    var titles = [String]()
    var phoneNumbers = [String]()
    var phoneNumberLabels = [String]()
    var emails = [String]()
    var emailLabels = [String]()
    var websites = [String]()
    var socialLinks = [String]()
    var notes = [String]()
    var tags = [String]()
    var addresses = [String]()
    var addressLabels = [String]()
    var corpBadges: [CardProfile.Bagde] = []
    
    // Store image icons
    var socialLinkBadges = [[String : Any]]()
    var links = [String]()
    var socialBadges = [UIImage]()
    
    var selectedBadgeIndex = Int()
    
    var sections = [String]()
    var tableData = [String: [String]]()
    

    
    // IBOutlets
    // --------------------------------------------
    @IBOutlet var followupActionToolbar: UIToolbar!
    @IBOutlet var socialMediaToolbar: UIToolbar!
    @IBOutlet var cardWrapperView: UIView!
    @IBOutlet var cardWrapperViewSingle: UIView!
    @IBOutlet var cardWrapperViewEmpty: UIView!
    @IBOutlet var cardShadowView: UIView!
    @IBOutlet var contactOutreachToolbar: UIToolbar!
    
    
    // Tableview
    @IBOutlet var profileInfoTableView: UITableView!
    
    // Card info outlets
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var contactImageView: UIImageView!
    @IBOutlet var cardNameLabel: UILabel!
    
    // Collection views
    @IBOutlet var singleBadgeCollectionView: UICollectionView!
    @IBOutlet var badgeCollectionView: UICollectionView!
    @IBOutlet var socialCollectionView: UICollectionView!
    
    @IBOutlet var editCardButton: UIButton!

    
    // Card info outlets for single
    @IBOutlet var nameLabelSingleWrapper: UILabel!
    @IBOutlet var titleLabelSingleWrapper: UILabel!
    @IBOutlet var emailLabelSingleWrapper: UILabel!
    @IBOutlet var phoneLabelSingleWrapper: UILabel!
    @IBOutlet var contactImageViewSingleWrapper: UIImageView!
    @IBOutlet var cardNameLabelSingleWrapper: UILabel!
    
    // Labels for empty wrapper
    @IBOutlet var nameLabelEmptyWrapper: UILabel!
    @IBOutlet var titleLabelEmptyWrapper: UILabel!
    @IBOutlet var emailLabelEmptyWrapper: UILabel!
    @IBOutlet var phoneLabelEmptyWrapper: UILabel!
    @IBOutlet var contactImageViewEmptyWrapper: UIImageView!
    @IBOutlet var cardNameLabelEmptyWrapper: UILabel!
    
    
    // IBActions / Buttons Pressed
    // --------------------------------------------
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        
        //dismiss(animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func smsSelected(_ sender: AnyObject) {
        
        let composeVC = MFMessageComposeViewController()
        
        if(MFMessageComposeViewController .canSendText()){
            
            composeVC.messageComposeDelegate = self
            
            // 6468251231
            
            // Configure the fields of the interface.
            composeVC.recipients = ["6463597308"]
            composeVC.body = "Hi, I'd like to connect with you. Here's my information \n\n\(String(describing: selectedCard.cardHolderName))\n\(String(describing: selectedCard.cardProfile.emails[0]["email"]))\n\(String(describing: selectedCard.cardProfile.title)))"
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func emailSelected(_ sender: AnyObject) {
        // Create instance of controller
        let mailComposeViewController = configuredMailComposeViewController()
        
        // Check if deviceCanSendMail
        if MFMailComposeViewController.canSendMail() {
            
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }
    @IBAction func callSelected(_ sender: AnyObject) {
        
        // configure call
        
    }
    
    @IBAction func editCardSelected(_ sender: Any) {
        
        // Show add card vc
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EditCardVC")
        self.present(controller, animated: true, completion: nil)
        
        // Pass selected card to view
        ContactManager.sharedManager.selectedCard = selectedCard
        
        // Set switch to true
        //ContactManager.sharedManager.userSelectedEditCard = true
        
        
    }
    
    
    // Page Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Set shadow
        //self.shadowView.shadowRadius = 3.0
        //self.shadowView.shadowMask = YIInnerShadowMaskTop
        
        // Set shadow
        //self.shadowView.shadowRadius = 2
        //self.shadowView.shadowMask = YIInnerShadowMaskTop
        
        // Register
        //self.socialCollectionView.register(MediaThumbnailCell.self, forCellWithReuseIdentifier:"Cell")
        //self.socialCollectionView.register(MediaThumbnailCell.self, forCellWithReuseIdentifier:"BadgeCell")
        
        //self.socialBadgeCollectionView
        
        print("The card badge list on selection")
        //print(selectedCard.cardProfile.badgeList)
        print(selectedCard.cardProfile.badgeDictionaryList)
        
        
        
        print("Current Card In SelectionVC >> \n\(selectedCard.toAnyObject())")
        
        print("Parsing card for corps")
        ContactManager.sharedManager.parseForCorpBadges(card: self.selectedCard)
        
        // Add observers for notifs
        addObservers()
        
        // Config header view based on counts
        if self.selectedCard.cardProfile.socialLinks.count > 0 && self.selectedCard.cardProfile.badgeDictionaryList.count > 0{
            print("The contact has both social and corp badges")
            // Set double collection wrapper as header
            profileInfoTableView.tableHeaderView = self.cardWrapperView
            
        }else if (self.selectedCard.cardProfile.socialLinks.count > 0 && self.selectedCard.cardProfile.badgeDictionaryList.count == 0) || (self.selectedCard.cardProfile.socialLinks.count == 0 && self.selectedCard.cardProfile.badgeDictionaryList.count > 0){
            print("The contact has one list populated")
            // Set single collection wrapper as header
            profileInfoTableView.tableHeaderView = self.cardWrapperViewSingle
            
        }else{
            print("The contact has neither list populated")
            // Set empty collection wrapper as header
            profileInfoTableView.tableHeaderView = self.cardWrapperViewEmpty
        }
        

        
    }

    // Page Setup
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //selectedCard = ContactManager.sharedManager.selectedCard
        
        // Do any additional setup after loading the view.
        
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
        
        // Add collectionview to toolbar
        /*let container = UIView(frame: CGRect(x: 0, y: 0, width: self.profileInfoTableView.frame.width, height: 3))
         container.backgroundColor = UIColor.blue
        container.addSubview(self.socialCollectionView)*/
        
        //self.socialMediaToolbar.addSubview(container)
        
        
        
        //self.profileInfoTableView.tableHeaderView = container
        
        
        // Register
        //self.socialCollectionView.register(MediaThumbnailCell.self, forCellWithReuseIdentifier:"Cell")
       // self.socialBadgeCollectionView.register(MediaThumbnailCell.self, forCellWithReuseIdentifier:"BadgeCell")
        
        
        // Reset arrays
        self.bios = [String]()
        self.titles = [String]()
        self.emails = [String]()
        self.phoneNumbers = [String]()
        self.socialLinks = [String]()
        self.organizations = [String]()
        self.websites = [String]()
        self.workInformation = [String]()
        self.addresses.removeAll()
        self.tags.removeAll()
        self.notes.removeAll()
        self.sections.removeAll()
        self.tableData.removeAll()
        // Corp badges?
        self.corpBadges.removeAll()
        self.emailLabels.removeAll()
        self.phoneNumberLabels.removeAll()
        self.addressLabels.removeAll()
        
        
        // Parse work info
        if selectedCard.cardProfile.titles.count > 0{
            // Add section
            sections.append("Titles")
            for info in selectedCard.cardProfile.titles{
                titles.append((info["title"])!)
            }
            // Create section data
            self.tableData["Titles"] = titles
        }
        
        if selectedCard.cardProfile.organizations.count > 0{
            // Add section
            sections.append("Company")
            for org in selectedCard.cardProfile.organizations{
                organizations.append(org["organization"]! )
            }
            // Create section data
            self.tableData["Company"] = organizations
        }
        
        // Parse card for profile info
        if selectedCard.cardProfile.bios.count > 0{
            // Add section
            sections.append("Bios")
            // Iterate throught array and append available content
            for bio in selectedCard.cardProfile.bios{
                bios.append(bio["bio"]!)
            }
            // Create section data
            self.tableData["Bios"] = bios
            
        }
        if selectedCard.cardProfile.phoneNumbers.count > 0{
            // Add section
            sections.append("Phone Numbers")
            for number in selectedCard.cardProfile.phoneNumbers{
                // Phone number with format style
                phoneNumbers.append(self.format(phoneNumber: number.values.first!)!)
                phoneNumberLabels.append(number.keys.first!)
                
                // Init record
                let record = [number.keys.first! : number.values.first!]
                // Test
                print("Phone record", record)
                
            }
            // Create section data
            self.tableData["Phone Numbers"] = phoneNumbers
        }
        
        if selectedCard.cardProfile.emails.count > 0{
            // Add section
            sections.append("Emails")
            for email in selectedCard.cardProfile.emails{
                emails.append(email["email"]! )
                emailLabels.append(email["type"] ?? "work")
                
                // Init record and test
                let record = ["email" : email["email"]!, "type" : email["type"] ?? "work"]
                print("Email Record", record)
            }
            // Create section data
            self.tableData["Emails"] = emails
        }
        
        /*
        // Parse work info
        if selectedCard.cardProfile.workInformationList.count > 0{
            // Add section
            sections.append("Work")
            for info in selectedCard.cardProfile.workInformationList{
                workInformation.append(info["work"]!)
            }
            // Create section data
            self.tableData["Work"] = workInformation
        }*/
        
        if selectedCard.cardProfile.websites.count > 0{
            // Add section
            sections.append("Websites")
            for site in selectedCard.cardProfile.websites{
                websites.append(site["website"]! )
            }
            // Create section data
            self.tableData["Websites"] = websites
        }
        if selectedCard.cardProfile.tags.count > 0{
            // Add section
            sections.append("Tags")
            for hashtag in selectedCard.cardProfile.tags{
                tags.append(hashtag["tag"]! )
            }
            // Create section data
            self.tableData["Tags"] = tags
        }
        if selectedCard.cardProfile.notes.count > 0{
            // Add section
            sections.append("Notes")
            for note in selectedCard.cardProfile.notes{
                notes.append(note["note"]! )
            }
            // Create section data
            self.tableData["Notes"] = notes
        }
        
        // Parse notes
        if selectedCard.cardProfile.addresses.count > 0{
            
            // Add section
            sections.append("Addresses")
            for add in selectedCard.cardProfile.addresses{
                
                // Set all values for the cells
                let street = add["street"] ?? ""
                let city = add["city"] ?? ""
                let state = add["state"] ?? ""
                let zip = add["zip"] ?? ""
                let country = add["country"] ?? ""
                
                // Create Address String
                let addressString = "\(street) \(city) \(state) \(zip) \(country)"
                
                // Append values
                addresses.append(addressString)
                addressLabels.append(add["type"] ?? "")
            }
            // Create section data
            self.tableData["Addresses"] = addresses
        }

        
        if selectedCard.cardProfile.socialLinks.count > 0{
            for link in selectedCard.cardProfile.socialLinks{
               // notes.append(link["link"]! )
                print("Card selection parsing on will appear")
            }
        }
        
        // Parse for corp
        for corp in selectedCard.cardProfile.badgeDictionaryList {
            // Init badge
            let badge = CardProfile.Bagde(snapshot: corp)
            
            // Add to list
            self.corpBadges.append(badge)
        }
        
        // Refresh table
        self.badgeCollectionView.reloadData()
        
        // Look for social badges 
        self.parseForSocialIcons()
        
        // Reload table data 
        profileInfoTableView.reloadData()
        
        
        // Set card name label 
        self.nameLabel.text = selectedCard.cardHolderName ?? ""
        self.nameLabelSingleWrapper.text = selectedCard.cardHolderName ?? ""
        self.nameLabelEmptyWrapper.text = selectedCard.cardHolderName ?? ""

        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // Collection view Delegate && Data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.badgeCollectionView {
            // Return count
            return self.corpBadges.count//self.selectedCard.cardProfile.badges.count//ContactManager.sharedManager.currentUser.userProfile.badgeList.count
        }else if collectionView == self.socialCollectionView{
            
            return self.socialBadges.count
        }else{
            if self.socialBadges.count > 0 {
                // Assign the socials to single collection
                return self.socialBadges.count
            }else{
                // The corp badges are the move
                return corpBadges.count
            }
        }
        //return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BadgeCell", for: indexPath)
        
        if collectionView == self.badgeCollectionView {
            // Badge config
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BadgeCell", for: indexPath)
            
            //self.configureBadges(cell: cell)
            
            ///cell.contentView.backgroundColor = UIColor.red
            self.configureBadges(cell: cell)
            
            let fileUrl = NSURL(string: self.corpBadges[indexPath.row].pictureUrl/*selectedCard.cardProfile.badgeList[indexPath.row].pictureUrl*/)
            
            // Configure corner radius
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            imageView.setImageWith(fileUrl! as URL)
            // Set image
            //imageView.image = image
            
            // Add subview
            cell.contentView.addSubview(imageView)
            
        }else if collectionView == badgeCollectionView{
            
            //cell.contentView.backgroundColor = UIColor.red
            self.configureBadges(cell: cell)
            
            // Configure corner radius
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            let image = self.socialBadges[indexPath.row]
            
            // Set image
            imageView.image = image
            
            // Add subview
            cell.contentView.addSubview(imageView)
        
        }else{
            
            // Check which list populated
            if self.socialBadges.count > 0 {
                // Config for social
                // Configure corner radius
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                let image = self.socialBadges[indexPath.row]
                
                // Set image
                imageView.image = image
                
                // Add subview
                cell.contentView.addSubview(imageView)
                
            }else{
                // Config for corp
                let fileUrl = NSURL(string: self.corpBadges[indexPath.row].pictureUrl/*selectedCard.cardProfile.badgeList[indexPath.row].pictureUrl*/)
                
                // Configure corner radius
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                imageView.setImageWith(fileUrl! as URL)
                // Set image
                //imageView.image = image
                
                // Add subview
                cell.contentView.addSubview(imageView)
                
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.badgeCollectionView {
            // Set index
            self.selectedBadgeIndex = indexPath.row
            // Config the social link webVC
            ContactManager.sharedManager.selectedSocialMediaLink = corpBadges[indexPath.row].pictureUrl
            
            // Show WebVC
            self.launchMediaWebView()
            
        }else{
            
            // Social link badges
            // Set selected index
            self.selectedBadgeIndex = indexPath.row
            // Config the social link webVC
            ContactManager.sharedManager.selectedSocialMediaLink = self.socialLinks[self.selectedBadgeIndex]
            
            // Show WebVC
            self.launchMediaWebView()

            
        }
        
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

    
    // MARK: - Table view data source
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[sections[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BioInfoCell", for: indexPath) as! CardOptionsViewCell
        
        cell.descriptionLabel.text = tableData[sections[indexPath.section]]?[indexPath.row]
        
        
        return cell
        
    }
    // Set row height
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        containerView.backgroundColor = UIColor.white
        
        // Add label to the view
        var lbl = UILabel(frame: CGRect(8, 3, 180, 15))
        lbl.text = sections[section]
        lbl.textAlignment = .left
        lbl.textColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        lbl.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium) //UIFont(name: "Avenir", size: CGFloat(14))
        
        // Add subviews
        containerView.addSubview(lbl)
        
        return containerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    
    // Message Composer Delegate
    
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
        if selectedCard.cardHolderName != "" || selectedCard.cardHolderName != nil{
           name = selectedCard.cardHolderName!
        }
        if selectedCard.cardProfile.phoneNumbers.count > 0{
            phone = selectedCard.cardProfile.phoneNumbers[0].values.first!
        }
        if selectedCard.cardProfile.emails.count > 0{
            email = selectedCard.cardProfile.emails[0]["email"]! 
        }
        if selectedCard.cardProfile.titles.count > 0{
            title = selectedCard.cardProfile.titles[0]["title"]!
        }

        
        
        // Create Message
        mailComposerVC.setToRecipients(["kfich7@gmail.com"])
        mailComposerVC.setSubject("Greetings - Let's Connect")
        mailComposerVC.setMessageBody("Hi, I'd like to connect with you. Here's my information \n\n\(name))\n\(title)\n\(email))\n\(title)))", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    
    
    // Custom Methods
    // -------------------------------------------
    
    // For sending notifications to the default center for other VC's that are listening
    func addObservers() {
        
        // Drop view after delete
        NotificationCenter.default.addObserver(self, selector: #selector(CardSelectionViewController.backButtonPressed(_:)), name: NSNotification.Name(rawValue: "CardDeleted"), object: nil)
        
        // Drop view after card edit
        NotificationCenter.default.addObserver(self, selector: #selector(CardSelectionViewController.backButtonPressed(_:)), name: NSNotification.Name(rawValue: "CardFinishedEditing"), object: nil)
        
        
    }
    
    
    
    // Format textfield for phone numbers
    func format(phoneNumber sourcePhoneNumber: String) -> String? {
        
        // Remove any character that is not a number
        let numbersOnly = sourcePhoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let length = numbersOnly.characters.count
        let hasLeadingOne = numbersOnly.hasPrefix("1")
        
        // Check for supported phone number length
        guard /*length == 7 ||*/ length == 10 || (length == 11 && hasLeadingOne) else {
            return sourcePhoneNumber ?? ""
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

    
    
    func launchMediaWebView() {
        // Config the social link webVC
        //ContactManager.sharedManager.selectedSocialMediaLink = self.socialLinks[self.selectedBadgeIndex]
        
        // Call the viewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SocialWebVC")
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
            //self.socialCollectionView.reloadData()
        }
        
        // Add image to the end of list
        //let image = UIImage(named: "icn-plus-blue")
        //self.socialBadges.append(image!)
        
        // Reload table
        //self.socialCollectionView.reloadData()
        
    }

    
    func createTransaction(type: String) {
        // Set type & Transaction data
        transaction.type = type
        transaction.setTransactionDate()
        transaction.senderName = ContactManager.sharedManager.currentUser.getName()
        transaction.senderId = ContactManager.sharedManager.currentUser.userId
        transaction.type = "connection"
        transaction.scope = "transaction"
        transaction.senderCardId = ContactManager.sharedManager.selectedCard.cardId!
        
        /*transaction.latitude = self.lat
         transaction.longitude = self.long
         transaction.recipientList = selectedUserIds
         transaction.location = self.address*/
        // Attach card id
        
        
        // Show progress hud
        /*
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
    
    func populateCards(){
        // Senders card config
        
        // Populate image view
        if selectedCard.cardProfile.images.count > 0{
            print("Profile images on selection greater.")
            contactImageView.image = UIImage(data: selectedCard.cardProfile.images[0]["image_data"] as! Data)
            contactImageViewSingleWrapper.image = UIImage(data: selectedCard.cardProfile.images[0]["image_data"] as! Data)
            contactImageViewEmptyWrapper.image = UIImage(data: selectedCard.cardProfile.images[0]["image_data"] as! Data)
        }else if selectedCard.isVerified{
            contactImageView.image = UIImage(data: ContactManager.sharedManager.currentUser.profileImages[0]["image_data"] as! Data)
            contactImageViewSingleWrapper.image = UIImage(data: ContactManager.sharedManager.currentUser.profileImages[0]["image_data"] as! Data)
            contactImageViewEmptyWrapper.image = UIImage(data: ContactManager.sharedManager.currentUser.profileImages[0]["image_data"] as! Data)
        }else if selectedCard.cardProfile.imageIds.count > 0{
            
            print("Profile image id not nil on selection", selectedCard.cardProfile.imageIds[0]["card_image_id"] as! String)
            print(selectedCard.cardProfile.imageIds)
            
            // Init id
            let idString = selectedCard.cardProfile.imageIds[0]["card_image_id"] as! String
            
            print("ID String :", idString)
            
            // Set image for contact
            let url = URL(string: "\(ImageURLS.sharedManager.getFromDevelopmentURL)\(idString).jpg")!
            let placeholderImage = UIImage(named: "profile")!
            
             print("URL String :", url)
            
            // Set image from url
            contactImageView.setImageWith(url, placeholderImage: placeholderImage)
            contactImageViewSingleWrapper.setImageWith(url, placeholderImage: placeholderImage)
            contactImageViewEmptyWrapper.setImageWith(url, placeholderImage: placeholderImage)
        }else{
            print("Profile met neither on selection")
            
            contactImageView.image = UIImage(data: ContactManager.sharedManager.currentUser.profileImages[0]["image_data"] as! Data)
            contactImageViewSingleWrapper.image = UIImage(data: ContactManager.sharedManager.currentUser.profileImages[0]["image_data"] as! Data)
            contactImageViewEmptyWrapper.image = UIImage(data: ContactManager.sharedManager.currentUser.profileImages[0]["image_data"] as! Data)
            print(selectedCard.cardProfile.imageId)
            print(selectedCard.imageId)
        }
        
        // Populate label fields
        if let name = selectedCard.cardName{
            cardNameLabel.text = name
            cardNameLabelSingleWrapper.text = name
            cardNameLabelEmptyWrapper.text = name
        }
        if selectedCard.cardProfile.phoneNumbers.count > 0{
            // Format number 
            phoneLabel.text = self.format(phoneNumber: selectedCard.cardProfile.phoneNumbers[0].values.first!)
            phoneLabelSingleWrapper.text = self.format(phoneNumber: selectedCard.cardProfile.phoneNumbers[0].values.first!)
            phoneLabelEmptyWrapper.text = self.format(phoneNumber: selectedCard.cardProfile.phoneNumbers[0].values.first!)
        }
        if selectedCard.cardProfile.emails.count > 0{
            emailLabel.text = selectedCard.cardProfile.emails[0]["email"]
            emailLabelSingleWrapper.text = selectedCard.cardProfile.emails[0]["email"]
            emailLabelEmptyWrapper.text = selectedCard.cardProfile.emails[0]["email"]
        }
        if selectedCard.cardProfile.titles.count > 0{
            titleLabel.text = selectedCard.cardProfile.titles[0]["title"]
            titleLabelSingleWrapper.text = selectedCard.cardProfile.titles[0]["title"]
            titleLabelEmptyWrapper.text = selectedCard.cardProfile.titles[0]["title"]
        }
        // Here, parse data to populate tableview
    }
    
    func configureSelectedImageView(imageView: UIImageView) {
        // Config imageview
        
        // Configure borders
        imageView.layer.borderWidth = 1
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 45
        // Changed the image rendering size
        //imageView.frame = CGRect(x: imageView.frame.origin.x, y: imageView.frame.origin.y , width: 125, height: 125)
        
    }
    
    func configureViews(){
        // Round out the vards here
        // Configure cards
        self.cardWrapperView.layer.cornerRadius = 12.0
        self.cardWrapperView.clipsToBounds = true
        self.cardWrapperView.layer.borderWidth = 2.0
        self.cardWrapperView.layer.borderColor = UIColor.white.cgColor
        
        self.cardWrapperViewSingle.layer.cornerRadius = 12.0
        self.cardWrapperViewSingle.clipsToBounds = true
        self.cardWrapperViewSingle.layer.borderWidth = 2.0
        self.cardWrapperViewSingle.layer.borderColor = UIColor.white.cgColor
        
        self.cardWrapperViewEmpty.layer.cornerRadius = 12.0
        self.cardWrapperViewEmpty.clipsToBounds = true
        self.cardWrapperViewEmpty.layer.borderWidth = 2.0
        self.cardWrapperViewEmpty.layer.borderColor = UIColor.white.cgColor
        
        // Config imageview 
        self.configureSelectedImageView(imageView: self.contactImageView)
        self.configureSelectedImageView(imageView: self.contactImageViewSingleWrapper)
        self.configureSelectedImageView(imageView: self.contactImageViewEmptyWrapper)
        
        self.profileInfoTableView.layer.cornerRadius = 12.0
        self.profileInfoTableView.clipsToBounds = true
        self.profileInfoTableView.layer.borderWidth = 2.0
        self.profileInfoTableView.layer.borderColor = UIColor.white.cgColor
        
        if self.selectedCard.isVerified {
            // Hide button
            self.editCardButton.isHidden = true
            self.editCardButton.isEnabled = false
        }
        
        
        // Set shadow on the container view
                
        
        // Toolbar button config
        
        /*outreachChatButton.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir", size: 13)!], for: UIControlState.normal)
        
        outreachMailButton.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir", size: 13)!], for: UIControlState.normal)
        
        outreachCallButton.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir", size: 13)!], for: UIControlState.normal)
        
        
        
        // Config buttons
        // ** Email and call inverted
        smsButton.image = UIImage(named: "btn-chat-blue")
        callButton.image = UIImage(named: "btn-message-blue")
        
        // Hide call button
        emailButton.image = UIImage(named: "")
        emailButton.isEnabled = false
        outreachCallButton.isEnabled = false
        outreachCallButton.title = ""*/
        
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
