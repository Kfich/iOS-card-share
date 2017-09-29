//
//  ContactListProfileViewController.swift
//  Unify
//
//  Created by Kevin Fich on 9/15/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit
import Eureka
import Contacts
import EventKitUI
import MessageUI


class ContactListProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, EKEventEditViewDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate{
    
    // Properties
    // ----------------------------------
    
    var currentUser = User()
    var contact = Contact()
    let formatter = CNContactFormatter()
    var selectedContact = CNContact()
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
    
    // Selected items
    var selectedUserPhone = ""
    var selectedUserEmail = ""
    var selectedBadgeIndex = 0
    
    var socialBadges = [UIImage]()
    var profileImages = [UIImage()]
    // To check user intent
    //var doneButtonSelected = false]
    
    // Store image icons
    var socialLinkBadges = [[String : Any]]()
    var links = [String]()
    var linkToDelete = ""
    
    var userBadges = [UIImage]()
    
    // Selected image
    var selectedImage = UIImage()
    
    var sections = [String]()
    var tableData = [String: [String]]()
    var labels = [String : [String]]()
    
    // For verified user badges
    var corpBadges: [Contact.Bagde] = []
    
    var count = 0
    
    @IBOutlet var cardWrapperView: UIView!
    @IBOutlet var cardWrapperViewSingleWrapper: UIView!
    @IBOutlet var cardWrapperViewEmptyWrapper: UIView!
    
    
    @IBOutlet var singleWrapperCollectionView: UICollectionView!
    @IBOutlet var socialBadgeCollectionView: UICollectionView!
    @IBOutlet var badgeCollectionView: UICollectionView!
    
    // Tableview
    @IBOutlet var profileInfoTableView: UITableView!
    
    // IBOutlets
    // ----------------------------------
    @IBOutlet var nameLabel: UILabel!
    
    // Card wrapper view with 2 collection cells
    @IBOutlet var contactImageView: UIImageView!
    @IBOutlet var smsButton: UIBarButtonItem!
    @IBOutlet var emailButton: UIBarButtonItem!
    @IBOutlet var callButton: UIBarButtonItem!
    @IBOutlet var calendarButton: UIBarButtonItem!
    @IBOutlet var badgeImageView: UIImageView!
    
    // Outreach toolbar
    @IBOutlet var outreachChatButton: UIBarButtonItem!
    @IBOutlet var outreachCallButton: UIBarButtonItem!
    @IBOutlet var outreachMailButton: UIBarButtonItem!
    @IBOutlet var outreachCalendarButton: UIBarButtonItem!
    
    
    // Card wrapper view with single collection cell
    @IBOutlet var contactImageViewSingleWrapper: UIImageView!
    @IBOutlet var smsButtonSingleWrapper: UIBarButtonItem!
    @IBOutlet var emailButtonSingleWrapper: UIBarButtonItem!
    @IBOutlet var callButtonSingleWrapper: UIBarButtonItem!
    @IBOutlet var calendarButtonSingleWrapper: UIBarButtonItem!
    // Outreach toolbar
    @IBOutlet var outreachChatButtonSingleWrapper: UIBarButtonItem!
    @IBOutlet var outreachCallButtonSingleWrapper: UIBarButtonItem!
    @IBOutlet var outreachMailButtonSingleWrapper: UIBarButtonItem!
    @IBOutlet var outreachCalendarButtonSingleWrapper: UIBarButtonItem!
    @IBOutlet var badgeImageViewSingleWrapper: UIImageView!
    
    
    
    // Card wrapper view with single collection cell
    @IBOutlet var contactImageViewEmptyWrapper: UIImageView!
    @IBOutlet var smsButtonEmptyWrapper: UIBarButtonItem!
    @IBOutlet var emailButtonEmptyWrapper: UIBarButtonItem!
    @IBOutlet var callButtonEmptyWrapper: UIBarButtonItem!
    @IBOutlet var calendarButtonEmptyWrapper: UIBarButtonItem!
    // Outreach toolbar
    @IBOutlet var outreachChatButtonEmptyWrapper: UIBarButtonItem!
    @IBOutlet var outreachCallButtonEmptyWrapper: UIBarButtonItem!
    @IBOutlet var outreachMailButtonEmptyWrapper: UIBarButtonItem!
    @IBOutlet var outreachCalendarButtonEmptyWrapper: UIBarButtonItem!
    @IBOutlet var badgeImageViewEmptyWrapper: UIImageView!
    
    
    
