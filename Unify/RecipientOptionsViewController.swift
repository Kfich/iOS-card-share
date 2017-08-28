//
//  RecipientOptionsViewController.swift
//  Unify
//
//  Created by Kevin Fich on 7/27/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit
import CoreLocation
import Contacts
import MessageUI


class RecipientOptionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, CustomSearchControllerDelegate {
    
    // Properties
    // --------------------------
    var currentUser = User()
    var transaction = Transaction()
    var radarContactList = [User]()
    var selectedUserIds = [String]()
    var selectedContactList = [User]()
    var segmentedControl = UISegmentedControl()
    var selectedCells = [NSIndexPath]()
    
    // If contact created from form
    var selectedContactPhone : String = ""
    var selectedEmail : String = ""
    
    // Contact Object 
    var contact = Contact()
    
    // Location 
    var lat : Double = 0.0
    var long : Double = 0.0
    var address = String()
    var updateLocation_tick = 5
    let locationManager = CLLocationManager()

    var cellReuseIdentifier = "ContactListCell"
    
    // For search results
    var dataArray = [String]()
    var filteredArray = [String]()
    var shouldShowSearchResults = false
    var customSearchController: CustomSearchController!
    
    // Sorted contact list
    var letters: [Character] = []
    var contacts = [Character: [String]]()
    
    var contactObjectTable = [[String: Any]]()
    var contactNamesHashTable = [String: CNContact]()
    
    
    var tuples = [(String, String)]()
    var contactTuples = [(String, CNContact)]()
    
    var selectedContact = CNContact()
    var contactObjectList = [Contact]()
    
    var phoneContacts = [CNContact]()

    
    // Radar 
    var radarStatus: Bool = false
    let formatter = CNContactFormatter()
    
    
    // IBOutlets
    // ----------------------------------------
    @IBOutlet var navigationBar: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var radarSwitch: UISwitch!
    
    @IBOutlet var syncContactSwitch: UISwitch!
    
    
    @IBOutlet var phoneLabel: UITextField!
    @IBOutlet var emailLabel: UITextField!
    
    @IBOutlet var firstNameLabel: UITextField!
    @IBOutlet var lastNameLabel: UITextField!
    
    @IBOutlet var tagsLabel: UITextField!
    @IBOutlet var notesLabel: UITextField!

    

    // Page setup 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Set currentUser
        self.currentUser = ContactManager.sharedManager.currentUser
        
