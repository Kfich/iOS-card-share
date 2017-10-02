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

class RadarViewController: UIViewController, ISHPullUpContentDelegate, CLLocationManagerDelegate, RSKImageCropViewControllerDelegate/*, RSKImageCropViewControllerDataSource*/ {
    
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
    
    // Array for storing plotted coordinates
    var plotLocations = [[String: CGFloat]]()
    
    // Status bar view
    var barView = UIView()
    
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
    
    
    // Container for Radar list
    @IBOutlet var radarListContainer: UIView!
    
    @IBOutlet var testImageView: UIImageView!
    
    
    
    
    // View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Setup views
        
        
        if selectedUserIds.count == 0 {
            // Disable button 
            self.sendCardButton.isEnabled = false
            // Hide button
            sendCardButton.isHidden = true
        }
        
        // Config buttons for view
        configureViews()
        
        // See if current user pass
        ContactManager.sharedManager.currentUser.printUser()
        
        // Set current user 
        self.currentUser = ContactManager.sharedManager.currentUser
        
        
        // Test
        //testImage()
        
        // Set tags to views to avoid deletion
        self.radarLogoImage.tag = 5100
        //self.addNewCardButton.tag = 5101
        self.sendCardButton.tag = 5102
        self.radarListContainer.tag = 5103
        
        //add halo to pulseview as sublayer only once when view loads to prevent dups
        
        // Swift 3
        let modelName = UIDevice.current.modelName
        
        print("Model Name \(modelName)")
        
        if modelName == "iPhone 6" || modelName == "iPhone 6s" || modelName == "iPhone 7" {
            print("Iphone 6 landia my friend")
            //plus device
            halo.position.y = pulseView.frame.height / 2.55
            halo.position.x = pulseView.frame.width / 2.0
            
            //radarLogoImage.frame.origin.y = radarLogoImage.frame.origin.y + 100

            
        }else if modelName == "iPhone 6 Plus" || modelName == "iPhone 6s Plus" || modelName == "iPhone 7 Plus"{
            print("Now entering iphone plus landia my friend to tread light")
            //standard device
            halo.position.y = pulseView.frame.height / 2.7
            halo.position.x = pulseView.frame.width / 1.82
            
            //self.radarLogoImage.frame = CGRect(x: radarLogoImage.frame.origin.x, y: radarLogoImage.frame.origin.y , width: 10, height: 10)
            //radarLogoImage.isHidden = true
            
            print(radarLogoImage.frame)
        
        }
        
        
        if (UIScreen.main.bounds.size.height == 667.0 && UIScreen.main.nativeScale < UIScreen.main.scale){
            
            print("iphone 6 plus zoomed")
        } else {
        
            print("iphone 6 plus")
        }
        
        /*if (UIScreen.main.bounds.size.height == 568.0 && UIScreen.main.nativeScale > UIScreen.main.scale) {
            print("zoomed iphone 6")
        } else {
            print("none zoomed standard iphone")
            halo.position.x = pulseView.frame.width / 2
        }*/
        

        halo.haloLayerNumber = 3;
        
        // Set radius
        halo.radius = 150;
        
        halo.backgroundColor = UIColor.white.cgColor
        
        pulseView.layer.addSublayer(halo)

        halo.opacity = 0
        halo.start()
        
        // For notifications 
        self.addObservers()
        
        // Get profile info
        self.fetchCurrentUser()
        
        // Fetch cards
        //self.fetchUserCards()
        
        // Hide container 
        self.radarListContainer.isHidden = true
        
        //self.fetchCurrentUser()
        
        // Test cropper
        //self.showCropper()
        
        // Update user interface to check for connection 
        self.updateUserInterface()
        
