//
//  CreateProfileViewController.swift
//  Unify
//
//  Created by Kevin Fich on 6/30/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit
import Contacts

class CreateProfileViewController: UITableViewController {
    
    // MARK: - Properties
    var books = [String]()
    var bookList = [[String]]()
    var filteredBooks = [NSAttributedString]()
    var filteredBookList = [[NSAttributedString]]()
    let fuse = Fuse()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self as! UISearchResultsUpdating
        searchController.searchBar.delegate = self as! UISearchBarDelegate
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        
        // Setup the Scope Bar
        tableView.tableHeaderView = searchController.searchBar
        
        books = [
            "Angels & Demons",
            "Old Man's War",
            "The Lock Artist",
            "HTML5",
            "Right Ho Jeeves",
            "The Code of the Wooster",
            "Thank You Jeeves",
            "The DaVinci Code",
            "The Silmarillion",
            "Syrup",
            "The Lost Symbol",
            "The Book of Lies",
            "Lamb",
            "Fool",
            "Incompetence",
            "Fat",
            "Colony",
            "Backwards, Red Dwarf",
            "The Grand Design",
            "The Book of Samson",
            "The Preservationist",
            "Fallen",
            "Monster 1959"
        ]
        
        bookList = [
            ["Angels & Demons"],
            ["Old Man's War"],
            ["The Lock Artist"],
            ["HTML5"],
            ["Right Ho Jeeves"],
            ["The Code of the Wooster"],
            ["Thank You Jeeves"],
            ["The DaVinci Code"],
            ["The Silmarillion"],
            ["Syrup"],
            ["The Lost Symbol"],
            ["The Book of Lies"],
            ["Lamb"],
            ["Fool"],
            ["Incompetence"],
            ["Fat"],
            ["Colony"],
            ["Backwards, Red Dwarf"],
            ["The Grand Design"],
            ["The Book of Samson"],
            ["The Preservationist"],
            ["Fallen"],
            ["Monster 1959"]
        ]

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            // The original book array
            if searchController.isActive && searchController.searchBar.text != "" {
                return filteredBooks.count
            }
            return books.count
        }else{
            if searchController.isActive && searchController.searchBar.text != "" {
                return filteredBookList.count
            }
            return bookList.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item: NSAttributedString
        
        if indexPath.section == 0 {
            // The original book array
            if searchController.isActive && searchController.searchBar.text != "" {
                item = filteredBooks[indexPath.row]
            } else {
                item = NSAttributedString(string: books[indexPath.row])
            }
            
            cell.textLabel!.attributedText = item
        }else{
            if searchController.isActive && searchController.searchBar.text != "" {
                item = filteredBookList[indexPath.section][indexPath.section]
            } else {
                item = NSAttributedString(string: bookList[indexPath.section][indexPath.row])
            }
            
            cell.textLabel!.attributedText = item
        }
        
        return cell
    }
    
    func filterContentForSearchText(_ searchText: String) {
        let boldAttrs = [
            NSFontAttributeName : UIFont.boldSystemFont(ofSize: 17),
            NSForegroundColorAttributeName: UIColor.blue
        ]
        
        let results = fuse.search(searchText, in: books)
        
        filteredBooks = results.map { (index, _, matchedRanges) in
            let book = books[index]
            
            let attributedString = NSMutableAttributedString(string: book)
            matchedRanges
                .map(Range.init)
                .map(NSRange.init)
                .forEach {
                    attributedString.addAttributes(boldAttrs, range: $0)
            }
            
            return attributedString
        }
        
        /*
        
        let boldAttrList = [
            NSFontAttributeName : UIFont.boldSystemFont(ofSize: 17),
            NSForegroundColorAttributeName: UIColor.blue
        ]
        
        let resultList = fuse.search(searchText, in: books)
        
        filteredBookList = results.map { (index, _, matchedRanges) in
            let book = bookList[index]
            
            let attributedString = NSMutableAttributedString(string: book)
            matchedRanges
                .map(Range.init)
                .map(NSRange.init)
                .forEach {
                    attributedString.addAttributes(boldAttrs, range: $0)
            }
            
            return attributedString
        }*/
        
        tableView.reloadData()
    }
    
}

