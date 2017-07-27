//
//  RecipientOptionsViewController.swift
//  Unify
//
//  Created by Kevin Fich on 7/27/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit
import CoreLocation


class RecipientOptionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, CLLocationManagerDelegate{
    
    // Properties
    // --------------------------
    var currentUser = User()
    var transaction = Transaction()
    var radarContactList = [User]()
    var selectedUserIds = [String]()
    var selectedContactList = [User]()
    var segmentedControl = UISegmentedControl()
    var selectedCells = [NSIndexPath]()
    
    // Location 
    var lat : Double = 0.0
    var long : Double = 0.0
    var address = String()
    var updateLocation_tick = 5
    let locationManager = CLLocationManager()

    
    // Radar 
    var radarStatus: Bool = false
    
    
    // IBOutlets
    // ----------------------------------------
    @IBOutlet var navigationBar: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var radarSwitch: UISwitch!
    
    
    @IBOutlet var phoneLabel: UITextField!
    @IBOutlet var emailLabel: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Init and configure segment controller
        segmentedControl = UISegmentedControl(frame: CGRect(x: 10, y: 5, width: tableView.frame.width - 20, height: 30))
        // Set tint
        segmentedControl.tintColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        
        segmentedControl.insertSegment(withTitle: "Tools", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Contacts", at: 1, animated: false)
        
        
        segmentedControl.selectedSegmentIndex = 0
        
        // Add segment control to navigation bar
        self.navigationBar.titleView = segmentedControl

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
            self.tableView.isHidden = true
            // Toggle radar status
            self.radarStatus = false
        }else{
            // Show table
            self.tableView.isHidden = false
            
            // Toggle radar status 
            self.radarStatus = true
            
            // Start updating location
            self.updateLocation()
        }
    }
    
    @IBAction func dismissViewController(_ sender: Any) {
        
        // Pop view 
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func shareWithContact(_ sender: Any) {
        
        // Create the transaction and share
        self.createTransaction(type: "connection", uuid: currentUser.userId)
        
    }
    
    
    // Tableview delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return radarContactList.count
        
        return 5 // your number of cell here
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // your cell coding
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsCell", for: indexPath) as! ContactListCell
        
        cell.contactNameLabel.text = "Peter Jenkins"
        cell.contactImageView.image = UIImage(named: "contact")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell selected code here
        
        // Set Checkmark
        let selectedCell = tableView.cellForRow(at: indexPath)
        
        selectedCells.append(indexPath as NSIndexPath)
        
        if selectedCell?.accessoryType == .checkmark {
            
            selectedCell?.accessoryType = .none
            
            selectedCells = selectedCells.filter {$0 as IndexPath != indexPath}
            
            // Remove from list
            selectedContactList.remove(at: indexPath.row)
            
        } else {
            
            selectedCell?.accessoryType = .checkmark
            
            // Append to list
            self.selectedContactList.append(radarContactList[indexPath.row])
            
            // Append id to selectedList
            self.selectedUserIds.append(radarContactList[indexPath.row].userId)
        }
        
        
    }
    
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
    
    // Empty State Delegate Methods
    
    // Settings
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
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
    }
    
    // Custom Methods
    
    func createTransaction(type: String, uuid: String) {
        // Set type & Transaction data 
        transaction.type = type
        transaction.recipientList = selectedUserIds
        transaction.setTransactionDate()
        transaction.senderId = ContactManager.sharedManager.currentUser.userId
        transaction.type = "connection"
        transaction.scope = "transaction"
        transaction.latitude = self.lat
        transaction.longitude = self.long
        transaction.location = self.address
        // Attach card id
        transaction.senderCardId = ContactManager.sharedManager.selectedCard.cardId!
        
        
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
                print("Card Created Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                let dictionary : Dictionary = response as! [String : Any]
                self.transaction.transactionId = (dictionary["uuid"] as? String)!
                
                // Insert to manager card array
                //ContactManager.sharedManager.currentUserCardsDictionaryArray.insert([card.toAnyObjectWithImage()], at: 0)
                
                // Hide HUD
                //KVNProgress.dismiss()
                KVNProgress.showSuccess(withStatus: "You are now connected!")
                
                
                
            } else {
                print("Card Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error. Please try again.")
                
            }
            
            
            // Clear List of recipients
            self.radarContactList.removeAll()
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