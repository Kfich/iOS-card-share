//
//  ContactManager.swift
//  Unify


import Foundation
import Contacts




class ContactManager{
    
    
    // Properties
    // ================================
    
    static let sharedManager = ContactManager()
    
    var application = UIApplication.shared
    
    // Contact store
    var store: CNContactStore = CNContactStore()
    var deviceToken : String = ""
    
    var jsonData : Data = Data()
    
    // Nav management for notifications
    var userArrivedFromContactList = false
    var userArrivedFromRadar = false
    var userArrivedFromIntro = false
    var userArrivedFromSocial = false
    var userArrivedFromLocationVC = false
    var userArrivedFromRecipients = false
    var userDidCreateCard = false
    var userSelectedEditCard = false
    var userCreatedNewContact = false
    var userSelectedRecipient = false
    var userSentCardFromRadarList = false
    var userSelectedNewContactForIntro = false
    var userSelectedNewRecipientForIntro = false
    var userSelectedPhoneLabelValue = false
    
    // Check for edit attempts
    var editRecipient = false
    var editContact = false
    
    // Check if objects have been added
    var contactAdded = false
    var recipientAdded = false
    
    // Toggle on selection
    var addContactSelected = false
    var addRecipientSelected = false
    
    // Conatct syncing on intro
    var syncIntroContactSwitch = true
    
    // Check if user from network
    var userIsRemoteUser = false
    var userNeedsRemoteImage = false
    var userCancelledPinEntry = false
    
    // Settings toggle
    var hideBadgesSelected = false
    var hideCardsSelected = true
    
    // Quickshare
    var quickshareSMSSelected = false
    var quickshareEmailSelected = false
    
    // Incognito toggle 
    var userIsIncognito = false
    var incognitoImage: UIImage? 
    var incognitoName = ""
    
    // Account for nav from card send view
    var userSMSCard = false
    var userEmailCard = false
    
    // ContactList for Refresh
    var contactListHasAppeared = false
    
    
    // Card and User Objects
    var currentUser = User()
    var selectedCard = ContactCard()
    var currentUserCards = [ContactCard]()
    var viewableUserCards = [ContactCard]()
    
    // Contacts for into activity
    var contactToIntro = CNContact()
    var recipientToIntro = CNContact()
    var contactToInvite = Contact()
    var contactObjectForIntro = Contact()
    var recipientObjectForIntro = Contact()
    var contactsHashTable = [String: [CNContact]]()
    
    // Contact for sending cards
    var contactForCardShare = CNContact()
    
    // Card list exported
    var currentUserCardsDictionaryArray = [[NSDictionary]]()
    
    // Phone ContactList Sync
    var phoneContactList = [CNContact]()
    var contactObjectList = [Contact]()
    var contactObjectTable = [String : [Contact]]()
    var dataArray = [String]()
    var letters = [String]()
    var synced = false
    var tuples = [(String, String)]()
    var contactTuples = [(String, CNContact)]()
    
    
    // Transaction Handling
    var transaction = Transaction()
    
    // Object for adding contacts 
    var newContact = Contact()
    var addedContact = CNContact()
    
    // For temp storage of social links 
    var tempSocialLinks = [[String:String]]()
    
    // Store image icons
    var socialLinkBadges = [[String : Any]]()
    var links = [String]()
    var socialBadges = [UIImage]()
    var socialLinks = [String]()
    var selectedSocialMediaLink : String = ""
    var cardBagdeLists = [String : [UIImage]]()
    
    // Global badges
    var badgeList: [CardProfile.Bagde] = []
    var viewableBadgeList: [CardProfile.Bagde] = []
    
    //var cardDesigns[]
    
    // Indexing the contact records for upload
    var index = 0
    var timer = Timer()
    
    // User radar position 
    var userLat : Double = 0.0
    var userLong : Double = 0.0
    var userAddress : String = ""
    // For google maps selection
    var selectedLocation : String = ""
    
    // For radar list
    var radarUserCount = 0
    