        // Init and configure segment controller
        segmentedControl = UISegmentedControl(frame: CGRect(x: 10, y: 5, width: 225, height: 30))
        // Set tint
        segmentedControl.tintColor = UIColor.white//UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        
        segmentedControl.insertSegment(withTitle: "New", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Contacts", at: 1, animated: false)
        
        
        // Set segment
        segmentedControl.selectedSegmentIndex = 0
        
        // Add target action method
        segmentedControl.addTarget(self, action: #selector(RecipientOptionsViewController.toggleViews(sender:)), for: .valueChanged)
        
        // Set nav background 
        // Set background image on collectionview
        let bgImage = UIImageView();
        bgImage.image = UIImage(named: "backgroundGradient");
        bgImage.contentMode = .scaleToFill
        self.navigationBar.titleView = bgImage
        
        // Add segment control to navigation bar
        self.navigationBar.titleView = segmentedControl
        
        // Hide table
        self.tableView.isHidden = true
        
        // Get contacts
        self.getContacts()
        
        // Configure bar
        self.configureCustomSearchController()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions
    // --------------------------
    
    @IBAction func radarSwitchSelected(_ sender: Any) {
        // Turn on location service
        if radarSwitch.isOn == false {
            // Hide tableview
            //self.tableView.isHidden = true
            // Toggle radar status
            self.radarStatus = false
        }else{
            // Show table
            //self.tableView.isHidden = false
            
            // Toggle radar status 
            //self.radarStatus = true
            
            // Start updating location
            //self.updateLocation()
        }
    }
    
    @IBAction func dismissViewController(_ sender: Any) {
        
        // Pop view 
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func shareWithContact(_ sender: Any) {
        
        // Check if contact list is in view
        if self.tableView.isHidden{
            //Check if form valid
            let isValidForm = self.validateForm()
            
            if isValidForm {
                // Configure and create transaction
                print("The form was valid, sms should launch")
            }else{
                // Error
                print("There was an error validating form")
            }
            
        }else{
            
            if ContactManager.sharedManager.userSelectedRecipient {
                
            }
            // CNContact Objects
            let contact = ContactManager.sharedManager.contactToIntro
            let recipient = ContactManager.sharedManager.recipientToIntro
            
            // Check if they both have email
            
            if contact.emailAddresses.count > 0 && recipient.emailAddresses.count > 0 {
                
                let contactEmail = contact.emailAddresses[0].value as String
                let recipientEmail = recipient.emailAddresses[0].value as String
                
                
                // Launch Email client
                showEmailCard()
                
            }else if contact.phoneNumbers.count > 0 && recipient.phoneNumbers.count > 0 {
                
                let contactPhone = (contact.phoneNumbers[0].value).value(forKey: "digits") as? String
                let recipientPhone = (recipient.phoneNumbers[0].value).value(forKey: "digits") as? String
                
                // Launch text client
                showSMSCard()
                
            }else{
                // No mutual way to connect
                // Pick default based on what the contact object has populated
                
                // ***** Handle this off case tomorrow ****
                print("No Mutual Info")
            }
            
        }
    
        
    }
    
    
// ++++++++++++ Tableview ++++++++++++++++++++++++++
    
    
    
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
        
        // Set cell image
        cell.contactImageView.image = UIImage(named: "profile")
        
        // Configure imageviews
        self.configureSelectedImageView(imageView: cell.contactImageView)
        
        // Set image
        //cell.contactImageView.image = UIImage(named: "profile")
        
        
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
                // Set recipient
                ContactManager.sharedManager.recipientToIntro = self.selectedContact
                
                // Toggle BOOL
                ContactManager.sharedManager.userSelectedRecipient = true
                
                // Trigger send action
                self.shareWithContact(self)
                
                
            }
        }
        
    }

