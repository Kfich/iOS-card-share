//
//  ContactProfileViewController.swift
//  Unify
//
//  Created by Kevin Fich on 5/24/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit
import Contacts
import MessageUI

class ContactProfileViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Properties
    // --------------------------------------------
    
    var active_card_unify_uuid: String?
    
    var selectedContact = CNContact()
    let formatter = CNContactFormatter()
    var contact = Contact()
    var cardLink = "https://project-unify-node-server.herokuapp.com/card/render/"
    
   // var selectedCard = ContactCard()
    
    // This contact card is really a transaction object
    var card = ContactCard()
    var transaction = Transaction()
    var currentUser = User()
    
    var selectedUserPhone = ""
    var selectedUserEmail = ""
    
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
    
    // Store image icons
    var socialLinkBadges = [[String : Any]]()
    var links = [String]()
    var socialBadges = [UIImage]()
    var selectedBadgeIndex : Int = 0
    
    var sections = [String]()
    var tableData = [String: [String]]()
    
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
    @IBOutlet var outreachCalendarButton: UIBarButtonItem!
    
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
    @IBOutlet var calendarButton: UIBarButtonItem!
    
    
    @IBOutlet var phoneImageView: UIImageView!
    @IBOutlet var emailImageView: UIImageView!
    
    // Buttons
    
    @IBOutlet var mediaButton1: UIBarButtonItem!
    @IBOutlet var mediaButton2: UIBarButtonItem!
    @IBOutlet var mediaButton3: UIBarButtonItem!
    
    @IBOutlet var mediaButton4: UIBarButtonItem!
    @IBOutlet var mediaButton5: UIBarButtonItem!
    @IBOutlet var mediaButton6: UIBarButtonItem!
    @IBOutlet var mediaButton7: UIBarButtonItem!
    
    @IBOutlet var socialBadgeCollectionView: UICollectionView!
    
    
    // IBActions / Buttons Pressed
    // --------------------------------------------
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        
        //dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func smsSelected(_ sender: AnyObject) {
        // Call sms function 
        self.showSMSCard()
        
    }
    
    @IBAction func emailSelected(_ sender: AnyObject) {
        // Call email function 
        self.showEmailCard()
        
    }
    @IBAction func callSelected(_ sender: AnyObject) {
        
        // Set phone val
        let phone = selectedUserPhone
        
        // configure call 
        if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
    }
    
    @IBAction func calendarSelected(_ sender: Any) {
        
        
        
        // Configure calendar
        //UIApplication.shared.openURL(NSURL(string: "calshow://")! as URL)
        
        //performSegue(withIdentifier: "showCreateAppointment", sender: self)
        // Typical usage
        self.open(scheme: "calshow://")
    }
    

    
    
    
    // Page Setup

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
 
        // Set selected card // Default for testing
        self.card = ContactManager.sharedManager.currentUserCards[0]
        self.card.printCard()
        
        // Set currentUser object
        self.currentUser = ContactManager.sharedManager.currentUser
            
        // Test is segue passed properly
        
        print("Selected Contact -> \(selectedContact)")
        
        // Set format style 
        formatter.style = .fullName

        // Parse card for profile info
        self.parseContactRecord()
        
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
    
    // Collection view Delegate && Data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         /*if self.socialBadges.count != 0 {
         // Return the count
            return self.socialBadges.count
         }else{
            
           /* let img = UIImage(named: "social-blank")
            self.socialBadges.append(img!)*/
            
            return 1
         }*/
        return self.socialBadges.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BadgeCell", for: indexPath)
        
        //cell.contentView.backgroundColor = UIColor.red
        self.configureBadges(cell: cell)
        
        // Configure corner radius
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let image = self.socialBadges[indexPath.row]
        
        // Set image
        imageView.image = image
        
        // Add subview
        cell.contentView.addSubview(imageView)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //performSegue(withIdentifier: "showSocialMediaOptions", sender: self)
        self.selectedBadgeIndex = indexPath.row
        
        // Set selected link
        self.launchMediaWebView()
        
        
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
    }
    
    func configureBadges(cell: UICollectionViewCell){
        // Add radius config & border color
        
        cell.contentView.layer.cornerRadius = 20.0
        cell.contentView.clipsToBounds = true
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.borderColor = UIColor.blue.cgColor
        
        // Set shadow on the container view
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowOffset = CGSize.zero
        cell.layer.shadowRadius = 0.5
        
    }
    
    
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
        lbl.font = UIFont(name: "Avenir", size: CGFloat(14))
        
        // Add subviews
        containerView.addSubview(lbl)
        
        return containerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    

    
    // Custom Methods
    // -------------------------------------------
    
    func launchMediaWebView() {
        // Config the social link webVC
        ContactManager.sharedManager.selectedSocialMediaLink = self.socialLinks[self.selectedBadgeIndex]
        
        // Call the viewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SocialWebVC")
        self.present(controller, animated: true, completion: nil)
    }
    
    
    func initializeBadgeList() {
        // Image config
        let img1 = UIImage(named: "icn-social-facebook.png")
        let img2 = UIImage(named: "icn-social-twitter.png")
        let img3 = UIImage(named: "icn-social-instagram.png")
        let img4 = UIImage(named: "icn-social-harvard.png")
        let img5 = UIImage(named: "icn-social-pinterest.png")
        let img6 = UIImage(named: "icn-social-pinterest.png")
        let img7 = UIImage(named: "icn-social-facebook.png")
        let img8 = UIImage(named: "icn-social-facebook.png")
        let img9 = UIImage(named: "icn-social-facebook.png")
        let img10 = UIImage(named: "icn-social-facebook.png")
        
        // Hash images
        self.socialLinkBadges = [["facebook" : img1!], ["twitter" : img2!], ["instagram" : img3!], ["harvard" : img4!], ["pinterest" : img5!]]/*, ["pinterest" : img6!], ["reddit" : img7!], ["tumblr" : img8!], ["myspace" : img9!], ["googleplus" : img10!]]*/
        
        
        // let fb : NSDictionary = ["facebook" : img1!]
        // self.socialLinkBadges.append([fb])
        
        
    }
    
    func parseForSocialIcons() {
        
        // Init icon list 
        self.initializeBadgeList()
        
        print("Looking for social icons on profile view")
        
        // Assign currentuser
        //self.currentUser = ContactManager.sharedManager.currentUser
        
        // Parse socials links
        /*if ContactManager.sharedManager.currentUser.userProfile.socialLinks.count > 0{
            for link in ContactManager.sharedManager.currentUser.userProfile.socialLinks{
                socialLinks.append(link["link"]!)
                // Test
                print("Count >> \(socialLinks.count)")
            }
        }*/
        
        // Remove all items from badges
        self.socialBadges.removeAll()
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
        //let image = UIImage(named: "icn-plus-blue")
        //self.socialBadges.append(image!)
        
        // Reload table
        self.socialBadgeCollectionView.reloadData()
        
    }
    
    func emptyArrays() {
        // Reset all array values to nil
        
    }
    
    // Initialize contact objects for upload
    
    func parseContactRecord(){
        // Clear all profile info to prepare for override
        bios.removeAll()
        titles.removeAll()
        emails.removeAll()
        phoneNumbers.removeAll()
        websites.removeAll()
        organizations.removeAll()
        socialLinks.removeAll()
        workInformation.removeAll()
        self.sections.removeAll()
        self.tableData.removeAll()
        
        
        // Init formatter
        let formatter = CNContactFormatter()
        formatter.style = .fullName
        
        // Iterate over list and itialize contact objects
            
            // Init temp contact object
            //let contactObject = Contact()
            
            // Set name
            //contactObject.name = formatter.string(from: contact) ?? "No Name"
            
            // Check for count
            if contact.phoneNumbers.count > 0 {
                // Add section
                sections.append("Phone Numbers")
                // Iterate over items
                for number in contact.phoneNumbers{
                    // print to test
                    //print("Number: \((number.value.value(forKey: "digits" )!))")
                    
                    // Init the number
                    let digits = number["phone"]!
                    
                    self.phoneNumbers.append(digits)
                    print(phoneNumbers.count)
                }
                // Create section data
                self.tableData["Phone Numbers"] = phoneNumbers
                
            }
            if contact.emails.count > 0 {
                // Add section
                sections.append("Emails")
                // Iterate over array and pull value
                for address in contact.emails {
                    // Print to test
                    print("Email : \(address["email"])")
                    
                    // Append to array
                    self.emails.append(address["email"]!)
                    print(emails.count)
                }
                // Create section data
                self.tableData["Emails"] = emails
            }
        
            if contact.websites.count > 0{
                // Add section
                sections.append("Websites")
                // Iterate over items
                for address in contact.websites {
                    // Print to test
                    print("Website : \(address["website"]!)")
                    
                    // Append to list
                    self.websites.append(address["website"]!)
                    print(websites.count)
                }
                // Create section data
                self.tableData["Websites"] = websites
                
            }
            if contact.socialLinks.count > 0{
                // Iterate over items
                for profile in contact.socialLinks {
                    // Print to test
                    print("Social Profile : \(profile["link"]!)")
                    
                    // Append to list
                    self.socialLinks.append(profile["link"]!)
                    print(socialLinks.count)
                }
                
            }
            
            if contact.titles.count > 0 {
                // Add section
                sections.append("Titles")
                
                for title in contact.titles {
                    // Print to test
                    print("Title : \(title["title"]!)")
                    
                    // Append to list
                    self.titles.append(title["title"]!)
                    print(titles.count)
                }
                // Set list for section
                self.tableData["Titles"] = titles
            }
        
        if contact.organizations.count > 0 {
            // Add section
            sections.append("Organizations")
            
            for org in contact.organizations {
                // Print to test
                print("Org : \(org["organization"]!)")
                
                // Append to list
                self.organizations.append(org["organization"]!)
                print(organizations.count)
            }
            // Set list for section
            self.tableData["Organizations"] = organizations
        }

        if contact.notes.count > 0 {
            // Add section
            sections.append("Notes")
            
            for note in contact.notes {
                // Print to test
                print("Note : \(note["note"]!)")
                
                // Append to list
                self.notes.append(note["note"]!)
                print(notes.count)
            }
            // Set list for section
            self.tableData["Notes"] = notes
        }

        
        if contact.tags.count > 0 {
            // Add section
            sections.append("Tags")
            
            for tag in contact.tags {
                // Print to test
                print("Title : \(tag["tag"]!)")
                
                // Append to list
                self.tags.append(tag["tag"]!)
                print(tags.count)
            }
            // Set list for section
            self.tableData["Tags"] = tags
        }

            // Test object
            print("Contact >> \n\(contact.toAnyObject()))")
        
        // Parse for badges 
        self.parseForSocialIcons()
        
        // Reload table data
        self.profileInfoTableView.reloadData()
        
        
    }

    
    
    func parseContactProfile() {
        // Check for values 
        
        
        
        
        /*if selectedContact.phoneNumbers.count > 0 {
            // Iterate over phones array
            for phone in selectedContact.phoneNumbers {
                self.phoneNumbers.append(phone.value.value(forKey: "digits") as! String)
            }
            
            // Set label text
            phoneLabel.text = (selectedContact.phoneNumbers[0].value).value(forKey: "digits") as? String
            
            // Set global phone val
            self.selectedUserPhone = (selectedContact.phoneNumbers[0].value).value(forKey: "digits") as! String
        }
        
        if selectedContact.emailAddresses.count > 0 {
            // Iterate over emails array
            for email in selectedContact.emailAddresses {
                // Add to emails array 
                self.emails.append((selectedContact.emailAddresses[0].value as String))
                print(email)
                
            }
            
        }*/

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
        
        
        //nameLabel.text = formatter.string(from: selectedContact) ?? "No Name"
        nameLabel.text = self.contact.name
        
        if self.contact.phoneNumbers.count > 0 {
            // Set label text
            //phoneLabel.text = (selectedContact.phoneNumbers[0].value).value(forKey: "digits") as? String
            phoneLabel.text = self.contact.phoneNumbers[0]["phone"]
            
            // Set global phone val
            self.selectedUserPhone = self.contact.phoneNumbers[0]["phone"]!
        }else{
            // Hide phone icon image 
            phoneImageView.isHidden = true
            // Disable buttons
            callButton.isEnabled = false
            smsButton.isEnabled = false
            
            // Set tint for buttons
            callButton.tintColor = UIColor.gray
            smsButton.tintColor = UIColor.gray
            
            // Toggle image
            callButton.image = UIImage(named: "btn-call-gray")
            smsButton.image = UIImage(named: "btn-chat-gray")
            
        }
        if contact.emails.count > 0 {
            // Set label text
            emailLabel.text = self.contact.emails[0]["email"]
            // Set global email
            self.selectedUserEmail = self.contact.emails[0]["email"]!
        }else{
            // Hide email icon
            emailImageView.isHidden = true
            // Disable button
            emailButton.isEnabled = false
            // Set tint
            emailButton.tintColor = UIColor.gray
            // Toggle image
            emailButton.image = UIImage(named: "btn-message-gray")
        }
        // Check if image data available
        
        
        if contact.imageId != "" {
            print("Has IMAGE")
            // Set id
            let id = contact.imageId
            
            // Set image for contact
            let url = URL(string: "\(ImageURLS.sharedManager.getFromDevelopmentURL)\(id).jpg")!
            let placeholderImage = UIImage(named: "profile")!
            // Set image
            //contactImageView?.setImageWith(url)
            self.contactImageView.setImageWith(url)
            
        }else{
            contactImageView.image = UIImage(named: "profile")
        }

        // Senders card
        //contactImageView.image = UIImage(named: "throwback.png")
        //nameLabel.text = "Harold Fich"
        //phoneLabel.text = "1+ (123)-345-6789"
        //emailLabel.text = "Kev.fich12@gmail.com"
        //titleLabel.text = "Founder & CEO, CleanSwipe"
    }
    
    func configureViews(){
        // Round out the vards here 
        // Configure cards
        self.cardWrapperView.layer.cornerRadius = 12.0
        self.cardWrapperView.clipsToBounds = true
        self.cardWrapperView.layer.borderWidth = 2.0
        self.cardWrapperView.layer.borderColor = UIColor.white.cgColor
        
        // Imageview 
        self.configureSelectedImageView(imageView: self.contactImageView)
        
        // Config table
        self.profileInfoTableView.layer.cornerRadius = 12.0
        self.profileInfoTableView.clipsToBounds = true
        self.profileInfoTableView.layer.borderWidth = 2.0
        self.profileInfoTableView.layer.borderColor = UIColor.white.cgColor
        
        // Set shadow on the container view
        
        addDropShadow()
        
        // Assign media buttons
       /* mediaButton1.image = UIImage(named: "icn-social-twitter.png")
        mediaButton2.image = UIImage(named: "icn-social-facebook.png")
        mediaButton3.image = UIImage(named: "icn-social-harvard.png")
        mediaButton4.image = UIImage(named: "icn-social-instagram.png")
        mediaButton5.image = UIImage(named: "icn-social-pinterest.png")
        mediaButton6.image = UIImage(named: "icn-social-twitter.png")
        mediaButton7.image = UIImage(named: "icn-social-facebook.png")*/
        
        
        // Toolbar button config
        
        outreachChatButton.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir", size: 14)!], for: UIControlState.normal)
        
        outreachMailButton.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir", size: 14)!], for: UIControlState.normal)
        
        outreachCallButton.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir", size: 14)!], for: UIControlState.normal)
        
        outreachCalendarButton.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir", size: 14)!], for: UIControlState.normal)
        
        
        // Config buttons
        // ** Email and call inverted
        smsButton.image = UIImage(named: "btn-chat-blue")
        emailButton.image = UIImage(named: "btn-message-blue")
        callButton.image = UIImage(named: "btn-call-blue")
        calendarButton.image = UIImage(named: "btn-calendar-blue")
    }
    
    func configureSelectedImageView(imageView: UIImageView) {
        // Config imageview
        
        // Configure borders
        imageView.layer.borderWidth = 0.5
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 45    // Create container for image and name
        
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
    
    
    // Custom Methods
    
    func open(scheme: String) {
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                                            print("Open \(scheme): \(success)")
                })
            } else {
                let success = UIApplication.shared.openURL(url)
                print("Open \(scheme): \(success)")
            }
        }
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
        
        // Show progress hud
        KVNProgress.show(withStatus: "Making the connection...")
        
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
                
                // Hide HUD
                KVNProgress.dismiss()
                
            } else {
                print("Card Created Error Response ---> \(error)")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error with your connection request. Please try again.")
                
            }
            // Hide indicator
            KVNProgress.dismiss()
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
            
           /* if contact.phoneNumbers.count > 0 && recipient.phoneNumbers.count > 0 {
                
                let contactPhone = (contact.phoneNumbers[0].value).value(forKey: "digits") as? String
                // Set contact phone number
                phone = contactPhone!
                
                let recipientPhone = (recipient.phoneNumbers[0].value).value(forKey: "digits") as? String
                
                // Launch text client
                composeVC.recipients = [contactPhone!, recipientPhone!]
            }
            
            if contact.emailAddresses.count > 0 {
                email = (contact.emailAddresses[0].value as String)
            }*/
            
            
            // Set card link from cardID
            cardLink = "https://project-unify-node-server.herokuapp.com/card/render/\(card.cardId!)"
            
            // Test String
            let str = "Hi, I'd like to connect with you. Here's my information \n\n\(String(describing: currentUser.getName()))\n\n\nBest, \n\(currentUser.getName()) \n\n \(cardLink)"
            
            // Set string as message body
            composeVC.body = str
            // Set recipient phone
            composeVC.recipients = [selectedUserPhone]
            
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
        var emailContact = ""
        //var title = ""
        
        
        // CNContact Objects
        let contact = self.selectedContact
        
        // Check if they both have email
        name = formatter.string(from: contact) ?? "No Name"
        
        if contact.emailAddresses.count > 0{
            // Set email string
            let contactEmail = contact.emailAddresses[0].value as String
            
            // Set variable
            emailContact = contactEmail
        }
        
        // Create Message
        
        //let str = "Hi, I'd like to connect with you. Here's my information \n\n\(String(describing: card.cardHolderName))\n\(String(describing: card.cardProfile.emails[0]["email"]))\n\(String(describing: card.cardProfile.title))\n\nBest, \n\(currentUser.getName()) \n\n"
        
        // Set card link from cardID
        cardLink = "https://project-unify-node-server.herokuapp.com/card/render/\(card.cardId!)"
        
        // Test String
        let str = "Hi, I'd like to connect with you. Here's my information \n\n\(String(describing: currentUser.getName()))\n\n\nBest, \n\(currentUser.getName()) \n\n\(cardLink)"
        
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
