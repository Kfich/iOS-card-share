//
//  Activity-ViewController.swift
//  Unify
//
//  Created by Ryan Hickman on 4/4/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit
import PopupDialog
import UIDropDown
import MessageUI


class ActivtiyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, CustomSearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating, UIActionSheetDelegate{
    
    // Properties
    // ----------------------------------------
    var currentUser = User()
    var transactions = [Transaction]()
    var transactionList =  [Transaction]()
    var transactionListReversed = [Transaction]()
    
    // Individual lists for segments
    var connections = [Transaction]()
    var introductions = [Transaction]()
    
    var selectedUsers = [User]()
    var selectedContacts = [Contact]()
    
    var selectedIndex = Int()
    var selectedTransaction = Transaction()
    var segmentedControl = UISegmentedControl()
    
    var customSearchController: CustomSearchController!
    var searchController: UISearchController!
    
    var shouldShowSearchResults = false
    
    var selectedUserEmails = [String]()
    var selectedUserPhones = [String]()
    var searchTransactionList = [Transaction]()
    
    var senderPhone = ""
    var senderEmail = ""
    
    
    @IBOutlet var navigationBar: UINavigationItem!
    // IBOutlets
    // ----------------------------------------
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var searchBarWrapperView: UIView!
    
    
    
    
    // Page Config
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        // Clear array list for fresh start
        self.transactions.removeAll()
        self.transactionListReversed.removeAll()
        self.transactions = [Transaction]()
        self.transactionListReversed = [Transaction]()
        self.connections.removeAll()
        self.introductions.removeAll()
        
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        // Add observers 
        self.addObservers()
        
        // Set currentUser object 
        currentUser = ContactManager.sharedManager.currentUser
        
        // Clear array list for fresh start
        self.transactions.removeAll()
        self.transactionListReversed.removeAll()
        self.transactions = [Transaction]()
        self.transactionListReversed = [Transaction]()
        self.connections.removeAll()
        self.introductions.removeAll()
    
        
        // Fetch the users transactions 
        getTranstactions()
        
        // Configure tableview
        tableView.dataSource = self
        tableView.delegate = self
        
        // Set delegate for empty state 
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        // View to remove separators
        tableView.tableFooterView = UIView()
        
        
        //tableView.estimatedSectionHeaderHeight = 8.0
        self.automaticallyAdjustsScrollViewInsets = false
        
       
        
