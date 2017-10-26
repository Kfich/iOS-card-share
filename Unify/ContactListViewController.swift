//
//  ContactListViewController.swift
//  Unify
//
//  Created by Kevin Fich on 6/27/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit
import Contacts



class ContactListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, CustomSearchControllerDelegate
{
    
    // IBOutlets
    // --------------------------------------
    @IBOutlet weak var tblSearchResults: UITableView!
    
    @IBOutlet var searchBarWrapperView: UIView!
    
    @IBOutlet var importContactsButton: UIButton!
    
    
    
    // Properties
    // --------------------------------------
    var formatter = CNContactFormatter()
    
    var dataArray = [String]()
    
    // Fuse for search
    let fuse = Fuse()
    
    var filteredArray = [CNContact]()
    var contactSearchResults = [Contact]()
    var contactSearchResultsInRange = [Contact]()
    
    var shouldShowSearchResults = false
    var searchInProgress = false
    
    var searchController: UISearchController!
    
    var customSearchController: CustomSearchController!
    
    var index = 0
    
    var timer = Timer()
    
    // Sorted contact list
    var letters: [String] = []
    var contacts = [String: [String]]()
    var sectionTitles = [String]()
    
    var contactObjectTable = [String: [Contact]]()
    var searchResultsTable = [String: [Contact]]()
    var contactsHashTable = [String: [CNContact]]()
    var tableData = [String: [CNContact]]()
    
    
    var tuples = [(String, String)]()
    var contactTuples = [(String, CNContact)]()
    
    var selectedContact = CNContact()
    var selectedContactObject = Contact()
    var contactObjectList = [Contact]()
    var contactList = [Contact]()
    
    var phoneContacts = [CNContact]()
    var synced = false
    var searchText = ""
    
    var refreshControl: UIRefreshControl!
    
    // Page setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Add obersevrs
        self.addObservers()
        
        tblSearchResults.delegate = self
        tblSearchResults.dataSource = self
        
        // Set delegate for empty state
        tblSearchResults.emptyDataSetSource = self
        tblSearchResults.emptyDataSetDelegate = self
        