    var labelPathWithIntent = ["index": IndexPath(), "label_value": String()] as [String : Any]
    
    
    // Initialize class
    init() {
    }
    
    
    
    func reset(){
        
        userArrivedFromIntro = false
        userArrivedFromRadar = false
        userArrivedFromContactList = false
        
    }
    
    func initializeBadgeList() {
        // Image config
        // Test data config
        let img1 = UIImage(named: "Facebook.png")
        let img2 = UIImage(named: "Twitter.png")
        let img3 = UIImage(named: "instagram.png")
        let img4 = UIImage(named: "Pinterest.png")
        let img5 = UIImage(named: "Linkedin.png")
        let img6 = UIImage(named: "GooglePlus.png")
        let img7 = UIImage(named: "Crunchbase.png")
        let img8 = UIImage(named: "Youtube.png")
        let img9 = UIImage(named: "Soundcloud.png")
        let img10 = UIImage(named: "Flickr.png")
        let img11 = UIImage(named: "AboutMe.png")
        let img12 = UIImage(named: "Angellist.png")
        let img13 = UIImage(named: "Foursquare.png")
        let img14 = UIImage(named: "Medium.png")
        let img15 = UIImage(named: "Tumblr.png")
        let img16 = UIImage(named: "Quora.png")
        let img17 = UIImage(named: "Reddit.png")
        let img18 = UIImage(named: "Snapchat.png")
        let img19 = UIImage(named: "social-blank")
        // Hash images
        
        self.socialLinkBadges = [["facebook" : img1!], ["twitter" : img2!], ["instagram" : img3!], ["pinterest" : img4!], ["linkedin" : img5!], ["plus.google" : img6!], ["crunchbase" : img7!], ["youtube" : img8!], ["soundcloud" : img9!], ["flickr" : img10!], ["about.me" : img11!], ["angel.co" : img12!], ["foursquare" : img13!], ["medium" : img14!], ["tumblr" : img15!], ["quora" : img16!], ["reddit" : img17!], ["snapchat" : img18!], ["other" : img19!]]
        
        
    }
    
    
    func parseContactCardForSocialIcons(card: ContactCard) -> [UIImage] {
        
        // Init list of images to be returned
        var finalBadgeList = [UIImage]()
        var socialLinksArray = [String]()
        
        // Create badge list
        self.initializeBadgeList()
        
        print("PARSING FOR PROFILES")
        
        // Assign currentuser
        //self.currentUser = ContactManager.sharedManager.currentUser
        
        // Parse socials links
        if card.cardProfile.socialLinks.count > 0{
            for link in card.cardProfile.socialLinks{
                socialLinksArray.append(link["link"]!)
                // Test
                print("Social Links Count >> \(socialLinksArray.count)")
            }
        }
        
        // Remove all items from badges
        finalBadgeList.removeAll()
        // Add plus icon to list
        
        // Iterate over links[]
        for link in socialLinksArray {
            // Check if link is a key
            print("Link >> \(link)")
            for item in self.socialLinkBadges {
                // temp string
                let str = item.first?.key
                //print("String >> \(str)")
                // Check if key in link
                if link.lowercased().range(of:str!) != nil {
                    print("exists")
                    
                    // Append link to list
                    finalBadgeList.append(item.first?.value as! UIImage)
                    
                    // Test output
                    //print(item.first?.value as! UIImage)
                    print("SOCIAL BADGES COUNT")
                    print(finalBadgeList.count)
                    
                    
                }
            }
            
        }
        return finalBadgeList
        
    }
    
    
    func parseForCorpBadges(card: ContactCard) -> [UIImage]{
        
        var imageList = [UIImage]()
        
        // Parse card for selected badges
        if card.cardProfile.badgeDictionaryList.count > 0{
            
            for corp in card.cardProfile.badgeDictionaryList {
                // Init badge
                let badge = CardProfile.Bagde(snapshot: corp)
                
                let image = self.load_image(urlString: badge.pictureUrl)
                imageList.append(image)
                print("Image list from Manager Corp Parse: \(imageList)")
            }
            
        }
        return imageList
    }
    
