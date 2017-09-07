//
//  RadarListViewController.swift
//  Unify
//
//  Created by Kevin Fich on 8/2/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit

class RadarListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, CLLocationManagerDelegate {
    
    // Properties
    // --------------------------
    var currentUser = User()
    var transaction = Transaction()
    var radarContactList = [User]()
    var selectedContactList = [User]()
    var segmentedControl = UISegmentedControl()
    var selectedCells = [NSIndexPath]()
    var counter = 0
    
    // Location
    var lat : Double = 0.0
    var long : Double = 0.0
    var address = String()
    var updateLocation_tick = 5
    let locationManager = CLLocationManager()
    
    let testURL = ImageURLS().getFromDevelopmentURL
    let prodURL = ImageURLS().getFromStagingURL
    
    // Radar
    var radarStatus: Bool = false
    
    // Struct to check if user selected for radar
    struct Check {
        var index: Int
        var isSelected: Bool // selection state
        
        init(arrayIndex: Int, selected: Bool) {
            index = arrayIndex
            isSelected = selected
        }
    }
    
    // List of checks to mark selected index
    var selectedUserList = [Check]()
    var selectedUserIds = [String]()

    
    // IBOutlets
    // --------------------------
    
    @IBOutlet var tableView: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        // Do any additional setup after loading the view.
        
        // Listen for notifications 
        self.addObservers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Tableview delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return radarContactList.count
        
        return self.radarContactList.count // your number of cell here
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // your cell coding
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactListCell", for: indexPath) as! ContactListCell
        
        // Set checkmark
        cell.accessoryType = selectedCells.contains(indexPath as NSIndexPath) ? .checkmark : .none
        
        // Config imageview 
        self.configureSelectedImageView(imageView: cell.contactImageView)
        // Fetch user image reference
        
         // Set user
         let user = radarContactList[indexPath.row]
         
         // Find image
         if user.profileImageId != ""{
            // Grab image ref using alamo
            
            // ** Currently Set to Test URL
            //let url = URL(string: "\(testURL)\(user.profileImageId).jpg")!
            let url = URL(string: "\(prodURL)\(user.profileImageId).jpg")!
            let placeholderImage = UIImage(named: "contact")!
            // Set image
            cell.contactImageView.setImageWith(url, placeholderImage: placeholderImage)
            
            // For now
            //image = UIImage(named: "radar-avatar")!
            
        }else{
            // Set image to default image
            cell.contactImageView.image = UIImage(named: "contact")!
        }
        
        // Set Name
         cell.contactNameLabel.text = user.getName()
        
        
        //cell.contactNameLabel.text = "Peter Jenkins"
        //cell.contactImageView.image = UIImage(named: "contact")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell selected code here
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Set Checkmark
        let selectedCell = tableView.cellForRow(at: indexPath)
        
        selectedCells.append(indexPath as NSIndexPath)
        
