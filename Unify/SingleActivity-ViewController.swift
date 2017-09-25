//
//  SingleActivity-ViewController.swift
//  Unify
//
//  Created by Ryan Hickman on 4/5/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit
import PopupDialog
import UIDropDown
import Eureka
import Contacts
import EventKitUI


class SingleActivityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource,  EKEventEditViewDelegate{
    
    // Properties
    // ----------------------------------
    
    var currentUser = User()
    var contact = Contact()
    let formatter = CNContactFormatter()
    
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
    
    var phoneNumberDictionaryArray = [NSDictionary]()
    var emailsDictionaryArray = [NSDictionary]()
    var addressDictionaryArray = [NSDictionary]()
    
    // Selected items
    var selectedUserPhone = ""
    var selectedUserEmail = ""
    
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
    var corpBadges: [CardProfile.Bagde] = []
    
    var count = 0
    var selectedBadgeIndex : Int = 0
    
    @IBOutlet var cardWrapperView: UIView!
    
    @IBOutlet var profileImageCollectionView: UICollectionView!
    @IBOutlet var socialBadgeCollectionView: UICollectionView!
    @IBOutlet var badgeCollectionView: UICollectionView!
    
    // Tableview
    @IBOutlet var profileInfoTableView: UITableView!
    
    // IBOutlets
    // ----------------------------------
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var contactImageView: UIImageView!
    @IBOutlet var smsButton: UIBarButtonItem!
    @IBOutlet var emailButton: UIBarButtonItem!
    @IBOutlet var callButton: UIBarButtonItem!
    @IBOutlet var calendarButton: UIBarButtonItem!
    
    
    // Outreach toolbar
    @IBOutlet var outreachChatButton: UIBarButtonItem!
    @IBOutlet var outreachCallButton: UIBarButtonItem!
    @IBOutlet var outreachMailButton: UIBarButtonItem!
    @IBOutlet var outreachCalendarButton: UIBarButtonItem!
    
    
    @IBOutlet var phoneImageView: UIImageView!
    @IBOutlet var emailImageView: UIImageView!
    @IBOutlet var badgeImageView: UIImageView!
    
   @IBOutlet var shadowView: YIInnerShadowView!
    
