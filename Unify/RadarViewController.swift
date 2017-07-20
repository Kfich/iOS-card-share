//
//  RadarViewController.swift
//  Unify
//
//  Created by Kevin Fich on 6/2/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import Firebase
import UIKit
import PopupDialog
import RKParallaxEffect
import MapKit
import CoreLocation
import MMPulseView
import Contacts
import PulsingHalo
import SwiftAddressBook
import SwiftyJSON
import Alamofire

import AFNetworking

class RadarViewController: UIViewController, ISHPullUpContentDelegate, CLLocationManagerDelegate {
    
    // Properties
    // -------------------------------------------
    
    var currentUser = User()
    var selectedUser = User()
    var transaction = Transaction()
    
    
    var selectedUsers = [User]()
    var radarUsers = [User]()
    
    var didReceieveList = false
    var lat : Double = 0.0
    var long : Double = 0.0
    var address = String()
    
    var nearbyList = [String: Any]()
    // Phone Contact Store
    var store: CNContactStore!
    // Location
    var updateLocation_tick = 5
    var myLocation:CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    // Pulse halo
    let halo = PulsingHaloLayer()
    // Anime
    var parallaxEffect: RKParallaxEffect!
    // Status check
    var radarStatus: Bool = false
    // For tagging contacts from radar
    var  counter = 0
    // Holds contacts returned from server when radar starts
    var radarContacts = [User]()
    
    
    // Halo
    let halo2 = PulsingHaloLayer()
    
    let keysToFetch = [
        CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
        CNContactEmailAddressesKey,
        CNContactPhoneNumbersKey,
        CNContactImageDataAvailableKey,
        CNContactThumbnailImageDataKey] as [Any]
    
    
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
    
    // IBOutlet
    // -------------------------------------------
    
    @IBOutlet var rootView: UIView!
    //@IBOutlet var radarOnLabel: UILabel!
    @IBOutlet var radarOffLabel: UILabel!
    
    @IBOutlet var radarImageView: UIButton!
    
    @IBOutlet var radarButton: UIButton!
    
    @IBOutlet var radarSwitch: UISwitch!
    
    @IBOutlet var sendCardButton: UIButton!
    
    @IBOutlet var pulseView: UIView!
    
    @IBOutlet var smsButton: UIButton!
    
    @IBOutlet var emailButton: UIButton!
    
    // Action buttons and logo
    
    @IBOutlet var addNewCardButton: UIButton!
    
    @IBOutlet var radarLogoImage: UIImageView!
    
    
    
    // View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Setup views
        
        // Hide button
        sendCardButton.isHidden = true
        
        // See if current user pass
        ContactManager.sharedManager.currentUser.printUser()
        
        // Test
        //testImage()
        
        // Set tags to views to avoid deletion
        self.radarLogoImage.tag = 5100
        self.addNewCardButton.tag = 5101
        self.sendCardButton.tag = 5102
        
        //add halo to pulseview as sublayer only once when view loads to prevent dups
        
        if (UIScreen.main.bounds.size.height == 667.0 && UIScreen.main.nativeScale < UIScreen.main.scale){
            //plus device
            halo.position.y = pulseView.frame.height / 2.55
            halo.position.x = pulseView.frame.width / 1.8
            print("iphone 6 plus zoomed")
        } else {
            //standard device
            halo.position.y = pulseView.frame.height / 2.55
            halo.position.x = pulseView.frame.width / 1.8
            print("iphone 6 plus")
        }
        if (UIScreen.main.bounds.size.height == 568.0 && UIScreen.main.nativeScale > UIScreen.main.scale) {
            print("zoomed iphone 6")
        } else {
            print("none zoomed")
        }
        

        halo.haloLayerNumber = 3;
        
        // Set radius
        halo.radius = 150;
        
        halo.backgroundColor = UIColor.white.cgColor
        
        pulseView.layer.addSublayer(halo)

