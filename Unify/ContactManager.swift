//
//  ContactManager.swift
//  Unify
//
//  Created by Kevin Fich on 5/24/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import Foundation
import Contacts



class ContactManager{
    
    
    // Properties
    // ================================
    
    static let sharedManager = ContactManager()
    
    // Contact store
    var store: CNContactStore = CNContactStore()
    
    
    var jsonData : Data = Data()
    
    // Nav management for notifications
    var userArrivedFromContactList = false
    var userArrivedFromRadar = false
    var userArrivedFromIntro = false
    var userArrivedFromSocial = false
    var userArrivedFromRecipients = false
    var userDidCreateCard = false
    var userSelectedEditCard = false
    var userCreatedNewContact = false
    var userSelectedRecipient = false
    var userSentCardFromRadarList = false
    
    // Settings toggle
    var hideBadgesSelected = false
    var hideCardsSelected = true
    
    // Quickshare
    var quickshareSMSSelected = false
    var quickshareEmailSelected = false
    
    // Incognito toggle 
    var userIsIncognito = false 
    
    // Account for nav from card send view
    var userSMSCard = false
    var userEmailCard = false
    
    // ContactList for Refresh
    var contactListHasAppeared = false
    
    
    // Card and User Objects
    var currentUser = User()
    var selectedCard = ContactCard()
    var currentUserCards = [ContactCard]()
    
    // Contacts for into activity
    var contactToIntro = CNContact()
    var recipientToIntro = CNContact()
    
    // Contact for sending cards
    var contactForCardShare = CNContact()
    
    // Card list exported
    var currentUserCardsDictionaryArray = [[NSDictionary]]()
    
    // Phone ContactList Sync
    var phoneContactList = [CNContact]()
    var contactObjectList = [Contact]()
    
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
    
    // Indexing the contact records for upload
    var index = 0
    var timer = Timer()
    
    // User radar position 
    var userLat : Double = 0.0
    var userLong : Double = 0.0
    var userAddress : String = ""
    
    // Initialize class
    init() {
    }
    
    
    // Custom methods
    
    func reset(){
        
        userArrivedFromIntro = false
        userArrivedFromRadar = false
        userArrivedFromContactList = false
        
    }
    
    func initializeBadgeList() {
        // Image config
        let img1 = UIImage(named: "icn-social-facebook.png")
        let img2 = UIImage(named: "icn-social-twitter.png")
        let img3 = UIImage(named: "icn-social-instagram.png")
        let img4 = UIImage(named: "icn-social-harvard.png")
        let img5 = UIImage(named: "icn-social-pinterest.png")
        let img6 = UIImage(named: "icn-social-pinterest.png")
        let img7 = UIImage(named: "icn-social-facebook.png")
        let img8 = UIImage(named: "icn-social-facebook.png")
        let img9 = UIImage(named: "icn-social-facebook.png")
        let img10 = UIImage(named: "icn-social-facebook.png")
        
        // Hash images
        self.socialLinkBadges = [["facebook" : img1!], ["twitter" : img2!], ["instagram" : img3!], ["harvard" : img4!], ["pinterest" : img5!]]/*, ["pinterest" : img6!], ["reddit" : img7!], ["tumblr" : img8!], ["myspace" : img9!], ["googleplus" : img10!]]*/
        
        
        // let fb : NSDictionary = ["facebook" : img1!]
        // self.socialLinkBadges.append([fb])
        
        
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
    
    // Card Handling 
    func deleteCardFromArray(cardIdString : String) {
        //  Iterate over cards 
        var index = 0
        
        for card in 0..<currentUserCards.count {
            // Find id match
            let card = currentUserCards[index]
            
            if card.cardId == cardIdString {
                
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
            presentSettingsActionSheet()
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
            let request = CNContactFetchRequest(keysToFetch: [CNContactIdentifierKey as NSString, CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey as CNKeyDescriptor, CNContactJobTitleKey as CNKeyDescriptor, CNContactImageDataAvailableKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor, CNContactImageDataKey as CNKeyDescriptor, CNContactOrganizationNameKey as CNKeyDescriptor, CNContactSocialProfilesKey as CNKeyDescriptor, CNContactUrlAddressesKey as CNKeyDescriptor, CNContactNoteKey as CNKeyDescriptor])
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
            
            // do something with the contacts array (e.g. print the names)
            
            let formatter = CNContactFormatter()
            formatter.style = .fullName
            for contact in contacts {
                //print(formatter.string(from: contact) ?? "No Name")
                
                if contact.phoneNumbers.count > 0 {
                  //print((contact.phoneNumbers[0].value ).value(forKey: "digits") as! String)
                }
                if contact.emailAddresses.count > 0 {
                    //print((contact.emailAddresses[0].value))
                }
                if contact.imageDataAvailable {
                    //print((contact.phoneNumbers[0].value ).value(forKey: "digits") as! String)
                    //print("Has IMAGE")
                }
                // Previous apprend area
                 self.phoneContactList.append(contact)
                
               // print(self.phoneContactList.count)
                //print(contact)
            }
            
            // Create contact objects
            self.contactObjectList = self.createContactRecords()
            
            // Set appeared to true
            self.contactListHasAppeared = true
            
            // Post refresh
            self.postContactListRefresh()
            
            //Set bool to indicate contacts have been synced
            //UDWrapper.setBool("contacts_synced", value: true)
            
            // Upload Contacts
            //self.uploadContactRecords()
            
        }
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
            print("Contact >> \n\(contactObject.toAnyObject()))")
            
            // Append object to contactObjectList
            contactObjectList.append(contactObject)
            
            
            // Print count
            print("List Count ... \(contactObjectList.count)")
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
        
        let data = ["Anton", "Anna", "John", "Caesar"] // Example data, use your phonebook data here.
        
        // Build letters array:
        
        var letters: [Character]
        
        letters = data.map { (name) -> Character in
            print(name[name.startIndex])
            return name[name.startIndex]
        }
        
        letters = letters.sorted()
        // Print letters array
        print("\n\nLETTERS >>>> \(letters)")
        
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
        var contacts = [Character: [String]]()
        // Iterate over contact list
        for entry in data {
            
            if contacts[entry[entry.startIndex]] == nil {
                // Set index if doesn't exist
                contacts[entry[entry.startIndex]] = [String]()
            }
            
            // Add entry to section
            contacts[entry[entry.startIndex]]!.append(entry)
            
        }
        
        // Sort list
        for (letter, list) in contacts {
            contacts[letter] = list.sorted()
            // Test output
            print(contacts[letter])
        }
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