    // IBActions / Buttons Pressed
    // --------------------------------------------
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        
        //dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func smsSelected(_ sender: AnyObject) {
        // Call sms function
        //self.showSMSCard()
        
    }
    
    @IBAction func emailSelected(_ sender: AnyObject) {
        // Call email function
        //self.showEmailCard()
        
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
        
       /* // Check status
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            // This happens on first-run
            //requestAccessToCalendar()
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
        }*/
        
    }
    
    
    
    // Collection view Delegate && Data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.socialBadgeCollectionView {
            // Config images
            return self.socialBadges.count
        }else if collectionView == self.profileImageCollectionView{
            // Photo config
            return profileImages.count
        }else{
            // Photo config
            return corpBadges.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        //cell.backgroundColor = UIColor.blue
        
        if collectionView == self.socialBadgeCollectionView {
            // Config social badges
            // Configure corner radius
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            let image = self.socialBadges[indexPath.row]
            
            // Set image
            imageView.image = image
            
            // Cell config
            self.configureBadges(cell: cell)
            
            // Add subview
            cell.contentView.addSubview(imageView)
        }else if collectionView == self.badgeCollectionView {
            // Badge config
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            
            self.configureBadges(cell: cell)
            
            ///cell.contentView.backgroundColor = UIColor.red
            self.configureBadges(cell: cell)
            
            let fileUrl = NSURL(string: self.corpBadges[indexPath.row].pictureUrl)
            
            // Configure corner radius
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            imageView.setImageWith(fileUrl! as URL)
            // Set image
            //imageView.image = image
            
            // Add subview
            cell.contentView.addSubview(imageView)
            
        }else{
            
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            
            ///cell.contentView.backgroundColor = UIColor.red
            self.configurePhoto(cell: cell)
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
            let image = self.profileImages[indexPath.row]
            imageView.layer.masksToBounds = true
            // Set image to view
            imageView.image = image
            // Add to collection
            cell.contentView.addSubview(imageView)
            
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.badgeCollectionView {
            // Set index
            self.selectedBadgeIndex = indexPath.row
            // Config the social link webVC
            ContactManager.sharedManager.selectedSocialMediaLink = ContactManager.sharedManager.currentUser.userProfile.badgeList[indexPath.row].pictureUrl
            
            // Show WebVC
            self.launchMediaWebView()
            
        }else if collectionView == self.socialBadgeCollectionView{
            // Social link badges
            // Set selected index
            self.selectedBadgeIndex = indexPath.row
            // Config the social link webVC
            ContactManager.sharedManager.selectedSocialMediaLink = self.socialLinks[self.selectedBadgeIndex]
            
            // Show WebVC
            self.launchMediaWebView()
            
        }
        
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
       
        if sections[indexPath.section] == "Phone Numbers" || sections[indexPath.section] == "Emails" || sections[indexPath.section] == "Addresses"{
            
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
                // No tint
                cell.titleLabel.text = self.addressLabels[indexPath.row]
                
            }
            
        }
       
        return cell
        
    }
    // Set row height
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 55.0
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
        
        // Really, we parse the card and profile infos to extract the list
        // Fill profile with example info
        currentUser = ContactManager.sharedManager.currentUser
        
        // Config image
        self.configureSelectedImageView(imageView: self.contactImageView)
        
        // Parse contact 
        //self.parseContactRecord()
        
        // Parse for images
        //self.parseAccountForImges()
        
        // Parse prof for social info
        //self.parseForSocialIcons()
        // Get prof data
        self.parseDataFromProfile()
        
        // View config
        self.populateCards()
        
        
        
        // Set header and footer for table
        profileInfoTableView.tableHeaderView = self.cardWrapperView
        profileInfoTableView.tableFooterView = self.profileImageCollectionView
        
        // Observer for notifs
        addObservers()
        
        
    }
    
    // Custom methods
    
    func addObservers() {
        // Call to refresh table
        NotificationCenter.default.addObserver(self, selector: #selector(SingleActivityViewController.parseDataFromProfile), name: NSNotification.Name(rawValue: "RefreshProfile"), object: nil)
        
        
    }
    
    func launchMediaWebView() {
        // Config the social link webVC
        //ContactManager.sharedManager.selectedSocialMediaLink = self.socialLinks[self.selectedBadgeIndex]
        
        // Call the viewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SocialWebVC")
        self.present(controller, animated: true, completion: nil)
    }
    
    func launchBadgeWebView() {
        // Config the social link webVC
        ContactManager.sharedManager.selectedSocialMediaLink = self.socialLinks[self.selectedBadgeIndex]
        
        // Call the viewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SocialWebVC")
        self.present(controller, animated: true, completion: nil)
    }
    
    
    func parseDataFromProfile() {
        
        // Reset arrays
        self.bios = [String]()
        self.titles = [String]()
        self.emails = [String]()
        self.phoneNumbers = [String]()
        self.socialLinks = [String]()
        self.organizations = [String]()
        self.websites = [String]()
        self.workInformation = [String]()
        self.sections.removeAll()
        self.tableData.removeAll()
        self.tags.removeAll()
        self.addresses.removeAll()
        self.notes.removeAll()
        self.corpBadges.removeAll()
        self.phoneNumberLabels.removeAll()
        self.emailLabels.removeAll()
        self.addressLabels.removeAll()
        self.labels.removeAll()
        
        
        // Call to populate cards
        self.populateCards()
        
        // Parse bio info
        //currentUser = ContactManager.sharedManager.currentUser
        
        // Parse work info
        if ContactManager.sharedManager.currentUser.userProfile.titles.count > 0{
            // Add section
            sections.append("Titles")
            // Label list
            var labelList = [String]()
            
            for info in ContactManager.sharedManager.currentUser.userProfile.titles{
                titles.append((info["title"])!)
                labelList.append("title")
                print(info["title"])
            }
            // Create section data
            self.tableData["Titles"] = titles
            self.labels["Titles"] = labelList
        }
        
        // Parse organizations
        if ContactManager.sharedManager.currentUser.userProfile.organizations.count > 0{
            // Add section
            sections.append("Company")
            var labelList = [String]()
            
            for org in ContactManager.sharedManager.currentUser.userProfile.organizations{
                organizations.append(org["organization"]!)
                labelList.append("company")
            }
            // Create section data
            self.tableData["Company"] = organizations
            self.labels["Company"] = labelList
        }
        
        if ContactManager.sharedManager.currentUser.userProfile.bios.count > 0{
            // Add section
            sections.append("Bios")
            var labelList = [String]()
            // Iterate throught array and append available content
            for bio in ContactManager.sharedManager.currentUser.userProfile.bios{
                bios.append((bio["bio"])!)
                labelList.append("bio")
                print(bio["bio"])
            }
            
            // Create section data
            self.tableData["Bios"] = bios
            self.labels["Bios"] = labelList
        }
        
        if ContactManager.sharedManager.currentUser.userProfile.phoneNumbers.count > 0{
            // Add section
            sections.append("Phone Numbers")
            for number in ContactManager.sharedManager.currentUser.userProfile.phoneNumbers{
                phoneNumbers.append(self.format(phoneNumber:(number.values.first!))!)
                phoneNumberLabels.append(number.keys.first!)
            }
            // Create section data
            self.tableData["Phone Numbers"] = phoneNumbers
            
        }
        // Parse emails
        
        if ContactManager.sharedManager.currentUser.userProfile.emails.count > 0{
            // Add section
            sections.append("Emails")
            for email in ContactManager.sharedManager.currentUser.userProfile.emails{
                emails.append(email["email"]!)
                emailLabels.append(email["type"]!)
                
            }
            // Create section data
            self.tableData["Emails"] = emails
        }
        // Parse work info
        
        if ContactManager.sharedManager.currentUser.userProfile.workInformationList.count > 0{
            // Add section
            sections.append("Work")
            // Iterate and parse
            for info in ContactManager.sharedManager.currentUser.userProfile.workInformationList{
                workInformation.append((info["work"])!)
            }
            // Create section data
            self.tableData["Work"] = workInformation
        }
        
        // Parse websites
        if ContactManager.sharedManager.currentUser.userProfile.websites.count > 0{
            // Add section
            sections.append("Websites")
            var labelList = [String]()
            for site in ContactManager.sharedManager.currentUser.userProfile.websites{
                websites.append(site["website"]!)
                labelList.append("url")
            }
            // Create section data
            self.tableData["Websites"] = websites
            self.labels["Websites"] = labelList
            
        }
        // Parse Tags
        if ContactManager.sharedManager.currentUser.userProfile.tags.count > 0{
            // Add section
            sections.append("Tags")
            var labelList = [String]()
            
            for hashtag in ContactManager.sharedManager.currentUser.userProfile.tags{
                
                tags.append(hashtag["tag"]!)
                labelList.append("tag")
            }
            // Create section data
            self.tableData["Tags"] = tags
            self.labels["Tags"] = labelList
        }
        
        // Parse notes
        if ContactManager.sharedManager.currentUser.userProfile.notes.count > 0{
            
            // Add section
            sections.append("Notes")
            var labelList = [String]()
            
            for note in ContactManager.sharedManager.currentUser.userProfile.notes{
                
                notes.append(note["note"]!)
                labelList.append("note")
            }
            // Create section data
            self.tableData["Notes"] = notes
            self.labels["Notes"] = labelList
        }
        // Parse notes
        if ContactManager.sharedManager.currentUser.userProfile.addresses.count > 0{
            
            // Add section
            sections.append("Addresses")
            for add in ContactManager.sharedManager.currentUser.userProfile.addresses{
                
                
                // Set all values for the cells
                let street = add["street"]!
                let city = add["city"]!
                let state = add["state"]!
                let zip = add["zip"]!
                let country = add["country"]!
                
                // Create Address String
                let addressString = "\(street), \(city) \(state), \(zip), \(country)"
                
                // Append values
                addresses.append(addressString)
                addressLabels.append(add["type"]!)
                
            }
            // Create section data
            self.tableData["Addresses"] = addresses
        }
        
        // Parse socials links
        if ContactManager.sharedManager.currentUser.userProfile.socialLinks.count > 0{
            
            for link in ContactManager.sharedManager.currentUser.userProfile.socialLinks{
                
                // socialLinks.append(link["link"]!)
                print("ParseProfileData function executing")
                
            }
            
        }
        // Check for visible badges
        for badge in ContactManager.sharedManager.badgeList {
            // Check if visible
            if badge.isHidden == false {
                // Append to list
                self.corpBadges.append(badge)
                print("The bagde acount on append \(badge.pictureUrl )")
                print(self.corpBadges.count)
            }
        }

        
        print("This is the section count .. \(sections.count)")
        
        // Parse out social icons
        self.parseForSocialIcons()
        
        // Get profile
        self.parseAccountForImges()
        
        // Refresh table
        profileInfoTableView.reloadData()
        socialBadgeCollectionView.reloadData()
        profileImageCollectionView.reloadData()
        
        print("PRINTING USER from profile view")
        ContactManager.sharedManager.currentUser.printUser()
        
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
        
        if ContactManager.sharedManager.currentUser.userProfile.socialLinks.count > 0{
            for link in ContactManager.sharedManager.currentUser.userProfile.socialLinks{
         
                socialLinks.append(link["link"]!)
                // Test
                print("Count >> \(socialLinks.count)")
            }
        }
        
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
        
        // Refresh
        self.profileImageCollectionView.reloadData()
        
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
        let actionSheetController: UIAlertController = UIAlertController(title: "Please select", message: "Option to select", preferredStyle: .actionSheet)
        
        // Make Button
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        
        // Add button
        actionSheetController.addAction(cancelActionButton)
        
        // Make button
        let emailAction = UIAlertAction(title: "Email", style: .default)
        { _ in
            
            print("Email")
        }
        // Add Buttoin
        actionSheetController.addAction(emailAction)
        
        // Make
        let textAction = UIAlertAction(title: "Text", style: .default)
        { _ in
        
            print("Text")
        }
        // Add Buttoin
        actionSheetController.addAction(textAction)
        
        // Add
        let callAction = UIAlertAction(title: "Call", style: .default)
        { _ in
            print("call")
            
        }
        
        //  Add action
        actionSheetController.addAction(callAction)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func populateCards(){
        
        var currentUser = ContactManager.sharedManager.currentUser
        
        // Senders card
        // Assign current user from manager
        currentUser = ContactManager.sharedManager.currentUser
        
        if currentUser.profileImages.count > 0 {
            contactImageView.image = UIImage(data: currentUser.profileImages[0]["image_data"] as! Data)
        }
        if currentUser.fullName != ""{
            nameLabel.text = currentUser.fullName
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
        imageView.layer.cornerRadius = 45    // Create container for image and name
        
    }
    
    func configureViews(){
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
    
    
}

/*: UIViewController {
 
    // Properties
    // ------------------------------------------
 
    var active_card_unify_uuid: String?
 

 
    // IBOutlets
    // ------------------------------------------
 
    @IBOutlet var businessCardView: BusinessCardView!
 
    @IBOutlet var contactCardView: ContactCardView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
 
 
 
        // Background view configuration
 
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background")?.draw(in: self.view.bounds)
 
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
        
        // View configuration 
        configureViews()
        }
    
    

    // IBOActions / Buttons Pressed
    // ------------------------------------------
    
    @IBAction func followUpBtn_click(_ sender: Any) {
        
        
        self.performSegue(withIdentifier: "activityFollowUpSegue", sender: self)

    }

    
    // Custom Methods
    
    func configureViews(){
        
        // Configure cards
        self.businessCardView.layer.cornerRadius = 10.0
        self.businessCardView.clipsToBounds = true
        self.businessCardView.layer.borderWidth = 2.0
        self.businessCardView.layer.borderColor = UIColor.lightGray.cgColor
        
        self.contactCardView.layer.cornerRadius = 10.0
        self.contactCardView.clipsToBounds = true
        self.contactCardView.layer.borderWidth = 2.0
        self.contactCardView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        
    }

    
    // Navigation 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        print(">Passed Contact Card ID")
        print(sender!)
        
        if segue.identifier == "activityFollowUpSegue"
        {
            
            let nextScene =  segue.destination as! FollowUpViewController
            
            nextScene.active_card_unify_uuid = "\(self.active_card_unify_uuid!)" as! String?
            
        }
    }
    


}*/