    func load_image(urlString:String) -> UIImage{
        
        var returnImage = UIImage()
        
        var imgURL: NSURL = NSURL(string: urlString)!
        let request: URLRequest = URLRequest(url: imgURL as URL)
        NSURLConnection.sendAsynchronousRequest(
            request as URLRequest, queue: OperationQueue.main,
            completionHandler: {(response: URLResponse!,data: Data!,error: Error!) -> Void in
                if error == nil {
                    returnImage = UIImage(data: data)!
                }
        })
        
        return returnImage
    }
    
    
    /*func fetchVerifiedContactCardDesign(card: ContactCard){
     
        for card in viewableUserCards {
            
            // Save card to DB
            let parameters = ["data": self.transaction.toAnyObject()]
            print(parameters)
            
            // Send to server
            
            Connection(configuration: nil).createTransactionCall(parameters as [AnyHashable : Any]){ response, error in
                if error == nil {
                    print("Transaction Created Response ---> \(String(describing: response))")
                    
                    // Set card uuid with response from network
                    let dictionary : Dictionary = response as! [String : Any]
                    self.transaction.transactionId = (dictionary["uuid"] as? String)!
                    
                    // Insert to manager card array
                    //ContactManager.sharedManager.currentUserCardsDictionaryArray.insert([card.toAnyObjectWithImage()], at: 0)
                    
                    // Hide HUD
                    KVNProgress.dismiss()
                    
                } else {
                    print("Transaction Created Error Response ---> \(String(describing: error))")
                    // Show user popup of error message
                    KVNProgress.showError(withStatus: "There was an error with your connection. Please try again.")
                    
                }
                // Hide indicator
                KVNProgress.dismiss()
            }

        }
      
        
    }*/
    
    func fetchCardDesigns(card: ContactCard, id: String){
        
        let design = NSDictionary()
        
        let parameters = ["organizationId": id]
        

        // Send to server
        
        Connection(configuration: nil).getOrgCardCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Transaction Created Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                let dictionary : NSDictionary = response as! NSDictionary
                print("Card Design from manager")
                print(dictionary)
                
                card.cardDesign = ContactCard.Design(snapshot: dictionary)
                card.cardDesign.logo = dictionary["logo"] as! String
                print("Card Logo outhere \(card.cardDesign.logo)")
                print("The card itsself's design >> \(card.cardDesign.toAny())")
                
                
                // Append values to card itself
                
            } else {
                print("Transaction Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error with your connection. Please try again.")
                
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
    }
    
    func parseForSocialIcons() {
        
        // Create badge list
        self.initializeBadgeList()
        
        print("PARSING FOR PROFILES")
        
        // Assign currentuser
        //self.currentUser = ContactManager.sharedManager.currentUser
        
        // Parse socials links
        if ContactManager.sharedManager.currentUser.userProfile.socialLinks.count > 0{
            for link in ContactManager.sharedManager.currentUser.userProfile.socialLinks{
                socialLinks.append(link["link"]!)
                // Test
                print("Count >> \(socialLinks.count)")
            }
        }
        
        // Remove all items from badges
        self.socialBadges.removeAll()
        // Add plus icon to list
        
        // Iterate over links[]
        for link in self.socialLinks {
            // Check if link is a key
            print("Link >> \(link)")
            for item in self.socialLinkBadges {
                // Test
                //print("Item >> \(item.first?.key)")
                // temp string
                let str = item.first?.key
                //print("String >> \(str)")
                // Check if key in link
                if link.lowercased().range(of:str!) != nil {
                    print("exists")
                    
                    // Append link to list
                    self.socialBadges.append(item.first?.value as! UIImage)
                    
                    /*if !socialBadges.contains(item.first?.value as! UIImage) {
                     print("NOT IN LIST")
                     // Append link to list
                     self.socialBadges.append(item.first?.value as! UIImage)
                     }else{
                     print("ALREADY IN LIST")
                     }*/
                    // Append link to list
                    //self.socialBadges.append(item.first?.value as! UIImage)
                    
                    
                    
                    //print("THE IMAGE IS PRINTING")
                    //print(item.first?.value as! UIImage)
                    print("SOCIAL BADGES COUNT")
                    print(self.socialBadges.count)
                    
                    
                }
            }
            
            
            // Reload table
            //self.socialBadgeCollectionView.reloadData()
        }
        
        // Add image to the end of list
        //let image = UIImage(named: "icn-plus-blue")
        //self.socialBadges.append(image!)
        
        // Reload table
        //self.socialBadgeCollectionView.reloadData()
        
    }
    
