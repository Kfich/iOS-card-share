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
import ACFloatingTextfield_Swift


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
    
    // Fuse for search
    let fuse = Fuse()
    
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
    var contactSearchResults = [Contact]()
    
    var phoneContacts = [CNContact]()
    var synced = false
    
    var tokenField = KSTokenView()

    
    // Radar 
    var radarStatus: Bool = false
    var formatter = CNContactFormatter()
    
    var searchText = ""
    
    // IBOutlets
    // ----------------------------------------
    @IBOutlet var navigationBar: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var radarSwitch: UISwitch!
    
    @IBOutlet var syncContactSwitch: UISwitch!
    
    
    @IBOutlet var phoneLabel: ACFloatingTextfield!
    @IBOutlet var emailLabel: ACFloatingTextfield!
    
    @IBOutlet var firstNameLabel: ACFloatingTextfield!
    @IBOutlet var lastNameLabel: ACFloatingTextfield!
    
    @IBOutlet var tagsLabel: ACFloatingTextfield!
    @IBOutlet var notesLabel: ACFloatingTextfield!

    
    @IBOutlet var tokenView: UIView!
    

    // Page setup 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Set currentUser
        self.currentUser = ContactManager.sharedManager.currentUser
        
        // Set target for location field
        notesLabel.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidBegin)
        
        // Init and configure segment controller
        segmentedControl = UISegmentedControl(frame: CGRect(x: 10, y: 5, width: 225, height: 30))
        // Set tint
        segmentedControl.tintColor = UIColor.white//UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        
        segmentedControl.insertSegment(withTitle: "Contacts", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "New", at: 1, animated: false)
        
        
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
        self.tableView.isHidden = false
        // Set height
        //self.tableView.frame.height = self.view.frame.height
        
        
        
        // Get contacts
        if ContactManager.sharedManager.contactObjectList.count != 0 {
            print("The manager count ", ContactManager.sharedManager.contactObjectList.count)
            
            // Set contact list from manager
            self.phoneContacts = ContactManager.sharedManager.phoneContactList
            self.contactObjectList = ContactManager.sharedManager.contactObjectList
            self.letters = ContactManager.sharedManager.letters
            self.dataArray = ContactManager.sharedManager.dataArray
            self.tuples = ContactManager.sharedManager.tuples
            self.contactObjectTable = ContactManager.sharedManager.contactObjectTable

            // Fetch from server
            //self.sortContacts()
            
        }else{
            // Fetch contacts here
            self.getContacts()
        }

        
        // Configure bar
        self.configureCustomSearchController()
        
        // Config textfields
        phoneLabel.disableFloatingLabel = true
        emailLabel.disableFloatingLabel = true
        tagsLabel.disableFloatingLabel = true
        notesLabel.disableFloatingLabel = true
        firstNameLabel.disableFloatingLabel = true
        lastNameLabel.disableFloatingLabel = true
        
        // Config index style
        self.tableView.sectionIndexBackgroundColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)//UIColor.clear
        self.tableView.sectionIndexColor = UIColor.white//UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        
        
        // Set token view
        tokenField = KSTokenView(frame: self.tokenView.bounds)//CGRect(x: 10, y: 250, width: 300, height: 40))
        tokenField.delegate = self as? KSTokenViewDelegate
        tokenField.promptText = " "
        tokenField.font = UIFont.systemFont(ofSize: 18)
        tokenField.placeholder = "Tags"
        tokenField.descriptionText = ""
        tokenField.activityIndicatorColor = UIColor.green
        tokenField.maxTokenLimit = 5
        tokenField.style = .squared
        tokenField.shouldHideSearchResultsOnSelect = true
        tokenField.searchResultSize = CGSize()
        tokenField.direction = .horizontal
        
        // Config container view
        let containerView = UIView(frame: CGRect(x: tokenField.frame.origin.x, y: tokenField.frame.height - 0.5, width: self.tagsLabel.frame.size.width,  height: 0.50))
        containerView.backgroundColor = UIColor.white
        // Add to token field
        self.tokenView.addSubview(containerView)
        
        
        // Add to view
        self.tokenView.addSubview(tokenField)
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Fix tableview hight
        //tableView.frame = CGRect(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.view.frame.size.height)
        
        if ContactManager.sharedManager.userArrivedFromLocationVC{
            // Set textfield text
            self.notesLabel.text = ContactManager.sharedManager.selectedLocation
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // Fix tableview hight
        tableView.frame = CGRect(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.view.frame.size.height - 50)
        
        // Lay out views again
        //self.view.layoutSubviews()
        //self.view.layoutIfNeeded()
        
        // Reset location selection
        ContactManager.sharedManager.userArrivedFromLocationVC = false
        ContactManager.sharedManager.selectedLocation = ""
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
            
        }
        
        
        /*else{
            
            if ContactManager.sharedManager.userSelectedRecipient {
                
            }
            // CNContact Objects
            let contact = ContactManager.sharedManager.contactToIntro
            let recipient = ContactManager.sharedManager.recipientToIntro
            
            // Check if they both have email
            
            if contact.emailAddresses.count > 0 && recipient.emailAddresses.count > 0 {
                
                print("Contact Object 1 \n\n\(contact.emailAddresses)")
                print("\n\nContact Object 2 \n\n\(recipient.emailAddresses)")
                
                
                let contactEmail = contact.emailAddresses[0].value as String
                let recipientEmail = recipient.emailAddresses[0].value as String
                
                // Add to transaction
                self.transaction.recipientEmails = []
                self.transaction.recipientEmails?.append(contactEmail)
                self.transaction.recipientEmails?.append(recipientEmail)
                
                // Launch Email client
                showEmailCard()
                
            }else if contact.phoneNumbers.count > 0 && recipient.phoneNumbers.count > 0 {
                
                let contactPhone = (contact.phoneNumbers[0].value).value(forKey: "digits") as? String
                let recipientPhone = (recipient.phoneNumbers[0].value).value(forKey: "digits") as? String
                
                // Add to transaction
                self.transaction.recipientPhones = []
                self.transaction.recipientPhones?.append(contactPhone!)
                self.transaction.recipientPhones?.append(recipientPhone!)
                
                // Launch text client
                showSMSCard()
                
            }else{
                // No mutual way to connect
                // Pick default based on what the contact object has populated
                
                // ***** Handle this off case tomorrow ****
                print("No Mutual Info")
            }
            
        }*/
    
        
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
            return contactSearchResults.count
        }
        else {
            //print("Section row count >>", contactsHashTable[letters[section]]!.count)
            return contactObjectTable[letters[section]]!.count
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
                //let placeholderImage = UIImage(named: "profile")!
                // Set image
                cell.contactImageView?.setImageWith(url)*/
                
                // Set from data
                cell.contactImageView?.image = UIImage(data: contact.imageData)
                
                
            }else{
                // Set to default
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
                /*print("Has IMAGE")
                // Set id
                let id = contact?.imageId
                
                // Set image for contact
                let url = URL(string: "\(ImageURLS.sharedManager.getFromDevelopmentURL)\(id ?? "").jpg")!
                //let placeholderImage = UIImage(named: "profile")!
                // Set image
                cell.contactImageView?.setImageWith(url)*/
                
                // Set from data
                cell.contactImageView.image = UIImage(data: (contact?.imageData)!)
                
                
            }else{
                // Set from default
                cell.contactImageView.image = UIImage(named: "profile")
            }
            
            
        }
        
        
        // Configure imageviews
        self.configureSelectedImageView(imageView: cell.contactImageView)
        
        
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
            print("The selected contact \(self.selectedContactObject.toAnyObject())")
            
        }else{
            // Set selected contact
            self.selectedContactObject = (contactObjectTable[letters[indexPath.section]]?[indexPath.row])!
            print("The selected contact \(self.selectedContactObject.toAnyObject())")
        }

        // Set selected contact from conversion
        self.selectedContact = self.contactToCNContact(contact: self.selectedContactObject)
        
        print("The object after selection\n\n\(selectedContact)")
        
        // Print to test
        print(self.selectedContact.givenName)
        // Make conditional checks to see where user navigated from
        if ContactManager.sharedManager.userArrivedFromIntro != true {
            
            // Set bool to true
            ContactManager.sharedManager.userArrivedFromIntro = true
            
            // Set bool to false
            ContactManager.sharedManager.userSelectedNewContactForIntro = false
            
            // Set Contact on Manager
            ContactManager.sharedManager.contactToIntro = selectedContact
            
            print("User arrived from intro on first selection \(ContactManager.sharedManager.userArrivedFromIntro)")
            print("User selected form contact \(ContactManager.sharedManager.userSelectedNewContactForIntro)")
            
            // Notification for intro screen
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ContactSelected"), object: self)
            
            // Drop view
            dismiss(animated: true, completion: nil)
        }else{
            // Set Contact on Manager
            ContactManager.sharedManager.recipientToIntro = selectedContact
            
            // Set nav bool
            //ContactManager.sharedManager.userSelectedNewRecipientForIntro = true
            
            
            print("User arrived from intro on second selection \(ContactManager.sharedManager.userArrivedFromIntro)")
            print("User selected form contact on second selection \(ContactManager.sharedManager.userSelectedNewContactForIntro)")
            print("User selected recipient on second selection \(ContactManager.sharedManager.userSelectedNewRecipientForIntro)")
            
            // Post for recipient selected
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RecipientSelected"), object: self)
            
            // Drop View
            dismiss(animated: true, completion: nil)
        }
        
        
        
        // Notification for intro screen
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ContactSelected"), object: self)        // Set selected tab
        
        
        // Sync up with main queue
        DispatchQueue.main.async {
            // Set selected tab
            //self.tabBarController?.selectedIndex = 1
            // Drop view
            self.navigationController?.popViewController(animated: true)
        }

        
    }

    // Search Bar Configuration & Delegates
    
    
    func configureCustomSearchController() {
        
        // Init blue color
        let blue = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        
        customSearchController = CustomSearchController(searchResultsController: self, searchBarFrame: CGRect(x: 0.0, y: 0.0, width: self.tableView.frame.size.width, height: 35.0), searchBarFont: UIFont(name: "Avenir", size: 16.0)!, searchBarTextColor: blue, searchBarTintColor: UIColor.white)
        
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
    
    // Textfield Delegate
    
    // Textfield delegate
    func textFieldDidChange(_ textField: UITextField) {
        
        // Show location
        self.showLocationVC()
        
    }
    
    // Show location
    
    func showLocationVC(){
        
        // Call the viewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LocationVC")
        self.present(controller, animated: true, completion: nil)
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
        // Clear search results array
        self.contactSearchResults.removeAll()
        
        
        DispatchQueue.main.async {
            
            KVNProgress.show(withStatus: "Searching...")
            
            // Init search results
            let results = self.fuse.search(self.searchText, in: self.contactObjectList)
            
            self.contactSearchResults = results.map { (index, _, matchedRanges) in
                
                // Init contact from results
                let contact = self.contactObjectList[index]
                
                return contact
                
            }
            // Refresh table
            self.tableView.reloadData()
            
            // Drop it
            KVNProgress.dismiss()
        }
        
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            // Hit search endpoint
            self.tableView.reloadData()
        }
        
        // Refresh table
        self.tableView.reloadData()
    }
    
    
    func didTapOnCancelButton() {
        shouldShowSearchResults = false
        self.tableView.reloadData()
        // Clear search results array
        self.contactSearchResults.removeAll()
    }
    
    
    func didChangeSearchText(_ searchText: String) {
        
        self.searchText = searchText
        
        print("self search text \(self.searchText)")

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
    
    
    // Contact management

    func contactToCNContact(contact: Contact) -> CNContact {
        var cnObject = CNContact()
        
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
        var lastName: String = fullNameArr.count > 1 ? fullNameArr[1] : ""
        
        // Add names
        contactToAdd.givenName = firstName
        contactToAdd.familyName = lastName ?? ""
        
        // Check for count
        if contact.phoneNumbers.count > 0 {
            
            // Iterate over items
            for number in contact.phoneNumbers{
                // print to test
                //print("Number: \((number.value.value(forKey: "digits" )!))")
                
                // Parse for mobile
                let mobileNumber = CNPhoneNumber(stringValue: (number["phone"] ?? ""))
                let mobileValue = CNLabeledValue(label: CNLabelPhoneNumberMobile, value: mobileNumber)
                contactToAdd.phoneNumbers = [mobileValue]
                
            }
            
            
        }
        if contact.emails.count > 0 {
        
            // Iterate over array and pull value
            for address in contact.emails {
                // Print to test
                print("Email : \(address["email"]!)")
                
                // Parse for emails
                let email = CNLabeledValue(label: CNLabelWork, value: address["email"] as NSString? ?? "")
                contactToAdd.emailAddresses = [email]
            
            }
        
        }
        
        
        if contact.imageId != "" {
            // Assign
            contactToAdd.imageData = contact.imageData
        }

        
        // Cast mutable contact back to regular contact
        cnObject = contactToAdd as CNContact
        
        print("Immutable Copy \(cnObject)")
        print("Immutable Copy Phones \(cnObject.phoneNumbers)")
        print("Immutable Copy Emails \(cnObject.emailAddresses)")
        
        
        // Return the non mutable copy
        return cnObject
    
    }
    
    
    func fetchContactsForUser() {
        // Fetch the user data associated with users
        
        var errorOccured = false
        
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
                //print(userArray)
                
                let userList = userArray?["data"] as! NSArray
                
                
                // Iterate over array, append trans to list
                for item in userList{
                    
                    print("Contact Item >> \(item)")
                    
                    let social = item as! NSDictionary
                    
                    print("The newest social", social["addresses"] as? NSArray ?? NSArray())
                    
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
            KVNProgress.dismiss()
            
        })
        
    }

    
    func getContacts() {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        if status == .denied || status == .restricted {
            
            print("Permission status >> \(status)")
            // Send them to the setting page
            self.presentSettingsActionSheet()
            return
        }
        
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
            self.contactObjectList = self.createContactRecords(phoneContactList: self.phoneContacts)
            
            // Sort list
            //self.sortContacts()
            
            // Get contacts
            self.fetchContactsForUser()
            
            
            
            // Find out if contacts synced
            self.synced = UDWrapper.getBool("contacts_synced")
            print("Contacts sync value!! >> \(self.synced)")
            //synced = false
            //print("Contacts overwrite sync value!! >> \(synced)")
            
            
            // Sync up with main queue
            DispatchQueue.main.async {
                
                // Upload Contacts
                //self.uploadContactRecords()
                // Reload the tableview.
                //self.tableView.reloadData()
                
                /*
                 if self.synced{
                 
                 print("Contacts synced!! >> \(self.synced)")
                 //Set bool to indicate contacts have been synced
                 //UDWrapper.setBool("contacts_synced", value: true)
                 
                 }else{
                 
                 // Upload Contacts
                 self.uploadContactRecords()
                 }*/
                
            }
            
        }
        /*DispatchQueue.main.async {
         
         // Sort list
         //self.sortContacts()
         // Reload the tableview.
         self.tblSearchResults.reloadData()
         }*/
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
    
    // Sort the contact list
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
                print("\n\nAdded >>>> \(list + [name])")
                return list + [name]
            }
            return list
        })
        
        // If first index is the misc, move to end of array
        if letters.first == "#" {
            // Move to end of array
            letters = self.rearrange(array: letters, fromIndex: 0, toIndex: letters.endIndex)
            // Test
            print("The new letters array\n\(letters)")
        }
        
        
        // Create indicies based on letters
        for letter in letters{
            
            // Create section in hash table
            contactsHashTable[letter] = [CNContact]()
            // Unify contacts table
            contactObjectTable[letter] = [Contact]()
            
        }
        
        /*
         // Apple contacts
         for contact in self.phoneContacts{
         // Init contact name
         var contactName : String = self.formatter.string(from: contact) ?? "No Name"
         // Uppercase the name
         contactName = contactName.uppercased()
         
         var fullNameArr = contactName.components(separatedBy: " ")  //split(contactName) {$0 == " "}
         
         let firstName: String = fullNameArr[0]
         var lastName: String = fullNameArr.count > 1 ? fullNameArr[1] : firstName
         
         
         // Check if section exists
         if contactsHashTable[String(describing: lastName.characters.first ?? "#")] == nil{
         //print("Hash Section Empty!")
         // If empty, initialize list
         contactsHashTable[String(describing: lastName.characters.first ?? "#")] = []
         }
         // Add contact to list
         //let charString = self.formatter.string(from: contact)?.uppercased() ?? "NO NAME"
         let startIndex = String(describing: lastName.characters.first ?? "#")
         print("Start Index: >> \(startIndex)")
         
         
         contactsHashTable[startIndex]!.append(contact)
         //print("Section count for added item")
         //print(contactsHashTable[startIndex]?.count)
         }*/
        
        
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
        
        
        
        /*
         // Sort list
         for (section, list) in contactObjectTable {
         
         // contacts[section] = list.sorted{ $0.givenName > $1.givenName}
         
         let array = list.sorted(by: { (object1, object2) -> Bool in
         object1.name < object2.name
         })
         
         // Set sorted array
         contactObjectTable[section] = array
         
         // Test output
         print("THE unify contacts hash table section list count")
         print(contacts[section]?.count)
         print(list)
         }
         
         // Sort list
         for (section, list) in contactsHashTable {
         
         // contacts[section] = list.sorted{ $0.givenName > $1.givenName}
         
         let array = list.sorted(by: { (object1, object2) -> Bool in
         object1.givenName < object2.givenName
         })
         
         // Set sorted array
         contactsHashTable[section] = array
         
         }
         */
        
        
        // Assign table data
        //self.tableData = contactsHashTable
        
        //print("Table Data \n\(self.tableData)")
        
        //print(contactObjectTable)
        
        //print("The Table Count >> ", contactObjectTable.count)
        
        DispatchQueue.main.async {
            
            // Reload data
            self.tableView.reloadData()
        }
        
        // Set hash to contact manager
        //ContactManager.sharedManager.contactsHashTable = self.contactsHashTable
        
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
                    // Set to contact object
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
                    
                    /*
                    if self.synced != true {
                        // Upload Record
                        ImageURLS.sharedManager.uploadImageToDev(imageDict: imageDict)
                    }else{
                        //
                        print("The users image has been uploaded already")
                    }*/
                    
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
                
                
                let addy = "\(street), \(city) \(state) \(zip), \(country)"
                
                //let formattedAddress = formatter.string(from: address!)
                
                //let trimmed = String(formattedAddress.characters.filter { !"\n\t\r".characters.contains($0) })
                
                
                
                print("The address is \(addy)")
                
                
                // Append to object
                contactObject.setAddresses(address: addy)
                
            }
            
            // Test object
            //print("Contact >> \n\(contactObject.toAnyObject()))")
            
            // Parse own record
            contactObject.parseContactRecord()
            
            // Append object to contactObjectList
            contactObjectList.append(contactObject)
            
            
            // Print count
            print("List Count ... \(contactObjectList.count)")
        }
        
        return contactObjectList
    }

    
    
    
    
    // Settings
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        if shouldShowSearchResults {
            
            return false
        }else{
            return true
        }

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
        self.getContacts()
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
            
            
            if contact.emailAddresses.count > 0 {
                email = (contact.emailAddresses[0].value as String)
            }
            // Set card link from cardID
            let cardLink = "https://project-unify-node-server.herokuapp.com/card/render/\(ContactManager.sharedManager.selectedCard.cardId!)"
            
            // Configure message
            let str = "\n\n\n\(cardLink)"
            
            //let str = ""
            
            // Check here if logic needed
            if self.tableView.isHidden {
                // Take selected phone from form
                // Set selected phone
                self.selectedContactPhone = self.phoneLabel.text ?? ""
                composeVC.recipients = [selectedContactPhone]
            }else{
                
                if contact.phoneNumbers.count > 0 && recipient.phoneNumbers.count > 0 {
                    
                    let contactPhone = (contact.phoneNumbers[0].value).value(forKey: "digits") as? String
                    // Set contact phone number
                   // phone = contactPhone!
                    
                    let recipientPhone = (recipient.phoneNumbers[0].value).value(forKey: "digits") as? String
                    
                    // Launch text client
                    composeVC.recipients = [contactPhone!, recipientPhone!]
                }

                
            }
            

            
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
        
        if self.tableView.isHidden == false{
            // Recipient name from the contact object
            recipientName = formatter.string(from: recipient) ?? "No Name"
        }else{
            recipientName = "\(self.firstNameLabel.text ?? "") \(self.lastNameLabel.text ?? "")"
        }
        
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
        
        let str = "\n\n\n\(cardLink)"
        
        
        if self.tableView.isHidden {
            print("Table hidden")
            // Default to form
            emailContact = self.emailLabel.text ?? ""
            
            // Create Message
            mailComposerVC.setToRecipients([emailContact])
        }else{
            print("Table showing")
            // Create Message
            mailComposerVC.setToRecipients([emailContact, emailRecipient])
            
        }
        
        
        
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
        imageView.layer.borderWidth = 0.5
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15    // Create container for image and name
        
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
            
            if tokenField.text != "" {
                // Iterate and set
                contact.setTags(tag: tokenField.text ?? "")
            }
            
            /*
            // Set notes
            if tagsLabel.text != nil{
                
                var fullString = tagsLabel.text!
                
                let tokenArray = fullString.components(separatedBy: " ")//split(fullString) {$0 == " "}
                
                print("Token Array\n\(tokenArray)")
                
                for item in tokenArray {
                    // Iterate and set
                    contact.setTags(tag: item)
                }
                
                
            }*/
            
            // Check for phone
            if phoneLabel.text != nil {
                // Set the number to contact
                contact.phoneNumbers.append(["phone": phoneLabel.text!])
            }
            // Check for email
            if emailLabel.text != nil{
                // Set email
                contact.emails.append(["email": emailLabel.text!])
            }
            
            
            if self.syncContactSwitch.isOn == true {
                
                // Set bool for contact sync
                ContactManager.sharedManager.syncIntroContactSwitch = true
                print("The intro switch was on")
                self.syncContact()
                
            }
            
            // Set manager navigation path
            ContactManager.sharedManager.userSelectedNewContactForIntro = true
            
            // Set as manager contact to intro
            ContactManager.sharedManager.contactObjectForIntro = self.contact
            
            // Check intent
            if ContactManager.sharedManager.userArrivedFromIntro != true {
                
                // Set bool to true
                ContactManager.sharedManager.userArrivedFromIntro = true
                
                // Let off notification
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ContactSelected"), object: self)
                
            }else{
                // Set bool to true
                ContactManager.sharedManager.userSelectedNewRecipientForIntro = true
                
                // Let off notification
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RecipientSelected"), object: self)
            
            }
            
            
            
            // Popview
            self.navigationController?.popViewController(animated: true)
            
            
            
            /*
            // Check for match in contact info
            let introContact = ContactManager.sharedManager.contactToIntro
            
            if introContact.emailAddresses.count > 0 && contact.emails.count > 0 {
                
                //
                self.selectedEmail = introContact.emailAddresses[0].value as String
                
                //let recipientEmail = recipient.emailAddresses[0].value as String
 
                
                // Launch Email client
                //showEmailCard()
                
            }else if introContact.phoneNumbers.count > 0 && contact.phoneNumbers.count > 0 {
                // Set selected phone
                self.selectedContactPhone = ((introContact.phoneNumbers[0].value).value(forKey: "digits") as? String)!
                
                // Launch text client
                //showSMSCard()
                
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
            
            }*/
            
            // Form valid
            return true
            
        }
    }
    
    

    
    func toggleViews(sender: UISegmentedControl) {
        
        print("Toggling views for selection")
        
        switch(sender.selectedSegmentIndex) {
        case 1:
            // Test
            print("Segment Two")
            // Hide view 
            self.tableView.isHidden = true
            
        case 0:
            // Test
            print("Segment One")
            // Hide view
            self.tableView.isHidden = false

        default:
            // Test
            print("Segment One")
            // Hide view
            self.tableView.isHidden = false

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
        
        /*let conf = KVNProgressConfiguration.default()
        conf?.isFullScreen = true
        conf?.statusColor = UIColor.white
        conf?.successColor = UIColor.white
        conf?.circleSize = 170
        conf?.lineWidth = 10
        conf?.statusFont = UIFont(name: ".SFUIText-Medium", size: CGFloat(25))
        conf?.circleStrokeBackgroundColor = UIColor.white
        conf?.circleStrokeForegroundColor = UIColor.white
        conf?.backgroundTintColor = UIColor(red: 0.173, green: 0.263, blue: 0.856, alpha: 0.4)
        KVNProgress.setConfiguration(conf!)*/
        
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
        let mobileNumber = CNPhoneNumber(stringValue: (self.contact.phoneNumbers[0].values.first ?? ""))
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
        
        // Configure notes field
        var notesString = "Unify Location:\n\(self.notesLabel.text ?? "") "
        
        notesString += "\nUnify Tags:\n\(self.tokenField.text ?? "")"
        
        // Set notes to contact
        contactToAdd.note = notesString
        
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
    
    func presentSettingsActionSheet() {
        let alert = UIAlertController(title: "Permission to Contacts", message: "This app needs access to contacts in order to ...", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default) { _ in
            let url = URL(string: UIApplicationOpenSettingsURLString)!
            UIApplication.shared.open(url)
        })
        
        // Add action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // Show the alert
        present(alert, animated: true)
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
        
        // CNContact Objects
        let contact = ContactManager.sharedManager.contactToIntro
        let recipient = ContactManager.sharedManager.recipientToIntro
        
        // Check if they both have email
        
        if contact.emailAddresses.count > 0 && recipient.emailAddresses.count > 0 {
            
            let contactEmail = contact.emailAddresses[0].value as String
            let recipientEmail = recipient.emailAddresses[0].value as String
            
            // Add to transaction
            self.transaction.recipientEmails = []
            self.transaction.recipientEmails?.append(contactEmail)
            self.transaction.recipientEmails?.append(recipientEmail)
        
        }
        
        if contact.phoneNumbers.count > 0 && recipient.phoneNumbers.count > 0 {
            
            let contactPhone = (contact.phoneNumbers[0].value).value(forKey: "digits") as? String
            let recipientPhone = (recipient.phoneNumbers[0].value).value(forKey: "digits") as? String
            
            // Add to transaction
            self.transaction.recipientPhones = []
            self.transaction.recipientPhones?.append(contactPhone!)
            self.transaction.recipientPhones?.append(recipientPhone!)
            
        }
        
        
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
            
            // Set location from field
            transaction.location = self.notesLabel.text ?? ""
            
            /*
            if self.syncContactSwitch.isOn == true {
                
                // Set bool for contact sync
                ContactManager.sharedManager.syncIntroContactSwitch = true
                
                
                // Upload sync contact record
                //self.syncContact()
                
                
            }*/

        }
        
        
        // Show progress hud
        
       /* let conf = KVNProgressConfiguration.default()
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
