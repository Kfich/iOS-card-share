//
//  Contacts-TableViewController.swift
//  Unify
//
//  Created by Ryan Hickman on 4/4/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import AlgoliaSearch
import InstantSearchCore
import Firebase
import UIKit
import PopupDialog
import CoreLocation
import Skeleton
import Contacts


class SelectRecipientViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating, CustomSearchControllerDelegate
{
    
    
    // Properties
    // ---------------------------------
    var currentUser = User()
    
    var cellReuseIdentifier = "ContactListCell"
    var searchController = UISearchController()
    
    var contactStore = CNContactStore()
    var contactList = [CNContact]()
    let formatter = CNContactFormatter()
    var selectedContact = CNContact()
    
    // Progress hud
    var progressHUD = KVNProgress()
    
    // User navigation switches
    var contactSeleted = false
    var recipientSelected = false
    
    // Conig search
    var customSearchController: CustomSearchController!
    
    var shouldShowSearchResults = false
    
    // Searching
    var dataArray = [String]()
    var filteredArray = [String]()
    
    // Sorted contact list
    var letters: [Character] = []
    var contacts = [Character: [String]]()
    
    var contactObjectTable = [[String: Any]]()
    var contactNamesHashTable = [String: CNContact]()
    
    
    var tuples = [(String, String)]()
    var contactTuples = [(String, CNContact)]()
    var contactObjectList = [Contact]()
    
    var phoneContacts = [CNContact]()
    
    
    // IBOutlets
    // ---------------------------------
    @IBOutlet var contactListTableView: UITableView!
    
    
    // Page Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Contact formatter style
        formatter.style = .fullName
        
        getContacts()
        
        // Observers for notifications
        addObservers()
        
        // Do any additional setup after loading the view.
        
        // Tableview config
        // Index tracking strip
        contactListTableView.sectionIndexBackgroundColor = UIColor.clear
        contactListTableView.sectionIndexColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        
        
        // Search controller
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = NSLocalizedString("Search", comment: "")
        
        // Add the search bar
        contactListTableView.tableHeaderView = self.searchController.searchBar
        definesPresentationContext = true
        searchController.searchBar.sizeToFit()
        
        // Style search bar
        searchController.searchBar.barStyle = UIBarStyle.default
        searchController.searchBar.backgroundColor = UIColor.white
        