    func setBadgeToVisible(websiteString : String, status: Bool) {
        //  Iterate over cards
        var index = 0
        var selectedCardId = ""
        
        for item in 0..<badgeList.count - 1 {
            // Find id match
            let badge = badgeList[index]
            
            if badge.website == websiteString {
                
                // Set card ID
                //selectedCardId = card.cardId!
                
                print(index)
                //card.printCard()
                // Remove index
                badge.isHidden = status
                // Test
                print("Current User Card Hidden Status \(badge.isHidden) at index: \(index)")
                
                // Exit loop
                break
            }
            // increment index
            index = index + 1
        }
        
        
        
        // Remove all from viewable
        //viewableUserCards.removeAll()
        
        var viewableIndex = 0
        
        // Viewable cards
        for viewable in 0..<ContactManager.sharedManager.badgeList.count{
            
            let viewableBadge = ContactManager.sharedManager.badgeList[viewableIndex]
            
            if viewableBadge.isHidden == true{
                
                // Add to viewable
                //ContactManager.sharedManager.viewableUserCards.append(viewableCard)
                
                print("Contact Manager Card Viewable On Toggle -> \(viewableBadge.website)")
                // Exit loop
                break
            }
            
        }
        
        // Post refresh
        
        print("Where the refresh would post for viewable \(viewableUserCards.count)")
        print("Where the refresh would post for current array \(currentUserCards.count)")

    }
    
    func setCardToVisible(cardIdString : String, status: Bool) {
        
        
        
        for card in viewableUserCards {
            // Check for id match
            
            if card.cardId! == cardIdString {
                
                print("Matching ID Strings!", card.cardId, cardIdString)
                
                // remove card from array
                viewableUserCards.remove(at: viewableUserCards.index(of: card)!)
                
                // Exit loop
                break
            }
        }
        
        
        /*//  Iterate over cards
        var index = 0
        var selectedCardId = ""
        
        for card in 0..<viewableUserCards.count {
            
            print("The card on manager serCardToVisible index: ", card)
            
            // Find id match
            let card = viewableUserCards[index]
            
            print("Manager serCardToVisible name: ", card.cardName ?? "No Name")
            print("Manager CardId: ", card.cardName ?? "No Name")
            
            if card.cardId == cardIdString {
                
                print("Manager CardId Match!!: ", card.cardName ?? "No Name")
                // Set card ID
                selectedCardId = card.cardId!
                
                print(index)
                //card.printCard()
                // Remove index
                card.isHidden = status
                // Test
                print("Current User Card Hidden Status \(card.isHidden) at index: \(index)")
                // Exit loop
                break
            }
            // increment index
            index = index + 1
        }
        
        
        
        // Remove all from viewable
        //viewableUserCards.removeAll()
        
        var viewableIndex = 0
        
        // Viewable cards
        for viewable in 0..<ContactManager.sharedManager.viewableUserCards.count{
            
            let viewableCard = ContactManager.sharedManager.viewableUserCards[viewableIndex]
            
            if viewableCard.isHidden == true{
                
                // Add to viewable
                //ContactManager.sharedManager.viewableUserCards.append(viewableCard)
                
                print("Contact Manager Card Viewable On Toggle -> \(viewableCard.cardId)")
                print(viewableCard.cardName ?? "")
                // Exit loop
                break
            }
            
        }*/
        
        // Post refresh
        
        //print("Where the refresh would post for viewable \(viewableUserCards.count)")
        //print("Where the refresh would post for current array \(currentUserCards.count)")
        
        postNotificationForCardRefresh()
        
    }
    
