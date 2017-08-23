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
    
    
    // Properties
    // --------------------------------------
    var formatter = CNContactFormatter()
    
    var dataArray = [String]()
    
    
    var filteredArray = [CNContact]()
    var contactSearchResults = [Contact]()
    
    var shouldShowSearchResults = false
    
    var searchController: UISearchController!
    
    var customSearchController: CustomSearchController!
    
    var index = 0
    
    var timer = Timer()
    
    // Sorted contact list
    var letters: [String] = []
    var contacts = [String: [String]]()
    
    var contactObjectTable = [String: [Contact]]()
    var contactsHashTable = [String: [CNContact]]()
    var tableData = [String: [CNContact]]()
    
    
    var tuples = [(String, String)]()
    var contactTuples = [(String, CNContact)]()
    
    var selectedContact = CNContact()
    var selectedContactObject = Contact()
    var contactObjectList = [Contact]()
    var contactList = [Contact]()
    
    var phoneContacts = [CNContact]()
    
    
    
    // Page setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tblSearchResults.delegate = self
        tblSearchResults.dataSource = self
        
        //loadListOfCountries()
        
        getContacts()
        
        //self.fetchContactsForUser()
        
        // Uncomment the following line to enable the default search controller.
        // configureSearchController()
        
        // Comment out the next line to disable the customized search controller and search bar and use the default ones. Also, uncomment the above line.
        configureCustomSearchController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions
    // ------------------------
    
    @IBAction func importContacts(_ sender: Any) {
        // Get contacts
        self.getContacts()
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
            print("Section row count >>", contactsHashTable[letters[section]]!.count)
            return contactObjectTable[letters[section]]!.count
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return letters//["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U", "V", "W", "X", "Y", "Z"] //String(letters)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return letters[section]
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactListCell", for: indexPath) as! ContactListCell
        
        if shouldShowSearchResults {
            
            let contact = contactSearchResults[indexPath.row]
            
            cell.contactNameLabel?.text = contactSearchResults[indexPath.row].name//filteredArray[indexPath.row].givenName
            
            // Set image data here
            if contact.imageId != "" {
                print("Has IMAGE")
                // Set id
                let id = contact.imageId
                
                // Set image for contact
                let url = URL(string: "\(ImageURLS.sharedManager.getFromDevelopmentURL)\(id ?? "").jpg")!
                let placeholderImage = UIImage(named: "profile")!
                // Set image
                cell.contactImageView?.setImageWith(url)
                
                
            }else{
                cell.contactImageView.image = UIImage(named: "profile")
            }

            
        }
        else {
            // Assign contact object
            
            let contact = contactObjectTable[letters[indexPath.section]]?[indexPath.row]
            let name = contact?.name //self.formatter.string(from: contact!) ?? "No Name"
            // Set name
            cell.contactNameLabel?.text = name//contactsHashTable[letters[indexPath.section]]?[indexPath.row].givenName ?? "Nothing"//dataArray[indexPath.row]
            
            // Set image data here
            if contact?.imageId != "" {
                print("Has IMAGE")
                // Set id
                let id = contact?.imageId
                
                // Set image for contact
                let url = URL(string: "\(ImageURLS.sharedManager.getFromDevelopmentURL)\(id ?? "").jpg")!
                let placeholderImage = UIImage(named: "profile")!
                // Set image
                cell.contactImageView?.setImageWith(url)
                
                
            }else{
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
        let lbl = UILabel(frame: CGRect(8, 3, 15, 15))
        lbl.text = String(letters[section])
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
        
        
        
        /* contactListTableView.deselectRow(at: indexPath, animated: true)
         
         print("You selected Conact --> \(ContactManager.sharedManager.phoneContactList[indexPath.row])")
         // Assign selected contact
         selectedContact = ContactManager.sharedManager.phoneContactList[indexPath.row]
         // Pass in segue
         self.performSegue(withIdentifier: "showContactProfile", sender: indexPath.row) */
        
        var selectedId = ""
        
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
        
        // Pass segue
        self.performSegue(withIdentifier: "showContactProfile", sender: indexPath.row)

        
        
    }
    
    
    // MARK: Custom functions
    
    // For sending notifications to the default center for other VC's that are listening
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(ContactListViewController.refreshTable), name: NSNotification.Name(rawValue: "RefreshContactsTable"), object: nil)
        
    }
    
    func refreshTable() {
        // Reload contacts
        
        // Reset all the arrays
        letters.removeAll()
        contacts.removeAll()
        contactObjectTable.removeAll()
        //contactsHashTable.removeAll()
        tuples.removeAll()
        contactTuples.removeAll()
        dataArray.removeAll()
        
        // Fetch contact list
        getContacts()
    }
    
    func configureSelectedImageView(imageView: UIImageView) {
        // Config imageview
        
        // Configure borders
        imageView.layer.borderWidth = 1
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 23    // Create container for image and name
        
    }
    
    func getContacts() {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        if status == .denied || status == .restricted {
            //presentSettingsActionSheet()
            return
        }
        
        // open it
        
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, error in
            guard granted else {
                DispatchQueue.main.async {
                    //self.presentSettingsActionSheet()
                }
                return
            }
            
            // get the contacts
            
            var contacts = [CNContact]()
            let request = CNContactFetchRequest(keysToFetch: [CNContactIdentifierKey as NSString, CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey as CNKeyDescriptor, CNContactJobTitleKey as CNKeyDescriptor, CNContactImageDataAvailableKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor, CNContactImageDataKey as CNKeyDescriptor, CNContactOrganizationNameKey as CNKeyDescriptor, CNContactSocialProfilesKey as CNKeyDescriptor, CNContactUrlAddressesKey as CNKeyDescriptor, CNContactNoteKey as CNKeyDescriptor])
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
                
                
                
                //dataArray
                
                //self.dataArray.append(formatter.string(from: contact) ?? "No Name")
                
                
                if contact.phoneNumbers.count > 0 {
                    //print((contact.phoneNumbers[0].value ).value(forKey: "digits") as! String)
                }
                if contact.emailAddresses.count > 0 {
                    //print((contact.emailAddresses[0].value))
                }
                if contact.imageDataAvailable {
                    //print((contact.phoneNumbers[0].value ).value(forKey: "digits") as! String)
                    //print("Has IMAGE")
                }
                // Previous apprend area
                //self.phoneContactList.append(contact)
                
                // print(self.phoneContactList.count)
                //print(contact)
            }
            
            // Find out if contacts synced
            let synced = UDWrapper.getBool("contacts_synced")
            print("Contacts sync value!! >> \(synced)")
            
            /*if  synced{
                
                print("Contacts synced!! >> \(synced)")
                //Set bool to indicate contacts have been synced
                UDWrapper.setBool("contacts_synced", value: true)
            
            }else{
                
                // Create contact objects
                self.contactObjectList = self.createContactRecords(phoneContactList: self.phoneContacts)
                
                // Upload Contacts
                self.uploadContactRecords()
            }*/
            
            // Create contact objects
            //self.contactObjectList = self.createContactRecords(phoneContactList: self.phoneContacts)
            
            // Create contact objects
            self.contactObjectList = self.createContactRecords(phoneContactList: self.phoneContacts)
            
            // Sort list
            self.sortContacts()
            
            
            
            // Sync up with main queue
            DispatchQueue.main.async {
                
                // Upload Contacts
                //self.uploadContactRecords()
                // Reload the tableview.
                self.tblSearchResults.reloadData()
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
            
            // Check for count
            if contact.phoneNumbers.count > 0 {
                // Iterate over items
                for number in contact.phoneNumbers{
                    // print to test
                    //print("Number: \((number.value.value(forKey: "digits" )!))")
                    
                    // Init the number
                    let digits = number.value.value(forKey: "digits") as! String
                    
                    // Append to object
                    contactObject.setPhoneRecords(phoneRecord: digits)
                }
                
            }
            if contact.emailAddresses.count > 0 {
                // Iterate over array and pull value
                for address in contact.emailAddresses {
                    // Print to test
                    print("Email : \(address.value)")
                    
                    // Append to object
                    contactObject.setEmailRecords(emailAddress: address.value as String)
                }
            }
            if contact.imageDataAvailable {
                // Print to test
                //print("Has IMAGE Data")
                
                // Create ID and add to dictionary
                // Image data png
                let imageData = contact.imageData!
                print(imageData)
                
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
                
                // Upload Record
                ImageURLS.sharedManager.uploadImageToDev(imageDict: imageDict)
                
            }
            if contact.urlAddresses.count > 0{
                // Iterate over items
                for address in contact.urlAddresses {
                    // Print to test
                    print("Website : \(address.value as String)")
                    
                    // Append to object
                    contactObject.setWebsites(websiteRecord: address.value as String)
                }
                
            }
            if contact.socialProfiles.count > 0{
                // Iterate over items
                for profile in contact.socialProfiles {
                    // Print to test
                    print("Social Profile : \((profile.value.value(forKey: "urlString") as! String))")
                    
                    // Create temp link
                    let link = profile.value.value(forKey: "urlString")  as! String
                    
                    // Append to object
                    contactObject.setSocialLinks(socialLink: link)
                }
                
            }
            
            if contact.jobTitle != "" {
                //Print to test
                print("Job Title: \(contact.jobTitle)")
                
                // Append to object
                contactObject.setTitleRecords(title: contact.jobTitle)
            }
            if contact.organizationName != "" {
                //print to test
                print("Organization : \(contact.organizationName)")
                
                // Append to object
                contactObject.setOrganizations(organization: contact.organizationName)
            }
            if contact.note != "" {
                //print to test
                print(contact.note)
                
                // Append to object
                contactObject.setNotes(note: contact.note)
                
            }
            
            // Test object
            //print("Contact >> \n\(contactObject.toAnyObject()))")
            
            // Append object to contactObjectList
            contactObjectList.append(contactObject)
            
            
            // Print count
            print("List Count ... \(contactObjectList.count)")
        }
        
        return contactObjectList
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
        
        customSearchController = CustomSearchController(searchResultsController: self, searchBarFrame: CGRect(x: 0.0, y: 0.0, width: tblSearchResults.frame.size.width, height: 50.0), searchBarFont: UIFont(name: "Avenir", size: 16.0)!, searchBarTextColor: blue, searchBarTintColor: UIColor.white)
        
        customSearchController.customSearchBar.placeholder = "Search"
        customSearchController.customSearchBar.tintColor = blue
        tblSearchResults.tableHeaderView = customSearchController.customSearchBar
        
        customSearchController.customDelegate = self
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
        print("Filtered list count >> \(self.contactSearchResults.count)")
        self.tblSearchResults.reloadData()
    }
    
    
    func didTapOnSearchButton() {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            // Hit search endpoint
            self.tblSearchResults.reloadData()
        }
        self.searchContacts()
    }
    
    
    func didTapOnCancelButton() {
        shouldShowSearchResults = false
        // Empty list
        self.contactSearchResults.removeAll()
        self.tblSearchResults.reloadData()
    }
    
    func didChangeSearchText(_ searchText: String) {
        // Filter the data array and get only those countries that match the search text.
        /*filteredArray = contactsHashTable.filter({ (contact) -> Bool in
            let countryText: NSString = contact.
            
            return (countryText.range(of: searchText, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })*/
        
        // Reload the tableview.
        //tblSearchResults.reloadData()
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
                    //self.sortTransactionList(list: self.searchTransactionList)
                    
                    
                    // Update the table values
                    self.tblSearchResults.reloadData()
                    
                    
                    // Show sucess
                    KVNProgress.showSuccess()
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
    
    func sortUnifyContacts(phoneList: [Contact]) {
        
        
        
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
            //print(nameToUpper[nameToUpper.startIndex])
            return String(nameToUpper[nameToUpper.startIndex])
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
        
        // Create indicies based on letters
        for letter in letters{
            
            // Create section in hash table
            contactsHashTable[letter] = [CNContact]()
            // Unify contacts table
            contactObjectTable[letter] = [Contact]()

        }
        
        // Apple contacts
        for contact in self.phoneContacts{
            // Init contact name
            var contactName : String = self.formatter.string(from: contact) ?? "No Name"
            // Uppercase the name
            contactName = contactName.uppercased()
            
            // Check if section exists
            if contactsHashTable[String(describing: contactName.characters.first!)] == nil{
                //print("Hash Section Empty!")
                // If empty, initialize list
               contactsHashTable[String(describing: contactName.characters.first!)] = []
            }
            // Add contact to list
            //let charString = self.formatter.string(from: contact)?.uppercased() ?? "NO NAME"
            let startIndex = String(describing: contactName.characters.first!)
            print("Start Index: >> \(startIndex)")
            
            contactsHashTable[startIndex]!.append(contact)
            //print("Section count for added item")
            //print(contactsHashTable[startIndex]?.count)
        }
        
        
        // Unify Contacts
        for contact in self.contactObjectList{
            // Init contact name
            var contactName : String = contact.name 
            // Uppercase the name
            contactName = contactName.uppercased()
            
            // Check if section exists
            if contactObjectTable[String(describing: contactName.characters.first!)] == nil{
                //print("Hash Section Empty!")
                // If empty, initialize list
                contactObjectTable[String(describing: contactName.characters.first!)] = []
            }
            // Add contact to list
            //let charString = self.formatter.string(from: contact)?.uppercased() ?? "NO NAME"
            let startIndex = String(describing: contactName.characters.first!)
            print("Start Index: >> \(startIndex)")
            
            contactObjectTable[startIndex]!.append(contact)
            //print("Section count for added item")
            //print(contactsHashTable[startIndex]?.count)
        }
        
        
        // Sort list
        for (section, list) in contactObjectTable {
           // contacts[section] = list.sorted{ $0.givenName > $1.givenName}
            // Test output
            print("THE unify contacts hash table section list count")
            print(contacts[section]?.count)
            print(list)
        }
        
        // Assign table data 
        //self.tableData = contactsHashTable
        
        //print("Table Data \n\(self.tableData)")
        
        //print(contactsHashTable)
        
        print("The Table Count >> ", contactObjectTable.count)
        
        DispatchQueue.main.async {
            
            // Reload data
            self.tblSearchResults.reloadData()
        }

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
        }

        
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
    
    
    func fetchContactsForUser() {
        // Fetch the user data associated with users
        
        // Hit endpoint for updates on users nearby
        let parameters = ["uuid": ContactManager.sharedManager.currentUser.userId]
        
        print(">>> SENT PARAMETERS >>>> \n\(parameters))")
        // Show progress
        KVNProgress.show(withStatus: "Fetching details on the activity...")
        
        // Create User Objects
        Connection(configuration: nil).getContactsCall(parameters, completionBlock: { response, error in
            
            if error == nil {
                
                //print("\n\nConnection - Radar Response: \n\n>>>>>> \(response)\n\n")
                
                // Init dictionary to capture response
                let userArray = response as? NSDictionary
                // // Parse dictionary for array of trans
                print(userArray)
                
                let userList = userArray?["data"] as! NSArray
                
                
                // Iterate over array, append trans to list
                for item in userList{
                    
                    print("Contact Item >> \(item)")
                    
                    // Init user objects from array
                    let contact = Contact(snapshotLite: item as! NSDictionary)
                    
                    // Append users to Selected array
                    self.contactList.append(contact)
                }
                
                // Delete all for next sync
                //self.deleteContactsForUser()
                
                // Show sucess
                //KVNProgress.showSuccess()
                
                
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
    
    
    // Empty State Delegate Methods
    
    // Settings
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        
        // All arrays are empty
        /*if checkForEmptyData() == true {
         return true
         }else{
         return false
         }*/
        return false
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
        
        let emptyString = "No Profile Info Found"
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
        
        let emptyString = "Tap to Sync Contacts"
        
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
        ContactManager.sharedManager.getContacts()
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
    
