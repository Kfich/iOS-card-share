//
//  SelectContactViewController.swift
//  Unify
//


import AlgoliaSearch
import InstantSearchCore
import Firebase
import UIKit
import PopupDialog
import CoreLocation
import Skeleton
import Contacts

class SelectContactViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, CustomSearchControllerDelegate
{
    
    // IBOutlets
    // --------------------------------------
    @IBOutlet weak var contactListTableView: UITableView!
    @IBOutlet var seachBarWrapperView: UIView!
    
    
    // Properties
    // --------------------------------------
    var dataArray = [String]()
    
    // Fuse for search results
    var fuse = Fuse()
    
    var formatter = CNContactFormatter()
    var filteredArray = [String]()
    
    var shouldShowSearchResults = false
    
    var searchController: UISearchController!
    
    var customSearchController: CustomSearchController!
    
    var index = 0
    
    var timer = Timer()
    
    // Sorted contact list
    var letters: [String] = []
    var contacts = [String: [String]]()
    
    
    var tuples = [(String, String)]()
    var contactTuples = [(String, CNContact)]()
    
    var selectedContact = CNContact()
    var phoneContacts = [CNContact]()
    var selectedContactObject = Contact()
    
    var contactObjectTable = [String: [Contact]]()
    var contactsHashTable = [String: [CNContact]]()
    var tableData = [String: [CNContact]]()
    var contactObjectList = [Contact]()
    var contactSearchResults = [Contact]()
    
    
    var searchText = ""
    
    
    // Page setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        contactListTableView.delegate = self
        contactListTableView.dataSource = self
        