    func postNotificationForCardRefresh() {
        
        print("Refresh notification posting on setting hide card")
        print("Refresh table")
        
        // Notify other VC's to update cardviews
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshViewable"), object: self)
        
        
        //RefreshViewable
    }


    
    // Card Handling 
    func deleteCardFromArray(cardIdString : String) {
        //  Iterate over cards 
        var index = 0
        var selectedCardId = ""
        
        for card in 0..<currentUserCards.count {
            // Find id match
            let card = currentUserCards[index]
            
            if card.cardId == cardIdString {
                
                // Set card ID
                selectedCardId = card.cardId!
                
                print(index)
                card.printCard()
                // Remove index
                currentUserCards.remove(at: index)
                currentUserCardsDictionaryArray.remove(at: index)
                
                print("Card Removed .. ")
                print("Current User Cards \(currentUserCardsDictionaryArray.count)")
                print("Current User Cards Dictionaries \(currentUserCards.count)")
                // Exit loop
                break
            }
            // increment index
            index = index + 1
        }
        
        // Remove all from viewable
        viewableUserCards.removeAll()
        
        var viewableIndex = 0
        
        // Viewable cards
        for viewable in 0..<ContactManager.sharedManager.currentUserCards.count{
            
            let viewableCard = ContactManager.sharedManager.currentUserCards[viewableIndex]
            
            if viewableCard.isHidden != true{
                
                // Add to viewable
                ContactManager.sharedManager.viewableUserCards.append(viewableCard)
                
                print("Viewable card count")
            }
            
        }
        
        print("Current User Cards \(currentUserCardsDictionaryArray.count)")
        print("Current User Cards Dictionaries \(currentUserCards.count)")
    }
    
    // Card Handling
    func saveCardToArray(cardIdString : String, currentCard: ContactCard) {
        //  Iterate over cards
        var index = 0
        
        for card in 0..<currentUserCards.count {
            // Find id match
            let card = currentUserCards[index]
            
            if card.cardId == cardIdString {
                
                print(index)
                card.printCard()
                // Remove index
                //currentUserCards.remove(at: index)
                //currentUserCardsDictionaryArray.remove(at: index)
                
                //currentUserCards[index] = currentCard
               // currentUserCardsDictionaryArray[index] = [currentCard.toAnyObjectWithImage()]
                
                print("Card Overwritten .. ")
                print("Current User Cards \(currentUserCardsDictionaryArray.count)")
                print("Current User Cards Dictionaries \(currentUserCards.count)")
                break
            }
            
            // increment index
            index = index + 1
        }
        print("Current User Cards \(currentUserCardsDictionaryArray.count)")
        print("Current User Cards Dictionaries \(currentUserCards.count)")
    }
    
    
    // Transaction handling
    
    func createTransaction(type: String) {
        // Set type
        transaction.type = type
        // Show progress hud
        KVNProgress.show(withStatus: "Creating your connection...")
        
        // Save card to DB
        let parameters = ["data": self.transaction.toAnyObject()]
        print(parameters)
        
        // Send to server
        
        Connection(configuration: nil).createTransactionCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Transaction Created Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                let dictionary : Dictionary = response as! [String : Any]
                self.transaction.transactionId = (dictionary["uuid"] as? String)!
                
                // Insert to manager card array
                //ContactManager.sharedManager.currentUserCardsDictionaryArray.insert([card.toAnyObjectWithImage()], at: 0)
                
                // Hide HUD
                KVNProgress.dismiss()
                
            } else {
                print("Transaction Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error with your connection. Please try again.")
                
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
    }
    
    
    
    // Phone Contact Access and Sync
    
    func checkContactsAccess() {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        // Update our UI if the user has granted access to their Contacts
        case .authorized:
            self.accessGrantedForContacts()
            
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
            
            // Show the alert
            
            //self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func requestContactsAccess() {
        
        store.requestAccess(for: .contacts) {granted, error in
            if granted {
                DispatchQueue.main.async {
                    self.accessGrantedForContacts()
                    return
                }
            }
        }
    }
    
    
    
