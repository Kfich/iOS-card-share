//
//  Contacts-TableViewController.swift
//  Unify


import AlgoliaSearch
import InstantSearchCore
import Firebase
import UIKit
import PopupDialog
import CoreLocation
import Skeleton
import Contacts


class ContactsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, CustomSearchControllerDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    // IBOutlets
    // --------------------------------------
    @IBOutlet weak var tblSearchResults: UITableView!
    
    
    // Properties
    // --------------------------------------
    var dataArray = [String]()
    
    
    var filteredArray = [String]()
    
    var shouldShowSearchResults = false
    
    var searchController: UISearchController!
    
    var customSearchController: CustomSearchController!
    
    var index = 0
    
    var timer = Timer()
    
    // Sorted contact list
    var letters: [Character] = []
    var contacts = [Character: [String]]()
    
    var contactObjectTable = [[String: Any]]()
    var contactNamesHashTable = [String: CNContact]()
    
    
    var tuples = [(String, String)]()
    var contactTuples = [(String, CNContact)]()
    
    var selectedContact = CNContact()
    
    
    
    // Page setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tblSearchResults.delegate = self
        tblSearchResults.dataSource = self
        
        //loadListOfCountries()
        
        getContacts()
        
        // Uncomment the following line to enable the default search controller.
        // configureSearchController()
        
        // Comment out the next line to disable the customized search controller and search bar and use the default ones. Also, uncomment the above line.
        configureCustomSearchController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UITableView Delegate and Datasource functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return letters.count
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
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactListCell", for: indexPath) as! ContactListCell
        
        if shouldShowSearchResults {
            cell.contactNameLabel?.text = filteredArray[indexPath.row]
        }
        else {
            // Assign contact object
            
            //let contact
            cell.contactNameLabel?.text = contacts[letters[indexPath.section]]?[indexPath.row]//dataArray[indexPath.row]
            
        }
        
        // Set image
        cell.contactImageView.image = UIImage(named: "profile")
        // Add tap gesture to follow up button
        self.addGestureToImage(image: (cell.introImageView)!, index: indexPath.row)
        
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
            print(filteredArray[indexPath.row])
            
            // Search for contact by name in list
            for item in self.tuples {
                if item.1 == filteredArray[indexPath.row] {
                    // This is the selected item
                    print("Selected Item: >> \(item)")
                    // Set Id
                    selectedId = item.0
                }
                
                
            }

            
        }else{
            //print("Index path for data array", indexPath)
            //print(dataArray[indexPath.row])
            
            // Search for contact by name in list
            for item in self.tuples {
                if item.1 == contacts[letters[indexPath.section]]?[indexPath.row] {
                    // This is the selected item
                    print("Selected Item: >> \(item)")
                    // Set Id
                    selectedId = item.0
                }
                
                
            }

            //print("The output <> \(String(describing: contacts[letters[indexPath.section]]?[indexPath.row]))")
        }
        
        // Set contact from list
        for item in contactTuples{
            if item.0 == selectedId {
                // Set contact object 
                self.selectedContact = item.1
                
                // Print to test
                print(self.selectedContact.givenName)
                // Call segue
                
            }
        }
        
    }
    
    
    // MARK: Custom functions
    
    
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
            
            // Create contact objects
            // self.contactObjectList = self.createContactRecords()
            
            // Set appeared to true
            // self.contactListHasAppeared = true
            
            // Post refresh
            // self.postContactListRefresh()
            
            //Set bool to indicate contacts have been synced
            //UDWrapper.setBool("contacts_synced", value: true)
            
            // Upload Contacts
            //self.uploadContactRecords()
            
            self.sortContacts()
            
            // Sync up with main queue
            DispatchQueue.main.async {
                
                // Sort list
                //self.sortContacts()
                // Reload the tableview.
                self.tblSearchResults.reloadData()
            }
            
        }
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
        customSearchController = CustomSearchController(searchResultsController: self, searchBarFrame: CGRect(x: 0.0, y: 0.0, width: tblSearchResults.frame.size.width, height: 50.0), searchBarFont: UIFont(name: "Futura", size: 16.0)!, searchBarTextColor: UIColor.blue, searchBarTintColor: UIColor.white)
        
        customSearchController.customSearchBar.placeholder = "Search"
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
        
        // Filter the data array and get only those countries that match the search text.
        filteredArray = dataArray.filter({ (country) -> Bool in
            let countryText:NSString = country as NSString
            
            return (countryText.range(of: searchString, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })
        
        // Reload the tableview.
        tblSearchResults.reloadData()
    }
    
    
    // MARK: CustomSearchControllerDelegate functions
    
    func didStartSearching() {
        shouldShowSearchResults = true
        tblSearchResults.reloadData()
    }
    
    
    func didTapOnSearchButton() {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tblSearchResults.reloadData()
        }
    }
    
    
    func didTapOnCancelButton() {
        shouldShowSearchResults = false
        tblSearchResults.reloadData()
    }
    
    
    func didChangeSearchText(_ searchText: String) {
        // Filter the data array and get only those countries that match the search text.
        filteredArray = dataArray.filter({ (country) -> Bool in
            let countryText: NSString = country as NSString
            
            return (countryText.range(of: searchText, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })
        
        // Reload the tableview.
        tblSearchResults.reloadData()
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
        print("\n\nLETTERS >>>> \(letters)")
        
        letters = letters.reduce([], { (list, name) -> [Character] in
            if !list.contains(name) {
                // Test to see if letters added
                print("\n\nAdded >>>> \(list + [name])")
                return list + [name]
            }
            return list
        })
        
        
        // Build contacts array:
        
        // Init sorted contacts array
        //var contacts = [Character: [String]]()
        
        
        
        
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
    
    func addGestureToImage(image: UIImageView, index: Int) {
        // Init tap gesture
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showIntroWithContact(sender:)))
        image.isUserInteractionEnabled = true
        // Add gesture to image
        image.addGestureRecognizer(tapGestureRecognizer)
        // Set image index
        image.tag = index
    }
    
    func showIntroWithContact(sender: UITapGestureRecognizer){
        // Set selected contact on manager using tag
        ContactManager.sharedManager.contactToIntro = ContactManager.sharedManager.phoneContactList[(sender.view?.tag)!]
        
        // Set navigation toggle on manager to indicate intent
        ContactManager.sharedManager.userArrivedFromContactList = true
        ContactManager.sharedManager.userArrivedFromIntro = true
        
        // Notification for intro screen
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ContactSelected"), object: self)
        // Set selected tab
        
        
        // Sync up with main queue
        DispatchQueue.main.async {
            // Set selected tab
            self.tabBarController?.selectedIndex = 1
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
        let contact = ContactManager.sharedManager.contactObjectList[self.index]
        
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
        if self.index < ContactManager.sharedManager.contactObjectList.count{
            // Increment index
            self.index = self.index + 1
            
        }else{
            // Turn off timer to end execution
            self.timer.invalidate()
            
            //Set bool to indicate contacts have been synced
            UDWrapper.setBool("contacts_synced", value: true)
        }
        
        
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
            //destination.selectedContact = self.selectedContact
            
            // Test
            print("Contact Passed in Seggy")
        }
        
        
    }
    
    
}

/*
 extension UISearchBar {
 func changeSearchBarColor(color: UIColor) {
 UIGraphicsBeginImageContext(self.frame.size)
 color.setFill()
 UIBezierPath(rect: self.frame).fill()
 let bgImage = UIGraphicsGetImageFromCurrentImageContext()!
 UIGraphicsEndImageContext()
 
 self.setSearchFieldBackgroundImage(bgImage, for: .normal)
 }
 }
 */

