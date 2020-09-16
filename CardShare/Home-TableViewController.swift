//
//  TableViewController.swift


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

class HomeTableViewController: UITableViewController, CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource  {
    
    // Properties
    // ------------------------------------
    var currentUser = User()
    
    var store: CNContactStore!
    var updateLocation_tick = 5
    var parallaxEffect: RKParallaxEffect!
    
    let locationManager = CLLocationManager()
    
    var myLocation:CLLocationCoordinate2D?
    
    var radarStatus: Bool = false

    
    let keysToFetch = [
        CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
        CNContactEmailAddressesKey,
        CNContactPhoneNumbersKey,
        CNContactImageDataAvailableKey,
        CNContactThumbnailImageDataKey] as [Any]
    
    
    
    
    // IBOutlets
    // ------------------------------------------------------------------------
    
    @IBOutlet weak var homeView: UIView!
    
    @IBOutlet weak var radarBtn: UIButton!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var pulseView: UIView!
    

    // IBActions
    // ------------------------------------------------------------------------
    
    @IBAction func showEmailRecipient(_ sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "QuickShareVC")
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func showSMSRecipient(_ sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "QuickShareVC")
        self.present(controller, animated: true, completion: nil)
    }
    
    
    
    @IBAction func radarBtn_click(_ sender: Any) {
        
        print("activate radar")
        
        if radarStatus == true
        {
            radarStatus = false
            pulseMe(status: "hide")
            self.radarBtn.setTitle("Radar off", for: .normal)
            self.locationManager.stopUpdatingLocation()
            
            
            
        } else {
            
            radarStatus = true
            pulseMe(status: "show")
            self.radarBtn.setTitle("Radar on", for: .normal)
            self.locationManager.startUpdatingLocation()
        }
        
        
        if CLLocationManager.locationServicesEnabled() {
            
            requestRadarAccess()
            
        } else {
            
            notifyFunction()
            
        }
        
        
        
        
    }
    
    // Page Configuration 
    // ------------------------------------------------------------------------

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //route handling
       
        var isPhoneVerified = currentUser.getVerificationStatus()
        
        print("HOME","isPhoneVerified", isPhoneVerified)
        
        if !isPhoneVerified {
            //send user to phone verification
            print("FAIL")
        }
        
        store = CNContactStore()

        checkContactsAccess()
        
        //print("before", self.pageControl.frame.origin.y)
        self.pageControl.frame.origin.y = self.homeView.frame.height / 4
        //print("after", self.pageControl.frame.origin.y)
       
        
        /*
        let containerView:UIView = UIView(frame:CGRect(x: 10, y: 100, width: 300, height: 400))
        self.tableView = UITableView(frame: containerView.bounds, style: .plain)
        containerView.backgroundColor = UIColor.clear
        containerView.layer.shadowColor = UIColor.darkGray.cgColor
        containerView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        containerView.layer.shadowOpacity = 1.0
        containerView.layer.shadowRadius = 2
        
        self.tableView.layer.cornerRadius = 10
        self.tableView.layer.masksToBounds = true
        self.view.addSubview(containerView)
        containerView.addSubview(self.tableView)
        */
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        /*
        FIRApp.configure()

        var ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference()
        */
        //self.ref.child("radar/location").setValue(username)

        
        // Ask for Authorisation from the User.
        if radarStatus == true
        {
        
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
            }
        
        }

    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Add a background view to the table view
        //let backgroundImage = UIImage(named: "background")
        //let imageView = UIImageView(image: backgroundImage)
        //self.tableView.backgroundView = imageView
        
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        parallaxEffect = RKParallaxEffect(tableView: tableView)
        parallaxEffect.isParallaxEffectEnabled = true
        parallaxEffect.isFullScreenTapGestureRecognizerEnabled = false
        parallaxEffect.isFullScreenPanGestureRecognizerEnabled = true
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // User Authorization
    // ------------------------------------

    
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
                    //self.getContacts()
                    return
                }
            }
        }
    }
    
    
    // This method is called when the user has granted access to their address book data.
    private func accessGrantedForContacts() {
        //Update UI for grated state.
        //...
        print("access granted, getting contacts... ")
        getContacts()
    }
    
    

    
    // Networking
    // ------------------------------------------------------------------------

    
    func uploadContactRecords(contacts: [Any?])
    {
        print("uploaded to contacts \(contacts.count)")
   
        print("------------------------------")
    
    }

    
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
    
    
    func uploadUserThumb(image: UIImage, recordId: Int){
        
        
        _ = UIImageJPEGRepresentation(image, 0.2)!
        
        let rname = "\(global_uuid!)-\(recordId)"
        
        
        
        
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
                                
                                self.uploadUserThumb(image: person.image!, recordId: person.recordID)

                                personJsonRecord["profilePicture_local"].stringValue = "\(global_uuid!)-\(person.recordID).jpg"
                                
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
                            print(">>>", strval)
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
            
            
            /*
            let contactStore = CNContactStore()
            var contacts = [CNContact]()
            var vcardFromContacts = NSData()
            
            let fetchRequest = CNContactFetchRequest(keysToFetch:[CNContactVCardSerialization.descriptorForRequiredKeys()])
            
            do{
                try contactStore.enumerateContacts(with: fetchRequest, usingBlock: {
                    contact, cursor in
            
                    //CNContactVCardSerialization
             
                    contacts.append(contact)

                })
            } catch {
                print("Get contacts \(error)")
            }
            */
            
            
            //self.uploadContactRecords(contacts:    contacts    )
            
            
            /*
            let contactStore = CNContactStore()
           
            
            // Get all the containers
            var allContainers: [CNContainer] = []
            do {
                allContainers = try contactStore.containers(matching: nil)
            } catch {
                print("Error fetching containers")
            }
            
            var results: [CNContact] = []
            
            // Iterate all containers and append their contacts to our results array
            for container in allContainers {
                let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                
                do {
                    let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: [CNContactVCardSerialization.descriptorForRequiredKeys()])
                    results.append(contentsOf: containerResults)
                } catch {
                    print("Error fetching results for container")
                }
            }
            
             self.uploadContactRecords(contacts:    results    )
            
            */
            
            
        } catch {
            print(error)
        }
    }
    
    
    
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
    

    
    // Radar
    // -------------------------------------------------------------------
    
    func plotPerson(distance: Int, direction: Int)
    {
        
        //let image = UIImage(named: "")
        //let imageView = UIImageView(image: image!)
        
        let imageView = UIImageView()
        
        imageView.frame = CGRect(x: 100 + (10*direction), y: 280 - (10 * distance), width: 80, height: 80)
        
        imageView.backgroundColor = .black
        
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.clipsToBounds = true
        
        let hover = CABasicAnimation(keyPath: "position")
        
        hover.isAdditive = true
        hover.fromValue = NSValue(cgPoint: CGPoint.zero)
        
        let xx = Int(random: -5..<5)
        let yy = Int(random: -5..<5)
       
        print(">>\(xx, yy)")
        
        hover.toValue = NSValue(cgPoint: CGPoint(x: xx, y: yy))
        hover.autoreverses = true
        hover.duration = 0.5
        hover.repeatCount = Float.infinity
        
        imageView.layer.add(hover, forKey: "myHoverAnimation")

        
        self.homeView.addSubview(imageView)
        
    }
    
    // Pulsing animation
    
    func pulseMe(status: String?){
        
     
        let halo = PulsingHaloLayer()
        halo.position = pulseView.center
        halo.haloLayerNumber = 3;
        
        halo.radius = 100;
        
        halo.backgroundColor = UIColor.white.cgColor
        
        
        pulseView.layer.addSublayer(halo)
        halo.start()
        
        
        plotPerson(distance: 5, direction: -4)
        
        //plotPerson(distance: 7, direction: 10)
        
            /*
        pulseView.frame = CGRect.init(x: 0, y: 0, width: 100, height: 200)
     
        self.homeView.addSubview(pulseView)

        
        pulseView.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseView.colors = [(UIColor.white.cgColor as? Any), (UIColor.black.cgColor as? Any), (UIColor.white.cgColor as? Any)]
        pulseView.locations = [(0.3), (0.5), (0.7)]
        pulseView.startPoint = CGPoint(x: CGFloat(0), y: CGFloat(0.5))
        pulseView.endPoint = CGPoint(x: CGFloat(1), y: CGFloat(0.5))
        pulseView.minRadius = 0
        pulseView.maxRadius = 100
        pulseView.duration = 3
        pulseView.count = 6
        pulseView.lineWidth = 3.0

        
        pulseView.startAnimation()
        */
        
    }
    
    
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
    
    
    
    func centerMap(_ center:CLLocationCoordinate2D){
        self.saveCurrentLocation(center)

    }
    
    func saveCurrentLocation(_ center:CLLocationCoordinate2D){
        let message = "\(center.latitude) , \(center.longitude)"
        print(message)
        
        let location = CLLocation(latitude: center.latitude, longitude: center.longitude)
        
        
        // Geocode Location
        let geocoder = CLGeocoder()
        
        let paramString = "latitude=\(center.latitude)&longitude=\(center.longitude)&uuid=\(global_uuid!)"
        

        self.updateLocation(param: paramString)
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            // Process Response
            if let placemarks = placemarks, let placemark = placemarks.first {
                print( placemark.compactAddress)
            }
        }
        
        
       // self.lable.text = message
        //myLocation = center
    }
    
    
    
    
    // Location Managment
    // -----------------------------------------------------------
    
    func updateLocation(param: String){
        updateLocation_tick = updateLocation_tick + 1
        
        if updateLocation_tick > 5
        {
            updateLocation_tick = 0
       
        
            let url:URL = URL(string: "https://unifyalphaapi.herokuapp.com/geoservice")!
            let session = URLSession.shared
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
            let paramString = param
        
                request.httpBody = paramString.data(using: String.Encoding.utf8)

                let task = session.dataTask(with: request as URLRequest) {
                (
                data, response, error) in
                
                guard let data = data, let _:URLResponse = response, error == nil else {
                    print("error")
                    return
                }
                
                let dataString =  String(data: data, encoding: String.Encoding.utf8)
                print(dataString)
                
                    
            }
            
            task.resume()
            
            
            
         }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        self.centerMap(locValue)

    }

    
    
    // Tableview Delegate & Data Source
    // -----------------------------------------------------------
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // if you use prototype cells
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCardTableCell") as! HomeCardTableCell
        
        // Configure tableview cells

        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        
        cell.collectionView.layer.masksToBounds = true;
        cell.collectionView.layer.cornerRadius = 8;
        
        cell.collectionView.frame = CGRect(x: cell.collectionView.frame.origin.x + 11, y: cell.collectionView.frame.origin.y, width: UIScreen.main.bounds.size.width - 22, height: cell.collectionView.frame.height)

        return cell
    }
    
    
    // Collection View Delegate & Data Source
    // -----------------------------------------------------------
    

    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let kWhateverHeightYouWant = (collectionView.bounds.size.width) * 2.8
        
        print("sized \(kWhateverHeightYouWant)")
        
        return CGSize(  (collectionView.bounds.size.width) , CGFloat(collectionView.bounds.size.height))
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        print("5")
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        print(">3")
        return 3.0
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        print("items 3")
        return 3
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if indexPath.row == 2
        {
            print("add new card")
            
        } else {
            
            print("activate card")
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print(indexPath.row)
        
        if indexPath.row == 0
        {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell",
                                                          for: indexPath as IndexPath) as! CardCollectionViewCell
            
            
            cell.cardName.text = "Default"
            
            if (global_givenName != nil){ cell.cardDisplayName.text = global_givenName! }
            if (global_phone != nil){ cell.cardPhone.text = global_phone! }
            if (global_email != nil){ cell.cardEmail.text = global_email! }
            if (global_image != nil){ cell.cardImage.image = global_image! }
            
            /*
             var global_uuid: String?
             var global_phone: String?
             var global_image: UIImage?
             var global_givenName: String?
             var global_email: String?
             
             @IBOutlet weak var cardName: UILabel!
             
             @IBOutlet weak var cardSelectedBtn: UIButton!
             
             @IBOutlet weak var cardImage: UIImageView!
             
             @IBOutlet weak var cardDisplayName: UILabel!
             
             @IBOutlet weak var cardPhone: UILabel!
             
             @IBOutlet weak var cardEmail: UILabel!
             
             */

            
            return cell
            
        } else if indexPath.row != 2
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell",
                                                          for: indexPath as IndexPath)
            
        
            //cell.frame = CGRect(origin: CGFloat(collectionView.bounds.size.width), size: CGFloat(160))
            //cell.backgroundColor = .red
            
            return cell
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCellNew",
                                                          for: indexPath as IndexPath)
            
            //cell.backgroundColor = .red
            
            return cell
        }
        
    }
    

    // Custom Methods
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

   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}


// Extensions
// ------------------------------------------------------------
/*
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
*/