    // This method is called when the user has granted access to their address book data.
    func accessGrantedForContacts() {
        //Update UI for grated state.
        //...
        getContacts()
    }
    
    // Pull contacts
    
    func retrieveContactsWithStore(store: CNContactStore) {
        do {
            let groups = try store.groups(matching: nil)
            //let predicate = CNContact.predicateForContactsInGroup(withIdentifier: groups[0].identifier)
            let predicate = CNContact.predicateForContacts(matchingName: "John")
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactEmailAddressesKey] as [Any]
            
            let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
            
            
            print(contacts)
            
           // self.uploadContactRecords(contacts: (contacts as AnyObject) as! [CNContact])
            
            
        } catch {
            print(error)
        }
    }
    
    
    func getContacts() {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        if status == .denied || status == .restricted {
            
            print("Permission status >> \(status)")
            
            // Send them to the setting page
            //self.presentSettingsActionSheet()
            return
        }
        
        // Show progress
        //KVNProgress.show(withStatus: "Syncing contacts...")
        
        
        // open it
        
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, error in
            guard granted else {
                DispatchQueue.main.async {
                    //self.presentSettingsActionSheet()
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
            self.phoneContactList = contacts
            
            // do something with the contacts array (e.g. print the names)
            
            let formatter = CNContactFormatter()
            formatter.style = .fullName
            
            for contact in contacts {
                //print(formatter.string(from: contact) ?? "No Name")
                
                // Generate ID String
                let str = User().randomString(length: 10)
                // Assign id to object
                let contactTuple = (str, formatter.string(from: contact) ?? "No Name")
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
            self.contactObjectList += self.createContactRecords()
            
            // Sort list
            self.sortContacts()
            
            //self.fetchContactsForUser()
            
            // Find out if contacts synced
            self.synced = UDWrapper.getBool("contacts_synced")
            print("Contacts sync value on manager!! >> \(self.synced)")
            
            // Sync up with main queue
            DispatchQueue.main.async {
                
                
                // Check if data synced
                if self.synced{
                    
                    print("Contacts synced on manager!! >> \(self.synced)")
                    
                    // Notification for intro screen
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshContactsTable"), object: self)
                    
                }else{
                    
                    // Set synced
                    UDWrapper.setBool("contacts_synced", value: true)
                }
                
            }
            
        }
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
    
    
   
    // Initialize contact objects for upload
    
    func createContactRecords() -> [Contact] {
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
            
            print("First ", contactObject.first, "Last ", contactObject.last)
            
            
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
                contactObject.imageData = contact.imageData!
                
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
            //print("Contact >> \n\(contactObject.toAnyObject()))")
            
            // Parse own record
            contactObject.parseContactRecord()
            
            // Append object to contactObjectList
            contactObjectList.append(contactObject)
            
            
            // Print count
            print("List Count on manager ... \(contactObjectList.count)")
        }
        
        return contactObjectList
    }
    
    // Func dispatches timer to upload contacts
    func uploadContactRecords(){
        // Call function from manager
        //ContactManager.sharedManager.uploadContactRecords()
        
        timer = Timer.scheduledTimer(timeInterval: 0.2 , target: self, selector: #selector(ContactManager.uploadRecord), userInfo: nil, repeats: true)
        
        //  Start timer
        timer.fire()
        
    }
    
    // Func to upload individual record
    
    @objc func uploadRecord(){
        
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
            self.timer.invalidate()
            
            //Set bool to indicate contacts have been synced
            UDWrapper.setBool("contacts_synced", value: true)
        }
        
        
    }
    
    func fetchContactsForUser() {
        // Fetch the user data associated with users
        
        var errorOccured = false
        
        // Hit endpoint for updates on users nearby
        let parameters = ["uuid": ContactManager.sharedManager.currentUser.userId]
        
        print(">>> SENT PARAMETERS >>>> \n\(parameters))")
        // Show progress
        //KVNProgress.show(withStatus: "Fetching details on the activity...")
        
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
                    
                    print("The newest social", social["addresses"] as Any /*as? NSArray ?? NSArray()*/)
                    
                    // Init user objects from array
                    let contact = Contact(arraySnapshot: item as! NSDictionary)
                    
                    //print("Contact Object Item >>")
                    //print(contact.toAnyObject())
                    
                    // Append users to Selected array
                    self.contactObjectList.append(contact)
                    
                    // Generate ID String
                    let str = User().randomString(length: 10)
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

    
    
    
    // **** Functions for sorting contacts into sections *** //
    
    func sort() {
        // Test for sorting contacts by last name into sections
        
        let data = phoneContactList // Example data, use your phonebook data here.
        
        // Build letters array:
        
        var letters: [Character]
        
        letters = data.map { (contact) -> Character in
            print(contact.familyName.startIndex)
            // Set index of letter 
            let index = contact.familyName.index(contact.familyName.startIndex, offsetBy: 0)
            // Return index value
            return contact.familyName[index]
        }
        
        letters = letters.sorted()
        // Print letters array
        print("\n\nLETTERS >>>> \(letters)")
        
        // Make sure no redundancies in section list
        letters = letters.reduce([], { (list, name) -> [Character] in
            if !list.contains(name) {
                // Test to see if letters added
                print("\n\nAdded >>>> \(list + [name])")
                return list + [name]
            }
            return list
        })
        
        
        // Build contacts array:
        
        // Init sorted contacts array
        var contactNames = [Character: [CNContact]]()
        // Iterate over contact list
        for item in data {
            
            if contactNames[item.familyName[item.familyName.startIndex]] == nil {
                // Set index if doesn't exist
                contactNames[item.familyName[item.familyName.startIndex]] = [CNContact]()
            }
            
            // Add contact to section
            contactNames[item.familyName[item.familyName.startIndex]]!.append(item)
            
        }
        
        // Sort list
        
        for (letter, list) in contactNames {
            contactNames[letter] = list.sorted(by: {
                (firt: CNContact, second: CNContact) -> Bool in firt.familyName < second.familyName
            })

            // Test output
            print(contactNames[letter] ?? "")
        }
    }

    
    
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
                print("Not a string on Manager", String(lastName[lastName.startIndex]))
                return "#"
            }
        }
        
        // Sort letters array
        letters = letters.sorted()
        
        // Reduce letters to single count for each
        letters = letters.reduce([], { (list, name) -> [String] in
            if !list.contains(name) {
                // Test to see if letters added
                //print("\n\nAdded >>>> \(list + [name])")
                return list + [name]
            }
            return list
        })
        
        // If first index is the misc, move to end of array
        if letters.first == "#" {
            // Move to end of array
            letters = self.rearrange(array: letters, fromIndex: 0, toIndex: letters.endIndex)
            // Test
            //print("The new letters array\n\(letters)")
        }
        
        
        // Create indicies based on letters
        for letter in letters{
            
            // Create section in hash table
            contactsHashTable[letter] = [CNContact]()
            // Unify contacts table
            contactObjectTable[letter] = [Contact]()
            
        }
        
        
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
                // Append to table
                contactObjectTable[startIndex]!.append(contact)
                
            }
            
        }
        
        // Print to test 
        print("The contact object list on Manager Sort")
        //print(contactObjectList)
        
        // Show success
        //KVNProgress.showSuccess()
        
        // Post notification 
        self.postContactListRefresh()

        
    }
    
    // END **** Functions for sorting contacts into sections *** END//
    
    func presentSettingsActionSheet() {
        let alert = UIAlertController(title: "Permission to Contacts", message: "This app needs access to contacts in order to ...", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default) { _ in
            let url = URL(string: UIApplicationOpenSettingsURLString)!
            UIApplication.shared.open(url)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        //present(alert, animated: true)
    }
    
    
    // Notifications 
    func postContactListRefresh() {
        // Post notification
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshContactList"), object: self)
    }
    
}