        // Search Bar
        configureCustomSearchController()
        
        
        // Reload Data
        contactListTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        // Set appeared to true
        ContactManager.sharedManager.contactListHasAppeared = true
    }
    
    // IBActions 
    // ---------------------------------------------
    
    @IBAction func cancelSelection(_ sender: Any) {
        
        // Dismiss view 
        dismiss(animated: true, completion: nil)
    }
    
    
    // TableView Delegates and DataSource
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ContactListCell!
        
        if shouldShowSearchResults {
            cell?.contactNameLabel?.text = filteredArray[indexPath.row]
        }
        else {
            // Assign contact object
            
            //let contact
            cell?.contactNameLabel?.text = contacts[letters[indexPath.section]]?[indexPath.row]//dataArray[indexPath.row]
            
        }
        
        // Set cell image
        cell?.contactImageView.image = UIImage(named: "profile")
        
        self.configureSelectedImageView(imageView: (cell?.contactImageView)!)
        
        
        
        /*
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
        
        // Add tap gesture to follow up button*/
        
        return cell!
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       /*
        print("You selected Conact --> \(ContactManager.sharedManager.phoneContactList[indexPath.row])")
        // Assign selected contact
        selectedContact = ContactManager.sharedManager.phoneContactList[indexPath.row]
        
        // Make conditional checks to see where user navigated from
        if ContactManager.sharedManager.userArrivedFromIntro != true {
            
            // Set bool to true 
            ContactManager.sharedManager.userArrivedFromIntro = true
            // Set Contact on Manager
            ContactManager.sharedManager.contactToIntro = selectedContact
            
            // Notification for intro screen
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ContactSelected"), object: self)
            
            // Drop view
            dismiss(animated: true, completion: nil)
        }else{
            
            // Set Contact on Manager
            ContactManager.sharedManager.recipientToIntro = selectedContact
            
            // Post for recipient selected
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RecipientSelected"), object: self)
            // Drop View
            dismiss(animated: true, completion: nil)
        }*/
        
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
            return filteredArray.count
        }
        else {
            return contacts[letters[section]]!.count
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U", "V", "W", "X", "Y", "Z"] //String(letters)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(letters[section])
    }

    
    
    func configureCustomSearchController() {
        
        // Init blue color
        let blue = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        
        customSearchController = CustomSearchController(searchResultsController: self, searchBarFrame: CGRect(x: 0.0, y: 0.0, width: self.contactListTableView.frame.size.width, height: 50.0), searchBarFont: UIFont(name: "Avenir", size: 16.0)!, searchBarTextColor: blue, searchBarTintColor: UIColor.white)
        
        customSearchController.customSearchBar.placeholder = "Search"
        customSearchController.customSearchBar.tintColor = blue
        // Hide cancel button
        customSearchController.customSearchBar.showsCancelButton = false
        self.contactListTableView.tableHeaderView = customSearchController.customSearchBar
        
        customSearchController.customDelegate = self
    }
    
    // MARK: UISearchBarDelegate functions
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        // Toggle cancel button
        customSearchController.customSearchBar.showsCancelButton = true
        self.contactListTableView.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        // Toggle cancel button
        customSearchController.customSearchBar.showsCancelButton = false
        self.contactListTableView.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            self.contactListTableView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    
    // MARK: UISearchResultsUpdating delegate function
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else {
            return
        }
        
        // Filter the data array and get only those countries that match the search text.
        /* filteredArray = dataArray.filter({ (country) -> Bool in
         let countryText:NSString = country as NSString
         
         return (countryText.range(of: searchString, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
         })*/
        
        // Reload the tableview.
        self.contactListTableView.reloadData()
    }
    
    
    // MARK: CustomSearchControllerDelegate functions
    
    func didStartSearching() {
        shouldShowSearchResults = true
        self.contactListTableView.reloadData()
    }
    
    
    func didTapOnSearchButton() {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            self.contactListTableView.reloadData()
        }
    }
    
    
    func didTapOnCancelButton() {
        shouldShowSearchResults = false
        self.contactListTableView.reloadData()
    }
    
    
    func didChangeSearchText(_ searchText: String) {
        // Filter the data array and get only those countries that match the search text.
        /*filteredArray = dataArray.filter({ (country) -> Bool in
         let countryText: NSString = country as NSString
         
         return (countryText.range(of: searchText, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
         })*/
        
        // Reload the tableview.
        self.contactListTableView.reloadData()
    }
    
    
    // Custom Methods
    
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
            
            let formatter = CNContactFormatter()
            formatter.style = .fullName
            for contact in contacts {
                //print(formatter.string(from: contact) ?? "No Name")
                
                // Generate ID String
                let str = self.randomString(length: 10)
                // Assign id to object
                let contactTuple = (str, formatter.string(from: contact) ?? "No Name")
                let objectTuple = (str, contact)
                
                // Create tuples and append to list
                self.tuples.append(contactTuple)
                print("Tuple >> \(contactTuple)")
                self.contactTuples.append(objectTuple)
                print("Object Tuple >> \(objectTuple)")
                
                let dataArrayObject = ["id" : str, "name": formatter.string(from: contact) ?? "No Name"]
                self.contactObjectTable.append(dataArrayObject)
                
                //print("The ContactDictionary")
                //print(contactDictionary)
                
                //print("The data array object")
                //print(dataArrayObject)
                
                
                
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
            
            // Set appeared to true
            // self.contactListHasAppeared = true
            
            // Post refresh
            // self.postContactListRefresh()
            
            
            self.sortContacts()
            
            // Sync up with main queue
            DispatchQueue.main.async {
                
                // Sort list
                //self.sortContacts()
                // Reload the tableview.
                self.contactListTableView.reloadData()
            }
            
        }
    }
    
    
    func sortContacts() {
        // Test for sorting contacts by last name into sections
        
        //let data = self.dataArray // Example data, use your phonebook data here.
        
        // Build letters array:
        
        //letters: [Character]
        // Init data array
        dataArray = self.tuples.map { $0.1 }
        
        
        
        letters = dataArray.map { (name) -> Character in
            print(name[name.startIndex])
            return name[name.startIndex]
        }
        
        letters = letters.sorted()
        // Print letters array
        //print("\n\nLETTERS >>>> \(letters)")
        
        letters = letters.reduce([], { (list, name) -> [Character] in
            if !list.contains(name) {
                // Test to see if letters added
                print("\n\nAdded >>>> \(list + [name])")
                return list + [name]
            }
            return list
        })
        
        // Iterate over contact list
        for entry in dataArray {
            
            if contacts[entry[entry.startIndex]] == nil {
                // Set index if doesn't exist
                contacts[entry[entry.startIndex]] = [String]()
            }
            
            // Add entry to section
            contacts[entry[entry.startIndex]]!.append(entry)
            
        }
        
        // Sort list
        for (letter, list) in contacts {
            contacts[letter] = list.sorted()
            // Test output
            print(contacts[letter])
        }
    }
    
    func configureSelectedImageView(imageView: UIImageView) {
        // Config imageview
        
        // Configure borders
        imageView.layer.borderWidth = 1
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 21    // Create container for image and name
        
    }
    
    
    
    func addObservers() {
        // Call to refresh table
        NotificationCenter.default.addObserver(self, selector: #selector(SelectRecipientViewController.refreshTableData), name: NSNotification.Name(rawValue: "RefreshContactList"), object: nil)
        
    }
    
    func postNotificationForContact() {
        // Notification for intro screen
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ContactSelected"), object: self)
    }
    
    func postNotificationForRecipient() {
        // Post for recipient selected
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RecipientSelected"), object: self)
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





extension UIColor {
    func brightened(by factor: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: b * factor, alpha: a)
    }
}