extension CreateProfileViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        // TODO: can run this on a background queue, and then reload the tableview back on the main queue
        filterContentForSearchText(searchBar.text!)
    }
}

extension CreateProfileViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}


/*: UITableViewController {
    
    // MARK: - Properties
    var books = [String]()
    var filteredBooks = [NSAttributedString]()
    let fuse = Fuse()
    
    var formatter = CNContactFormatter()
    
    var contactObjectList = [Contact]()
    var contactList = [Contact]()
    
    var phoneContacts = [CNContact]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        
        // Setup the Scope Bar
        tableView.tableHeaderView = searchController.searchBar
        
        books = [
            "Angels & Demons",
            "Old Man's War",
            "The Lock Artist",
            "HTML5",
            "Right Ho Jeeves",
            "The Code of the Wooster",
            "Thank You Jeeves",
            "The DaVinci Code",
            "The Silmarillion",
            "Syrup",
            "The Lost Symbol",
            "The Book of Lies",
            "Lamb",
            "Fool",
            "Incompetence",
            "Fat",
            "Colony",
            "Backwards, Red Dwarf",
            "The Grand Design",
            "The Book of Samson",
            "The Preservationist",
            "Fallen",
            "Monster 1959"
        ]
        
        getContacts()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredBooks.count
        }
        return contactObjectList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item: NSAttributedString
        
        if searchController.isActive && searchController.searchBar.text != "" {
            item = filteredBooks[indexPath.row]
        } else {
            item = NSAttributedString(string: contactObjectList[indexPath.row].name)
        }
        
        cell.textLabel!.attributedText = item
        
        return cell
    }
    
    func filterContentForSearchText(_ searchText: String) {
        
        
        
        
        /*let boldAttrs = [
            NSFontAttributeName : UIFont.boldSystemFont(ofSize: 17),
            NSForegroundColorAttributeName: UIColor.blue
        ]
        
        let results = fuse.search(searchText, in: contactObjectList)
        
        filteredBooks = results.map { (index, _, matchedRanges) in
            let book = contactObjectList[index]
            
            let attributedString = NSMutableAttributedString(string: book.name)
            
            return attributedString
    
        }*/
        
        tableView.reloadData()
    
    }
    
    
    func getContacts() {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        if status == .denied || status == .restricted {
            
            print("Permission status >> \(status)")
            // Send them to the setting page
            //self.presentSettingsActionSheet()
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
                let str = "12345"
                // Assign id to object
                let contactTuple = (str, self.formatter.string(from: contact) ?? "No Name")
                let objectTuple = (str, contact)
                
                // Create tuples and append to list
                //self.tuples.append(contactTuple)
                //print("Tuple >> \(contactTuple)")
                //self.contactTuples.append(objectTuple)
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
            
            // Create contact objects
            //self.contactObjectList = self.createContactRecords(phoneContactList: self.phoneContacts)
            
            // Create contact objects
            self.contactObjectList = self.createContactRecords(phoneContactList: self.phoneContacts)
            
            
            // Sync up with main queue
            DispatchQueue.main.async {
                
                // Upload Contacts
                //self.uploadContactRecords()
                // Reload the tableview.
                self.tableView.reloadData()
                
                
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
                
                // **** Check here if contact image valid --> This caused lyss' phone to crash ***** \\
                
                if let imageData = contact.imageData{
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
                    
            
                }
                
                
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

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension CreateProfileViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        // TODO: can run this on a background queue, and then reload the tableview back on the main queue
        filterContentForSearchText(searchBar.text!)
    }
}

extension CreateProfileViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
*/