    // Search Bar Configuration & Delegates
    
    
    func configureCustomSearchController() {
        
        // Init blue color
        let blue = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        
        customSearchController = CustomSearchController(searchResultsController: self, searchBarFrame: CGRect(x: 0.0, y: 0.0, width: self.tableView.frame.size.width, height: 50.0), searchBarFont: UIFont(name: "Avenir", size: 16.0)!, searchBarTextColor: blue, searchBarTintColor: UIColor.white)
        
        customSearchController.customSearchBar.placeholder = "Search"
        customSearchController.customSearchBar.tintColor = blue
        self.tableView.tableHeaderView = customSearchController.customSearchBar
        
        customSearchController.customDelegate = self
    }
    
    
    // MARK: UISearchBarDelegate functions
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        self.tableView.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        self.tableView.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            self.tableView.reloadData()
        }
        
        //self.tableView.searchBar.resignFirstResponder()
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
        self.tableView.reloadData()
    }
    
    
    // MARK: CustomSearchControllerDelegate functions
    
    func didStartSearching() {
        shouldShowSearchResults = true
        self.tableView.reloadData()
    }
    
    
    func didTapOnSearchButton() {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            self.tableView.reloadData()
        }
    }
    
    
    func didTapOnCancelButton() {
        shouldShowSearchResults = false
        self.tableView.reloadData()
    }
    
    
    func didChangeSearchText(_ searchText: String) {
        // Filter the data array and get only those countries that match the search text.
        filteredArray = dataArray.filter({ (country) -> Bool in
            let countryText: NSString = country as NSString
            
            return (countryText.range(of: searchText, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })
        
        // Reload the tableview.
        self.tableView.reloadData()
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
        //print("\n\nLETTERS >>>> \(letters)")
        
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

    
    
    
    // Contact management
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
            
            self.sortContacts()
            
            // Sync up with main queue
            DispatchQueue.main.async {
                
                // Sort list
                //self.sortContacts()
                // Reload the tableview.
                self.tableView.reloadData()
            }
            
        }
    }

    
    
    
    
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


// ++++++++++++ Tableview ++++++++++++++++++++++++++
    // Location Managment
    
    func updateLocation(){
        
        // Update location tick
        updateLocation_tick = updateLocation_tick + 1
    
        print(updateLocation_tick)
        
        // Check is list should be refreshed
        
        
        if updateLocation_tick >= 5  && radarStatus == true{
            
            // Reset Ticker
            updateLocation_tick = 0
            
            
            // Hit endpoint for updates on users nearby
            let parameters = ["uuid": ContactManager.sharedManager.currentUser.userId, "location": ["latitude": self.lat, "longitude": self.long]] as [String : Any]
            
            print(">>> SENT PARAMETERS >>>> \n\(parameters))")
            
            // Create User Objects
            Connection(configuration: nil).startRadarCall(parameters, completionBlock: { response, error in
                if error == nil {
                    
                    //print("\n\nConnection - Radar Response: \n\n>>>>>> \(response)\n\n")
                    
                    let dictionary : NSArray = response as! NSArray
                    
                    print("data length", dictionary.count)
            
                    
                    for item in dictionary {
                        
                        //print(item)
                        
                        let userDict = item as? NSDictionary
                        
                        // Init user objects from array
                        let user = User(withRadarSnapshot: userDict!)
                        
                        // Test user
                        user.printUser()
                        
                        // Append users to radarContacts array
                        self.radarContactList.append(user)
                        print("Radar List Count >>>> \(self.radarContactList.count)")
                    
                    }
                    
                    // Reload table 
                    self.tableView.reloadData()
                    
                    
                } else {
                    print(error ?? "")
                    // Show user popup of error message
                    print("\n\nConnection - Radar Error: \n\n>>>>>>>> \(String(describing: error))\n\n")
                    
                }
                
            })
        }
        
        print("Updating location")
        
        
    }
    
    func saveCurrentLocation(_ center:CLLocationCoordinate2D){
        // Create location message
        let message = "THIS IS THE CURRENT \(center.latitude) , \(center.longitude)"
        
        // Test
        print(message)
        
        // Set lat and long
        self.lat = center.latitude
        self.long = center.longitude
        //print(message)
        
        
        // Get Location
        let location = CLLocation(latitude: center.latitude, longitude: center.longitude)
        
        
        // Geocode Location
        let geocoder = CLGeocoder()
        
        /* let paramString = "latitude=\(center.latitude)&longitude=\(center.longitude)&uuid=\(global_uuid!)"*/
        
        
        // Upload location to sever
        self.updateLocation()
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            // Process Response
            if let placemarks = placemarks, let placemark = placemarks.first {
                //print( placemark.compactAddress)
                // Set placemark address
                self.address = placemark.compactAddress!
            }
        }
        
        
        // self.lable.text = message
        //myLocation = center
    }
    
    
    func centerMap(_ center:CLLocationCoordinate2D){
        self.saveCurrentLocation(center)
        
    }
    
    // Location delegate method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        self.centerMap(locValue)
        
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
            
            if contact.phoneNumbers.count > 0 && recipient.phoneNumbers.count > 0 {
                
                let contactPhone = (contact.phoneNumbers[0].value).value(forKey: "digits") as? String
                // Set contact phone number
                phone = contactPhone!
                
                let recipientPhone = (recipient.phoneNumbers[0].value).value(forKey: "digits") as? String
                
                // Launch text client
                composeVC.recipients = [contactPhone!, recipientPhone!]
            }
            
            if contact.emailAddresses.count > 0 {
                email = (contact.emailAddresses[0].value as String)
            }
            // Set card link from cardID
            let cardLink = "https://project-unify-node-server.herokuapp.com/card/render/\(ContactManager.sharedManager.selectedCard.cardId!)"
            
            // Configure message
            let str = "Hi \(name), Please meet \(recipientName). Thought you should connect. You are both doing some cool projects and thought you might be able to work together. \n\nYou two can take it from here! \n\nBest, \n\(currentUser.getName()) \n\n\(cardLink)"
            
            composeVC.body = str
            
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
        var recipientName = ""
        var phone = ""
        var emailContact = ""
        var emailRecipient = ""
        //var title = ""
        
        
        // CNContact Objects
        let contact = ContactManager.sharedManager.contactToIntro
        let recipient = ContactManager.sharedManager.recipientToIntro
        
        // Check if they both have email
        name = formatter.string(from: contact) ?? "No Name"
        recipientName = formatter.string(from: recipient) ?? "No Name"
        
        if contact.emailAddresses.count > 0 && recipient.emailAddresses.count > 0 {
            
            let contactEmail = contact.emailAddresses[0].value as String
            let recipientEmail = recipient.emailAddresses[0].value as String
            
            // Set variable
            emailContact = contactEmail
            emailRecipient = recipientEmail
            
            print("Emails :: \(emailContact) \(emailRecipient)")
            
        }
        
        if contact.phoneNumbers.count > 0 {
            phone = (contact.emailAddresses[0].value as String)
        }
        
        // Create Message
        // Set card link from cardID
        let cardLink = "https://project-unify-node-server.herokuapp.com/card/render/\(ContactManager.sharedManager.selectedCard.cardId!)"
        
        let str = "Hi \(name), Please meet \(recipientName). Thought you should connect. You are both doing some cool projects and thought you might be able to work together. \n\nYou two can take it from here! \n\nBest, \n\(currentUser.getName()) \n\n\(cardLink)"
        
        // Create Message
        mailComposerVC.setToRecipients([emailContact, emailRecipient])
        mailComposerVC.setSubject("Unify Intro - \(name) meet \(recipientName)")
        mailComposerVC.setMessageBody(str, isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    

    // Custom Methods
    
    func configureSelectedImageView(imageView: UIImageView) {
        // Config imageview
        
        // Configure borders
        imageView.layer.borderWidth = 1
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 23    // Create container for image and name
        
    }
    
    func validateForm() -> Bool {

        // Here, configure form validation
        
        if (firstNameLabel.text == nil || lastNameLabel.text == nil || (emailLabel.text == nil && phoneLabel.text == nil)) {
            
            // form invalid
            let message = "Please enter valid contact information"
            let title = "There was an error"
            
            // Configure alertview
            let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                
                // Dismiss alert
                self.dismiss(animated: true, completion: nil)
                
            })
            
            // Add action to alert
            alertView.addAction(cancel)
            self.present(alertView, animated: true, completion: nil)
            
            // Form not valid
            return false
            
        }else{
            
            // Pass form values into contact object
            contact.name = "\(firstNameLabel.text!) \(lastNameLabel.text!)"
            
            // Set notes
            if notesLabel.text != nil{
                contact.setNotes(note: notesLabel.text!)
            }
            
            // Set notes
            if tagsLabel.text != nil{
                // Add tag to object
                contact.setTags(tag: tagsLabel.text!)
                
            }
            
            // Check for phone
            if phoneLabel.text != nil {
                // Set the number to contact
                contact.phoneNumbers.append(["phone": emailLabel.text!])
            }
            // Check for email
            if emailLabel.text != nil{
                // Set email
                contact.emails.append(["email": emailLabel.text!])
            }
            
            // Check for match in contact info
            let introContact = ContactManager.sharedManager.contactToIntro
            
            if introContact.emailAddresses.count > 0 && contact.emails.count > 0 {
                
                //
                self.selectedEmail = introContact.emailAddresses[0].value as String
                
                //let recipientEmail = recipient.emailAddresses[0].value as String
 
                
                // Launch Email client
                showEmailCard()
                
            }else if introContact.phoneNumbers.count > 0 && contact.phoneNumbers.count > 0 {
                // Set selected phone
                self.selectedContactPhone = ((introContact.phoneNumbers[0].value).value(forKey: "digits") as? String)!
                
                // Launch text client
                showSMSCard()
                
            }else{
                // Users don't have things in common
                // form invalid
                let message = "The two people have no contact info in common"
                let title = "Unable to Connect"
                
                // Configure alertview
                let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                    
                    // Dismiss alert
                    self.dismiss(animated: true, completion: nil)
                    
                })
                
                // Add action to alert
                alertView.addAction(cancel)
                self.present(alertView, animated: true, completion: nil)
            
            }
            
            // Form valid
            return true
            
        }
    }
    
    

    
    func toggleViews(sender: UISegmentedControl) {
        
        print("Toggling views for selection")
        
        switch(sender.selectedSegmentIndex) {
        case 0:
            // Test
            print("Segment One")
            // Hide view 
            self.tableView.isHidden = true
            
        case 1:
            // Test
            print("Segment Two")
            // Hide view
            self.tableView.isHidden = false

        default:
            // Test
            print("Segment One")
            // Hide view
            self.tableView.isHidden = true

        }
    }
    
    func uploadFormContactRecord(){
        
        // Check user intent
        /*if self.tableView.isHidden == false{
            // Use introContact from manager
            /*let temp = ContactManager.sharedManager.recipientToIntro
            
            self.contact = self.createContactRecord(contact: temp)*/
            
            // Parse contact
        }else{
            // User filled out form
            
            
        }*/
        
        // Assign contact
        let contact = self.contact
        
        // Show progress hud
        
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
        KVNProgress.setConfiguration(conf!)
        
        // Set text to HUD
        KVNProgress.show(withStatus: "Saving to your contacts...")
        
        
        // Create dictionary
        let parameters = ["data" : contact.toAnyObject(), "uuid" : ContactManager.sharedManager.currentUser.userId] as [String : Any]
        print(parameters)
        
        // Send to server
        Connection(configuration: nil).uploadContactCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                // Call successful
                print("Transaction Created Response ---> \(String(describing: response))")
                
                // Parse array for
                let array = response as! NSArray
                print("Array List >> \(array)")
                
                // Set recipient list to transaction
                self.transaction.recipientList = array as! [String]
                // Test
                print("Transaction List Count >> \(self.transaction.recipientList.count)")
                print("Transaction List >> \(self.transaction.recipientList)")
                
                // Create transaction
                self.createTransaction(type: "introduction")
                
                
                // Hide HUD
                KVNProgress.dismiss()
                
            } else {
                // Error occured
                print("Transaction Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error with your connection request. Please try again.")
                
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
        
    }
    
    func createContactRecord(contact: CNContact) -> Contact {
        // Create CNContact
        //let contact = CNContact()
        
        // Init formatter
        let formatter = CNContactFormatter()
        formatter.style = .fullName
        
        // Iterate over list and itialize contact objects
        
            
            // Init temp contact object
            let contactObject = Contact()
            
            // Set name
            contactObject.name = formatter.string(from: contact) ?? "No Name"
            
            // Check for count
            if contact.phoneNumbers.count > 0 {
                // Iterate over items
                for number in contact.phoneNumbers{
                    // print to test
                    print("Number: \((number.value.value(forKey: "digits" )!))")
                    
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
                print("Has IMAGE Data")
                
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
                
                // Upload image to amazon?
                
                
                // Append to object
                contactObject.setContactImageId(id: idString)
                contactObject.imageDictionary = imageDict
                
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
            print("Contact >> \n\(contactObject.toAnyObject()))")
        
        
        return contactObject
    }

    func syncContact() {
        
        // Init CNContact Object
        //let temp = CNContact()
        //temp.emailAddresses.append(CNLabeledValue<NSString>)
        //let tempContact = ContactManager.sharedManager.newContact
        
        // Append to list of existing contacts
        let store = CNContactStore()
        
        // Set text for name
        let contactToAdd = CNMutableContact()
        contactToAdd.givenName = self.firstNameLabel.text ?? ""
        contactToAdd.familyName = self.lastNameLabel.text ?? ""
        
        // Parse for mobile
        let mobileNumber = CNPhoneNumber(stringValue: (self.contact.phoneNumbers[0]["phone"] ?? ""))
        let mobileValue = CNLabeledValue(label: CNLabelPhoneNumberMobile, value: mobileNumber)
        contactToAdd.phoneNumbers = [mobileValue]
        
        // Parse for emails
        let email = CNLabeledValue(label: CNLabelWork, value: self.emailLabel.text as! NSString ?? "")
        contactToAdd.emailAddresses = [email]
        
        // Set organizations
        if self.contact.organizations.count > 0 {
            // Add to contact
            contactToAdd.organizationName = self.contact.organizations[0]["organization"]!
        }
        
        // Set notes to contact
        contactToAdd.note = self.notesLabel.text ?? ""
        
        // **** Make a scheme for adding tags to contact **** //
        
        // Save contact to phone
        let saveRequest = CNSaveRequest()
        saveRequest.add(contactToAdd, toContainerWithIdentifier: nil)
        
        do {
            try store.execute(saveRequest)
        } catch {
            print(error)
        }
        
        // Init contact object
        let newContact : CNContact = contactToAdd
        
        print("New Contact >> \(newContact)")
        
        // Append to contact list
        ContactManager.sharedManager.phoneContactList.append(newContact)
        
        // Post notification for refresh
        //self.postRefreshNotification()
        
    }
    
    func createTransaction(type: String) {
        // Configure trans for CNContact
        // Set type & Transaction data
        transaction.type = type
        //transaction.recipientList = selectedUserIds
        transaction.setTransactionDate()
        transaction.senderName = ContactManager.sharedManager.currentUser.getName()
        transaction.senderId = ContactManager.sharedManager.currentUser.userId
        transaction.type = "introduction"
        transaction.scope = "transaction"
        // Attach card id
        transaction.senderCardId = ContactManager.sharedManager.selectedCard.cardId!
        
        
        if self.tableView.isHidden == false {
            
            // Set names
            let recipient = ContactManager.sharedManager.recipientToIntro
            let introContact = ContactManager.sharedManager.contactToIntro
            
            let recipientName = formatter.string(from: recipient) ?? "No Name"
            let contactName = formatter.string(from: introContact) ?? "No Name"
            // Init list
            transaction.recipientNames = [String]()
            transaction.recipientNames?.append(recipientName)
            transaction.recipientNames?.append(contactName)
            
            
        }else{
            
            // Set names
            let introContact = ContactManager.sharedManager.contactToIntro
            let contactName = formatter.string(from: introContact) ?? "No Name"
            
            // Set recipient names
            transaction.recipientNames = [String]()
            transaction.recipientNames?.append(self.contact.name)
            transaction.recipientNames?.append(contactName)
            
            /*if self.syncContactSwitch.isOn == true {
                // Upload sync contact record
                self.syncContact()
            }*/

        }
        
        
        // Show progress hud
        
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
        KVNProgress.setConfiguration(conf)
        
        KVNProgress.show(withStatus: "Sending your card...")
        
        // Save card to DB
        let parameters = ["data": self.transaction.toAnyObject()]
        print(parameters)
        
        // Send to server
        
        Connection(configuration: nil).createTransactionCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Transaction Created Response ---> \(String(describing: response))")
                

                // Show success indicator
                KVNProgress.showSuccess(withStatus: "You are now connected!")
               
                /*
                if self.syncContactSwitch.isOn == true {
                 // Upload sync contact record
                 self.syncContact()
                 }*/
                
                
            } else {
                print("Transaction Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error. Please try again.")
                
            }
            
            // Clear List of recipients
            //self.radarContactList.removeAll()
        }
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if result == .cancelled {
            // User cancelled
            print("User cancelled")
            
        }else if result == .sent{
            // User sent
            
            if self.tableView.isHidden {
                // User filled out form
                self.uploadFormContactRecord()
            }else{
                // Chose from list
                self.createTransaction(type: "introduction")
                // Dimiss vc
                self.dismiss(animated: true, completion: nil)
            }
            
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
            // User sent message
            
            if self.tableView.isHidden {
                // User filled out form
                self.uploadFormContactRecord()
            }else{
                
                // Create transaction
                self.createTransaction(type: "introduction")
            }
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