    @IBOutlet var phoneImageView: UIImageView!
    @IBOutlet var emailImageView: UIImageView!
    
    @IBOutlet var shadowView: YIInnerShadowView!
    
    // IBActions / Buttons Pressed
    // --------------------------------------------
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        
        //dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func smsSelected(_ sender: AnyObject) {
        
        // Check for count
        if contact.phoneNumbers.count > 1 {
        
            // Call sms function
            self.showActionTextAlert()
        }else{
            // show sms 
            self.showSMSCard()
        }
        
    }
    
    @IBAction func emailSelected(_ sender: AnyObject) {
        
        if contact.emails.count > 1{
            // call email options alert
            self.showActionEmailAlert()
       
        }else{
            
            // Call email function
            self.showEmailCard()
            
        }
        
    }
    @IBAction func callSelected(_ sender: AnyObject) {
        
        if contact.phoneNumbers.count < 2 {
            
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
            
        }else{
            // Show alert with multiples
            self.showActionAlert()
        }
        
        
        
        
    }
    
    @IBAction func calendarSelected(_ sender: Any) {
        
         // Check status
         let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
         
        
        switch (status) {
        
        case EKAuthorizationStatus.notDetermined:
        
            // This happens on first-run
         
            requestAccessToCalendar()
         
            print("Undecided")
         
        case EKAuthorizationStatus.authorized:
         
        
            let vc = EKEventEditViewController()
            // Event
            vc.editViewDelegate = self
            let eventStore = EKEventStore()
            // Init new event
            let newEvent = EKEvent(eventStore: eventStore)
            // Init new event
            vc.event = newEvent
            // Create store
            vc.eventStore = eventStore
            // Present view
            self.present(vc, animated: true, completion: nil)
         
         break
         
         case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
         
            // We need to help them give us permission
         
            //needPermissionView.fadeIn()
         
            print("Restricted")
         
            break
        
        }
        
    }
    // Request access to calendar 
    func checkCalendarAuthorizationStatus() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            // This happens on first-run
            requestAccessToCalendar()
            print("Undecided")
        case EKAuthorizationStatus.authorized: break
        // Things are in line with being able to show the calendars in the table view
        print("Authorized")
            
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied: break
        // We need to help them give us permission
        //needPermissionView.fadeIn()
        print("Restricted")
        }
    }
    
    // Send user to app settings
    func showGeneralSettings() {
        // Push to settings
        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
        }
    }
    
    // Show settings alert
    func showAccessAlert() {
        // Configure alertview
        let alertView = UIAlertController(title: "Unify would like to access your calendar", message: "You need to authorize 'Unify' to access your location in your iPhone settings in order to schedule appointments with your contacts", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Not now", style: .default, handler: { (alert) in
            
            // Dismiss alert
            self.dismiss(animated: true, completion: nil)
            
        })
        
        let settings = UIAlertAction(title: "Allow", style: .default, handler: { (alert) in
            // Execute logout function
            self.showGeneralSettings()
        })
        
        alertView.addAction(cancel)
        alertView.addAction(settings)
        self.present(alertView, animated: true, completion: nil)
    }
    
    // Get access
    func requestAccessToCalendar() {
        EKEventStore().requestAccess(to: .event, completion: {
            (accessGranted: Bool, error: Error?) in
            
            if accessGranted == true {
                DispatchQueue.main.async(execute: {
                    // self.loadCalendars()
                    //self.refreshTableView()
                    print("Allowed")
                })
            } else {
                DispatchQueue.main.async(execute: {
                    //self.needPermissionView.fadeIn()
                    self.showAccessAlert()
                })
            }
        })
    }
    
    
    // Collection view Delegate && Data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.socialBadgeCollectionView {
            // Config images
            return self.socialBadges.count
        }else if collectionView == self.badgeCollectionView{
            // Badge config
            return corpBadges.count
        }else{
            if self.socialBadges.count > 0 {
                // Assign the socials to single collection
                return self.socialBadges.count
            }else{
                // The corp badges are the move
                return corpBadges.count
            }
        }
        //return 4//self.socialBadges.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        //cell.backgroundColor = UIColor.blue
        
        //cell.contentView.backgroundColor = UIColor.red
        self.configureBadges(cell: cell)
        
        if collectionView == self.socialBadgeCollectionView {
            // Config social badges
            // Configure corner radius
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            let image = self.socialBadges[indexPath.row]
            
            // Set image
            imageView.image = image
            
            // Add subview
            cell.contentView.addSubview(imageView)
        }else if collectionView == self.badgeCollectionView{
            
            // Config badge
            
            let fileUrl = NSURL(string: self.corpBadges[indexPath.row].pictureUrl/*selectedCard.cardProfile.badgeList[indexPath.row].pictureUrl*/)
            
            // Configure corner radius
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            imageView.setImageWith(fileUrl! as URL)
            // Set image
            //imageView.image = image
            
            // Add subview
            cell.contentView.addSubview(imageView)
            
        }else{
            
            // The single collection is present
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
        
        //performSegue(withIdentifier: "showSocialMediaOptions", sender: self)
        self.selectedBadgeIndex = indexPath.row
        
        // Set selected link
        self.launchMediaWebView()
        
        
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
        
        //cell.descriptionLabel.text = tableData[sections[indexPath.section]]?[indexPath.row]
        cell.titleLabel.text = labels[sections[indexPath.section]]?[indexPath.row]
        //cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
        cell.descriptionLabel.text = tableData[sections[indexPath.section]]?[indexPath.row]
        //cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16)
        
        if sections[indexPath.section] == "Phone Numbers" || sections[indexPath.section] == "Emails" || sections[indexPath.section] == "Addresses" || sections[indexPath.section] == "Websites"{
            
            // Set labels for field values
            if sections[indexPath.section] == "Emails"{
                cell.titleLabel.text = self.emailLabels[indexPath.row]
                // Set tint on text field
                cell.descriptionLabel.textColor = self.view.tintColor
                
            }else if sections[indexPath.section] == "Phone Numbers"{
                cell.titleLabel.text = self.phoneNumberLabels[indexPath.row]
                // Set tint on text field
                cell.descriptionLabel.textColor = self.view.tintColor
                
            }else if sections[indexPath.section] == "Addresses"{
                // Set label
                cell.titleLabel.text = self.addressLabels[indexPath.row]
                // Not tint
            }else if sections[indexPath.section] == "Websites"{
            
                // Set tint on text field
                cell.descriptionLabel.textColor = self.view.tintColor
                
            }
            
        }

        
        return cell
        
    }
    // Set row height
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 55.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Deselect row
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Check section for click actions
        if sections[indexPath.section] == "Phone Numbers"{
            
            // Call option
            self.callSelected(self)
        }
        
        if sections[indexPath.section] == "Emails"{
            
            // Email option
            self.emailSelected(self)
        }
        
        if sections[indexPath.section] == "Websites"{
            
            // Set proper index
            self.selectedBadgeIndex = indexPath.row
            // Launch website option
            self.launchWebView()
        }
            
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 1))
        containerView.backgroundColor = UIColor.white
        
        // Add label to the view
        /*var lbl = UILabel(frame: CGRect(8, 3, 180, 15))
        lbl.text = ""//sections[section]
        lbl.textAlignment = .left
        lbl.textColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        lbl.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium) //UIFont(name: "Avenir", size: CGFloat(14))*/
        
        // Init line view
        let lineView = UIView(frame: CGRect(x: 5, y: containerView.frame.height + 4, width: self.view.frame.width, height: 0.5))
        
        lineView.backgroundColor = UIColor.lightGray
        
        // Add subviews
        //containerView.addSubview(lbl)
        containerView.addSubview(lineView)
        
        return containerView
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    // Event delegate
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        //
        print("The calendar is done")
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    // Page setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show nav
        //self.navigationController?.navigationBar.isHidden = false
        

        
        // Really, we parse the card and profile infos to extract the list
        // Fill profile with example info
        currentUser = ContactManager.sharedManager.currentUser
        
        // Contact
        //self.contact = ContactManager.sharedManager.newContact
        
        
        // Parse contact
        self.parseContactRecord()
        
        // Parse for images
        //self.parseAccountForImges()
        
        // Parse prof for social info
        self.parseForSocialIcons()
        
        // View config
        configureViews()
        self.populateCards()
        
        // Parse for corp
        for corp in self.contact.badgeDictionaryList {
            // Init badge
            let badge = Contact.Bagde(snapshot: corp)
            
            // Add to list
            self.corpBadges.append(badge)
            print("CorpBadges", self.corpBadges.count)
            
        }
        
        self.badgeCollectionView.reloadData()
        
        // Pass corp badges 
        //self.corpBadges = self.contact.badgeList
        
        
        if self.contact.socialLinks.count > 0 && self.contact.badgeDictionaryList.count > 0{
            print("The contact has both social and corp badges")
            // Set double collection wrapper as header
            profileInfoTableView.tableHeaderView = self.cardWrapperView
        }else if (self.contact.socialLinks.count > 0 && self.contact.badgeDictionaryList.count == 0) || (self.contact.socialLinks.count == 0 && self.contact.badgeDictionaryList.count > 0){
            print("The contact has one list populated")
            // Set single collection wrapper as header
            profileInfoTableView.tableHeaderView = self.cardWrapperViewSingleWrapper
        }else{
            print("The contact has neither list populated")
            // Set empty collection wrapper as header
            profileInfoTableView.tableHeaderView = self.cardWrapperViewEmptyWrapper
        }
        
        
        //tableView.tableFooterView = self.profileImageCollectionView
        
        // Request calendar access
        checkCalendarAuthorizationStatus()
    }
    
    // Custom methods
    
    
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
        tags.removeAll()
        addresses.removeAll()
        self.sections.removeAll()
        self.tableData.removeAll()
        self.notes.removeAll()
        phoneNumberLabels.removeAll()
        emailLabels.removeAll()
        addresses.removeAll()
        labels.removeAll()
        
        
        // Init formatter
        let formatter = CNContactFormatter()
        formatter.style = .fullName
        
        // Iterate over list and itialize contact objects
        
        // Init temp contact object
        //let contactObject = Contact()
        
        // Set name
        //contactObject.name = formatter.string(from: contact) ?? "No Name"
        
        
        if contact.titles.count > 0 {
            // Add section
            sections.append("Titles")
            
            // Init labels
            var labelList = [String]()
            
            for title in contact.titles {
                // Print to test
                print("Title : \(title["title"]!)")
                
                // Append to list
                self.titles.append(title["title"]!)
                
                labelList.append("title")
                
                
                print(titles.count)
            }
            // Set list for section
            self.tableData["Titles"] = titles
            self.labels["Titles"] = labelList
        }
        
        if contact.organizations.count > 0 {
            // Add section
            sections.append("Company")
            // Init labellist
            var labelList = [String]()
            
            for org in contact.organizations {
                // Print to test
                print("Org : \(org["organization"]!)")
                
                // Append to list
                self.organizations.append(org["organization"]!)
                labelList.append("company")
                print(organizations.count)
            }
            // Set list for section
            self.tableData["Company"] = organizations
            self.labels["Company"] = labelList
        }
        
        // Check for count
        if contact.phoneNumbers.count > 0 {
            // Add section
            sections.append("Phone Numbers")
            
            // Iterate over items
            for number in contact.phoneNumbers{
                // print to test
                // Phone number with format style
                
                if (number.values.first?.isPhoneNumber)! {
                    // Format and add to list
                    phoneNumbers.append(self.format(phoneNumber: number.values.first ?? "")!)
                }else{
                    // Add unformatted number
                    phoneNumbers.append(number.values.first!)
                }
                // Add label
                phoneNumberLabels.append(number.keys.first!)
                
                // Init record
                let record = [number.keys.first! : number.values.first!]
                // Test
                print("Phone record", record)
                
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
                self.emailLabels.append(address["type"] ?? "work")
                
                // Init record and test
                let record = ["email" : address["email"]!, "type" : address["type"] ?? "work"]
                print("Email Record", record)
                
                print(emails.count)
            }
            // Create section data
            self.tableData["Emails"] = emails
        }
        
        if contact.websites.count > 0{
            // Add section
            sections.append("Websites")
            // Init label list
            var labelList = [String]()
            
            // Iterate over items
            for address in contact.websites {
                // Print to test
                print("Website : \(address["website"]!)")
                
                // Append to list
                self.websites.append(address["website"]!)
                labelList.append("url")
                print(websites.count)
            }
            // Create section data
            self.tableData["Websites"] = websites
            self.labels["Websites"] = labelList
            
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
        
        
        if contact.notes.count > 0 {
            // Add section
            sections.append("Notes")
            // Init label list
            var labelList = [String]()
            
            for note in contact.notes {
                // Print to test
                print("Note : \(note["note"]!)")
                
                // Append to list
                self.notes.append(note["note"]!)
                // Append label
                labelList.append("note")
                print(notes.count)
            }
            // Set list for section
            self.tableData["Notes"] = notes
            self.labels["Notes"] = labelList
        }
        
        
        if contact.tags.count > 0 {
            // Add section
            sections.append("Tags")
            
            var labelList = [String]()
            
            for tag in contact.tags {
                // Print to test
                print("Title : \(tag["tag"]!)")
                
                // Append to list
                self.tags.append(tag["tag"]!)
                labelList.append("tag")
                print(tags.count)
            }
            // Set list for section
            self.tableData["Tags"] = tags
            self.labels["Tags"] = labelList
        }
        
        if contact.addresses.count > 0 {
            // Add section
            sections.append("Addresses")
            for add in contact.addresses {
                // Print to test
                //print("Address : \(add["address"]!)")
                
                // Append to list
                self.addresses.append(add.values.first!)
                self.addressLabels.append(add.keys.first!)
                
                // Init record
                let record = [add.keys.first! : add.values.first!]
                // Test
                print("Address record", record)
                
                print(addresses.count)
            }
            // Set list for section
            self.tableData["Addresses"] = addresses
        }
        
        
        // Test object
        print("Contact >> \n\(contact.toAnyObject()))")
        
        // Parse for badges
        self.parseForSocialIcons()
        
        // Parse for crop
        //self.parseForCorpBadges()
        
        // Reload table data
        self.profileInfoTableView.reloadData()
        
        
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
        // Hash images
        
        self.socialLinkBadges = [["facebook" : img1!], ["twitter" : img2!], ["instagram" : img3!], ["pinterest" : img4!], ["linkedin" : img5!], ["plus.google" : img6!], ["crunchbase" : img7!], ["youtube" : img8!], ["soundcloud" : img9!], ["flickr" : img10!], ["about.me" : img11!], ["angel.co" : img12!], ["foursquare" : img13!], ["medium" : img14!], ["tumblr" : img15!], ["quora" : img16!], ["reddit" : img17!], ["snapchat" : img18!]]
        
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
            //self.socialBadgeCollectionView.reloadData()
        }
        
        // Add image to the end of list
        //let image = UIImage(named: "icn-plus-blue")
        //self.socialBadges.append(image!)
        
        // Reload table
        self.socialBadgeCollectionView.reloadData()
        
    }
    
    
    /*
     func parseForSocialIcons() {
     
     // Badge List
     self.initializeBadgeList()
     
     print("PARSING for icons from edit profile vc")
     // Remove all items from badges
     self.socialBadges.removeAll()
     self.socialLinks.removeAll()
     
     // Assign currentuser
     //self.currentUser = ContactManager.sharedManager.currentUser
     
     // Parse socials links
     if ContactManager.sharedManager.currentUser.userProfile.socialLinks.count > 0{
     for link in ContactManager.sharedManager.currentUser.userProfile.socialLinks{
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
     //self.collectionTableView.reloadData()
     }
     
     // Add image to the end of list
     let image = UIImage(named: "Green-1")
     self.socialBadges.append(image!)
     
     // Get images
     parseAccountForImges()
     
     // Reload table
     
     //self..reloadData()
     
     }
     */
    
    
    func parseAccountForImges() {
        print("Parse account for images Executing")
        print("Parse account images count >> \(self.profileImages.count)")
        
        // Clear all from list
        self.profileImages.removeAll()
        
        print("Parse account images count post delete >> \(self.profileImages.count)")
        print("Profile images count for current user >> \(ContactManager.sharedManager.currentUser.profileImages.count)")
        
        // Set current user
        self.currentUser = ContactManager.sharedManager.currentUser
        
        // Check for image, set to imageview
        if currentUser.profileImages.count > 0{
            for img in currentUser.profileImages {
                let image = UIImage(data: img["image_data"] as! Data)
                // Append to list
                self.profileImages.append(image!)
            }
        }
        
        // Append dummy image to the end
        // Add image to the end of list
        let image = UIImage(named: "Green-1")
        self.profileImages.append(image!)
        
        print("Refreshing table of photos")
        
        // Refresh
        //self.profileImageCollectionView.reloadData()
        
    }
    
    
    func addGestureToLabel(label: UILabel, intent: String) {
        // Init tap gesture
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showSelectionOptions))
        label.isUserInteractionEnabled = true
        // Add gesture to image
        label.addGestureRecognizer(tapGestureRecognizer)
        // Set description to view based on intent
        
    }
    
    
    func showSelectionOptions() {
        // Call the viewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LabelSelectVC")
        self.present(controller, animated: true, completion: nil)
    }
    
    
    // Action sheet
    func showActionAlert() {
        // Config action
        let actionSheetController: UIAlertController = UIAlertController(title: "Please select a phone number", message: "", preferredStyle: .actionSheet)
        
        // Make Button
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        
        // Add button
        actionSheetController.addAction(cancelActionButton)
        
        
        // Check for count
        if contact.phoneNumbers.count > 0 {
            
            // Iterate over items
            for number in contact.phoneNumbers{
                
                // Add phone number button
                let digits = number.values.first!
                
                // Formatted digits
                let digitsFormatted = "\(number.keys.first ?? "phone"): \(self.format(phoneNumber: number.values.first!)!)"
                
                // Add
                let callAction = UIAlertAction(title: digitsFormatted, style: .default)
                { _ in
                    print("call")
                    
                    // Get call ready
                    // Set phone val
                    var phone: String = digits
                    
                    //print(self.selectedTransaction.recipientCard?.cardProfile.phoneNumbers[0]["phone"])
                    
                    
                    let result = String(phone.characters.filter { "01234567890.".characters.contains($0) })
                    
                    print(result)
                    
                    if let url = NSURL(string: "tel://\(result)"), UIApplication.shared.canOpenURL(url as URL) {
                        UIApplication.shared.openURL(url as URL)
                    }
                    
                }
                
                //  Add action
                actionSheetController.addAction(callAction)
                
            }
            
        }
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    
    // Action sheet
    func showActionEmailAlert() {
        // Config action
        let actionSheetController: UIAlertController = UIAlertController(title: "Please select an email address", message: "", preferredStyle: .actionSheet)
        
        // Make Button
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        
        // Add button
        actionSheetController.addAction(cancelActionButton)
        
        
        // Check for count
        if contact.emails.count > 0 {
            
            // Iterate over items
            for email in contact.emails{
                
                // Add email button
                let emailAddress = email["email"]!
                
                let emailString = "\(email["type"] ?? "email"): \(emailAddress)"
                
                // Formatted digits
                //let digitsFormatted = self.format(phoneNumber: number.values.first!)
                
                // Add
                let callAction = UIAlertAction(title: emailString, style: .default)
                { _ in
                    print("email")
                    
                    // Set selection
                    self.selectedUserEmail = emailAddress
                    
                    // Show console
                    self.showEmailCard()
                    
                }
                
                //  Add action
                actionSheetController.addAction(callAction)
                
            }
            
        }
        
        self.present(actionSheetController, animated: true, completion: nil)
    }

    
    // Action sheet
    func showActionTextAlert() {
        // Config action
        let actionSheetController: UIAlertController = UIAlertController(title: "Please select a phone number", message: "", preferredStyle: .actionSheet)
        
        // Make Button
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        
        // Add button
        actionSheetController.addAction(cancelActionButton)
        
        
        // Check for count
        if contact.phoneNumbers.count > 0 {
            
            // Iterate over items
            for number in contact.phoneNumbers{
                
                // Add phone number button
                let digits = number.values.first!
                
                // Formatted digits
                let digitsFormatted = self.format(phoneNumber: number.values.first!)
                
                // Format title
                let title = "\(number.keys.first ?? "phone"): \(digitsFormatted!)"
                
                // Add
                let callAction = UIAlertAction(title: title, style: .default)
                { _ in
                    print("call")
                    
                    // Get call ready
                    // Set phone val
                    var phone: String = digits
                    
                    //print(self.selectedTransaction.recipientCard?.cardProfile.phoneNumbers[0]["phone"])
                    
                    
                    let result = String(phone.characters.filter { "01234567890.".characters.contains($0) })
                    
                    print(result)
                    
                    // Set selection
                    self.selectedUserPhone = result
                    
                    // Show console
                    self.showSMSCard()
                    
                }
                
                //  Add action
                actionSheetController.addAction(callAction)
                
            }
            
        }
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    // Social selection
    func launchMediaWebView() {
        // Config the social link webVC
        ContactManager.sharedManager.selectedSocialMediaLink = self.socialLinks[self.selectedBadgeIndex]
        
        // Call the viewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SocialWebVC")
        self.present(controller, animated: true, completion: nil)
    }
    
    func launchWebView() {
        // Config the social link webVC
        ContactManager.sharedManager.selectedSocialMediaLink = self.websites[self.selectedBadgeIndex]
        
        // Call the viewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SocialWebVC")
        self.present(controller, animated: true, completion: nil)
    }
    
    
    // Page styling
    func populateCards(){
        
        
        //nameLabel.text = formatter.string(from: selectedContact) ?? "No Name"
        nameLabel.text = self.contact.name
        
        
         if self.contact.phoneNumbers.count > 0 {
            // Set global phone val
            self.selectedUserPhone = self.contact.phoneNumbers[0].values.first!
         }else{
         
            // Disable buttons
            callButton.isEnabled = false
            callButtonSingleWrapper.isEnabled = false
            callButtonEmptyWrapper.isEnabled = false
            smsButton.isEnabled = false
            smsButtonSingleWrapper.isEnabled = false
            smsButtonEmptyWrapper.isEnabled = false
         
            // Set tint for buttons
            callButton.tintColor = UIColor.gray
            smsButton.tintColor = UIColor.gray
         
            // Toggle image
            callButton.image = UIImage(named: "btn-call-white")
            callButtonSingleWrapper.image = UIImage(named: "btn-call-white")
            callButtonEmptyWrapper.image = UIImage(named: "btn-call-white")
            smsButton.image = UIImage(named: "btn-chat-white")
            smsButtonSingleWrapper.image = UIImage(named: "btn-chat-white")
            smsButtonEmptyWrapper.image = UIImage(named: "btn-chat-white")
         
         }
         if contact.emails.count > 0 {
            // Set global email
            self.selectedUserEmail = self.contact.emails[0]["email"]!
         
         }else{
            // Disable button
            emailButton.isEnabled = false
            emailButtonSingleWrapper.isEnabled = false
            emailButtonEmptyWrapper.isEnabled = false
         
            // Set tint
            emailButton.tintColor = UIColor.gray
            emailButtonSingleWrapper.tintColor = UIColor.gray
            emailButtonEmptyWrapper.tintColor = UIColor.gray
         
            // Toggle image
            emailButton.image = UIImage(named: "btn-message-white")
            emailButtonSingleWrapper.image = UIImage(named: "btn-message-white")
            emailButtonEmptyWrapper.image = UIImage(named: "btn-message-white")
         }
         // Check if image data available
        if contact.imageId != "" {
            print("Has IMAGE")
            // Set id
            /*let id = contact.imageId
            
            // Set image for contact
            let url = URL(string: "\(ImageURLS.sharedManager.getFromDevelopmentURL)\(id).jpg")!
            let placeholderImage = UIImage(named: "profile")!
            // Set image
            //contactImageView?.setImageWith(url)
            self.contactImageView.setImageWith(url)
            self.contactImageViewSingleWrapper.setImageWith(url)
            self.contactImageViewEmptyWrapper.setImageWith(url)*/
            
            self.contactImageView.image = UIImage(data: contact.imageData)
            self.contactImageViewSingleWrapper.image = UIImage(data: contact.imageData)
            self.contactImageViewEmptyWrapper.image = UIImage(data: contact.imageData)
            
        }else{
            // Set placeholder image
            contactImageView.image = UIImage(named: "profile")
            contactImageViewSingleWrapper.image = UIImage(named: "profile")
            contactImageViewEmptyWrapper.image = UIImage(named: "profile")
        }
        
        
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
    
    func configurePhoto(cell: UICollectionViewCell){
        // Add radius config & border color
        
        cell.contentView.layer.cornerRadius = 45.0
        cell.contentView.clipsToBounds = true
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.borderColor = UIColor.blue.cgColor
        
        // Set shadow on the container view
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowOffset = CGSize.zero
        cell.layer.shadowRadius = 0.5
        
    }
    
    func configureSelectedImageView(imageView: UIImageView) {
        // Config imageview
        
        // Configure borders
        imageView.layer.borderWidth = 0.5
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 55    // Create container for image and name
        
    }
    
    func configureViews(){
        // Toolbar button config
        
        outreachChatButton.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir", size: 14)!], for: UIControlState.normal)
        
        outreachMailButton.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir", size: 14)!], for: UIControlState.normal)
        
        outreachCallButton.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir", size: 14)!], for: UIControlState.normal)
        
        outreachCalendarButton.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir", size: 14)!], for: UIControlState.normal)
        
        outreachChatButtonSingleWrapper.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir", size: 14)!], for: UIControlState.normal)
        
        outreachMailButtonSingleWrapper.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir", size: 14)!], for: UIControlState.normal)
        
        outreachCallButtonSingleWrapper.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir", size: 14)!], for: UIControlState.normal)
        
        outreachCalendarButtonSingleWrapper.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir", size: 14)!], for: UIControlState.normal)
        
        outreachChatButtonEmptyWrapper.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir", size: 14)!], for: UIControlState.normal)
        
        outreachMailButtonEmptyWrapper.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir", size: 14)!], for: UIControlState.normal)
        
        outreachCallButtonEmptyWrapper.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir", size: 14)!], for: UIControlState.normal)
        
        outreachCalendarButtonEmptyWrapper.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir", size: 14)!], for: UIControlState.normal)
        
        
        // Config buttons
        // ** Email and call inverted
        smsButton.image = UIImage(named: "btn-chat-blue")
        emailButton.image = UIImage(named: "btn-message-blue")
        callButton.image = UIImage(named: "btn-call-blue")
        calendarButton.image = UIImage(named: "btn-calendar-blue")
        
        smsButtonSingleWrapper.image = UIImage(named: "btn-chat-blue")
        emailButtonSingleWrapper.image = UIImage(named: "btn-message-blue")
        callButtonSingleWrapper.image = UIImage(named: "btn-call-blue")
        calendarButtonSingleWrapper.image = UIImage(named: "btn-calendar-blue")
        
        smsButtonEmptyWrapper.image = UIImage(named: "btn-chat-blue")
        emailButtonEmptyWrapper.image = UIImage(named: "btn-message-blue")
        callButtonEmptyWrapper.image = UIImage(named: "btn-call-blue")
        calendarButtonEmptyWrapper.image = UIImage(named: "btn-calendar-blue")
        
        // Config image
        self.configureSelectedImageView(imageView: self.contactImageView)
        self.configureSelectedImageView(imageView: self.contactImageViewSingleWrapper)
        self.configureSelectedImageView(imageView: self.contactImageViewEmptyWrapper)
        
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
    
    // Add formatting action to textfield
    func textFieldDidChange(_ textField: UITextField) {
        
        
        if format(phoneNumber: textField.text! ) != nil
        {
            textField.text = format(phoneNumber: textField.text! )!
        }
        
    }
    
    // Notifications
    
    func postNotification() {
        
        // Notification for radar screen
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewContactAdded"), object: self)
        
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
            let cardLink = "https://project-unify-node-server.herokuapp.com/card/render/\(ContactManager.sharedManager.selectedCard.cardId!)"
            
            // Test String
            let str = "\n\n\n \(cardLink)"
            
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
        let cardLink = "https://project-unify-node-server.herokuapp.com/card/render/\(ContactManager.sharedManager.selectedCard.cardId!)"
        
        // Test String
        let str = "\n\n\n\(cardLink)"
        
        // Create Message
        mailComposerVC.setToRecipients([selectedUserEmail])
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
}