        halo.opacity = 0
        halo.start()

  
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        // End radar
        //self.endRadar()
        //pulseMe(status: "hide")
    }
    
    
    // IBActions / Buttons Pressed
    // -------------------------------------------
    
    
    // TESTING -----------------------------
    
    @IBAction func addCard(_ sender: Any) {
        
        // Test user
        // testUser()
        
        // Show add card vc
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CreateCardVC")
        self.present(controller, animated: true, completion: nil)
        
        
    }
    
    func testImage() {
        // Pull image data
        // Image data png
        //let imageData = UIImagePNGRepresentation(self.profileImageContainerView.image!, 0.5)
        let imageData = UIImageJPEGRepresentation(UIImage(named: "contact")!, 0.5)
        print(imageData!)
        
        // Create user for string gen
        let newUser = User()
        // Generate id string for image
        let idString = newUser.randomString(length: 20)
        
        // Set id string to user object for image
        newUser.profileImageId = idString
        
        // Assign asset name and type
        let fname = idString
        let mimetype = "image/png"
        
        // Create image dictionary
        let imageDict = ["image_id": idString, "image_data": imageData!, "file_name": fname, "type": mimetype] as [String : Any]
        
        // Add image to user profile images
        //newUser.setImages(imageRecords: imageDict)
        
        
        // Upload to Server
        // Save card to DB
        let parameters = imageDict
        print(parameters)
        
        // Show progress HUD
        KVNProgress.show(withStatus: "Generating profile..")
        
        //Alamofire.down
        
        // Upload image with Alamo
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData!, withName: "files", fileName: "\(fname).jpg", mimeType: "image/jpg")
            
            print("Multipart Data >>> \(multipartFormData)")
            /*for (key, value) in parameters {
             multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
             }*/
        }, to:"https://project-unify-node-server.herokuapp.com/image/uploadcdn")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print("\n\n\n\n success...")
                    print(response.result.value ?? "Successful upload")
                    
                    // Dismiss hud
                    KVNProgress.dismiss()
                }
                
            case .failure(let encodingError):
                print("\n\n\n\n error....")
                print(encodingError)
                // Show error message
                KVNProgress.showError(withStatus: "There was an error generating your profile. Please try again.")
            }
        }
        
    }
    
    func testUser(){
        // Test current user object
        
        /*currentUser.firstName = "Kevin"
         currentUser.lastName = "Fich"
         currentUser.userId = "54321"
         currentUser.fullName = currentUser.getName()
         currentUser.emails.append(["email": "kfich7@aol.com"])
         currentUser.emails.append(["email": "kfich7@gmail.com"])
         currentUser.phoneNumbers.append(["phone": "1234567890"])
         currentUser.phoneNumbers.append(["phone": "0987654321"])
         currentUser.phoneNumbers.append(["phone": "6463597308"])
         currentUser.scope = "user"
         
         
         
         let parameters = ["uuid" : "4b12ee87-9822-419a-b31a-b76bfdafdd78"]
         print("\n\n")
         print(parameters)
         
         
         //let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
         
         
         // Print to test
         //print("Current User")
         //currentUser.printUser()
         
         
         // Print as dictionary
         print("\nUser As Dictionary")
         print(currentUser.toAnyObject())
         
         //genericPostCall(parameters as NSDictionary)
         */
        
        /*let parameters = ["uuid" : "4b12ee87-9822-419a-b31a-b76bfdafdd78"]
         
         // Send current user to DB
         
         
         Connection(configuration: nil).getUserCall(parameters, completionBlock: { response, error in
         if error == nil {
         
         print("\n\nConnection - Create User Response: \(response)\n\n")
         
         // Here you set the id for the user and resubmit the object
         
         //let user = User(snapshot: response as! NSDictionary)
         //user.printUser()
         
         
         
         } else {
         print(error)
         // Show user popup of error message
         print("\n\nConnection - Create User Error: \(error)\n\n")
         }
         })*/
    }
    
    
    
    
    
    // IBActions --------------------------------
    
    
    
    
    
    
    
    @IBAction func radarButtonSelected(_ sender: AnyObject) {
        
        print("activate radar")
        
        
        if radarSwitch.isOn{
            
            print("turn radar on")
            
            radarStatus = true
            pulseMe(status: "show")
            
            /*
            halo2.position = view.center
            pulseView.layer.addSublayer(halo)
            halo2.start()
            
            
            halo2.isHidden = false
            */
            self.locationManager.startUpdatingLocation()
            
            Countly.sharedInstance().recordEvent("turned radar on")
            // Configure Label text and set image
            //self.radarOnLabel.isHidden = true
            //  self.radarOffLabel.text = "radar off"
            //self.radarButton.setImage(UIImage(named:"radar_off.png"), for: UIControlState.normal)
            
            
        } else {
            
            radarStatus = false
            pulseMe(status: "hide")
            //halo.isHidden = true
            self.locationManager.stopUpdatingLocation()
            self.locationManager.stopMonitoringSignificantLocationChanges()
            
            // Stop animations and remove from view
            //self.stopPulseAnimation()
            
            // End radar
            self.endRadar()
            
            //remove people from radar
            self.removePlottedPeople(self.pulseView)
            self.radarUsers.removeAll()
            
            Countly.sharedInstance().recordEvent("turned radar off")
            
        }
        
        
        if CLLocationManager.locationServicesEnabled() {
            
            requestRadarAccess()
            
        } else {
            
            notifyFunction()
            
        }
    }
    
    // Sending cards
    
    @IBAction func sendCardSelected(_ sender: Any) {
        
        // Test uuid
        print("\n\nCurrent User ID >>> \(currentUser.userId)")
        
        // Dyamically set selected card here
        
        // Iterate through selected card list
        for contact in selectedUserList {
            // Check if isSelected
            if contact.isSelected{
                // Init user from list
                let user = radarUsers[contact.index]
                // Set id to recipient list
                selectedUserIds.append(user.userId)
            }
        }
        
        // Set selected ids to trans and values
        // Set temp id for transaction
        transaction.transactionId = transaction.randomString(length: 15)
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
        
        
        // Print tranny
        transaction.printTransaction()
        
        // Call create transaction function
        createTransaction(type: "connection", uuid: ContactManager.sharedManager.currentUser.userId)
        
        Countly.sharedInstance().recordEvent("shared contacts from radar")
        
    }
    
    
    
    
    // Pull up Delegate Protocols
    // -------------------------------------------
    
    func pullUpViewController(_ vc: ISHPullUpViewController, update edgeInsets: UIEdgeInsets, forContentViewController _: UIViewController) {
        // update edgeInsets
        rootView.layoutMargins = edgeInsets
        
        // call layoutIfNeeded right away to participate in animations
        // this method may be called from within animation blocks
        rootView.layoutIfNeeded()
    }
    
    
    // Pulsing animation
    // -------------------------------------------
    
    func stopPulseAnimation() {
        halo.removeAllAnimations()
        halo.shouldResume = false
        
    }
    
    func pulseMe(status: String?){
        
        if status == "show"
        {
        
          halo.opacity = 0.7
         
        
        } else {
            
            halo.opacity = 0
            
        }
        
    }
    
    
    // Radar
    // -------------------------------------------------------------------
    
    func plotPerson(distance: Int, direction: Int, tag: Int){
        
        // Init temp user
        let user = radarUsers[tag]
        
        // Reverted code
        var image = UIImage(named: "radar-avatar")
        var imageView = UIImageView(image: image!)
        
        //let imageView = UIImageView()
        
        //imageView.frame = CGRect(x: 100 + (10*direction), y: 280 - (10 * distance), width: 30, height: 30)
        
        //imageView.backgroundColor = .black
        
        
        /*// Create image
         var image = UIImage()
         // Create imageView and set image
         let imageView = UIImageView()
         
         image = UIImage(named: "radar-avatar")!*/
        
        // Create URL For Prod
        //let prodURL = "https://project-unify-node-server-stag.herokuapp.com/image/"
        
        // Create URL For Test
        let testURL = "https://project-unify-node-server.herokuapp.com/image/"
        
        
        
        // Fetch user image reference
        if user.profileImageId != ""{
            // Grab image ref using alamo
            
            // ** Currently Set to Prod URL
            
            let url = URL(string: "\(testURL)\(user.profileImageId).jpg")!
            let placeholderImage = UIImage(named: "user")!
            // Set image
            imageView.setImageWith(url, placeholderImage: placeholderImage)
            
            // For now
            //image = UIImage(named: "radar-avatar")!
            
        }else{
            // Set image to default image
            image = UIImage(named: "user")!
        }
        
        //let imageView = UIImageView()
        //imageView.frame = CGRect(x: 50, y: 80, width: 60, height: 60)
        
        //imageView.backgroundColor = .black
        
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.clipsToBounds = true
        
        // Init container view for wrapper
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        containerView.backgroundColor = UIColor.clear
        
        // Changed the image rendering size
        containerView.frame = CGRect(x: 100 + (10 * direction), y: 80 - (10 * distance), width: 60, height: 60)
        // Changed the image rendering size
        imageView.frame = CGRect(x: 0, y: 0 , width: 60, height: 60)
        
        // Add label to the view
        let lbl = UILabel(frame: CGRect(0, 60, 60, 15))
        // Set name to label
        lbl.text = user.getName()
        lbl.textAlignment = .center
        lbl.textColor = UIColor.white
        lbl.font = UIFont(name: ".SFUIText-Medium", size: CGFloat(10))
        
        // Configure Hover Animation
        let hover = CABasicAnimation(keyPath: "position")
        hover.isAdditive = true
        hover.fromValue = NSValue(cgPoint: CGPoint.zero)
        
        // Create coordinates for hovering
        let xx = Int(random: -5..<5)
        let yy = Int(random: -5..<5)
        
        print(">>\(xx, yy)")
        
        // Hover config
        hover.toValue = NSValue(cgPoint: CGPoint(x: xx, y: yy))
        hover.autoreverses = true
        hover.duration = 0.9
        hover.repeatCount = Float.infinity
        
        // Add animation to container
        containerView.layer.add(hover, forKey: "myHoverAnimation")
        
        // Add action tap gesture to view object
        let imageAction = UITapGestureRecognizer(target: self, action: #selector(radarContactSelected(sender:)))
        containerView.isUserInteractionEnabled = true
        containerView.addGestureRecognizer(imageAction)
        
        // Assign tag to image to identify what index in the array user lies
        containerView.tag = tag
        
        // Add subviews
        containerView.addSubview(lbl)
        containerView.addSubview(imageView)
        
        // Adding image of contact to map screen
        self.pulseView.addSubview(containerView)
        
        // test on main view
        /*let lbl = UILabel()
         lbl.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
         lbl.backgroundColor = UIColor.blue
         lbl.text = "Yo \(tag)"
         self.container.addSubview(lbl)*/
        
    }
    
    func endRadar() {
        // Stop radar pulsing
        
        // Hit endpoint for updates on users nearby
        let parameters = ["uuid": ContactManager.sharedManager.currentUser.userId]
        
        print(">>> SENT PARAMETERS >>>> \n\(parameters))")
        
        // Create User Objects
        Connection(configuration: nil).endRadarCall(parameters, completionBlock: { response, error in
            if error == nil {
                
                // print("\n\nConnection - Radar Response: \n\n>>>>>> \(response)\n\n")
                
                
            } else {
                print("End Radar Error", error)
                // Show user popup of error message
                // print("\n\nConnection - Radar Error: \n\n>>>>>>>> \(error)\n\n")
                //KVNProgress.show(withStatus: "There was an issue with your pin. Please try again.")
            }
            
        })
        
        // Stop animations and remove from view
        self.stopPulseAnimation()
        
    }
    
    func createTransaction(type: String, uuid: String) {
        // Set type
        transaction.type = type
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
            self.selectedUserIds.removeAll()
        }
    }
    
    func radarContactSelected(sender:UITapGestureRecognizer) {
        
        print("Radar User Index Counter >>> \((sender.view?.tag)!)")
        
        if selectedUserList[(sender.view?.tag)!].isSelected != true {
            // Set to true
            selectedUserList[(sender.view?.tag)!].isSelected = true
            
            
            // Make sender bigger
            radarStatus = false
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                
                
                //assuming the image is loaded second
                
                sender.view?.subviews[1].frame = CGRect(x: (sender.view?.subviews[1].frame.origin.x)!, y: (sender.view?.subviews[1].frame.origin.y)!, width: 100, height: 100)
                
                sender.view?.subviews[0].frame = CGRect(x: (sender.view?.subviews[0].frame.origin.x)!, y: (sender.view?.subviews[0].frame.origin.y)! + 10, width: 100, height: 100)
                
            }) { (Bool) -> Void in
                
                sender.view?.subviews[1].layer.borderWidth = 4
                sender.view?.subviews[1].layer.cornerRadius = 50
                sender.view?.subviews[1].layer.borderColor = UIColor.green.cgColor

            }
            
            // Set tint to show selected
            //sender.view?.tintColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 0/255.0, alpha: 1.0)
            
            // Add to selected user list
            selectedUsers.append(radarUsers[(sender.view?.tag)!])
            // Test count
            print("Selected User List Count --> \(selectedUsers.count)")
            
        } else{
            // Set to false
            selectedUserList[(sender.view?.tag)!].isSelected = false
            // Toggle the image
            
            
            sender.view?.subviews[1].layer.borderWidth = 0
            sender.view?.subviews[1].layer.cornerRadius = 0
            sender.view?.subviews[1].layer.borderColor = UIColor.clear.cgColor

            // Set tint to show deselection
            sender.view?.tintColor = UIColor.clear
            
            // Set to regular size 
            radarStatus = true
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                
                sender.view?.subviews[1].frame = CGRect(x: (sender.view?.subviews[1].frame.origin.x)!, y: (sender.view?.subviews[1].frame.origin.y)!, width: 60, height: 60)
                
                sender.view?.subviews[0].frame = CGRect(x: (sender.view?.subviews[0].frame.origin.x)!, y: (sender.view?.subviews[0].frame.origin.y)! - 10, width: 60, height: 15)
            })
            
        }
        
        // Toggle send button if list empty
        
        if selectedUsers.count > 0 {
            // Show button for send
            sendCardButton.isHidden = false
        }else{
            // Hide button
            sendCardButton.isHidden = true
        }
        
        
    }
    
    
    func centerMap(_ center:CLLocationCoordinate2D){
        self.saveCurrentLocation(center)
        
    }
    
    // User Data Access Permissions
    // -------------------------------------------------------------------
    
    func requestRadarAccess(){
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
    }
    
    private func checkContactsAccess() {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        // Update our UI if the user has granted access to their Contacts
        case .authorized:
            self.accessGrantedForContacts()
            //self.getContacts()
            
        // Prompt the user for access to Contacts if there is no definitive answer
        case .notDetermined :
            self.requestContactsAccess()
            
        // Display a message if the user has denied or restricted access to Contacts
        case .denied,
             .restricted:
            let alert = UIAlertController(title: "Privacy Warning!",
                                          message: "Permission was not granted for Contacts.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    private func requestContactsAccess() {
        
        store.requestAccess(for: .contacts) {granted, error in
            if granted {
                DispatchQueue.main.async {
                    self.accessGrantedForContacts()
                    Countly.sharedInstance().recordEvent("granted contacts access")
                    //self.getContacts()
                    return
                }
            } else {
                
                Countly.sharedInstance().recordEvent("blocked contacts access")
                
                
            }
        }
    }
    
    // This method is called when the user has granted access to their address book data.
    private func accessGrantedForContacts() {
        //Update UI for grated state.
        //...
        print("access granted, getting contacts... ")
        //getContacts()
    }
    
    
    
    // Location Managment
    // -----------------------------------------------------------
    
    func saveCurrentLocation(_ center:CLLocationCoordinate2D){
        let message = "THIS IS THE CURRENT \(center.latitude) , \(center.longitude)"
        
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
    
    
    func removePlottedPeople(_ containerView: UIView) {
        
        for view in containerView.subviews {
            
            if view.tag < 5000
            {
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    view.alpha = 0
                }) { (Bool) -> Void in
                    
                    view.removeFromSuperview()
                    
                }
            }
            
            
            
        }
        
    }
    
    
    func removeHalo(_ containerView: UIView) {
       
        for layer in containerView.layer.sublayers! {
            
            print(layer)
            print("------")
        
            
            
        }
        
    }
    
    
    
    
    func updateLocation(){
        
        // Update location tick
        updateLocation_tick = updateLocation_tick + 1
        
        
        // Flip switch if count == 4
        /*if updateLocation_tick == 4 && radarStatus == true {
            
            // Set receieved to false
            self.didReceieveList = false
            
                      // Check if radar button on the remount halo w/ animation
            if self.radarSwitch.isOn {
                
                // Flip all radar actions back to true
                radarStatus = true
                pulseMe(status: "show")
                
                // Start updating location
                self.locationManager.startUpdatingLocation()
            }else{
                print("The radar is off so its cool")
            }
        }*/
 
        
        print(updateLocation_tick)
        
        // Check is list should be refreshed
        
        
        if updateLocation_tick >= 5  && radarStatus == true
        {
            updateLocation_tick = 0
            
            // End radar first to clear instances of yourself
            //self.endRadar()
            
            
            
                
                // Hit endpoint for updates on users nearby
                let parameters = ["uuid": ContactManager.sharedManager.currentUser.userId, "location": ["latitude": self.lat, "longitude": self.long]] as [String : Any]
                
                print(">>> SENT PARAMETERS >>>> \n\(parameters))")
                
                // Create User Objects
                Connection(configuration: nil).startRadarCall(parameters, completionBlock: { response, error in
                    if error == nil {
                        
                        //print("\n\nConnection - Radar Response: \n\n>>>>>> \(response)\n\n")
                        
                        let dictionary : NSArray = response as! NSArray
                        
                        print("data length", dictionary.count)
                        
                        // Set counter to 0
                        self.counter = 0
                        
                        if  dictionary.count >= 0
                        {
                            // Clear radar list
                            self.removePlottedPeople(self.pulseView)
                            self.radarUsers.removeAll()
                        }
                        
                       

                        for item in dictionary {
                            
                            //print(item)
                            
                            let userDict = item as? NSDictionary
                            
                            // Init user objects from array
                            let user = User(withRadarSnapshot: userDict!)
                            //user.printUser()
                            // Add to list of users on radar
                            self.radarUsers.append(user)
                            
                            // Create selected index
                            let selectedIndex = Check(arrayIndex: self.counter, selected: false)
                            // Set Selected index
                            self.selectedUserList.append(selectedIndex)
                            
                            // Append users to radarContacts array
                            self.radarContacts.append(user)
                            //print("Radar List Count >>>> \(self.radarContacts.count)")
                            
                            // Set random coordinates for plotting images on radar
                            let distance = user.distance
                            let direction = user.direction
                            
                            /*
                            let distance = Int(random: -5..<10)
                            let direction = Int(random: -5..<10)*/
                            
                            // plot person on map
                            // The tag is used to tag images to identify their index in the array
                            self.plotPerson(distance: Int(distance), direction: Int(direction), tag: self.counter)
                            print("\n\nPerson Plotted - >>>Dist : \(distance), Direction : \(direction)\n\n")
                            
                            // Update counter
                            self.counter = self.counter + 1
                        }
                        
                        
                        // Here you set the id for the user and resubmit the object
                        // Perfom seggy to next vc
                        
                        //KVNProgress.showSuccess(withStatus: "The Code Has Been Sent.")
                        
                        
                    } else {
                        print(error)
                        // Show user popup of error message
                        print("\n\nConnection - Radar Error: \n\n>>>>>>>> \(error)\n\n")
                        //KVNProgress.show(withStatus: "There was an issue with your pin. Please try again.")
                    }
                    
                })
            }
            
            
            print("Updating location")
            
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        self.centerMap(locValue)
        
    }
    
    
    
    
    // Networking
    // ------------------------------------------------------------------------
    
    
    func uploadContactRecords(contacts: [Any?])
    {
        print("uploaded to contacts \(contacts.count)")
        
        print("------------------------------")
        
    }
    
    
    // Also use for storing images
    func createRequestBodyWith(parameters:[String:NSObject], filePathKey:String, boundary:String) -> NSData{
        
        let body = NSMutableData()
        
        for (key, value) in parameters {
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString(string: "\(value)\r\n")
        }
        
        body.appendString(string: "--\(boundary)\r\n")
        
        let mimetype = "image/jpg"
        
        let defFileName = "yourImageName.jpg"
        
        let yourImage = UIImage(named: "logo")
        
        let imageData = UIImageJPEGRepresentation(yourImage!, 1)
        
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(defFileName)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageData!)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    
    // Use for storing images
    func uploadUserThumb(image: UIImage, recordId: Int){
        
        
        _ = UIImageJPEGRepresentation(image, 0.2)!
        
        let rname = "\(global_uuid!)-\(recordId)"
        
        
        
        // LocalHost URL Link
        let url = NSURL(string: "http://localhost:5000/storeImages")
        
        var request = URLRequest(url: url! as URL)
        
        request.httpMethod = "POST"
        
        let boundary = self.generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type")
        
        
        let image_data = UIImagePNGRepresentation(image)
        let body = NSMutableData()
        let fname = "\(rname).jpg"
        let mimetype = "image/jpg"
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"photo\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("Incoming\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"files\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using:
            String.Encoding.utf8)!)
        body.append(image_data!)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)--\r\n".data(using:
            String.Encoding.utf8)!)
        
        request.httpBody = body as Data
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) {
            (
            data, response, error) in
            
            print(response)
            print(error)
            
            guard let _:Data = data, let _:URLResponse = response , error
                == nil else {
                    print("error")
                    return
            }
            
            let dataString = String(data: data!, encoding:
                String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            print(dataString)
            
            
            
            
        }
        
        task.resume()
        
        
        /*
         let parameters = ["name": rname]
         
         Alamofire.upload(multipartFormData: { multipartFormData in
         multipartFormData.append(imgData, withName: "\(rname).jpg", fileName: "\(rname).jpg", mimeType: "image/jpg")
         for (key, value) in parameters {
         multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
         }
         },
         to:"http://localhost:5000/storeImages")
         { (result) in
         switch result {
         case .success(let upload, _, _):
         
         upload.uploadProgress(closure: { (progress) in
         print("Upload Progress: \(progress.fractionCompleted)")
         })
         
         upload.responseJSON { response in
         print("\n\n\n\n success...")
         print(response.result.value)
         }
         
         case .failure(let encodingError):
         print("\n\n\n\n error....")
         print(encodingError)
         }
         }
         */
        
    }
    
    
    // Function called to retrieve contacts and sort to find user
    
    // Deprecate this method once conatcts settled in
    
    func retrieveContactsWithStore(store: CNContactStore) {
        do {
            print("retrieveContactsWithStore")
            
            
            SwiftAddressBook.requestAccessWithCompletion({ (success, error) -> Void in
                if success {
                    //do something with swiftAddressBook
                    
                    _ = [Any?]()
                    var jsonRecord = [JSON]()
                    var jsonRecordOutput : JSON = ["process" : "success"]
                    var records = 0
                    
                    if let people = swiftAddressBook?.allPeople {
                        
                        for person in people {
                            
                            var personJsonRecord : JSON = ["id": person.recordID, "uuid_associated": global_uuid]
                            
                            
                            
                            _ = [String: Any]()
                            
                            
                            
                            if (person.firstName != nil)        {  personJsonRecord["firstName"].stringValue = person.firstName! }
                            if (person.lastName != nil)         {  personJsonRecord["lastName"].stringValue = person.lastName! }
                            if (person.nickname != nil)         {  personJsonRecord["nickname"].stringValue = person.nickname! }
                            
                            //if (person.birthday != nil)         {  personJsonRecord["birthday"] = person.birthday }
                            
                            //if (person.hasImageData() == true)  {  importRecord["imageData"] = person.image }
                            
                            //if (person.phoneNumbers != nil)     {  importRecord["phoneNumbers"] = person.phoneNumbers }
                            //if (person.emails != nil)           {  importRecord["emails"] = person.emails }
                            //if (person.socialProfiles != nil)   {  importRecord["socialProfiles"] = person.socialProfiles }
                            //if (person.addresses != nil)        {  importRecord["addresses"] = person.addresses }
                            
                            
                            // Pull image data using uuid
                            
                            if (person.hasImageData() == true){
                                
                                //self.uploadUserThumb(image: person.image!, recordId: person.recordID)
                                
                                // personJsonRecord["profilePicture_local"].stringValue = "\(global_uuid!)-\(person.recordID).jpg"
                                
                                //let imageData: NSData = UIImageJPEGRepresentation(person.image!, 0.4)! as NSData
                                //personJsonRecord["imageData"].stringValue =  imageData.base64EncodedString()
                                
                                
                                
                            }
                            
                            // Populate phone records
                            
                            if ( person.phoneNumbers != nil){
                                
                                
                                for numb in person.phoneNumbers! {
                                    
                                    
                                    let recordNum = String(numb.id)
                                    
                                    let phoneRecord : JSON = [recordNum : ["value": "", "label": ""]]
                                    
                                    personJsonRecord["phoneNumbers"] = phoneRecord
                                    
                                    let path: [JSONSubscriptType] = ["phoneNumbers",recordNum]
                                    
                                    personJsonRecord[path]["value"].stringValue = numb.value
                                    
                                    if (numb.label != nil){ personJsonRecord[path]["label"].stringValue = numb.label! }
                                    
                                    
                                }
                            }
                            
                            // Populate email fields
                            
                            if ( person.emails != nil){
                                
                                
                                for numb in person.emails! {
                                    
                                    print(numb)
                                    
                                    let recordNum = String(numb.id)
                                    
                                    let emailsRecord : JSON = [recordNum : ["value": "", "label": ""]]
                                    
                                    personJsonRecord["emails"] = emailsRecord
                                    
                                    let path: [JSONSubscriptType] = ["emails",recordNum]
                                    
                                    personJsonRecord[path]["value"].stringValue = numb.value
                                    
                                    if (numb.label != nil){ personJsonRecord[path]["label"].stringValue = numb.label! }
                                    
                                    
                                }
                            }
                            
                            // Pull social profile information
                            if ( person.socialProfiles != nil){
                                
                                
                                for numb in person.socialProfiles! {
                                    
                                    print(numb)
                                    
                                    let recordNum = String(numb.id)
                                    
                                    let socialsRecord : JSON = [recordNum : ["value": "", "label": ""]]
                                    
                                    personJsonRecord["emails"] = socialsRecord
                                    
                                    let path: [JSONSubscriptType] = ["emails",recordNum]
                                    
                                    //personJsonRecord[path]["value"].stringValue = numb.value
                                    
                                    if (numb.label != nil){ personJsonRecord[path]["label"].stringValue = numb.label! }
                                    
                                    
                                }
                                
                                
                            }
                            
                            
                            // Output person object as string value
                            let strval = String(records)
                            //print(">>>", strval)
                            jsonRecordOutput[strval].object = personJsonRecord.object
                            records = records + 1
                            jsonRecord.append(personJsonRecord)
                            
                            
                            
                        }
                        
                        
                        print("type" , type(of: jsonRecordOutput)    )
                        print(jsonRecordOutput)
                        
                        
                        
                        
                        // do {
                        //var json = try JSONSerialization.jsonObject(with: jsonRecordOutput, options: [])
                        
                        //https://unifyalphaapi.herokuapp.com
                        
                        // Post dictionary object to endpoint
                        
                        Alamofire.request("http://localhost:5000/importContactRecords", method: .post, parameters: jsonRecordOutput.dictionaryValue, encoding: URLEncoding.default, headers:["Content-Type" : "application/x-www-form-urlencoded"])
                            .responseJSON { response in
                                
                                print(response)
                                
                                switch response.result {
                                case .failure(let error):
                                    print(error)
                                    
                                    if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                                        print(responseString)
                                    }
                                case .success(let responseObject):
                                    print(responseObject)
                                }
                        }
                        
                        
                        // }
                        // catch {
                        //     print(error)
                        // }
                        
                        
                        
                        //self.uploadContactRecords(contacts: fullRecord)
                        
                        
                    }
                    
                    
                }
                else {
                    //no success. Optionally evaluate error
                    print("/n/nThere was an error processing the post request /n/n")
                }
            })
            
            
            
            
        } catch {
            print(error)
        }
    }
    
    
    // Retrieve contacts from DB
    func getContacts() {
        let store = CNContactStore()
        
        print("set up cn contact store ...")
        
        
        if CNContactStore.authorizationStatus(for: .contacts) == .notDetermined {
            store.requestAccess(for: .contacts, completionHandler: { (authorized: Bool, error: NSError?) -> Void in
                if authorized {
                    self.retrieveContactsWithStore(store: store)
                }
                } as! (Bool, Error?) -> Void)
        } else if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
            self.retrieveContactsWithStore(store: store)
        }
    }
    
    // Notifications
    // ------------------------------------------------------------
    
    
    func notifyFunction(){
        
        // Prepare the popup assets
        let title = "THIS IS THE DIALOG TITLE"
        let message = "This is the message section of the popup dialog default view"
        let image = UIImage(named: "3b48a74")
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: image)
        
        // Create buttons
        let buttonOne = CancelButton(title: "CANCEL") {
            print("You canceled the car dialog.")
        }
        
        let buttonTwo = DefaultButton(title: "ADMIRE CAR") {
            print("What a beauty!")
        }
        
        let buttonThree = DefaultButton(title: "BUY CAR", height: 60) {
            print("Ah, maybe next time :)")
        }
        
        // Add buttons to dialog
        // Alternatively, you can use popup.addButton(buttonOne)
        // to add a single button
        popup.addButtons([buttonOne, buttonTwo, buttonThree])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
        
    }
    
    
    // Navigation
    // ------------------------------------------------------------
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showRadarContactProfile" {
            
            // Set destination 
            let contactVC = segue.destination as! RadarContactSelectionViewController
            // Pass currentUser object
            contactVC.selectedUser = self.selectedUser
        }
    }
    
}

// Extensions
// ------------------------------------------------------------

extension CGRect{
    init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
        self.init(x:x,y:y,width:width,height:height)
    }
    
}
extension CGSize{
    init(_ width:CGFloat,_ height:CGFloat) {
        self.init(width:width,height:height)
    }
}
extension CGPoint{
    init(_ x:CGFloat,_ y:CGFloat) {
        self.init(x:x,y:y)
    }
}

extension CLPlacemark {
    
    var compactAddress: String? {
        if let name = name {
            var result = name
            
            if let street = thoroughfare {
                result += ", \(street)"
            }
            
            if let city = locality {
                result += ", \(city)"
            }
            
            if let country = country {
                result += ", \(country)"
            }
            
            return result
        }
        
        return nil
    }
    
}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
    
}

extension Int {
    init(random range: Range<Int>) {
        
        let offset: Int
        if range.lowerBound < 0 {
            offset = abs(range.lowerBound)
        } else {
            offset = 0
        }
        
        let min = UInt32(range.lowerBound + offset)
        let max = UInt32(range.upperBound   + offset)
        
        self = Int(min + arc4random_uniform(max - min)) - offset
    }
}
