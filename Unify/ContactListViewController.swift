//
//  ContactListViewController.swift
//  Unify
//
//  Created by Kevin Fich on 6/27/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit
import Contacts



class ContactListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating
{
    
    
    // Properties
    // ---------------------------------
    var cellReuseIdentifier = "ContactListCell"
    var searchController = UISearchController()
    
    var contactStore = CNContactStore()
    
    var contactList = [CNContact]()
    let formatter = CNContactFormatter()

    var selectedContact = CNContact()
    var currentUserContact = CNContact()
    
    // Progress hud
    var progressHUD = KVNProgress()
    
    
    // IBOutlets
    // ---------------------------------
    @IBOutlet var contactListTableView: UITableView!

   
    // Page Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Contact formatter style
        formatter.style = .fullName
        
        // Add loading indicator
    
        KVNProgress.show(withStatus: "Syncing Contacts...")
        
        // Parse for contacts in contact list
        ContactManager.sharedManager.getContacts()
        
        // Observers for notifications 
        addObservers()

        // Do any additional setup after loading the view.
        
        // Tableview config 
        // Index tracking strip 
        contactListTableView.sectionIndexBackgroundColor = UIColor.white
        contactListTableView.sectionIndexColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)

        
        // Search controller
        searchController = UISearchController(searchResultsController: nil)
        searchController.view.backgroundColor = UIColor.white
        searchController.searchBar.backgroundColor = UIColor.white
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = NSLocalizedString("Search", comment: "")
        
        // Add the search bar
        contactListTableView.tableHeaderView = self.searchController.searchBar
        definesPresentationContext = true
        searchController.searchBar.sizeToFit()
        
        // Style search bar
        //searchController.searchBar.barStyle = UIBarStyle.
        searchController.searchBar.changeSearchBarColor(color: UIColor.white)
        searchController.searchBar.backgroundColor = UIColor.white
        
        
        
        // Reload Data 
        contactListTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Search Bar Delegate 
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
    // TableView Delegates and DataSource
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
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
        
        return cell!
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
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
    
    
    // Custom Methods
    func addObservers() {
        // Call to refresh table
        NotificationCenter.default.addObserver(self, selector: #selector(ContactListViewController.refreshTableData), name: NSNotification.Name(rawValue: "RefreshContactList"), object: nil)
        
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
