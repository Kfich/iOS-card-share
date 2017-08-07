//
//  ContactListViewController.swift
//  Unify
//
//  Created by Kevin Fich on 6/27/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit
import Contacts



class ContactListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
{
    
    
    // Properties
    // ---------------------------------
    var cellReuseIdentifier = "ContactListCell"
    var searchController = UISearchController()
    
    var contactStore = CNContactStore()
    
    var contactList = [CNContact]()
    var filteredContactList : [CNContact]?
    let formatter = CNContactFormatter()

    var selectedContact = CNContact()
    var currentUserContact = CNContact()
    var selectedIndexPath = Int()
    
    // Progress hud
    var progressHUD = KVNProgress()
    
    // Index in track of contact records
    var index = 0
    var helloWorldTimer = Timer()
    
    
    
    // IBOutlets
    // ---------------------------------
    @IBOutlet var contactListTableView: UITableView!

   
    // Page Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Contact formatter style
        formatter.style = .fullName
        
    
        
        // Parse for contacts in contact list
        if ContactManager.sharedManager.phoneContactList.isEmpty{
           // Add loading indicator
            KVNProgress.show(withStatus: "Syncing Contacts...")
            // Make call to get contacts
            ContactManager.sharedManager.getContacts()
        }else{
            // Refresh table
            print("Contacts should be set")
        }
                
        // Observers for notifications 
        addObservers()

        // Do any additional setup after loading the view.
        
        // Tableview config 
        // Set delegate for empty state
        contactListTableView.emptyDataSetSource = self
        contactListTableView.emptyDataSetDelegate = self
        // Index tracking strip 
        contactListTableView.sectionIndexBackgroundColor = UIColor.white
        contactListTableView.sectionIndexColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)

        
        // Search controller
        searchController = UISearchController(searchResultsController: nil)
        searchController.view.backgroundColor = UIColor.white
        searchController.searchBar.backgroundColor = UIColor.white
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = NSLocalizedString("Search", comment: "")
        
        // Add the search bar
        contactListTableView.tableHeaderView = self.searchController.searchBar
        definesPresentationContext = true
        searchController.searchBar.sizeToFit()
        
        // Style search bar
        //searchController.searchBar.barStyle = UIBarStyle.
        //searchController.searchBar.changeSearchBarColor(color: UIColor.white)
        //searchController.searchBar.backgroundColor = UIColor.white
        
        
        
        // Reload Data 
        contactListTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Search Bar Delegate 
    
    /*func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredNFLTeams = unfilteredNFLTeams.filter { team in
                return team.lowercased().contains(searchText.lowercased())
            }
            
        } else {
            filteredNFLTeams = unfilteredNFLTeams
        }
        tableView.reloadData()
    }*/

    
    // TableView Delegates and DataSource
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        /*guard let contacts = filteredContactList else{
            return 0
        }
        return contacts.count*/
        
        return ContactManager.sharedManager.phoneContactList.count //contactList.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
        
        // Add tap gesture to follow up button
        self.addGestureToImage(image: (cell?.introImageView)!, index: indexPath.row)
        
        
        
        return cell!
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Deselect rows 
        contactListTableView.deselectRow(at: indexPath, animated: true)
        
        print("You selected Conact --> \(ContactManager.sharedManager.phoneContactList[indexPath.row])")
        // Assign selected contact
        selectedContact = ContactManager.sharedManager.phoneContactList[indexPath.row]
        // Pass in segue
        self.performSegue(withIdentifier: "showContactProfile", sender: indexPath.row)
        /*ContactManager.sharedManager.userArrivedFromContactList = true
        
        if ContactManager.sharedManager.userArrivedFromIntro{
            // Perform information transfer
            // -> Give contact record to the manager
            
            
            // Navigate appropriately
            
            dismiss(animated: true, completion: nil)
            ContactManager.sharedManager.userArrivedFromIntro = false
        }else{
            
            // Show contact profile and set arrival to false
            self.performSegue(withIdentifier: "showContactProfile", sender: indexPath.row)
            ContactManager.sharedManager.userArrivedFromContactList = false
            
        }*/
    }
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Config the alphabet
        return 2
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

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U", "V", "W", "X", "Y", "Z"]
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "G"
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        print("PRINTING")
        
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredContactList = ContactManager.sharedManager.phoneContactList.filter { contact in
                return contact.givenName.lowercased().contains(searchText.lowercased())
            }
            
        } else {
            filteredContactList = ContactManager.sharedManager.phoneContactList
        }
        contactListTableView.reloadData()
        
        
    }
    
    // Custom Methods
    
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
    
    func addObservers() {
        // Call to refresh table
        NotificationCenter.default.addObserver(self, selector: #selector(ContactListViewController.refreshTableData), name: NSNotification.Name(rawValue: "RefreshContactList"), object: nil)
        
    }

    func refreshTableData() {
        
        //DispatchQueue.main.async {
        //self.uploadContactRecords()
        
        let synced = UDWrapper.getBool("contacts_synced")
        
        
        // Reload contact list
        DispatchQueue.main.async {
            
            // Check if contacts already synced
            if synced{
                // already done
                print("Contacts already synced")
            }else{
                // Sync records
               // self.uploadContactRecords()
            }
            
            // Hide HUD
            KVNProgress.showSuccess()
            // Update UI
            self.contactListTableView.reloadData()
            
        }
    }
    
    func uploadContactRecords(){
        // Call function from manager
        //ContactManager.sharedManager.uploadContactRecords()
        
        helloWorldTimer = Timer.scheduledTimer(timeInterval: 0.2 , target: self, selector: #selector(ContactListViewController.uploadRecord), userInfo: nil, repeats: true)
        
        //  Start timer
        helloWorldTimer.fire()
        
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
            self.helloWorldTimer.invalidate()
            
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
            destination.selectedContact = self.selectedContact
            
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