        // Drop keyboard
        self.view.endEditing(true)

  
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        /*
        // Hide container
        if radarUsers.count > 7 && radarStatus == true {
            // Show list
            self.radarListContainer.isHidden = false
            
            // Post notification
            self.postUpdateLocationNotification()
        }else{
            // Hide
            self.radarListContainer.isHidden = true
        }
        */
        
    }
    
    // Testing
    
    // =======================
    
    // Image Cropper Delegates
    
    func showCropper(withImage: UIImage) {
        // Show image cropper
        let cropper = RSKImageCropViewController()
        // Set Cropper Image
        cropper.originalImage = withImage
        // Set mode
        cropper.cropMode = RSKImageCropMode.circle
        // Set Delegate
        cropper.delegate = self
        
        self.present(cropper, animated: true, completion: nil)
    }
    
    /*
     func imageCropViewControllerCustomMaskRect(_ controller: RSKImageCropViewController) -> CGRect {
     // Configure custom rect
     var size = CGSize()
     // Set size
     size.height = 150
     size.width = 150
     
     // Config view size
     let viewWidth = self.view.frame.width
     let viewHeight = self.view.frame.height
     
     // Make rect
     let rect = CGRect(x: (viewWidth - size.width) * 0.5, y: (viewHeight - size.height) * 0.5, width: size.width, height: size.height)
     
     return rect
     
     }*/
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        // Drop vc
        self.dismiss(animated: true, completion: nil)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        
        // Set image to view
        //self.profileImageContainerView.image = croppedImage
        
        // Test
        print("Cropped Image >> \n\(croppedImage)")
        
        self.testImageView.addSubview(self.configureSelectedImageView(selectedImage: croppedImage))
        // Dismiss vc
        dismiss(animated: true, completion: nil)
        
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, willCropImage originalImage: UIImage) {
        
        // Set image to view
        //self.profileImageContainerView.image = originalImage
        
        // Test
        print("Selected Image >> \n\(originalImage)")
    }
    
    func configureSelectedImageView(selectedImage: UIImage) -> UIImageView{
        // Config imageview
        
        // Set image to imageview
        let imageView = UIImageView(image: selectedImage)
        
        // Configure borders
        imageView.layer.borderColor = UIColor.blue.cgColor
        imageView.layer.borderWidth = 1.5
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 59    // Create container for image and name
        
        // Changed the image rendering size
        imageView.frame = CGRect(x: 10, y: 0 , width: 125, height: 125)
        
        return imageView
    }

    
    // =======================
    
    // Testing
    
    
    // IBActions / Buttons Pressed
    // -------------------------------------------
    
    @IBAction func testcrop(_ sender: Any) {
        print("showing croppper")
        
        self.showCropper(withImage: UIImage(named: "throwback")!)
    }
    
    @IBAction func addCard(_ sender: Any) {
        
        // Test user
        // testUser()
        
        // Show add card vc
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CreateCardVC")
        self.present(controller, animated: true, completion: nil)
        
        
    }
    
    
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
            
            // Record event
            Countly.sharedInstance().recordEvent("turned radar on")
            
            
            // Post update notifcation for listVC
            if self.radarListContainer.isHidden == false {
                // Let listVC know to update location
                self.postUpdateLocationNotification()
                
            }

            if selectedUsers.count > 0 {
                // Enable button
                self.sendCardButton.isEnabled = true
            }
            // Show it
            self.sendCardButton.isHidden = false
            // Set text
            sendCardButton.setTitle("Select people on the radar", for: .normal)
            
            
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
            
            // Hide card button
            self.sendCardButton.isEnabled = false
            self.sendCardButton.isHidden = true
            
            // Post notification for list VC
            //self.postEndRadarNotification()
            
            // Record event
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
        
        if self.radarListContainer.isHidden {
            // Send from the radar
            
            // Dyamically set selected card here
            
            // Iterate through selected card list
            for contact in selectedUserList {
                // Check if isSelected
                if contact.isSelected{
                    // Init user from list
                    let user = radarUsers[contact.index]
                    // Set id to recipient list
                    selectedUserIds.append(user.userId)
                    // Add recipient names 
                    self.transaction.recipientNames?.append(user.getName())
                }
            }
            
            // Set selected ids to trans and values
            // Set temp id for transaction
            transaction.recipientList = selectedUserIds
            transaction.setTransactionDate()
            transaction.senderName = ContactManager.sharedManager.currentUser.getName()
            transaction.senderId = ContactManager.sharedManager.currentUser.userId
            transaction.type = "connection"
            transaction.scope = "transaction"
            transaction.latitude = self.lat
            transaction.longitude = self.long
            transaction.location = self.address
            // Attach card id
            transaction.senderCardId = ContactManager.sharedManager.selectedCard.cardId!
            transaction.senderImageId = ContactManager.sharedManager.currentUser.profileImageId
            
            
            // Print tranny
            transaction.printTransaction()
            
            // Call create transaction function
            createTransaction(type: "connection", uuid: ContactManager.sharedManager.currentUser.userId)
            
            Countly.sharedInstance().recordEvent("shared contacts from radar")
            
        }else{
            // Post notification for radar list to handle the sending
            self.postSendCardNotification()
        }
        
    }
    
    func configureViews() {
        //self.sendCardButton.isHidden = false
        // Config send button
        self.sendCardButton.layer.cornerRadius = 12.0
        self.sendCardButton.clipsToBounds = true
        self.sendCardButton.layer.borderWidth = 1.0
        self.sendCardButton.layer.borderColor = UIColor.lightGray.cgColor
        
        // Configure borders
        radarListContainer.layer.borderColor = UIColor.blue.cgColor
        radarListContainer.layer.borderWidth = 1.5
        radarListContainer.clipsToBounds = true
        radarListContainer.layer.cornerRadius = 12
        
    }
    
    
    // Custom Methods
    
    // Notifications
    func postSendCardNotification() {
        
        // Post notification
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SendCardsFromRadarList"), object: self)
    }
    
    func postUpdateLocationNotification() {
        
        // Post notification
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateLocation"), object: self)
    }
    
    func postEndRadarNotification() {
        
        // Post notification
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "EndRadar"), object: self)
    }
    

    
    func fetchUserCards() {
        // Fetch cards from server 
        let parameters = ["uuid" : currentUser.userId]
        
        print("\n\nTHE CARD TO ANY - PARAMS")
        print(parameters)
        
        // Temp card list
        var tempCardList = [ContactCard]()
        
        // Connect to server
        Connection(configuration: nil).getCardsCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Card Created Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                let dictionary : NSArray = response as! NSArray
                print("\n\nCard List")
                print(dictionary)
                
                for item in dictionary{
                    let card = ContactCard(snapshot: item as! NSDictionary)
                    tempCardList.append(card)
                }
                
                
                for card in ContactManager.sharedManager.currentUserCards{
                    
                    for temp in tempCardList{
                        // Check for match
                        if temp.cardId == card.cardId{
                            // Test
                            print("Found an ID match")
                            // Set the field
                            card.isVerified = temp.isVerified
                        }
                    }
                }
                
                //self.fetchUserBadges()
                
            } else {
                print("Card Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error retrieving your cards. Please try again.")
            }
            // Hide indicator
            KVNProgress.dismiss()
        }

    }
    
    func fetchUserBadges() {
        // Fetch cards from server
        let parameters = ["data" : ContactManager.sharedManager.currentUser.userProfile.badges]
        
        print("\n\nTHE Badges TO ANY - PARAMS")
        print(parameters)
        
        // Store current user cards to local device
        //let encodedData = NSKeyedArchiver.archivedData(withRootObject: ContactManager.sharedManager.currentUserCards)
        //UDWrapper.setData("contact_cards", value: encodedData)
        
        
        // Show progress hud
        //KVNProgress.show(withStatus: "Saving your new card...")
        
        // Save card to DB
        //let parameters = ["data": card.toAnyObject()]
        
        Connection(configuration: nil).getBadgesCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Card Created Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                let dictionary : NSArray = response as! NSArray
                print("\n\nBadge List YYAAA")
                print(dictionary)
                // Init badges
                for item in dictionary{
                    let badge = CardProfile.Bagde(snapshot: item as! NSDictionary)
                    ContactManager.sharedManager.currentUser.userProfile.badgeList.append(badge)
                    
                    print("Printing badge")
                    print(badge)
                    print("Count for corp ", ContactManager.sharedManager.currentUser.userProfile.badgeList.count)
                }
                
                // Set global badge list
                ContactManager.sharedManager.badgeList =  ContactManager.sharedManager.currentUser.userProfile.badgeList
                // Add to viewable
                ContactManager.sharedManager.viewableBadgeList = ContactManager.sharedManager.currentUser.userProfile.badgeList
                
                
            } else {
                print("Card Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error retrieving your cards. Please try again.")
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
        
    }
    
    func fetchCurrentUser() {
        // Fetch cards from server
        let parameters = ["uuid" : currentUser.userId]
        
        print("\n\nTHE CARD TO ANY - PARAMS")
        print(parameters)
        
        
        // Show progress hud
        KVNProgress.show(withStatus: "Fetching profile...")
        
        // Save card to DB
        //let parameters = ["data": card.toAnyObject()]
        
        Connection(configuration: nil).getUserCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Get User Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                let dictionary : Dictionary = response as! [String : Any]
                print("\n\nUser from get call")
                print(dictionary)
                
                let profileDict = dictionary["data"]
                
                let user = User(snapshot: profileDict as! NSDictionary)
                
                // Set current user
                self.currentUser = user
                
                print("Current user to any", self.currentUser.toAnyObject())
                
                // Set manager badges
                ContactManager.sharedManager.currentUser.userProfile.badges = self.currentUser.userProfile.badges
                
                print("RadarViewController FetchUser >> Badges tho >> \(self.currentUser.userProfile.badges)")
                
                // Fetch cards 
                //self.fetchUserCards()
                
                self.fetchUserBadges()
                
            } else {
                print("Card Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error retrieving your cards. Please try again.")
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
        
    }
    
    
    
    // For notifications
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(RadarViewController.toggleRadar), name: NSNotification.Name(rawValue: "TurnOnRadar"), object: nil)
        
        // Toggle send card button
        NotificationCenter.default.addObserver(self, selector: #selector(RadarViewController.showSendCard), name: NSNotification.Name(rawValue: "ShowSendCard"), object: nil)
        
        // Toggle send card button
        NotificationCenter.default.addObserver(self, selector: #selector(RadarViewController.hideSendCard), name: NSNotification.Name(rawValue: "HideSendCard"), object: nil)
        
        // Update send card button
        NotificationCenter.default.addObserver(self, selector: #selector(RadarViewController.updateSendCardButton), name: NSNotification.Name(rawValue: "UpdateSendCard"), object: nil)
        
        // Notification for network connection
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
    
    }
    
    func toggleRadar() {
        // Turn radar on
        radarSwitch.isOn = true
        
        radarStatus = true
        pulseMe(status: "show")
        
        
         halo.position = view.center
         pulseView.layer.addSublayer(halo)
         halo.start()
         
         
         halo.isHidden = false
        
        self.locationManager.startUpdatingLocation()
        
        Countly.sharedInstance().recordEvent("turned radar on")
        
        self.radarButtonSelected(self)
    }
    
    func showSendCard() {
        // Toggle button on
        self.sendCardButton.isHidden = false
        self.sendCardButton.isEnabled = true
    }
    
    func hideSendCard() {
        // Toggle button on
        //self.sendCardButton.isHidden = true
        self.sendCardButton.isEnabled = false
    }
    
    func updateSendCardButton() {
        // Update text
        
        if ContactManager.sharedManager.radarUserCount > 0 {
            // Show button for send
            sendCardButton.isHidden = false
            sendCardButton.isEnabled = true
            
            if ContactManager.sharedManager.radarUserCount == 1 {
                // Grammar check
                // Set card text
                sendCardButton.setTitle("Tap to send to \(ContactManager.sharedManager.radarUserCount) person", for: .normal)
            }else{
                // Set card text
                sendCardButton.setTitle("Tap to send to \(ContactManager.sharedManager.radarUserCount) people", for: .normal)
            }
            
            // Set button color
            self.sendCardButton.backgroundColor = UIColor.white
        }else{
            // Hide button
            sendCardButton.isHidden = true
            // Set button to origial settings
            sendCardButton.isEnabled = false
            
            // Set text
            sendCardButton.setTitle("Select people on the radar", for: .normal)
            // Set color for bg
            self.sendCardButton.backgroundColor = UIColor.lightGray
            
        }

        
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
        var image = UIImage(named: "user")
        var imageView = UIImageView(image: image!)
        
        
        // Init imageURLS
        let urls = ImageURLS()
        
        // Create URL For Prod
        //let prodURL = urls.getFromStagingURL
        
        // Create URL For Test
        let testURL = urls.getFromDevelopmentURL
        let id = user.publicProfile?.imageId
        
        if user.userIsIncognito == true {
            // Show incognito data
            let url = URL(string: "\(testURL)\(id ?? "").jpg")!
            let placeholderImage = UIImage(named: "user")!
            // Set image
            imageView.setImageWith(url, placeholderImage: placeholderImage)
            
        }else{
            
            // Fetch user image reference
            if user.profileImageId != ""{
                // Grab image ref using alamo
                
                // ** Currently Set to Test URL
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
        
        // Store location coordinates
        let coords = ["x": containerView.frame.origin.x, "y": containerView.frame.origin.y]
        self.plotLocations.append(coords)
        print("\n\nPrinting coordinates : >> \(coords) <<  Tag# : \(tag)\n\n")
        
        
        // Manually plot points
        switch tag {
        case 0:
            containerView.frame.origin.x = 55
            containerView.frame.origin.y = 95
            print("New Coords from switch : x \(containerView.frame.origin.x), y \(containerView.frame.origin.y)")
        case 1:
            containerView.frame.origin.x = 110
            containerView.frame.origin.y = 5
            print("New Coords from switch : x \(containerView.frame.origin.x), y \(containerView.frame.origin.y)")
        case 2:
            containerView.frame.origin.x = 215
            containerView.frame.origin.y = 5
            print("New Coords from switch : x \(containerView.frame.origin.x), y \(containerView.frame.origin.y)")
        case 3:
            containerView.frame.origin.x = 255
            containerView.frame.origin.y = 170
            print("New Coords from switch : x \(containerView.frame.origin.x), y \(containerView.frame.origin.y)")
        case 4:
            containerView.frame.origin.x = 135
            containerView.frame.origin.y = 180
            print("New Coords from switch : x \(containerView.frame.origin.x), y \(containerView.frame.origin.y)")
        case 5:
            containerView.frame.origin.x = 285
            containerView.frame.origin.y = 70
            print("New Coords from switch : x \(containerView.frame.origin.x), y \(containerView.frame.origin.y)")
        default:
            print("Shit happens")
        }
        
        // Subtracts new x from old x
       /* if tag != 0 {
            
            let lastIndexX = self.plotLocations[tag - 1]["x"]
            print("Last Index x : \(lastIndexX)")
            let currentIndexX = coords["x"]
            print("Current Index x : \(currentIndexX)")
            // Calc different in x's
            let difference = (lastIndexX! - currentIndexX!)
            print("Index difference X : >>>>> \(abs(difference))")
            
            let lastIndexY = self.plotLocations[tag - 1]["y"]
            print("Last Index y : \(lastIndexY)")
            let currentIndexY = coords["y"]
            print("Current Index y : \(currentIndexY)")
            // Calc different in x's
            let differenceY = (lastIndexY! - currentIndexY!)
            print("Index difference y : >>>>> \(abs(differenceY))")
            
            if difference < 50 {
                // Test coord
                print("containerView.frame.origin.x Original \(containerView.frame.origin.x)")
                
                // Update coordinate
                containerView.frame.origin.x = containerView.frame.origin.x + 60
                print("containerView.frame.origin.x modified \(containerView.frame.origin.x)")
            }
            
            if differenceY < 50 {
                // Test coord
                print("containerView.frame.origin.y Original \(containerView.frame.origin.y)")
                
                // Update coordinate
                containerView.frame.origin.x = containerView.frame.origin.y + 60
                print("containerView.frame.origin.y modified \(containerView.frame.origin.y)")
            }
            
            
            
            
        }*/
        
        // If diff less than 60
        
        // Replot direction
        
        
        
        
        // Changed the image rendering size
        imageView.frame = CGRect(x: 0, y: 0 , width: 60, height: 60)
        
        // Add label to the view
        let lbl = UILabel(frame: CGRect(0, 60, 60, 15))
        
        
        // Set name to label
        if user.userIsIncognito == true {
            // Set to incognito name 
            lbl.text = user.publicProfile?.name
        }else{
            // Set to realname 
            lbl.text = user.getName()
        }
        
        
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
                print("Transaction Created Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                /*let dictionary : Dictionary = response as! [String : Any]
                self.transaction.transactionId = (dictionary["uuid"] as? String)!*/
                
                // Insert to manager card array
                //ContactManager.sharedManager.currentUserCardsDictionaryArray.insert([card.toAnyObjectWithImage()], at: 0)
                
                // Hide HUD
                //KVNProgress.dismiss()
                KVNProgress.showSuccess(withStatus: "You are now connected!")
                
                self.removePlottedPeople(self.pulseView)
                self.radarUsers.removeAll()
                self.radarStatus = true
                
                // Hide card button
                self.sendCardButton.isHidden = true
                
                
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
            UIView.animate(withDuration: 0.0001, animations: { () -> Void in
                
                
                //assuming the image is loaded second
                
                sender.view?.subviews[1].frame = CGRect(x: (sender.view?.subviews[1].frame.origin.x)!, y: (sender.view?.subviews[1].frame.origin.y)!, width: 80, height: 80)
                
                sender.view?.subviews[0].frame = CGRect(x: (sender.view?.subviews[0].frame.origin.x)!, y: (sender.view?.subviews[0].frame.origin.y)! + 10, width: 80, height: 80)
                
            }) { (Bool) -> Void in
                
                sender.view?.subviews[1].layer.borderWidth = 3
                sender.view?.subviews[1].layer.cornerRadius = 40
                sender.view?.subviews[1].layer.borderColor = UIColor.green.cgColor

            }
            
            // Set tint to show selected
            //sender.view?.tintColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 0/255.0, alpha: 1.0)
            
            // Add to selected user list
            //selectedUsers.append(radarUsers[(sender.view?.tag)!])
            // Test count
            //print("Selected User List Count --> \(selectedUsers.count)")
            
        } else{
            // Set to false
            selectedUserList[(sender.view?.tag)!].isSelected = false
            // Toggle the image
            
            
            sender.view?.subviews[1].layer.borderWidth = 0
            sender.view?.subviews[1].layer.cornerRadius = 0
            sender.view?.subviews[1].layer.borderColor = UIColor.clear.cgColor
            sender.view?.subviews[1].layer.cornerRadius = 30

            // Set tint to show deselection
            sender.view?.tintColor = UIColor.clear
            
            // Set to regular size 
            radarStatus = true
            UIView.animate(withDuration: 0.0001, animations: { () -> Void in
                
                sender.view?.subviews[1].frame = CGRect(x: (sender.view?.subviews[1].frame.origin.x)!, y: (sender.view?.subviews[1].frame.origin.y)!, width: 60, height: 60)
                
                //sender.view?.subviews[1].layer.borderWidth = 0
                //sender.view?.subviews[1].layer.cornerRadius = 30
                //sender.view?.subviews[1].layer.borderColor = UIColor.clear.cgColor
                
                sender.view?.subviews[0].frame = CGRect(x: (sender.view?.subviews[0].frame.origin.x)!, y: (sender.view?.subviews[0].frame.origin.y)! - 10, width: 60, height: 15)
            })
            
            // Remove object from selected user list
            //selectedUsers.remove(at:(sender.view?.tag)!)
            
        }
        
        // Filter out list of selected users
        let selectedListCounter = selectedUserList.filter { $0.isSelected == true }
        print("Selected List filtered \(selectedListCounter.count)")
        
        // Toggle send button if list empty
        if selectedListCounter.count > 0 {
            // Show button for send
            sendCardButton.isHidden = false
            sendCardButton.isEnabled = true
            
            if selectedListCounter.count == 1 {
                // Grammar check
                // Set card text
                sendCardButton.setTitle("Tap to send to \(selectedListCounter.count) person", for: .normal)
            }else{
                // Set card text
                sendCardButton.setTitle("Tap to send to \(selectedListCounter.count) people", for: .normal)
            }
            
            // Set button color
            self.sendCardButton.backgroundColor = UIColor.white
        }else{
            // Hide button
            sendCardButton.isHidden = true
            // Set button to origial settings
            sendCardButton.isEnabled = false
            
            // Set text
            sendCardButton.setTitle("Select people on the radar", for: .normal)
            // Set color for bg
            self.sendCardButton.backgroundColor = UIColor.lightGray
            
        }
        
        
        
    }
    
    
    func centerMap(_ center:CLLocationCoordinate2D){
        self.saveCurrentLocation(center)
        
    }
    
    // User Data Access Permissions
    // -------------------------------------------------------------------
    
    // Send user to app settings
    func showGeneralSettings() {
        // Push to settings
        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
        }
    }
    
    // Show settings alert
    func showAccessAlert() {
        // Configure alertview
        let alertView = UIAlertController(title: "Unify would like to access your location", message: "You need to authorize 'Unify' to access your location in your iPhone settings in order to use your radar", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Not now", style: .default, handler: { (alert) in
            
            // Dismiss alert
            self.dismiss(animated: true, completion: nil)
            
        })
        
        let settings = UIAlertAction(title: "Allow", style: .default, handler: { (alert) in
            // Execute logout function
            self.showGeneralSettings()
        })
        
        alertView.addAction(cancel)
        alertView.addAction(settings)
        self.present(alertView, animated: true, completion: nil)
    }

    
    func requestRadarAccess(){
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined:
                print("No access")
                
                self.locationManager.requestAlwaysAuthorization()
                
                // For use in foreground
                self.locationManager.requestWhenInUseAuthorization()
                
            case .restricted, .denied:
                print("Rejected")
                
                // Show modal to all access
                self.showAccessAlert()
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
            }
        } else {
            print("Location services are not enabled")
            
            // Show modal to gain access
            self.showAccessAlert()
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
                //self.address = placemark.compactAddress!
                self.address = placemark.addressDictionary?["Street"] as? String ?? ""
                print("Street >> \(self.address)")
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
                            // Hide card button
                            //self.sendCardButton.isHidden = true
                        }
                        
                       
                        
                        for item in dictionary {
                            
                            //print(item)
                            
                            let userDict = item as? NSDictionary
                            
                            // Init user objects from array
                            let user = User(withRadarSnapshot: userDict!)
                            //user.printUser()
                            // Add to list of users on radar
                            self.radarUsers.append(user)
                            /*self.radarUsers.append(user)
                            self.radarUsers.append(user)*/
                            
                            // Create selected index
                            let selectedIndex = Check(arrayIndex: self.counter, selected: false)
                            // Set Selected index
                            self.selectedUserList.append(selectedIndex)
                            
                            // Append users to radarContacts array
                            self.radarContacts.append(user)
                            //self.radarContacts.append(user)
                            //print("Radar List Count >>>> \(self.radarContacts.count)")
                            
                            // Set random coordinates for plotting images on radar
                            //let distance = user.distance
                            //let direction = user.direction
                            
                            
                            var distance = Int(random: -6..<12)
                            var direction = Int(random: -2..<10)
                            
                            
                            // Check if user count is at 7 
                            // Radar showing so plot people
                            // plot person on map
                            // The tag is used to tag images to identify their index in the array
                            //self.plotPerson(distance: Int(distance), direction: Int(direction), tag: self.counter)
                            
                            //print("\n\nPerson Plotted - >>>Dist : \(distance), Direction : \(direction)\n\n")
                        /*
                            distance = Int(random: -6..<12)
                            direction = Int(random: -2..<10)
        
                            self.plotPerson(distance: Int(distance), direction: Int(direction), tag: self.counter)
                            
                            distance = Int(random: -6..<12)
                            direction = Int(random: -2..<10)
                            
                            self.plotPerson(distance: Int(distance), direction: Int(direction), tag: self.counter)
                            
                            distance = Int(random: -6..<12)
                            direction = Int(random: -2..<10)
                            
                            self.plotPerson(distance: Int(distance), direction: Int(direction), tag: self.counter)*/
                            
                            
                            
                           /* // Update counter
                            self.counter = self.counter + 1
                            
                            self.plotPerson(distance: Int(distance), direction: Int(direction), tag: self.counter)
                        
                            
                            self.counter = self.counter + 1*/
                            
                            self.plotPerson(distance: Int(distance), direction: Int(direction), tag: self.counter)
                            
                            
                            self.counter = self.counter + 1
                            
                            /*self.plotPerson(distance: Int(distance), direction: Int(direction), tag: self.counter)
                            
                            
                            self.counter = self.counter + 1
                            
                            self.plotPerson(distance: Int(distance), direction: Int(direction), tag: self.counter)
                            
                            
                            self.counter = self.counter + 1*/
                            
                        }
                        
                        
                        // Test if user count over 7
                        if self.radarUsers.count > 5{
                            
                            print("")
                            // Set lat & long for user
                            ContactManager.sharedManager.userLat = self.lat
                            ContactManager.sharedManager.userLong = self.long
                            ContactManager.sharedManager.userAddress = self.address
                            
                            // Remove people
                            self.removePlottedPeople(self.pulseView)
                            // Post notif
                            self.postUpdateLocationNotification()
                            // Show container
                            self.radarListContainer.isHidden = false
                            // Hide pulse view
                            //self.pulseView.isHidden = true
                            // End radar pulsing
                            self.stopPulseAnimation()
                            
                            
                        }else{
                            // Test
                            print("The count was less then 7")

                        }
                        
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
    
    // Update interface if no service available
    
    func updateUserInterface() {
        guard let status = Network.reachability?.status else { return }
        switch status {
        case .unreachable:
            // Show view 
            print("Unreachable")
            // Hide bar
            self.barView.isHidden = false
            
            // Hide status bar
            var prefersStatusBarHidden: Bool {
                return true
            }
            // Show message
            showNetworkConnectionNotification()
            //view.backgroundColor = .red
        case .wifi:
            //view.backgroundColor = .green
            print("Wifi")
            // Hide bar
            self.barView.isHidden = true
            // Show status
            var prefersStatusBarHidden: Bool {
                return false
            }
            
        case .wwan:
            print("WWAN")
            // Hide barview
            self.barView.isHidden = true
            // Show status bar
            var prefersStatusBarHidden: Bool {
                return false
            }
        }
        print("Reachability Summary")
        print("Status:", status)
        print("HostName:", Network.reachability?.hostname ?? "nil")
        print("Reachable:", Network.reachability?.isReachable ?? "nil")
        print("Wifi:", Network.reachability?.isReachableViaWiFi ?? "nil")
    }
    
    
    func statusManager(_ notification: NSNotification) {
        updateUserInterface()
    }

    func showNetworkConnectionNotification(){
        
        // Init view to mount
        barView = UIView(frame: CGRect(x:0, y:0, width:view.frame.width, height:25))
        barView.backgroundColor=UIColor.white // set any colour you want..
        
        // Add view to main view
        self.view.addSubview(barView)
 
        
        let notifyLabel = UILabel()
        notifyLabel.frame = CGRect(x:0, y:0, width:view.frame.width, height:25)
        notifyLabel.backgroundColor=UIColor.clear
        notifyLabel.text = "No network connection. Checking again..."
        notifyLabel.textAlignment = .center
        notifyLabel.textColor = UIColor.blue
        notifyLabel.alpha = 0.8
        barView.addSubview(notifyLabel)
        
        
        
        // To achive animation
        //barView.center.y -= (navigationController?.navigationBar.bounds.height)!
        
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.6, options: UIViewAnimationOptions.curveEaseIn, animations:{
            
            UIApplication.shared.isStatusBarHidden = true
            UINavigationController().navigationBar.isHidden = true
            self.barView.center.y += (45)
            
            
        }, completion:{ finished in
            
            
            
            UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.9, options: UIViewAnimationOptions.curveEaseOut, animations:{
                // notifyLabel.alpha = 0...1
                UIApplication.shared.isStatusBarHidden = false
                //UINavigationController().navigationBar.isHidden = false
                self.barView.center.y -= ((25) + UIApplication.shared.statusBarFrame.height)
                
                
            }, completion: nil)
            
        })
        
        
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}