        // Config index style
        contactListTableView.sectionIndexBackgroundColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)//UIColor.clear
        contactListTableView.sectionIndexColor = UIColor.white//UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        
        //loadListOfCountries()
        
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
    
    @IBAction func cancelSelection(_ sender: Any) {
        
        // Dismiss view
        dismiss(animated: true, completion: nil)
        // Drop view
        self.navigationController?.popViewController(animated: true)
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
            return contactObjectTable[letters[section]]!.count //contacts[letters[section]]!.count
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return letters
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
                
                // Set from default
                cell.contactImageView.image = UIImage(data: contact.imageData)
                
                
            }else{
                // Set from default
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
                
                // Set to default
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
        let lbl = UILabel(frame: CGRect(8, 3, 15, 15))
        
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
        
        // Print to test
        print(self.selectedContact.givenName)
        // Make conditional checks to see where user navigated from
        
        
        /*if ContactManager.sharedManager.userArrivedFromIntro != true {*/
            
        
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
        // Drop view
        self.navigationController?.popViewController(animated: true)
        
        
        //}
        
        
        /*else{
            // Set Contact on Manager
            ContactManager.sharedManager.recipientToIntro = selectedContact
            
            print("User arrived from intro on second selection \(ContactManager.sharedManager.userArrivedFromIntro)")
            print("User selected form contact on second selection \(ContactManager.sharedManager.userSelectedNewContactForIntro)")
            
            // Post for recipient selected
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RecipientSelected"), object: self)
            // Drop View
            dismiss(animated: true, completion: nil)
            // Drop view
            self.navigationController?.popViewController(animated: true)
        }*/
        
        
        
        /*
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
         
         print("User arrived from intro on second selection \(ContactManager.sharedManager.userArrivedFromIntro)")
         print("User selected form contact on second selection \(ContactManager.sharedManager.userSelectedNewContactForIntro)")
         
         // Post for recipient selected
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RecipientSelected"), object: self)
         // Drop View
         dismiss(animated: true, completion: nil)
         }
         
         
         }
         }*/
        
    }
    
    
    // MARK: Custom functions
    
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
        tuples.removeAll()
        contactTuples.removeAll()
        dataArray.removeAll()
        
        // Fetch contact list
        getContacts()
    }
    
    func configureSelectedImageView(imageView: UIImageView) {
        // Config imageview
        
        // Configure borders
        imageView.layer.borderWidth = 0.5
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15    // Create container for image and name
        
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
            //self.synced = UDWrapper.getBool("contacts_synced")
            //print("Contacts sync value!! >> \(self.synced)")
            //synced = false
            //print("Contacts overwrite sync value!! >> \(synced)")
            
            
            // Sync up with main queue
            DispatchQueue.main.async {
                
                // Upload Contacts
                //self.uploadContactRecords()
                // Reload the tableview.
                self.contactListTableView.reloadData()
                
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
                    
                    // Set image data for local use
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
                //let address = contact.postalAddresses.first?.value
                
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
        contactListTableView.tableHeaderView = searchController.searchBar
    }
    
    
    func configureCustomSearchController() {
        
        // Init blue color
        let blue = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        
        customSearchController = CustomSearchController(searchResultsController: self, searchBarFrame: CGRect(x: 0.0, y: 0.0, width: contactListTableView.frame.size.width, height: 35.0), searchBarFont: UIFont(name: "Avenir", size: 16.0)!, searchBarTextColor: blue, searchBarTintColor: UIColor.white)
        
        customSearchController.customSearchBar.placeholder = "Search"
        customSearchController.customSearchBar.tintColor = blue
        //contactListTableView.tableHeaderView = customSearchController.customSearchBar
        // Add bar to view
        self.seachBarWrapperView.addSubview(customSearchController.customSearchBar)
        
        customSearchController.customDelegate = self
    }
    
    
    // MARK: UISearchBarDelegate functions
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        contactListTableView.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        contactListTableView.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            contactListTableView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    
    // MARK: UISearchResultsUpdating delegate function
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else {
            return
        }
        
        /*
         // Filter the data array and get only those countries that match the search text.
         filteredArray = dataArray.filter({ (country) -> Bool in
         let countryText:NSString = country as NSString
         
         return (countryText.range(of: searchString, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
         })
         
         // Reload the tableview.
         contactListTableView.reloadData()*/
    }
    
    
    // MARK: CustomSearchControllerDelegate functions
    
    func didStartSearching() {
        shouldShowSearchResults = true
        contactListTableView.reloadData()
    }
    
    
    func didTapOnSearchButton() {
        
        // Clear search results array
        self.contactSearchResults.removeAll()
        
        KVNProgress.show(withStatus: "Searching...")
        
        DispatchQueue.main.async {
            
            //    KVNProgress.show(withStatus: "Searching...")
            
            // Init search results
            let results = self.fuse.search(self.searchText, in: self.contactObjectList)
            
            let match = results.filter {$0.score < 0.1}
            
            let inRange = results.filter {$0.score > 0.01}
            
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
            
            let closeResults = inRange.map{ (index, score, matchedRanges) -> Contact in
                
                print("Score ", score)
                //print("Ranges Matched ", matchedRanges.)
                
                // Init contact from results
                let contact = self.contactObjectList[index]
                
                return contact
                
            }
            
            print("In Range ", closeResults)
            
            // Sort results
            self.sortSearchResultContacts()
            
            
            // Refresh table
            //self.tblSearchResults.reloadData()
            
        }
        
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            // Hit search endpoint
            self.contactListTableView.reloadData()
        }
        
        /*
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
            self.contactListTableView.reloadData()
            
            // Drop it
            KVNProgress.dismiss()
        }
        
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            // Hit search endpoint
            self.contactListTableView.reloadData()
        }
        
        // Refresh table
        self.contactListTableView.reloadData()*/
        
    }
    
    
    func didTapOnCancelButton() {
        shouldShowSearchResults = false
        contactListTableView.reloadData()
        
        // Clear search results array
        self.contactSearchResults.removeAll()
    }
    
    
    func didChangeSearchText(_ searchText: String) {
        // Set text
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
            self.contactListTableView.reloadData()
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
        
        print("Sorting the names")
        
        nameList.removeAll()
        nameList = contactSearchResults.map {$0.last}
        
        print("Sorted Search list\n", nameList)
        
        DispatchQueue.main.async {
            
            // Reload data
            self.contactListTableView.reloadData()
        }
        
        // Drop it
        KVNProgress.dismiss()
        
        // Set hash to contact manager
        //ContactManager.sharedManager.contactsHashTable = self.contactsHashTable
        self.contactListTableView.reloadData()
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
            for item in self.tuples {
                if item.1 == filteredArray[row] {
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
                    DispatchQueue.main.async {
                        // Set selected tab
                        self.tabBarController?.selectedIndex = 1
                    }
                    
                    
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
        let contact = Contact() //self.contactObjectTable[self.index]
        
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
    
    
    // Empty State Delegate Methods
    
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
        ContactManager.sharedManager.getContacts()
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
            let destination = segue.destination as! ContactProfileViewController
            // Assign selected contact object
            destination.selectedContact = self.selectedContact
            
            // Test
            print("Contact Passed in Seggy")
        }
        
        
    }
    
}