        tblSearchResults.sectionIndexBackgroundColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)//UIColor.clear
        tblSearchResults.sectionIndexColor = UIColor.white//UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        
        // View to remove separators
        tblSearchResults.tableFooterView = UIView()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Syncing Contacts...")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tblSearchResults.addSubview(refreshControl)
        
        // Init custom search
        configureCustomSearchController()
        
        //loadListOfCountries()
        
        if ContactManager.sharedManager.contactObjectList.count != 0 {
            print("The manager array greater than zero on ConListVC ", ContactManager.sharedManager.contactObjectList.count)
            
            // Set contact list from manager
            self.phoneContacts = ContactManager.sharedManager.phoneContactList
            self.contactObjectList = ContactManager.sharedManager.contactObjectList
            self.letters = ContactManager.sharedManager.letters
            self.dataArray = ContactManager.sharedManager.dataArray
            self.tuples = ContactManager.sharedManager.tuples
            self.contactObjectTable = ContactManager.sharedManager.contactObjectTable
            
            // Hide button
            self.importContactsButton.isHidden = true
            
            // Show search bar
            self.customSearchController.customSearchBar.isHidden = false
            
            //KVNProgress.show(withStatus: "Syncing contacts...", on: self.tblSearchResults.backgroundView)
            
            // Fetch from server
            //self.sortContacts()
            
        }else{
            // Fetch contacts here
            //self.getContacts()
            
            print("The sync on ContactListVC happening")
            //KVNProgress.show(withStatus: "Syncing contacts...", on: self.tblSearchResults.backgroundView)
        }
        
        //self.fetchContactsForUser()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions
    // ------------------------
    
    @IBAction func importContacts(_ sender: Any) {
        // Clear arrays and get contacts
        print("Hey!")
        
        self.refreshTable()
        
        // Get contacts
        //self.getContacts()
    }
    
    
    // MARK: UITableView Delegate and Datasource functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if shouldShowSearchResults {
            return 1
        }else{
            // Index by letter 
            return letters.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return contactSearchResults.count
        }
        else {
            //print("Section row count >>", contactsHashTable[letters[section]]!.count)
            return contactObjectTable[letters[section]]?.count ?? 0
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        return letters//["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U", "V", "W", "X", "Y", "Z"] //String(letters)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if shouldShowSearchResults {
            print("Should show results >> \(shouldShowSearchResults)")
            return " "
        }else{
            return letters[section]
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactListCell", for: indexPath) as! ContactListCell
        
        // Get separators right
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        if shouldShowSearchResults {
            
            let contact = contactSearchResults[indexPath.row]
            
            cell.contactNameLabel?.text = contactSearchResults[indexPath.row].name//filteredArray[indexPath.row].givenName
            
            // Set image data here
            if contact.imageId != "" {
                /*print("Has IMAGE")
                // Set id
                let id = contact.imageId
                
                // Set image for contact
                let url = URL(string: "\(ImageURLS.sharedManager.getFromDevelopmentURL)\(id ?? "").jpg")!
                let placeholderImage = UIImage(named: "profile")!
                // Set image
                cell.contactImageView?.setImageWith(url)*/
                // Set from image data
                cell.contactImageView.image = UIImage(data: contact.imageData)
                
                
            }else{
                cell.contactImageView.image = UIImage(named: "profile")
            }

            
        }
        else {
            // Assign contact object
            
            let contact = contactObjectTable[letters[indexPath.section]]?[indexPath.row] ?? Contact()
            let name = contact.name //self.formatter.string(from: contact!) ?? "No Name"
            // Set name
            cell.contactNameLabel?.text = name//contactsHashTable[letters[indexPath.section]]?[indexPath.row].givenName ?? "Nothing"//dataArray[indexPath.row]
            
            // Set image data here
            if contact.imageId != "" {
                /*print("Has IMAGE")
                 // Set id
                 let id = contact.imageId
                 
                 // Set image for contact
                 let url = URL(string: "\(ImageURLS.sharedManager.getFromDevelopmentURL)\(id ?? "").jpg")!
                 let placeholderImage = UIImage(named: "profile")!
                 // Set image
                 cell.contactImageView?.setImageWith(url)*/
               
                // Set from image data
                cell.contactImageView.image = UIImage(data: (contact.imageData))
                
                
            }else{
                // Set to default
                cell.contactImageView.image = UIImage(named: "profile")
            }

            
        }
        
        
        // Set cell image
        //cell.contactImageView.image = UIImage(named: "profile")
        
        // Configure imageviews
        self.configureSelectedImageView(imageView: cell.contactImageView)
        
        // Set image
        //cell.contactImageView.image = UIImage(named: "profile")
        // Add tap gesture to follow up button
        self.addGestureToImage(image: (cell.introImageView)!, index: indexPath)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 47.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 19))
        containerView.backgroundColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        
        // Add label to the view
        let lbl = UILabel(frame: CGRect(10, 3, 20, 15))
        
        // Empty header if searching
        if shouldShowSearchResults {
            // Empty header
            lbl.text = ""
        }else{
            lbl.text = String(letters[section])
        }
        
        lbl.textAlignment = .left
        lbl.textColor = UIColor.white
        lbl.font = UIFont(name: "SanFranciscoRegular", size: CGFloat(16))
        containerView.addSubview(lbl)
        
        return containerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Deselect row
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        if shouldShowSearchResults {
            // Show results from filtered array
            print("Index path", indexPath)
            print(contactSearchResults[indexPath.row])
            
            // Set selected contact
            self.selectedContactObject = contactSearchResults[indexPath.row]
            
            
        }else{
            // Set selected contact
            self.selectedContactObject = (contactObjectTable[letters[indexPath.section]]?[indexPath.row])!
        
        }
        
        print(self.selectedContactObject.toAnyObject())
        
        // Pass segue
        self.performSegue(withIdentifier: "showContactProfile", sender: indexPath.row)

        
        
    }
    
    
    
    
    // MARK: Custom functions
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        
        if !shouldShowSearchResults || customSearchController.searchBar.text == ""{
            // Make sure search not in progress
            DispatchQueue.main.async {
                
                /*
                 // Reset all the arrays
                 self.letters.removeAll()
                 self.contacts.removeAll()
                 self.contactObjectTable.removeAll()
                 //contactsHashTable.removeAll()
                 self.tuples.removeAll()
                 self.contactTuples.removeAll()
                 self.dataArray.removeAll()*/
                
                
                
                // Fetch contact list
                self.getContacts()
                //fetchContactsForUser()
                
            }
        }
        
    }
    
    // For sending notifications to the default center for other VC's that are listening
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(ContactListViewController.refreshTable), name: NSNotification.Name(rawValue: "RefreshContactsTable"), object: nil)
        
        // RefreshContactList
        NotificationCenter.default.addObserver(self, selector: #selector(ContactListViewController.refreshTable), name: NSNotification.Name(rawValue: "RefreshContactList"), object: nil)
        
    }
    
    func refreshTable() {
        
        // Hide button
        self.importContactsButton.isHidden = true
        
        if ContactManager.sharedManager.contactObjectList.count != 0 {
            print("The manager count on refresh ", ContactManager.sharedManager.contactObjectList.count)
            
            // Hit the search config
            self.configureCustomSearchController()
            
            // Set contact list from manager
            self.phoneContacts = ContactManager.sharedManager.phoneContactList
            self.contactObjectList = ContactManager.sharedManager.contactObjectList
            self.letters = ContactManager.sharedManager.letters
            self.dataArray = ContactManager.sharedManager.dataArray
            self.tuples = ContactManager.sharedManager.tuples
            self.contactObjectTable = ContactManager.sharedManager.contactObjectTable
            
            // Show bar
            self.customSearchController.customSearchBar.isHidden = false

            
            DispatchQueue.main.async {
                // Reload table
                self.tblSearchResults.reloadData()
                
                // Show the bar
                self.customSearchController.customSearchBar.isHidden = false
                
                // Dismiss progress view
                KVNProgress.dismiss()
            }

            
            // Fetch from server
            //self.sortContacts()
            
        }else{
            
            DispatchQueue.main.async {
                
                // Reset all the arrays
                self.letters.removeAll()
                self.contacts.removeAll()
                self.contactObjectTable.removeAll()
                //contactsHashTable.removeAll()
                self.tuples.removeAll()
                self.contactTuples.removeAll()
                self.dataArray.removeAll()
                
                
                
                // Fetch contact list
                self.getContacts()
                //fetchContactsForUser()
                
            }

        }
        
        
    }
    
    func configureSelectedImageView(imageView: UIImageView) {
        // Config imageview
        
        // Configure borders
        imageView.layer.borderWidth = 0.5
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15    // Create container for image and name
        
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
    func showSyncAlert() {
        // Configure alertview
        let alertView = UIAlertController(title: "Would you like to sync your contacts?", message: "You need to authorize 'Unify' to access your contacts in your iPhone settings in order to sync your contact list", preferredStyle: .alert)
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

    
    func getContacts() {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        if status == .denied || status == .restricted {
            
            print("Permission status >> \(status)")
            
            // Show sync alert
            self.showSyncAlert()
            
            
            // Show import btn
            self.importContactsButton.isHidden = false
            
            // Send them to the setting page
            //self.presentSettingsActionSheet()
            return
        }
        
        // Hide import button
        self.importContactsButton.isHidden = true
        
        // Show alert
        //KVNProgress.show(withStatus: "Syncing contacts on get contacts call...")
        
        
        // open it
        
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, error in
            guard granted else {
                DispatchQueue.main.async {
                    self.presentSettingsActionSheet()
                }
                return
            }
            
            // get the contacts
            
            var contacts = [CNContact]()
            let request = CNContactFetchRequest(keysToFetch: [CNContactIdentifierKey as NSString, CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey as CNKeyDescriptor, CNContactJobTitleKey as CNKeyDescriptor, CNContactImageDataAvailableKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor, CNContactImageDataKey as CNKeyDescriptor, CNContactOrganizationNameKey as CNKeyDescriptor, CNContactSocialProfilesKey as CNKeyDescriptor, CNContactUrlAddressesKey as CNKeyDescriptor, CNContactNoteKey as CNKeyDescriptor, CNContactPostalAddressesKey as CNKeyDescriptor])
            // Sort users by last name
            request.sortOrder = CNContactSortOrder.familyName
            // Execute request
            do {
                try store.enumerateContacts(with: request) { contact, stop in
                    contacts.append(contact)
                }
            } catch {
                print(error)
            }
            
            // Set phone contact list
            self.phoneContacts = contacts
            
            // do something with the contacts array (e.g. print the names)
            
            self.formatter = CNContactFormatter()
            self.formatter.style = .fullName
            
            for contact in contacts {
                //print(formatter.string(from: contact) ?? "No Name")
                
                // Generate ID String
                let str = self.randomString(length: 10)
                // Assign id to object
                let contactTuple = (str, self.formatter.string(from: contact) ?? "No Name")
                let objectTuple = (str, contact)
                
                // Create tuples and append to list
                self.tuples.append(contactTuple)
                //print("Tuple >> \(contactTuple)")
                self.contactTuples.append(objectTuple)
                //print("Object Tuple >> \(objectTuple)")

                
            }
            
            // Create contact objects
            //self.contactObjectList = self.createContactRecords(phoneContactList: self.phoneContacts)
            
            // Create contact objects
            self.contactObjectList += self.createContactRecords(phoneContactList: self.phoneContacts)
            
            // Sort list
            //self.sortContacts()
            
            self.fetchContactsForUser()
            
            // Find out if contacts synced
            self.synced = UDWrapper.getBool("contacts_synced")
            print("Contacts sync value on ListVC!! >> \(self.synced)")
            
            // Sync up with main queue
            DispatchQueue.main.async {
                
            
                // Check if data synced
                if self.synced{
                    
                    print("Contacts synced for ListVC!! >> \(self.synced)")
                    //Set bool to indicate contacts have been synced
                    //UDWrapper.setBool("contacts_synced", value: true)
                    
                }else{
                    
                    // Set synced 
                    UDWrapper.setBool("contacts_synced", value: true)
                }

            }
            
        }
        /*DispatchQueue.main.async {
         
         // Sort list
         //self.sortContacts()
         // Reload the tableview.
         self.tblSearchResults.reloadData()
         }*/
    }
    
    func createContactRecords(phoneContactList: [CNContact]) -> [Contact] {
        
        // Create array of contacts
        var contactObjectList = [Contact]()
        
        // Init formatter
        let formatter = CNContactFormatter()
        formatter.style = .fullName
        
        // Iterate over list and itialize contact objects
        for contact in phoneContactList{
            
            // Init temp contact object
            let contactObject = Contact()
            
            // Set name
            contactObject.name = formatter.string(from: contact) ?? "No Name"
            
            
            var fullNameArr = contactObject.name.components(separatedBy: " ")  //split(contactName) {$0 == " "}
            let firstName: String = fullNameArr[0]
            var lastName: String = fullNameArr.count > 1 ? fullNameArr.last! : firstName
            
            if lastName.isEmpty{
                lastName = "#"
            }
            
            // Add names individually
            contactObject.first = firstName
            contactObject.last = lastName
            
            print("First ", contactObject.first, "Last ", contactObject.last)
            
            
            // Check for count
            if contact.phoneNumbers.count > 0 {
                // Iterate over items
                for number in contact.phoneNumbers{
                    // print to test
                    //print("Number: \((number.value.value(forKey: "digits" )!))")
                    
                    // Init the number
                    let digits = number.value.value(forKey: "digits") as! String
                    
                    let label = CNLabeledValue<NSString>.localizedString(forLabel: number.label ?? "work") //number.label ?? "phone"
                    
                    // Init dict
                    let record = [label : digits]
                    //print("Phone record", record)
                    
                    // Append to object
                    //contactObject.setPhoneRecords(phoneRecord: digits)
                    contactObject.phoneNumbers.append(record)
                }
                
            }
            if contact.emailAddresses.count > 0 {
                // Iterate over array and pull value
                for address in contact.emailAddresses {
                    // Print to test
                    //print("Email : \(address.value)")
                    
                    let label =  CNLabeledValue<NSString>.localizedString(forLabel: address.label ?? "work")
                    // Init dict
                    let record = ["email" : address.value as String, "type": label]
                    //print("Email record", record)
                    
                    // Append to object
                    //contactObject.setEmailRecords(emailAddress: address.value as String)
                    contactObject.emails.append(record)
                }
            }
            if contact.imageDataAvailable {
                // Print to test
                //print("Has IMAGE Data")
                
                // Create ID and add to dictionary
                // Image data png
                
                // **** Check here if contact image valid --> This caused lyss' phone to crash ***** \\
                
                if let imageData = contact.imageData{
                    
                    // Assign image to contact for local use
                    contactObject.imageData = imageData
                    
                    
                    // Assign asset name and type
                    let idString = contactObject.randomString(length: 20)
                    
                    // Name image with id string
                    let fname = idString
                    let mimetype = "image/png"
                    
                    // Create image dictionary
                    let imageDict = ["image_id":idString, "image_data": imageData, "file_name": fname, "type": mimetype] as [String : Any]
                    
                    
                    // Append to object
                    contactObject.setContactImageId(id: idString)
                    contactObject.imageDictionary = imageDict
                    
                    
                    if self.synced != true {
                        // Upload Record
                        ImageURLS.sharedManager.uploadImageToDev(imageDict: imageDict)
                    }else{
                        //
                        print("The users image has been uploaded already")
                    }
                    
                }
                
                
            }
            if contact.urlAddresses.count > 0{
                // Iterate over items
                for address in contact.urlAddresses {
                    // Print to test
                    //print("Website : \(address.value as String)")
                    
                    // Append to object
                    contactObject.setWebsites(websiteRecord: address.value as String)
                }
                
            }
            if contact.socialProfiles.count > 0{
                // Iterate over items
                for profile in contact.socialProfiles {
                    // Print to test
                    //print("Social Profile : \((profile.value.value(forKey: "urlString") as! String))")
                    
                    // Create temp link
                    let link = profile.value.value(forKey: "urlString")  as! String
                    
                    // Append to object
                    contactObject.setSocialLinks(socialLink: link)
                }
                
            }
            
            if contact.jobTitle != "" {
                //Print to test
                //print("Job Title: \(contact.jobTitle)")
                
                // Append to object
                contactObject.setTitleRecords(title: contact.jobTitle)
            }
            if contact.organizationName != "" {
                //print to test
                //print("Organization : \(contact.organizationName)")
                
                // Append to object
                contactObject.setOrganizations(organization: contact.organizationName)
            }
            if contact.note != "" {
                //print to test
                //print(contact.note)
                
                // Append to object
                contactObject.setNotes(note: contact.note)
                
            }
            
            
            if contact.postalAddresses.count > 0{
                
                print("The postal address")
                let address = contact.postalAddresses.first?.value
                
                let formatter = CNPostalAddressFormatter()
                formatter.style = .mailingAddress
                
                let city = contact.postalAddresses.first?.value.city ?? ""
                let state = contact.postalAddresses.first?.value.state ?? ""
                let street = contact.postalAddresses.first?.value.street ?? ""
                let zip = contact.postalAddresses.first?.value.postalCode ?? ""
                let country = contact.postalAddresses.first?.value.country ?? ""
                
                // Init address
                let addy = "\(street), \(city) \(state), \(zip), \(country)"
                // Init label and record
                let label =  CNLabeledValue<NSString>.localizedString(forLabel: contact.postalAddresses.first?.label ?? "home")
                let record = [label : addy]

                //print("Address record", record)
                
                //let formattedAddress = formatter.string(from: address!)
                
                //let trimmed = String(formattedAddress.characters.filter { !"\n\t\r".characters.contains($0) })
                
                
                
                //print("The address is \(addy)")
                
                
                // Append to object
                //contactObject.setAddresses(address: addy)
                contactObject.addresses.append(record)
                
            }
            
            // Test object
            //print("Contact >> \n\(contactObject.toAnyObject()))")
            
            // Parse own record
            contactObject.parseContactRecord()
            
            // Append object to contactObjectList
            contactObjectList.append(contactObject)
            
            
            // Print count
            print("List Count On ContactListVC... \(contactObjectList.count)")
        }
        
        return contactObjectList
    }
    
    func presentSettingsActionSheet() {
        let alert = UIAlertController(title: "Permission to Contacts", message: "This app needs access to contacts in order to sync your contact list", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default) { _ in
            let url = URL(string: UIApplicationOpenSettingsURLString)!
            UIApplication.shared.open(url)
        })
        
        // Add action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // Show the alert
        present(alert, animated: true)
    }

    
    // Search Bar Configuration & Delegates
    
    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        
        // Place the search bar view to the tableview headerview.
        tblSearchResults.tableHeaderView = searchController.searchBar
    }
    
    
    func configureCustomSearchController() {
        
        // Init blue color
        let blue = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        
        customSearchController = CustomSearchController(searchResultsController: self, searchBarFrame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: 35.0), searchBarFont: UIFont(name: "Avenir", size: 16.0)!, searchBarTextColor: blue, searchBarTintColor: UIColor.white)
        
        customSearchController.customSearchBar.placeholder = "Search"
        customSearchController.customSearchBar.tintColor = blue
        //tblSearchResults.tableHeaderView = customSearchController.customSearchBar
        
        customSearchController.customDelegate = self
        customSearchController.customSearchBar.isHidden = true
        
        // Add to view
        self.searchBarWrapperView.addSubview(customSearchController.customSearchBar)
    }
    
    
    // MARK: UISearchBarDelegate functions
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        tblSearchResults.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tblSearchResults.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tblSearchResults.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    
    // MARK: UISearchResultsUpdating delegate function
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else {
            return
        }
        
        
        DispatchQueue.main.async {
            
            // Init search results
            let results = self.fuse.search(searchString, in: self.contactObjectList)
            
            results.forEach { item in
                print("\n\n---------------")
                print("index: ", item.index)
                print("score: ", item.score)
                print("results: ", item.results)
                print("---------------")
            }
            
            //print("Results >> \(results)")
            
            /*self.contactSearchResults = results.map { (index, _, matchedRanges) in
                let contact = self.contactObjectList[index]
                
                //print("Contact Object >> \(book.toAnyObject())")
                
                return contact
                
            }*/
            // Refresh table
            //
            
            
        }
        
        
        
        /*// Filter the data array and get only those countries that match the search text.
        filteredArray = dataArray.filter({ (country) -> Bool in
            let countryText:NSString = country as NSString
            
            return (countryText.range(of: searchString, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })*/
        
        // Reload the tableview.
        //tblSearchResults.reloadData()
    }
    
    
    // MARK: CustomSearchControllerDelegate functions
    
    func didStartSearching() {
        shouldShowSearchResults = true
        
        // Update results
        //updateSearchResults(for: self.customSearchController)
        self.tblSearchResults.reloadData()
    }
    
    
    func didTapOnSearchButton() {
       
        // Toggle progress
        self.searchInProgress = true
        
        
        // Clear search results array
        self.contactSearchResults.removeAll()
        
        // Async on queue
        DispatchQueue.main.async {
            
            // Show progress
            KVNProgress.show(withStatus: "Searching...")
            
            
            // Init search results
            let results = self.fuse.search(self.searchText, in: self.contactObjectList)
            
            let match = results.filter {$0.score < 0.05}
            
            let inRange = results.filter {$0.score > 0.05 && $0.score < 0.125}
            
            print("Match Results Count", match.count)
            print("In Range Results ", inRange.count)
            
            self.contactSearchResults = match.map { (index, score, matchedRanges) in
                
                print("Score ", score)
                //print("Ranges Matched ", matchedRanges.)
                
                // Init contact from results
                let contact = self.contactObjectList[index]
                
                return contact
                
            }
            
            print("Match Results ", self.contactSearchResults)
            
            self.contactSearchResultsInRange = inRange.map{ (index, score, matchedRanges) -> Contact in
                
                print("Score ", score)
                //print("Ranges Matched ", matchedRanges.)
                
                // Init contact from results
                let contact = self.contactObjectList[index]
                
                return contact
                
            }
            
            print("In Range ", self.contactSearchResultsInRange)
            
            // Make table
           // self.searchResultsTable[""] = []
           // self.searchResultsTable[""] = self.contactSearchResults
            
          //  self.searchResultsTable["Other"] = []
          //  self.searchResultsTable["Other"] = closeResults
            
            print("Results table ", self.searchResultsTable)
            
            // Sort results
            self.sortSearchResultContacts()
            

            // Refresh table
            //self.tblSearchResults.reloadData()
            
        }
        
        // Toggle bool
        
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            // Hit search endpoint
            self.tblSearchResults.reloadData()
        }
        
        // Refresh table
        //self.tblSearchResults.reloadData()
        
    }
    
    
    func didTapOnCancelButton() {
        shouldShowSearchResults = false
        searchInProgress = false
        // Empty list
        self.contactSearchResults.removeAll()
        self.tblSearchResults.reloadData()
        
    }
    
    func didChangeSearchText(_ searchText: String) {
        
        self.searchText = searchText
        
        print("self search text \(self.searchText)")
    }
    
    
    // Custom Methods
    
    
    func searchContacts() {
        
        print("Searching transaction")
        
        let searchString = customSearchController.customSearchBar.text ?? ""
        
        
        
        // Export transaction
        let parameters = ["uuid" : ContactManager.sharedManager.currentUser.userId, "search": searchString]
        
        // Show HUD
        KVNProgress.show(withStatus: "Searching..")
        
        // Clear results
        self.contactSearchResults.removeAll()
        self.tblSearchResults.reloadData()
        
        // Send to sever
        
        Connection(configuration: nil).searchContactsCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Get contacts Response ---> \(String(describing: response))")
                
                // Init dictionary to capture response
                if let dictionary = response as? [String : Any] {
                    // // Parse dictionary for array of trans
                    let dictionaryArray = dictionary["contacts"] as! NSArray
                    
                    // Iterate over array, append trans to list
                    for item in dictionaryArray {
                        // Update counter
                        // Init user objects from array
                        let contact = Contact(snapshot: item as! NSDictionary)
                        print("Transaction List")
                        //trans.printTransaction()
                        
                        
                        // Append users to radarContacts array
                        self.contactSearchResults.append(contact)
                    }
                    
                    // Sort list
                    self.sortSearchResultContacts()
                    
                    
                    // Update the table values
                    self.tblSearchResults.reloadData()
                    
                    
                }else{
                    print("Array empty !!!!")
                    // dismiss HUD
                    KVNProgress.dismiss()
                }
                
                
            } else {
                print("Rejection Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error with your introduction. Please try again.")
                
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
    }

    
    // Generate random string for transaction id
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    // Check if char is a letter
    func isAlpha(char: Character) -> Bool {
        switch char {
        case "a"..."z":
            return true
        case "A"..."Z":
            return true
        default:
            return false
        }
    }
    // Check if string char is a letter
    func isAlphaString(char: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "[:alpha:]", options: [])
        return regex.firstMatch(in: char, options: [], range: NSMakeRange(0, char.characters.count)) != nil
    }
    
    // Rearrang idecies in an array
    func rearrange<T>(array: Array<T>, fromIndex: Int, toIndex: Int) -> Array<T>{
        var arr = array
        // Set element
        let element = arr[fromIndex]
        // Append to array
        arr.insert(element, at: toIndex)
        // Now remove from beginning
        arr.remove(at: fromIndex)
        
        return arr
    }
    
    func sortContacts() {
        // Test for sorting contacts by last name into sections
        
        //let data = self.dataArray // Example data, use your phonebook data here.
        
        // Build letters array:
        
        //letters: [Character]
        // Init data array
        dataArray = self.tuples.map { $0.1 }
        
        
        letters = dataArray.map { (name) -> String in
            //print("UPPER CASE HERE")
            let nameToUpper = name.uppercased()
            
            var fullNameArr = nameToUpper.components(separatedBy: " ")  //split(contactName) {$0 == " "}
            let firstName: String = fullNameArr[0]
            var lastName: String = fullNameArr.count > 1 ? fullNameArr.last! : firstName
            
            if lastName.isEmpty{
                lastName = "No Name"
            }
            
            // Check if letter in the alphabet
            if isAlphaString(char: String(lastName[lastName.startIndex])){
                
                return String(lastName[lastName.startIndex])
                
            }else{
                
                // Otherwise return #
                print("Not a string", String(lastName[lastName.startIndex]))
                return "#"
            }
        }
        
        // Sort letters array
        letters = letters.sorted()
        
        // Reduce letters to single count for each
        letters = letters.reduce([], { (list, name) -> [String] in
            if !list.contains(name) {
                // Test to see if letters added
                //print("\n\nAdded >>>> \(list + [name])")
                return list + [name]
            }
            return list
        })
        
        // If first index is the misc, move to end of array
        if letters.first == "#" {
            // Move to end of array
            letters = self.rearrange(array: letters, fromIndex: 0, toIndex: letters.endIndex)
            // Test
            //print("The new letters array\n\(letters)")
        }
        
        
        // Create indicies based on letters
        for letter in letters{
            
            // Create section in hash table
            contactsHashTable[letter] = [CNContact]()
            // Unify contacts table
            contactObjectTable[letter] = [Contact]()

        }
        
        // Unify Contacts
        for contact in self.contactObjectList{
            // Init contact name
            var contactName : String = contact.name 
            // Uppercase the name
            contactName = contactName.uppercased()
            
            // Init full name
            var fullNameArr = contactName.components(separatedBy: " ")
            
            // Init first name just in case no last exists
            let firstName: String = fullNameArr[0]
            // Retieve last name
            var lastName: String = fullNameArr.count > 1 ? fullNameArr.last! : firstName
            
            //print("First + Last", firstName, lastName)
            
            
            // Check if letter in the alphabet
            if isAlphaString(char: String(lastName.characters.first ?? "#")){
                
                // Check if section exists
                if contactObjectTable[String(describing: lastName.characters.first ?? "#")] == nil{
                    //print("Hash Section Empty!")
                    // If empty, initialize list
                    contactObjectTable[String(describing: lastName.characters.first ?? "#")] = []
                }
                // Add contact to list
                //let charString = self.formatter.string(from: contact)?.uppercased() ?? "NO NAME"
                let startIndex = String(describing: lastName.characters.first ?? "#")
                //print("Start Index: >> \(startIndex)")
                
                contactObjectTable[startIndex]!.append(contact)
                //print("Section count for added item", contact.toAnyObject())
                //print(contactsHashTable[startIndex]?.count)
                
            }else{
               
                // Check if first name valid
                // Check if section exists
                if contactObjectTable[String(describing: firstName.characters.first ?? "#")] == nil{
                    //print("Hash Section Empty!")
                    // If empty, initialize list
                    contactObjectTable[String(describing: firstName.characters.first ?? "#")] = []
                }
                // Add contact to list
                //let charString = self.formatter.string(from: contact)?.uppercased() ?? "NO NAME"
                let startIndex = String(describing: firstName.characters.first ?? "#")
                //print("Start Index: >> \(startIndex)")
                
                contactObjectTable[startIndex]!.append(contact)
                //print("Section count for added item", contact.toAnyObject())
                //print(contactsHashTable[startIndex]?.count)
                
            }
            
        }
        
        
        // Assign table data 
        //self.tableData = contactsHashTable
        
        //print("Table Data \n\(self.tableData)")
        
        //print(contactObjectTable)
        
        //print("The Table Count >> ", contactObjectTable.count)
        
        
        DispatchQueue.main.async {
            
            // Reload data
            self.tblSearchResults.reloadData()
            
            // End refreshing
            self.refreshControl.endRefreshing()
        }
        
        // Set hash to contact manager
        //ContactManager.sharedManager.contactsHashTable = self.contactsHashTable

    }

    // Sorting search results list
    
    func sortSearchResultContacts() {
        
        var nameList = contactSearchResults.map {$0.last}
        print("Original Search list\n", nameList)
        
        // Sort by last name
        contactSearchResults = contactSearchResults.sorted { $0.name < $1.name }
        contactSearchResults = contactSearchResults.sorted { $0.last < $1.last }
        
        print("Sorting the names")
        
        nameList.removeAll()
        nameList = contactSearchResults.map {$0.last}
        
        print("Sorted Search list\n", nameList)
        
        // Sort range list
        contactSearchResultsInRange = contactSearchResultsInRange.sorted { $0.last < $1.last }
        
        // Append results out of range to bottom of list
        contactSearchResults += self.contactSearchResultsInRange
        
        
        
        DispatchQueue.main.async {
            
            // Reload data
            self.tblSearchResults.reloadData()
            
            // Drop it
            KVNProgress.dismiss()
        }
        
        // Toggle bool off
        self.searchInProgress = false
        
        // Set hash to contact manager
        //ContactManager.sharedManager.contactsHashTable = self.contactsHashTable
        self.tblSearchResults.reloadData()
    }

    
    
    
    
    func addGestureToImage(image: UIImageView, index: IndexPath) {
        // Init tap gesture
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showIntroWithContact(sender:)))
        image.isUserInteractionEnabled = true
        // Add gesture to image
        image.addGestureRecognizer(tapGestureRecognizer)
        // Set image index
        image.tag = index.row
        image.accessibilityIdentifier = String(index.section)
        
    }
    
    func showIntroWithContact(sender: UITapGestureRecognizer){
        
        let row = (sender.view?.tag)!
        let section = Int((sender.view?.accessibilityIdentifier)!)
        
        print("Section:", section)
        print("Row :" , row)
        
        
        if shouldShowSearchResults {
            // Show results from filtered array
            
            
        }else{
           
            // Set selected contact
            self.selectedContactObject = (contactObjectTable[letters[section!]]![row])
            
            self.selectedContact = self.contactToCNContact(contact: self.selectedContactObject)
            
            
            // Set contact to manager
            ContactManager.sharedManager.contactToIntro = selectedContact
            
            // Set navigation toggle on manager to indicate intent
            ContactManager.sharedManager.userArrivedFromContactList = true
            ContactManager.sharedManager.userArrivedFromIntro = true
            
            // Notification for intro screen
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ContactSelected"), object: self)        // Set selected tab
            
            
            // Sync up with main queue
            DispatchQueue.main.async {
                // Set selected tab
                self.tabBarController?.selectedIndex = 1
            }

            
        }

        
        /*
        var selectedId = ""
        
        if shouldShowSearchResults {
            // Show results from filtered array
            print(filteredArray[row])
            
            // Search for contact by name in list
            /*for item in self.tuples {
                if item.1 == filteredArray[row] {
                    // This is the selected item
                    print("Selected Item: >> \(item)")
                    // Set Id
                    selectedId = item.0
                }
                
                
            }*/
            
            
        }else{
            //print("Index path for data array", indexPath)
            //print(dataArray[indexPath.row])
            
            // Search for contact by name in list
            for item in self.tuples {
                if item.1 == contacts[letters[section!]]?[row]{
                    // This is the selected item
                    print("Selected Item: >> \(item)")
                    // Set Id
                    selectedId = item.0
                }
                
                
            }
            
            // Set contact from list
            for item in contactTuples{
                if item.0 == selectedId {
                    // Set contact object
                    self.selectedContact = item.1
                    
                    // Print to test
                    print(self.selectedContact.givenName)
                    
                    // Set contact to manager
                    ContactManager.sharedManager.contactToIntro = selectedContact
                    
                    // Set navigation toggle on manager to indicate intent
                    ContactManager.sharedManager.userArrivedFromContactList = true
                    ContactManager.sharedManager.userArrivedFromIntro = true
                    
                    // Notification for intro screen
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ContactSelected"), object: self)        // Set selected tab
                    
                    
                    // Sync up with main queue
                    /*DispatchQueue.main.async {
                        // Set selected tab
                        self.tabBarController?.selectedIndex = 1
                    }*/
                    
                    
                }
            }

            
            //print("The output <> \(String(describing: contacts[letters[indexPath.section]]?[indexPath.row]))")
        }*/

        
    }
    
    func uploadContactRecords(){
        // Call function from manager
        //ContactManager.sharedManager.uploadContactRecords()
        
        timer = Timer.scheduledTimer(timeInterval: 0.2 , target: self, selector: #selector(ContactListViewController.uploadRecord), userInfo: nil, repeats: true)
        
        //  Start timer
        timer.fire()
        
    }
    
    func uploadRecord(){
        
        print("hello World")
        // Assign contact
        let contact = self.contactObjectList[self.index]
        
        // Create dictionary
        let parameters = ["data" : contact.toAnyObject(), "uuid" : ContactManager.sharedManager.currentUser.userId] as [String : Any]
        print(parameters)
        
        // Send to server
        Connection(configuration: nil).uploadContactCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                // Call successful
                print("Transaction Created Response ---> \(String(describing: response))")
                
                
            } else {
                // Error occured
                print("Transaction Created Error Response ---> \(String(describing: error))")
                
                // Show user popup of error message
                
                
            }
            // Hide indicator
            
            
        }
        
        // Check if we're at the end of the list
        if self.index < self.contactObjectList.count - 1{
            
            // Increment index
            self.index = self.index + 1
            
        }else{
            // Turn off timer to end execution
            self.timer.invalidate()
            
            //Set bool to indicate contacts have been synced
            UDWrapper.setBool("contacts_synced", value: true)
        }
        
        
    }
    
    func deleteContactsForUser() {
        // Fetch the user data associated with users
        
        // Hit endpoint for updates on users nearby
        let parameters = ["uuid": ContactManager.sharedManager.currentUser.userId]
        
        print(">>> SENT PARAMETERS >>>> \n\(parameters))")
        
        
        // Create User Objects
        Connection(configuration: nil).deleteContactsCall(parameters, completionBlock: { response, error in
            
            if error == nil {
                
                print("\n\nDeleting Contacts >>> \(response)\n\n")
                
                
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
    
    // Contact management
    
    func contactToCNContact(contact: Contact) -> CNMutableContact {
        
        // Set text for name
        let contactToAdd = CNMutableContact()
        //contactToAdd.givenName = self.firstNameLabel.text ?? ""
        //contactToAdd.familyName = self.lastNameLabel.text ?? ""
        
        // Init formatter
        let formatter = CNContactFormatter()
        formatter.style = .fullName
        
        // Iterate over list and itialize contact objects
        
        // Set name
        //contactObject.name = formatter.string(from: contact) ?? "No Name"
        
        let fullName = contact.name
        var fullNameArr = fullName.components(separatedBy: " ")
        let firstName: String = fullNameArr[0]
        let lastName: String = fullNameArr.count > 1 ? fullNameArr.last! : ""
        
        // Add names
        contactToAdd.givenName = firstName
        contactToAdd.familyName = lastName
        
        /*
         // Parse for mobile
         let mobileNumber = CNPhoneNumber(stringValue: (contact.phoneNumbers[0].values.first ?? ""))
         let mobileValue = CNLabeledValue(label: CNLabelPhoneNumberMobile, value: mobileNumber)
         contactToAdd.phoneNumbers = [mobileValue]*/
        
        
        // Set organizations
        if contact.organizations.count > 0 {
            // Add to contact
            contactToAdd.organizationName = contact.organizations[0]["organization"]!
        }
        
        
        
        // Check for count
        if contact.phoneNumbers.count > 0 {
            
            var mobiles = [CNLabeledValue<CNPhoneNumber>]()
            // Iterate over items
            for number in contact.phoneNumbers{
                // print to test
                //print("Number: \((number.value.value(forKey: "digits" )!))")
                
                // Parse for mobile
                let mobileNumber = CNPhoneNumber(stringValue: (number.values.first ?? ""))
                let mobileValue = CNLabeledValue(label: CNLabelPhoneNumberMobile, value: mobileNumber)
                
                // Add objects to phone list
                mobiles.append(mobileValue)
            }
            // Add phones as value
            contactToAdd.phoneNumbers = mobiles
            
            
        }
        
        
        
        // Parse for emails
        if contact.emails.count > 0 {
            
            var emails = [CNLabeledValue<NSString>]()
            // Iterate over array and pull value
            for address in contact.emails {
                // Print to test
                print("Email : \(address["email"]!)")
                
                // Parse for emails
                let email = CNLabeledValue(label: address["type"] ?? CNLabelWork, value: address["email"] as NSString? ?? "")
                emails.append(email)
            }
            
            // Add array as value
            contactToAdd.emailAddresses = emails
            
        }
        
        /*
         // Parse for image data
         if contact.imageId != "" {
         // Assign
         contactToAdd.imageData = contact.imageData
         }*/
        
        
        
        // Parse sites
        if contact.websites.count > 0{
            // Add sites
            for site in contact.websites {
                // Format labeled value
                contactToAdd.urlAddresses.append(CNLabeledValue(
                    label: "url", value: site["website"]! as NSString))
            }
        }
        
        // Parse sites
        if contact.socialLinks.count > 0{
            
            // Init list
            var socials = [CNLabeledValue<CNSocialProfile>]()
            
            // Add sites
            for site in contact.socialLinks {
                
                let profile = CNLabeledValue(label: "social", value: CNSocialProfile(urlString: site["link"]!, username: "", userIdentifier: "", service: nil))
                
                // Add to prof list
                socials.append(profile)
                
                print("printing social link", site["link"]!)
                
                
            }
            
            // Append to object
            contactToAdd.socialProfiles = socials
        }
        
        
        
        // Parse badges
        if contact.badgeDictionaryList.count > 0{
            // Add badge links as sites
            // Parse for corp
            for corp in contact.badgeDictionaryList {
                
                // Init badge
                //let badge = Contact.Bagde(snapshot: corp)
                
                print("The badge on contact convert", corp)
                
                if corp["website"] is String {
                    
                    // Add to list
                    contactToAdd.urlAddresses.append(CNLabeledValue(
                        label: "badge", value: corp["url"] as? NSString ?? ""))
                    
                    // Add to list
                    contactToAdd.urlAddresses.append(CNLabeledValue(
                        label: "imageURL", value: corp["image"] as? NSString ?? ""))
                }else{
                    
                    let websiteArray = corp["image"] as? NSArray ?? NSArray()
                    
                    for item in websiteArray {
                        // Append items individually
                        // Add to list
                        contactToAdd.urlAddresses.append(CNLabeledValue(
                            label: "badgeURL", value: item as? NSString ?? ""))
                    }
                    
                    let imageArray = corp["url"] as? NSArray ?? NSArray()
                    
                    for item in imageArray {
                        // Append items individually
                        // Add to list
                        contactToAdd.urlAddresses.append(CNLabeledValue(
                            label: "imageURL", value: item as? NSString ?? ""))
                        
                    }
                    
                    
                    
                }
                
                
                
            }
        }
        
        // Parse company info
        if contact.organizations.count > 0 {
            // add company
            contactToAdd.organizationName = contact.organizations[0]["organization"] ?? ""
        }
        
        // Parse titles
        if contact.titles.count > 0 {
            // add title
            contactToAdd.jobTitle = contact.titles[0]["title"] ?? ""
            
        }
        
        // Format a notes string to hold extra data
        var notesString = ""
        
        // Parse notes
        if contact.notes.count > 0 {
            
            // Add label to notes string
            notesString += "Unify Notes:"
            
            // Format notes field
            for note in contact.notes {
                // Add note to string
                notesString += "\n\(note["note"] ?? "")"
                
            }
        }
        
        // Parse notes
        if contact.tags.count > 0 {
            // Format notes field
            // Add label to notes string
            notesString += "\nUnify Tags:"
            
            // Format notes field
            for tag in contact.tags {
                // Add note to string
                notesString += "\n\(tag["tag"] ?? "")"
                
            }
        }
        
        // Parse notes
        if contact.bioList != "" {
            // Format notes field
            // Add label to notes string
            notesString += "\nUnify Bios:"
            
            // Append value to string
            notesString += "\n\(contact.bioList)"
            
        }
        
        // Parse notes
        if contact.isVerified == "1" {
            // Format notes field
            // Add label to notes string
            notesString += "\nUnify Verified: 1"
            
            
        }
        
        // Add note to contact object
        contactToAdd.note = notesString
        
        
        // Parse address info
        if contact.addresses.count > 0 {
            // Format in notes field
            
            for address in contact.addresses {
                
                // Parse address
                let postal = CNMutablePostalAddress()
                postal.street = address["street"] ?? ""
                postal.city = address["city"] ?? ""
                postal.state = address["state"] ?? ""
                postal.postalCode = address["zip"] ?? ""
                postal.country = address["country"] ?? ""
                
                let home = CNLabeledValue<CNPostalAddress>(label:CNLabelHome, value:postal)
                
                contactToAdd.postalAddresses = [home]
                
            }
            
            
        }
        
        
        // Cast mutable contact back to regular contact
        //cnObject = contactToAdd as CNContact
        
        print("Immutable Copy \(contactToAdd)")
        print("Immutable Copy Phones \(contactToAdd.phoneNumbers)")
        print("Immutable Copy Emails \(contactToAdd.emailAddresses)")
        print("Immutable Copy URLs \(contactToAdd.urlAddresses)")
        print("Immutable Copy Notes \(contactToAdd.note)")
        print("Immutable Copy address \(contactToAdd.postalAddresses)")
        print("Immutable Copy Company \(contactToAdd.organizationName)")
        
        
        // Return the non mutable copy
        return contactToAdd
        
    }
    
    func fetchContactsForUser() {
        // Fetch the user data associated with users
        
        var errorOccured = false
        
        // Hit endpoint for updates on users nearby
        let parameters = ["uuid": ContactManager.sharedManager.currentUser.userId]
        
        print(">>> SENT PARAMETERS >>>> \n\(parameters))")
        // Show progress
        //KVNProgress.show(withStatus: "Fetching details on the activity...")
        
        // Create User Objects
        Connection(configuration: nil).getContactsCall(parameters, completionBlock: { response, error in
            
            if error == nil {
                
                //print("\n\nConnection - Radar Response: \n\n>>>>>> \(response)\n\n")
                
                // Init dictionary to capture response
                let userArray = response as? NSDictionary
                // // Parse dictionary for array of trans
                //print(userArray)
                
                let userList = userArray?["data"] as! NSArray
                
                
                // Iterate over array, append trans to list
                for item in userList{
                    
                    print("Contact Item >> \(item)")
                    
                    let social = item as! NSDictionary
                    
                    print("The newest social", social["addresses"] as Any /*as? NSArray ?? NSArray()*/)
                    
                    // Init user objects from array
                    let contact = Contact(arraySnapshot: item as! NSDictionary)
                    
                    //print("Contact Object Item >>")
                    //print(contact.toAnyObject())
                    
                    // Append users to Selected array
                    self.contactObjectList.append(contact)
                    
                    // Generate ID String
                    let str = self.randomString(length: 10)
                    // Assign id to object
                    let contactTuple = (str, contact.name)
                    
                    // Create tuples and append to list
                    self.tuples.append(contactTuple)
                    print("Tuples array", self.tuples)
                    
                    //print(self.contactObjectList.count, "Object count")
                }
                
                // sort contacts
                self.sortContacts()
                
                // Show sucess
                //KVNProgress.showSuccess()
                
                
            } else {
                print(error)
                // Show user popup of error message
                print("\n\nConnection - User Fetch Error: \n\n>>>>>>>> \(error)\n\n")
                //KVNProgress.showError(withStatus: "There was an issue getting activities. Please try again.")
                
                // Set the bool to true
                errorOccured = true
                
                if errorOccured == true{
                    
                    DispatchQueue.main.async {
                        // Sort and refresh table
                        self.sortContacts()
                    }
                    
                }
                
            }
            // Regardless, hide hud
            //KVNProgress.dismiss()
            
        })
        
    }
    
    
    // Empty State Delegate Methods
    
    // Settings
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
            
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
        var emptyString = ""
        
        if ContactManager.sharedManager.synced && !shouldShowSearchResults{
            // Show syncing progress
            emptyString = "Syncing contacts..."
            
            // Hide button
            self.importContactsButton.isHidden = true
            
        }else if searchInProgress{
            // Show syncing progress
            emptyString = "Searching contacts..."
            
        }else if !ContactManager.sharedManager.synced{
            // Contacts not imported
            emptyString = "Contacts Not Imported"
        }
        
        // Make attrib string
        let attrString = NSAttributedString(string: emptyString)
        
        return attrString
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        // Config Message for user
        
        // Configure string
        var emptyString = ""
        
        if ContactManager.sharedManager.synced && !shouldShowSearchResults{
            // Show syncing progress
            emptyString = "This may take a moment"
        }else if !ContactManager.sharedManager.synced{
            // Contacts not imported
            emptyString = "Syncing your contacts enables you to enjoy the full Unify experience"
        }
    
        // Init attrib string
        let attrString = NSAttributedString(string: emptyString)
        
        return attrString
        
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControlState) -> NSAttributedString? {
        // Config button for data set
        var emptyString = ""
        
        if ContactManager.sharedManager.synced {
            // Show syncing progress
            emptyString = ""
        }else{
            // Contacts not imported
            emptyString = "Import"
        }
        
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
        
        // Sync contact list
        self.refreshTable()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showContactProfile"{
            // Find destination
            let destination = segue.destination as! ContactListProfileViewController
            // Assign selected contact object
            destination.selectedContact = self.selectedContact
            destination.contact = self.selectedContactObject
            
            // Test
            print("Contact Passed in Seggy >> \(destination.contact.toAnyObject())")
        }
        
        
    }
    
    
}
    