        if selectedCell?.accessoryType == .checkmark {
            
            selectedCell?.accessoryType = .none
            
            selectedCells = selectedCells.filter {$0 as IndexPath != indexPath}
            
            // Remove from list
            //selectedContactList.remove(at: indexPath.row)
            print("User removed")
            print("Selected Count >> \(selectedContactList.count)")
            
            if selectedContactList.count == 0{
                // Hide send button
                self.postHideSendCard()
            }
            
            if selectedUserList[indexPath.row].isSelected == true {
                // Set to true
                selectedUserList[indexPath.row].isSelected = false
            }

            
        } else {
            
            selectedCell?.accessoryType = .checkmark
            
            if selectedUserList[indexPath.row].isSelected != true {
                // Set to true
                selectedUserList[indexPath.row].isSelected = true
            }
            
                // Append to list
                //self.selectedContactList.append(radarContactList[indexPath.row])
            
            print("User Added")
            print("Selected Count >> \(selectedContactList.count)")
            
            // Show send card
            self.postShowSendCard()
            
            // Append id to selectedList
            //self.selectedUserIds.append(radarContactList[indexPath.row].userId)

        }
        
        
    }
    
    // Location Managment
    
    func updateLocation(){
        //print("UPDATING LOCATION FROM THE LIST")
        
        // Toggle status
        self.radarStatus = true
        
        // Update location tick
        updateLocation_tick = updateLocation_tick + 1
        
        print(updateLocation_tick)
        
        // Check is list should be refreshed
        
        
        if updateLocation_tick >= 5  && radarStatus == true{
            
            // Reset Ticker
            updateLocation_tick = 0
            
            // Set lat and long from manager
            self.lat = ContactManager.sharedManager.userLat
            self.long = ContactManager.sharedManager.userLong
            self.address = ContactManager.sharedManager.userAddress
            
            print("List View Lat >> \(self.lat) , Long >> \(self.long)")
            
            // Hit endpoint for updates on users nearby
            let parameters = ["uuid": ContactManager.sharedManager.currentUser.userId, "location": ["latitude": self.lat, "longitude": self.long]] as [String : Any]
            
            print(">>> SENT PARAMETERS >>>> \n\(parameters))")
            
            // Create User Objects
            Connection(configuration: nil).startRadarCall(parameters, completionBlock: { response, error in
                if error == nil {
                    
                    print("\n\nRadar List Response: \n\n>>>>>> \(response)\n\n")
                    
                    let dictionary : NSArray = response as! NSArray
                    
                    print("data length", dictionary.count)
                    
                    // Set counter to 0
                    self.counter = 0
                    
                    if  dictionary.count >= 0
                    {
                        
                        // Clear Lists
                        self.radarContactList.removeAll()
                    }
                    
                    
                    for item in dictionary {
                        
                        //print(item)
                        
                        let userDict = item as? NSDictionary
                        
                        // Init user objects from array
                        let user = User(withRadarSnapshot: userDict!)
                        
                        // Create selected index
                        let selectedIndex = Check(arrayIndex: self.counter, selected: false)
                        
                        // Set Selected index
                        self.selectedUserList.append(selectedIndex)
                        
                        // Test user
                        user.printUser()
                        
                        // Append users to radarContacts array
                        self.radarContactList.append(user)
                        print("Radar List Count >>>> \(self.radarContactList.count)")
                        
                        // Update counter
                        self.counter = self.counter + 1
                        
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
    
    func endRadar() {
        // Toggle status
        self.radarStatus = true
        
        // Hit endpoint for updates on users nearby
        let parameters = ["uuid": ContactManager.sharedManager.currentUser.userId]
        
        print(">>> SENT PARAMETERS >>>> \n\(parameters))")
        
        // Create User Objects
        Connection(configuration: nil).endRadarCall(parameters, completionBlock: { response, error in
            if error == nil {
                
                 print("\n\nEnding Radar - Response: \n\n>>>>>> \(response)\n\n")
                
                
            } else {
                print("End Radar Error", error ?? "Error")
                // Show user popup of error message
                // print("\n\nConnection - Radar Error: \n\n>>>>>>>> \(error)\n\n")
                //KVNProgress.show(withStatus: "There was an issue with your pin. Please try again.")
            }
            
        })
        
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
    
    // Custom Methods
    
    // For notifications
    func addObservers() {
        
        // Sending card notif
        NotificationCenter.default.addObserver(self, selector: #selector(RadarListViewController.sendCardSelected), name: NSNotification.Name(rawValue: "SendCardsFromRadarList"), object: nil)
        
        // Update location 
        NotificationCenter.default.addObserver(self, selector: #selector(RadarListViewController.updateLocation), name: NSNotification.Name(rawValue: "UpdateLocation"), object: nil)
        
        // Update location
        NotificationCenter.default.addObserver(self, selector: #selector(RadarListViewController.endRadar), name: NSNotification.Name(rawValue: "EndRadar"), object: nil)
        
    }
    
    func configureSelectedImageView(imageView: UIImageView) {
        // Config imageview
        
        // Configure borders
        imageView.layer.borderWidth = 1
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 23    // Create container for image and name
        
    }
    
    
    func postShowSendCard() {
        
        // Post notification
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowSendCard"), object: self)
        
    }
    
    func postHideSendCard() {
        
        // Post notification
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HideSendCard"), object: self)
        
    }
    
    func sendCardSelected() {
        
        // Test uuid
        print("\n\nCurrent User ID >>> \(currentUser.userId)")
        // Init name list
        self.transaction.recipientNames = [String]()
        
        // Dyamically set selected card here
        
        // Iterate through selected card list
        for contact in selectedUserList {
            // Check if isSelected
            print("Selected: \(contact.isSelected) Index: \(contact.index)")
            if contact.isSelected{
                print("Printing contact : >> \(radarContactList[contact.index])")
                print("Index for Selected Contact : >> \(radarContactList[contact.index].getName())")
                // Init user from list
                let user = radarContactList[contact.index]
                // Set id to recipient list
                selectedUserIds.append(user.userId)
                
                // Add recipient names to transaction 
                self.transaction.recipientNames?.append(user.getName())
                
            }
        }
        
        // Print tranny
        transaction.printTransaction()
        
        // Call create transaction function
        createTransaction(type: "connection", uuid: ContactManager.sharedManager.currentUser.userId)
        
        Countly.sharedInstance().recordEvent("shared contacts from radar")
        
    }

    
    func createTransaction(type: String, uuid: String) {
        // Set type & Transaction data
        transaction.type = type
        transaction.senderName = ContactManager.sharedManager.currentUser.getName()
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
        KVNProgress.setConfiguration(conf)*/
        
        KVNProgress.show(withStatus: "Sending your card...")
        
        // Save card to DB
        let parameters = ["data": self.transaction.toAnyObject()]
        print(parameters)
        
        // Send to server
        
        Connection(configuration: nil).createTransactionCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Card Created Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                /*let dictionary : Dictionary = response as! [String : Any]
                self.transaction.transactionId = (dictionary["uuid"] as? String)!*/
                
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