        // Init and configure segment controller
        segmentedControl = UISegmentedControl(frame: CGRect(x: 10, y: 5, width: tableView.frame.width - 20, height: 30))
        // Set tint
        segmentedControl.tintColor = UIColor.white//UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        //segmentedControl.backgroundColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        
        segmentedControl.insertSegment(withTitle: "All", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Connections", at: 1, animated: false)
        segmentedControl.insertSegment(withTitle: "Introductions", at: 2, animated: false)
        // Init index
        segmentedControl.selectedSegmentIndex = 0
        
        // Add target action method
        segmentedControl.addTarget(self, action: #selector(ActivtiyViewController.reloadTableWithList(sender:)), for: .valueChanged)
        
        
        // Add segment control to navigation bar
        self.navigationBar.titleView?.backgroundColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        self.navigationBar.titleView = segmentedControl
        
        
        // Set graphics for background of tableview
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "backgroundGradient")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)

        
        // Set tint on main nav bar
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor(red: 28/255.0, green: 52/255.0, blue: 110/255.0, alpha: 1.0)]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        
        
        // Search Bar 
        configureCustomSearchController()
        
    }
    
    
    // TableView Delegate & Data Source

    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Set selected trans
        if segmentedControl.selectedSegmentIndex == 0 {
            // All
            self.selectedTransaction = transactionListReversed[indexPath.row]
        }else if segmentedControl.selectedSegmentIndex == 1 {
            // Connections
            self.selectedTransaction = connections[indexPath.row]
        }else{
            // Intro
            self.selectedTransaction = introductions[indexPath.row]
            
        }

        
        //if selectedTransaction.type
        // Get users in transaction
        
        if selectedTransaction.type == "connection" {
            // Hit for userList
            self.fetchUsersForTransaction()
            
        }else if self.selectedTransaction.type == "introduction" && self.selectedTransaction.senderId == self.currentUser.userId{
            // Get values from transaction
            self.selectedUserEmails = self.selectedTransaction.recipientEmails ?? [String]()
            self.selectedUserPhones = self.selectedTransaction.recipientPhones ?? [String]()
            
            print("Selected Tranny >> \(self.selectedTransaction.recipientPhones), \(self.selectedTransaction.recipientEmails)")
            
            // Show alert
            self.showActionAlert(phones: selectedUserPhones, emails: selectedUserEmails)
            
        }else{
            // Get contact list
            self.fetchContactsForTransaction()
        }
        
        // Pass in segue
        //self.performSegue(withIdentifier: "showFollowupSegue", sender: self)
        
        
    }
    
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Config container view
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        containerView.backgroundColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        
        // Create section header buttons
        let imageName = "icn-time.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 10, y: 10, width: 12, height: 12)
        
        // Add label to the view
        let lbl = UILabel(frame: CGRect(30, 9, 100, 15))
        // Empty header if searching
        if shouldShowSearchResults {
            // Empty header
            lbl.text = ""
        }else{
            lbl.text = "Recents"
        }

        lbl.textAlignment = .left
        lbl.textColor = UIColor.white
        lbl.font = UIFont(name: "Avenir", size: CGFloat(14))
        
        // Add subviews
        containerView.addSubview(lbl)
        containerView.addSubview(imageView)

        return containerView
    }
   
    
   
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32.0
    }
 
    
    //MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            
            return self.searchTransactionList.count
       
        }else {
            
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                return self.transactionListReversed.count
            case 1:
                return self.connections.count
            case 2:
                return self.introductions.count
            default:
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Check what cell is needed
        //var cell = UITableViewCell()
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "CellD") as! ActivityCardTableCell
        
        
            // Init transaction
        if shouldShowSearchResults {
            
            //return self.searchTransactionList.count
            let trans = searchTransactionList[indexPath.row]
            
            if trans.type == "introduction"{
                
                // Configure Cell
                cell = tableView.dequeueReusableCell(withIdentifier: "CellD") as! ActivityCardTableCell
                // Execute func
                configureViewsForIntro(cell: cell , index: indexPath.row)
                
                // Add tap gesture to cell labels
                self.addGestureToLabel(label: cell.approveButton, index: indexPath.row, intent: "approve")
                //self.addGestureToLabel(label: cell.rejectButton, index: indexPath.row, intent: "reject")
                
            }else {
                // Configure Cell
                cell = tableView.dequeueReusableCell(withIdentifier: "CellDb") as! ActivityCardTableCell
                // Execute func
                configureViewsForConnection(cell: cell , index: indexPath.row)
                
                // Add tap gesture to cell labels
                self.addGestureToLabel(label: cell.connectionApproveButton, index: indexPath.row, intent: "approve")
                //self.addGestureToLabel(label: cell.connectionRejectButton, index: indexPath.row, intent: "reject")
                
            }
        
            
        }else {
            
            let trans = transactionListReversed[indexPath.row]
            
            if trans.type == "introduction"{
                
                // Configure Cell
                cell = tableView.dequeueReusableCell(withIdentifier: "CellD") as! ActivityCardTableCell
                // Execute func
                configureViewsForIntro(cell: cell , index: indexPath.row)
                
                // Add tap gesture to cell labels
                self.addGestureToLabel(label: cell.approveButton, index: indexPath.row, intent: "approve")
                //self.addGestureToLabel(label: cell.rejectButton, index: indexPath.row, intent: "reject")
                
            }else {
                // Configure Cell
                cell = tableView.dequeueReusableCell(withIdentifier: "CellDb") as! ActivityCardTableCell
                // Execute func
                configureViewsForConnection(cell: cell , index: indexPath.row)
                
                // Add tap gesture to cell labels
                self.addGestureToLabel(label: cell.connectionApproveButton, index: indexPath.row, intent: "approve")
                //self.addGestureToLabel(label: cell.connectionRejectButton, index: indexPath.row, intent: "reject")
                
            }
            
            if segmentedControl.selectedSegmentIndex == 0 {
                // norhing
            }else if segmentedControl.selectedSegmentIndex == 1 {
                // Config for connections
                //let trans = connections[indexPath.row]
                // Configure Cell
                cell = tableView.dequeueReusableCell(withIdentifier: "CellDb") as! ActivityCardTableCell
                // Execute func
                configureViewsForConnection(cell: cell as! ActivityCardTableCell, index: indexPath.row)
                
            }else if segmentedControl.selectedSegmentIndex == 2{
                // Config for intro
                //let trans = introductions[indexPath.row]
                // Configure Cell
                cell = tableView.dequeueReusableCell(withIdentifier: "CellD") as! ActivityCardTableCell
                // Execute func
                configureViewsForIntro(cell: cell as! ActivityCardTableCell, index: indexPath.row)
            }
        
        }
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero

        return cell
    }
    
    // Tableview editing capabilities
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return tableView.isEditing ? UITableViewCellEditingStyle.none : UITableViewCellEditingStyle.delete
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler:{action, indexpath in
            
            // Reject transaction call
            self.rejectTransaction(index: indexPath.row)
            
            self.tableView.isEditing = false
            
            print("This is the cell to delete")
            
            
        })
        
        return [deleteRowAction]
    }
    
    
    
    // Search Config
    
    /*func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        
        // Place the search bar view to the tableview headerview.
        self.tableView.tableHeaderView = searchController.searchBar
    }*/
    
    func configureCustomSearchController() {
        
        // Init blue color 
        let blue = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        
        customSearchController = CustomSearchController(searchResultsController: self, searchBarFrame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: 35.0), searchBarFont: UIFont(name: "Avenir", size: 16.0)!, searchBarTextColor: blue, searchBarTintColor: UIColor.white)
        
        customSearchController.customSearchBar.placeholder = "Search"
        customSearchController.customSearchBar.tintColor = blue
        // Hide cancel button
        customSearchController.customSearchBar.showsCancelButton = false
        //self.tableView.tableHeaderView = customSearchController.customSearchBar
        // Add search bar to wrapper view 
        self.searchBarWrapperView.addSubview(customSearchController.customSearchBar)
        
        customSearchController.customDelegate = self
    }
    
    // MARK: UISearchBarDelegate functions
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        // Empty list
        self.searchTransactionList.removeAll()
        // Toggle cancel button
        customSearchController.customSearchBar.showsCancelButton = true
        self.tableView.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        // Toggle cancel button
        customSearchController.customSearchBar.showsCancelButton = false
        // Empty list
        self.searchTransactionList.removeAll()
        // Reload
        self.tableView.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            self.tableView.reloadData()
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
        //self.tableView.reloadData()
    }
    
    
    // MARK: CustomSearchControllerDelegate functions
    
    func didStartSearching() {
        shouldShowSearchResults = true
        print("Filtered list count >> \(self.searchTransactionList)")
        self.tableView.reloadData()
    }
    
    
    func didTapOnSearchButton() {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            // Hit search endpoint
            self.tableView.reloadData()
        }
        self.searchTransactions()
    }
    
    
    func didTapOnCancelButton() {
        shouldShowSearchResults = false
        // Empty list 
        self.searchTransactionList.removeAll()
        self.tableView.reloadData()
    }
    
    
    func didChangeSearchText(_ searchText: String) {
        // Filter the data array and get only those countries that match the search text.
        /*filteredArray = dataArray.filter({ (country) -> Bool in
            let countryText: NSString = country as NSString
            
            return (countryText.range(of: searchText, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })*/
        
        // Reload the tableview.
        self.tableView.reloadData()
    }
    
    // Action sheet 
    func showActionAlert(phones: [String], emails: [String]) {
        // Config action 
        let actionSheetController: UIAlertController = UIAlertController(title: "Please select", message: "Option to select", preferredStyle: .actionSheet)
        
        // Make Button
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        
        // Add button
        actionSheetController.addAction(cancelActionButton)
        
        // Make button
        let emailAction = UIAlertAction(title: "Email", style: .default)
        { _ in
            
            // Show email controller
            self.showEmailCard()
            
            print("Email")
        }
        // Add Buttoin
        actionSheetController.addAction(emailAction)
        
        // Make
        let textAction = UIAlertAction(title: "Text", style: .default)
        { _ in
            self.showSMSCard(recipientList: self.selectedUserPhones)
            //self.parseAndSend()
            //self.show
            
            print("Text")
        }
        // Add Buttoin
        actionSheetController.addAction(textAction)

        // Add
        let callAction = UIAlertAction(title: "Call", style: .default)
        { _ in
            print("call")
            
            // Get call ready
            // Set phone val
            var phone: String = ""
            
            //print(self.selectedTransaction.recipientCard?.cardProfile.phoneNumbers[0]["phone"])
            
            if self.selectedTransaction.senderId == self.currentUser.userId{
                 phone = (self.selectedTransaction.recipientCard?.cardProfile.phoneNumbers[0]["phone"]!)!
            }else if self.selectedTransaction.type == ""{
                phone = self.senderPhone
            }
            
            let result = String(phone.characters.filter { "01234567890.".characters.contains($0) })
            
            print(result)
            
            if let url = NSURL(string: "tel://\(result)"), UIApplication.shared.canOpenURL(url as URL) {
                UIApplication.shared.openURL(url as URL)
            }
            
            /*
            // configure call
            if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }*/

        }
    
            //  Add action
        actionSheetController.addAction(callAction)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    
    
    // Custom Methods
    
    // Event handler for segment control
    func reloadTableWithList(sender: UISegmentedControl) {
        
        print("Change color handler is called.")
        print("Changing Color to ")
        
        switch sender.selectedSegmentIndex {
        case 1:
            self.view.backgroundColor = UIColor.green
            print("Green")
            self.tableView.reloadData()
        case 2:
            self.view.backgroundColor = UIColor.blue
            print("Blue")
            self.tableView.reloadData()
        default:
            self.view.backgroundColor = UIColor.purple
            print("Purple")
            self.tableView.reloadData()
        }
        
        // Reload views
        self.view.layoutSubviews()
        self.view.layoutIfNeeded()
        
        // Refresh
        self.tableView.reloadData()
    }

    
    func addObservers() {
        // Call to show options
        NotificationCenter.default.addObserver(self, selector: #selector(ActivtiyViewController.setSelectedTransaction(sender:)), name: NSNotification.Name(rawValue: "Approve Connection"), object: nil)
        
        // Call Contacts sync
        NotificationCenter.default.addObserver(self, selector: #selector(ActivtiyViewController.setSelectedTransaction(sender:)), name: NSNotification.Name(rawValue: "Reject Connection"), object: nil)
        
        
    }
    
    func addGestureToLabel(label: UILabel, index: Int, intent: String) {
        // Init tap gesture
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(setSelectedTransaction(sender:)))
        label.isUserInteractionEnabled = true
        // Add gesture to image
        label.addGestureRecognizer(tapGestureRecognizer)
        // Set image index
        label.tag = index
        
        // Set description to view 
        //label.
    }
    
    func setSelectedTransaction(sender: UITapGestureRecognizer){
        
        let label = sender.view as! UILabel
        let intent = label.text!
        
        print("Sender Index: \((sender.view?.tag)!)")
        print("Intent : \(intent)")
        
        
        if segmentedControl.selectedSegmentIndex == 0 {
            // All
            self.selectedTransaction = transactionListReversed[(sender.view?.tag)!]
        }else if segmentedControl.selectedSegmentIndex == 1 {
            // Connections
            self.selectedTransaction = connections[(sender.view?.tag)!]
        }else{
            // Intro
            self.selectedTransaction = introductions[(sender.view?.tag)!]
            
        }

        // Post notification
        /*if intent == "approve" {*/
            // Approve transaction 
        
        print("The label text >> \(label.text ?? "")")
        
        
        // Assign selected transaction
        if segmentedControl.selectedSegmentIndex == 0 {
            // All
            self.selectedTransaction = transactionListReversed[(sender.view?.tag)!]
        }else if segmentedControl.selectedSegmentIndex == 1 {
            // Connections
            self.selectedTransaction = connections[(sender.view?.tag)!]
        }else{
            // Intro
            self.selectedTransaction = introductions[(sender.view?.tag)!]
            
        }

        
        // Check for user intent
        if label.text == "Follow up" {
            // Test 
            print("Followup")
            
            // Get users in transaction
            
            if selectedTransaction.type == "connection" {
                // Hit for userList
                self.fetchUsersForTransaction()
                
            }else{
                // Hit for contact list
                self.fetchContactsForTransaction()
            }

        }else{
            // Approve transaction call
            print("Approve")
            self.approveTransaction()
        }
        

    }
    
    
    func approveTransaction() {
        // Test
        print("Approving transaction")
        
        // Export transaction
        let parameters = ["uuid" : self.selectedTransaction.transactionId]
        
        // Show HUD 
        KVNProgress.show(withStatus: "Approving the connection...")
        
        // Send to sever
        
        Connection(configuration: nil).approveTransactionCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Approval Response ---> \(String(describing: response))")
                
                // Set response from network
                let dictionary : Dictionary = response as! [String : Any]
                // Test callback
                print("THE DICTIONARY OF APPROVAL", dictionary)
                
                // Change status for trans
                self.transactions[self.selectedIndex].approved = true
                
                // Refresh transaction feed
                self.getTranstactions()
                
                
                // Reload table
                //self.tableView.reloadData()
                // Hide HUD
                KVNProgress.showSuccess(withStatus: "Approved.")
                
            } else {
                print("Approval Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error with your introduction. Please try again.")
                
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
    }
    
    func rejectTransaction(index: Int) {
        
        print("Rejecting transaction")
        
        // Set selected transaction 
        //self.selectedTransaction = self.transactions[]
        
        if segmentedControl.selectedSegmentIndex == 0 {
            // All
            self.selectedTransaction = transactionListReversed[index]
        }else if segmentedControl.selectedSegmentIndex == 1 {
            // Connections
            self.selectedTransaction = connections[index]
        }else{
            // Intro
            self.selectedTransaction = introductions[index]
            
        }
        
        // Export transaction
        let parameters = ["uuid" : self.selectedTransaction.transactionId]
        
        // Show HUD
        KVNProgress.show(withStatus: "Deleting the connection...")
        
        // Send to sever
        
        Connection(configuration: nil).rejectTransactionCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Rejection Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                let dictionary : Dictionary = response as! [String : Any]
                // Test callback 
                print("THE DICTIONARY OF DENIAL" , dictionary)
                
                // Change status for trans
                self.transactions[self.selectedIndex].approved = false
                // Remove transaction from list
                self.transactions.remove(at: self.selectedIndex)
                
                // Re-fetch data
                self.getTranstactions()
                
                // Reload table 
                self.tableView.reloadData()
                
                // Hide HUD
                KVNProgress.showSuccess(withStatus: "Rejected.")
                
            } else {
                print("Rejection Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error with your introduction. Please try again.")
                
            }
            
        }
    }
    
    func searchTransactions() {
        
        print("Searching transaction")
        
        let searchString = customSearchController.customSearchBar.text ?? ""

        
        
        // Export transaction
        let parameters = ["uuid" : ContactManager.sharedManager.currentUser.userId, "search": searchString]
        
        // Show HUD
        KVNProgress.show(withStatus: "Searching..")
        
        // Send to sever
        
        Connection(configuration: nil).searchTransactionCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Rejection Response ---> \(String(describing: response))")
                
                // Init dictionary to capture response
                if let dictionary = response as? [String : Any] {
                    // // Parse dictionary for array of trans
                    let dictionaryArray = dictionary["transactions"] as! NSArray
                    
                    // Iterate over array, append trans to list
                    for item in dictionaryArray {
                        // Update counter
                        // Init user objects from array
                        let trans = Transaction(snapshot: item as! NSDictionary)
                        print("Transaction List")
                        //trans.printTransaction()
                        
                        
                        // Append users to radarContacts array
                        self.searchTransactionList.append(trans)
                    }
                    
                    // Sort list
                    self.sortTransactionList(list: self.searchTransactionList)
                    
                    
                    // Update the table values
                    self.tableView.reloadData()
                    
                    // Parse lists for segment control
                    self.parseTransactionList(transactionList: self.searchTransactionList)
                    
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
    
    
    
    func getTranstactions() {
        
        // Clear array list for fresh start 
        self.transactions.removeAll()
        self.transactionListReversed.removeAll()
        self.transactions = [Transaction]()
        self.transactionListReversed = [Transaction]()
        self.transactionList.removeAll()
        
        // 
        // Hit endpoint for updates on users nearby
        let parameters = ["uuid": ContactManager.sharedManager.currentUser.userId]
        
        print(">>> SENT PARAMETERS >>>> \n\(parameters))")
        // Show progress 
        KVNProgress.show(withStatus: "Fetching your activity feed...")
        
        // Create User Objects
        Connection(configuration: nil).getTransactionsCall(parameters, completionBlock: { response, error in
            if error == nil {
                
                print("\n\nGet Trans Response: \n\n>>>>>> \(response)\n\n")
                
                // Init dictionary to capture response
                if let dictionary = response as? [String : Any] {
                    // // Parse dictionary for array of trans
                    let dictionaryArray = dictionary["transactions"] as! NSArray
                    
                    // Iterate over array, append trans to list
                    for item in dictionaryArray {
                        // Update counter
                        // Init user objects from array
                        let trans = Transaction(snapshot: item as! NSDictionary)
                        print("Transaction Individual item after get")
                        trans.printTransaction()
                        
                        
                        // Append users to radarContacts array
                        self.transactions.append(trans)
                    }
                    
                    // Sort list
                    self.sortTransactionList(list: self.transactions)
                    
                    // Reload views
                    self.view.layoutSubviews()
                    self.view.layoutIfNeeded()
                    
                    // Update the table values
                    self.tableView.reloadData()
                    
                    // Parse lists for segment control 
                    self.parseTransactionList(transactionList: self.transactions)
                    
                    // Show sucess
                    KVNProgress.showSuccess()
                }else{
                    print("Array empty !!!!")
                    // dismiss HUD
                    KVNProgress.dismiss()
                }
                
                
                
            } else {
                print(error)
                // Show user popup of error message
                print("\n\nConnection - Radar Error: \n\n>>>>>>>> \(error)\n\n")
                KVNProgress.showError(withStatus: "There was an issue getting activities. Please try again.")
            }
            // Regardless, hide hud 
            KVNProgress.dismiss()
        })
    
    }
    
    // For sorting transaction list
    func sortTransactionList(list: [Transaction]) {
        
        for child in list {
            
            // Configure dates
            
            let strTime = child.date
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy HH:mm"
            let s = formatter.date(from: strTime)
            child.sortDate = s
                
            self.transactionList.append(child)
        }
        
        
        self.transactionList.sort(by: { $0.sortDate!.compare($1.sortDate! as Date) == ComparisonResult.orderedAscending })
        
        
        // Handle sorting into buckets here by date
         for trans in self.transactionList{
            print(trans.sortDate!)
            
            let elapsedTime = NSDate().timeIntervalSince(trans.sortDate!)
            print("Right Nows DateTime: > \(Date())")
            let duration = Double(elapsedTime) / (60.0 * 60.0)
            print("The Elapsed Time Since Transaction >>> \(duration)")
            
            if duration > 5.6 {
                // Send to recents
            }else{
                // Send to the old trans list
            }
            
            //print(trans.sortDate)
         }
        
        //Reverse list and set
        self.transactionListReversed = self.transactionList.reversed()
        
        // Update the table values
        self.tableView.reloadData()
    }
    
    // ----------------------------- Test -------------------
    
    
    
    // ----------------------------- Test --------------------
    
    // Retrieve lists from all transactions
    func parseTransactionList(transactionList : [Transaction]) {
        // Iterate over list
        for transaction in transactionList {
            // Check for tran type
            switch transaction.type {
            case "connection":
                // Print to test
                print(transaction.type)
                // Append to connection list
                self.connections.append(transaction)
                // Exit
                break
                
            case "introduction":
                // Print to test
                print(transaction.type)
                // Append to connection list
                self.introductions.append(transaction)
                // Exit
                break
                
            default:
                print("No transaction type")
            }
        }
        
        // Reverse lists for sorting
        self.connections = self.connections.reversed()
        self.introductions = self.introductions.reversed()
    }
    
    func fetchTransactionCard() {
        // Fetch cards from server
        let parameters = ["uuid" : selectedTransaction.senderCardId]
        
        print("\n\nTHE CARD TO ANY - PARAMS")
        print(parameters)
        
        
        // Connect to server
        Connection(configuration: nil).getSingleCardCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Card Created Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                let dictionary : NSDictionary = response as! NSDictionary
                print("\n\nCard List")
                print(dictionary)
                
                // Init card
                let card = ContactCard(snapshot: dictionary)
                
                // Parse for phone
                if card.cardProfile.phoneNumbers.count > 0{
                    // Set selected phone
                    self.senderPhone = card.cardProfile.phoneNumbers[0]["phone"]!
                }
                // Parse for email
                if card.cardProfile.emails.count > 0{
                    // Set selected phone
                    self.senderEmail = card.cardProfile.emails[0]["email"]!
                }
                
                // Set lists
                self.selectedUserEmails = [self.senderEmail]
                self.selectedUserPhones = [self.senderPhone]
                
                // Show alert
                self.showActionAlert(phones: self.selectedUserPhones, emails: self.selectedUserEmails)

                
            } else {
                print("Card Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error retrieving your cards. Please try again.")
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
        
    }
    
    
    
    
    func fetchContactsForTransaction() {
        // Fetch the user data associated with users
        
        // Hit endpoint for updates on users nearby
        let parameters = ["data": selectedTransaction.recipientList]
        
        print(">>> SENT PARAMETERS >>>> \n\(parameters))")
        // Show progress
        KVNProgress.show(withStatus: "Fetching details on the activity...")
        
        // Create User Objects
        Connection(configuration: nil).getTransactionContactsCall(parameters, completionBlock: { response, error in
            
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
                    self.selectedContacts.append(contact)
                }
                
                // Func to parse phone numbers and show sms client
                self.parseAndSend()
                
                // Show sucess
                KVNProgress.showSuccess()
                
                
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

    
    
    func fetchUsersForTransaction() {
        // Fetch the user data associated with users
        
        // Hit endpoint for updates on users nearby
        let parameters = ["data": selectedTransaction.recipientList]
        
        print(">>> SENT PARAMETERS >>>> \n\(parameters))")
        // Show progress
        KVNProgress.show(withStatus: "Fetching details on the activity...")
        
        // Create User Objects
        Connection(configuration: nil).getUserListCall(parameters, completionBlock: { response, error in
            
            if error == nil {
                
                //print("\n\nConnection - Radar Response: \n\n>>>>>> \(response)\n\n")
                
                // Init dictionary to capture response
                let userArray = response as? NSDictionary
                    // // Parse dictionary for array of trans
                print(userArray)
                    
                let userList = userArray?["data"] as! NSArray
                
                
                // Iterate over array, append trans to list
                for item in userList{
                        
                        // Init user objects from array
                    let user = User(snapshotWithLiteProfile: item as! NSDictionary)
                
                    // Append users to Selected array
                    self.selectedUsers.append(user)
                }
                
                // Func to parse phone numbers and show sms client
                self.parseAndSend()
                
                
                    
                // Show sucess
                KVNProgress.showSuccess()
                
                
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
    
    
    func parseAndSend() {
        
        if self.selectedTransaction.senderId == self.currentUser.userId {
            // User is sender
            // Get PhoneNumbers
            self.selectedUserPhones = self.retrievePhoneForUsers(contactsArray: self.selectedUsers, contacts: self.selectedContacts)
            self.selectedUserEmails = self.retrieveEmailForUsers(contactsArray: self.selectedUsers, contacts: self.selectedContacts)
            
            if selectedUserEmails.count > 0 && selectedUserPhones.count > 0{
                // Show option message
                showActionAlert(phones: selectedUserPhones, emails: selectedUserEmails)
            }else if selectedUserEmails.count > 0 && selectedUserPhones.count == 0{
                // Show email client
                self.showEmailCard()
            }else if selectedUserPhones.count > 0{
                // Show the message client
                self.showSMSCard(recipientList: selectedUserPhones)
            }

        }else{
            // Fetch card from network
            self.fetchTransactionCard()
            
        }
        
    }
    
    
    func retrievePhoneForUsers(contactsArray: [User], contacts: [Contact]) -> [String] {
        
        // Init email array
        var phoneList = [String]()
        
        if self.selectedTransaction.type == "connection" {
            // Iterate through email list for contact emails
            for contact in contactsArray {
                // Check for phone number
                if contact.userProfile.phoneNumbers.count > 0{
                    let phone = contact.userProfile.phoneNumbers[0]["phone"]
                    
                    // Add phone to list
                    phoneList.append(phone!)
                    
                    // Print to test phone
                    print("PHONE !!!! PHONE")
                    print("\n\n\(String(describing: phone))")
                    print(phoneList.count)
                }
                
            }
        }else{
            // Iterate through email list for contact emails
            for contact in contacts {
                // Check for phone number
                if contact.phoneNumbers.count > 0{
                    let phone = contact.phoneNumbers[0]["phone"]
                    
                    // Add phone to list
                    phoneList.append(phone!)
                    
                    // Print to test phone
                    print("PHONE !!!! PHONE")
                    print("\n\n\(String(describing: phone))")
                    print(phoneList.count)
                }
                
            }
            
        }
        

        // Append phone to a list of phones
        
        // Return the list of phones
        return phoneList
        
    }
    
    func retrieveEmailForUsers(contactsArray: [User], contacts: [Contact]) -> [String] {
        
        // Init email array
        var emailList = [String]()
        if self.selectedTransaction.type == "connection" {
            // Iterate through email list for contact emails
            for contact in contactsArray {
                // Check for phone number
                if contact.userProfile.emails.count > 0{
                    let email = contact.userProfile.emails[0]["email"]
                    
                    // Add phone to list
                    emailList.append(email!)
                    
                    // Print to test phone
                    print("PHONE !!!! PHONE")
                    print("\n\n\(String(describing: email))")
                    print(emailList.count)
                }
                
            }
        }else{
            // Iterate through email list for contact emails
            for contact in contacts {
                // Check for phone number
                if contact.emails.count > 0{
                    let email = contact.emails[0]["email"]
                    
                    // Add phone to list
                    emailList.append(email!)
                    
                    // Print to test phone
                    print("PHONE !!!! PHONE")
                    print("\n\n\(String(describing: email))")
                    print(emailList.count)
                }
                
            }
        }
        

        // Append emails to a list of emails
        
        // Return the list of emails
        return emailList
        
    }
    
    
    
    func createTransaction(type: String) {
        // Set type & Transaction data
        selectedTransaction.type = type
        selectedTransaction.senderName = ContactManager.sharedManager.currentUser.getName()
        selectedTransaction.setTransactionDate()
        selectedTransaction.senderId = ContactManager.sharedManager.currentUser.userId
        selectedTransaction.type = "connection"
        selectedTransaction.scope = "transaction"
        selectedTransaction.senderCardId = ContactManager.sharedManager.selectedCard.cardId!
        
        // Show progress hud
        KVNProgress.show(withStatus: "Following up..")
        
        // Save card to DB
        let parameters = ["data": self.selectedTransaction.toAnyObject()]
        print(parameters)
        
        // Send to server
        
        Connection(configuration: nil).createTransactionCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Card Created Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                /*let dictionary : Dictionary = response as! [String : Any]
                self.selectedTransaction.transactionId = (dictionary["uuid"] as? String)!*/
                
                // Insert to manager card array
                //ContactManager.sharedManager.currentUserCardsDictionaryArray.insert([card.toAnyObjectWithImage()], at: 0)
                
                // Hide HUD
                KVNProgress.dismiss()
                
            } else {
                print("Card Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error with your introduction. Please try again.")
                
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
    }
    
    // View Configuration
    
    
    func configureViewsForIntro(cell: ActivityCardTableCell, index: Int){
        // Set transaction values for cell
        var trans = Transaction()
       
        if shouldShowSearchResults {
            // Trans list
            trans = searchTransactionList[index]
            
        }else{
            
            if segmentedControl.selectedSegmentIndex == 0 {
                // All
                trans = transactionListReversed[index]
            }else if segmentedControl.selectedSegmentIndex == 1 {
                // Connections
                trans = connections[index]
            }else{
                // Intro
                trans = introductions[index]
                
            }
        }
        
        // Assign user objects
        
        // Config imageview
        self.configureSelectedImageView(imageView: cell.profileImage)
        
        // See if image ref available
        let image = UIImage(named: "contact")
        cell.profileImage.image = image
        
        // Config label
        self.configureFollowUpLabel(label: cell.approveButton)
        
        
        // Set description text
        
        if (trans.recipientNames?.count)! > 1{
            cell.descriptionLabel.text = "You introduced \(trans.recipientNames?[0] ?? "") to \(trans.recipientNames?[1] ?? "")"
            
            cell.approveButton.text = "Follow up"
            cell.approveButton.textColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
            //cell.approveButton.textColor = UIColor.white
            //cell.approveButton.isEnabled = false
            cell.approveButton.backgroundColor = UIColor.white
            
        }else{
            cell.descriptionLabel.text = "You made an introduction"
        }
        
        // Set location
        cell.locationLabel.text = trans.location
        
        //cell.approveButton.isEnabled = false
        //cell.approveButton.ish = false
        
        // Hide buttons if already approved
        /*if trans.approved {
            // Hide and replace
            //cell.rejectButton.isHidden = true
            //cell.rejectButton.isEnabled = false
            
            cell.approveButton.text = "Follow up"
            cell.approveButton.isEnabled = false
            
            // Change the label
            //cell.approveButton.setTitle("Follow up", for: .normal)
            
        }*/
        /*else if trans.rejected{
            // Show
            cell.approveButton.isHidden = true
            cell.approveButton.isEnabled = false
            
            cell.rejectButton.text = "Rejected"
            cell.rejectButton.isEnabled = false
        }else{
            print("In Between state, waiting for approval")
        }*/
        
        if trans.location == ""{
            // Hide icon
            
        }
        
        // Hide location 
        cell.locationIcon.isHidden = true
        
        
        // Add tag to view
        cell.cardWrapperView.tag = index
        cell.approveButton.tag = index
        // Make rejection tag index + 1 to identify the users action intent
        //cell.rejectButton.tag = index
        
    }
    
    func configureFollowUpLabel(label: UILabel) {
        
        label.layer.cornerRadius = 17.0
        label.clipsToBounds = true
        label.layer.borderWidth = 1.0
        label.layer.borderColor = UIColor.white.cgColor
        label.backgroundColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        label.textColor = UIColor.white
    }
    
    
    func configureViewsForConnection(cell: ActivityCardTableCell, index: Int){
        // Set transaction values for cell
        var trans = Transaction()
        
        if shouldShowSearchResults {
            // Trans list
            trans = searchTransactionList[index]
            
        }else{
            
            if segmentedControl.selectedSegmentIndex == 0 {
                // All
                trans = transactionListReversed[index]
            }else if segmentedControl.selectedSegmentIndex == 1 {
                // Connections
                trans = connections[index]
            }else{
                // Intro
                trans = introductions[index]
                
            }
        }
        
        // Config label
        self.configureFollowUpLabel(label: cell.connectionApproveButton)

        // Temp string
        var name : String = ""
        
        // Check if user sent card
        if trans.senderId == self.currentUser.userId {
            // Set card name to recipient
            if (trans.type != "quick_share" && trans.type != "introduction") {
                // Add recipient card name
                name = (trans.recipientCard?.cardHolderName)!
            }else{
                // Add from recipient names 
                name = trans.recipientNames?[0] ?? "No name"
            }
            
        }else{
            // Set to recipient
            name = trans.senderName
            if !trans.approved && trans.type == "connection"{
                // Set description text
                cell.connectionDescriptionLabel.text = "You have a pending connection with \(trans.recipientCard?.cardHolderName)"
            }
            

        }
        
        // Configure image 
        self.configureSelectedImageView(imageView: cell.connectionOwnerProfileImage)
        
        // See if image ref available
        // Set description text
        cell.connectionDescriptionLabel.text = "You connected with \(String(describing: name))"
        
        print("recipientCard", trans.recipientCard )
        
        //print("img", trans.recipientCard.imageURL)
        
        
        // Set location
        cell.connectionLocationLabel.text = trans.location
        
        let placeholder = UIImage(named: "contact")
        
        if trans.senderId == self.currentUser.userId {
            
            // Hide and replace
            //cell.connectionRejectButton.isHidden = true
            //cell.connectionRejectButton.isEnabled = false
        
            cell.connectionApproveButton.isHidden = true
            cell.connectionApproveButton.isEnabled = false
            
            
            if trans.recipientCard?.imageId != ""{
                // Init url
                let link = ImageURLS.sharedManager.getFromDevelopmentURL
                let id = trans.recipientCard?.imageId
                let url = URL(string: "\(link)\(id ?? "").jpg")
                //print("Link for image sender: \(link)\(trans.recipientCard?.imageId).jpg")
                cell.connectionOwnerProfileImage.setImageWith(url!, placeholderImage: placeholder)
            }else{
                cell.connectionOwnerProfileImage.image = placeholder
                
            }
            
            
        }else{
            // Set image
            print("Image ID", trans.senderImageId)
            
            if trans.senderImageId != ""{
                // Init url
                let link = ImageURLS.sharedManager.getFromDevelopmentURL
                let url = URL(string: "\(link)\(trans.senderImageId).jpg")
                print("Link for image sender: \(link)\(trans.senderImageId).jpg")
                cell.connectionOwnerProfileImage.setImageWith(url!, placeholderImage: placeholder)
            }else{
                cell.connectionOwnerProfileImage.image = placeholder
                
            }

        }
        
            
            // Hide buttons if already approved
        if trans.approved {
            // Hide and replace
            //cell.connectionRejectButton.isHidden = true
            //cell.connectionRejectButton.isEnabled = false
                
            cell.connectionApproveButton.text = "Follow up"
            cell.connectionApproveButton.textColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
            //cell.connectionApproveButton.isEnabled = false
            cell.connectionApproveButton.backgroundColor = UIColor.white
                
            // Change the label
            //cell.connectionApproveButton.setTitle("Follow up", for: .normal)
                
        }/*else if trans.rejected{
            // Show
            cell.connectionApproveButton.isHidden = true
            cell.connectionApproveButton.isEnabled = false
                
            // Hide approve
            cell.connectionRejectButton.text = "Rejected"
            cell.connectionRejectButton.isEnabled = false
                
        }*/else{
            print("Waiting for confirmation")
            // Set description text
            cell.connectionDescriptionLabel.text = "You have a pending connection with \(String(describing: name))"
            
        }

        if trans.type == "quick_share" {
            // Set label text
            cell.connectionDescriptionLabel.text = "You shared your contact information with \(String(describing: name))"
        }
        
        
        if trans.location == ""{
            // Hide icon
            cell.connectionLocationIcon.isHidden = true
        }
        
        // Add tag to view
        //cell.connectionCardWrapperView.tag = index
        //cell.connectionApproveButton.tag = index
        // Make rejection tag index + 1 to identify the users action intent
        //cell.connectionRejectButton.tag = index
        
        
    }
    
    func configureSelectedImageView(imageView: UIImageView) {
        // Config imageview
        
        // Configure borders
        imageView.layer.borderWidth = 0.5
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30   // Create container for image and name
        
    }

    
    
    // Empty State Delegate Methods 
    
    // Settings
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        
        /*if self.transactions.count > 0 {
            // Hide empty
            return false
        }else{
            // Show empty
            return true
        }*/
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
        
        let emptyString = "No Transactions Found"
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
        
        let emptyString = "Tap to Start Unifying"
        
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
        
        // Post notification for radar to turn on
        self.postNotification()
        
        // Sync up with main queue
        DispatchQueue.main.async {
            // Set selected tab
            self.tabBarController?.selectedIndex = 2
        }
        
    }
    
    // Notifications
    
    func postNotification() {
        
        // Notification for radar screen
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TurnOnRadar"), object: self)
        
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
    
    func showSMSCard(recipientList: [String]) {
        
        print("SMS CARD SELECTED")
        // Send post notif
        
        let composeVC = MFMessageComposeViewController()
        if(MFMessageComposeViewController .canSendText()){
            
            composeVC.messageComposeDelegate = self
            
            // Set card link from cardID
            let cardLink = "https://project-unify-node-server.herokuapp.com/card/render/\(ContactManager.sharedManager.selectedCard.cardId!)"
            
            // Configure message
            let str = "\n\n\n\(cardLink)"
            
            // Set message string
            composeVC.body = str
            // Set recipient list
            composeVC.recipients = recipientList
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
            
        }
        
    }
    
    
    // Email Composer Delegate Methods
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
        // Create Instance of controller
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
    
        // Set card link from cardID
        let cardLink = "https://project-unify-node-server.herokuapp.com/card/render/\(ContactManager.sharedManager.selectedCard.cardId!)"
        
        // Configure message
        let str = "\n\n\n\(cardLink)"
        
        var mail = [String]()
        
        if (self.selectedTransaction.senderId == self.currentUser.userId) && self.selectedTransaction.type == "connection"{
            // Radar recipient
            mail = [(self.selectedTransaction.recipientCard?.cardProfile.emails[0]["email"]!)!]
        }else if self.selectedTransaction.type == "introduction"{
            // Intro with multiple users
            mail = selectedUserEmails
        }else{
            //
            mail = [self.senderEmail]
        }

        
        // Create Message
        mailComposerVC.setToRecipients(mail)
        mailComposerVC.setSubject("Unify Follow-Up")
        mailComposerVC.setMessageBody(str, isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    
    // MARK: MFMailComposeViewControllerDelegate Method
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if result == .cancelled {
            // User cancelled
            print("User cancelled")
            
        }else if result == .sent{
            // User sent
            self.createTransaction(type: "connection")
            // Dimiss vc
            self.dismiss(animated: true, completion: nil)
            
        }else{
            // There was an error
            KVNProgress.showError(withStatus: "There was an error sending your message. Please try again.")
            
        }
        
        // Dismiss controller
        controller.dismiss(animated: true, completion: nil)
    }
    
    // Message Composer Delegate
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        if result == .cancelled {
            // User cancelled
            print("Cancelled")
            
        }else if result == .sent{
            // User sent
            // Create transaction
            self.createTransaction(type: "connection")
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

    // Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        print(">Passed Contact Card ID")
        print(sender!)
        
        if segue.identifier == "showFollowupSegue"
        {
            
            let nextScene =  segue.destination as! FollowUpViewController
            // Pass the transaction object to nextVC
            nextScene.transaction = self.selectedTransaction
            nextScene.active_card_unify_uuid = "\(sender!)" as String?
            
            
        }
        
    }
    
    
}
