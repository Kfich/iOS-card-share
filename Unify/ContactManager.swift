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
    var userArrivedFromRecipients = false
    var userDidCreateCard = false
    var userSelectedEditCard = false
    
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
    
    // Transaction Handling
    var transaction = Transaction()
    
    
    
    // Initialize class
    init() {
    }
    
    
    // Custom methods
    
    func reset(){
        
        userArrivedFromIntro = false
        userArrivedFromRadar = false
        userArrivedFromContactList = false
        
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
    
    
    
    
    
    func uploadContactRecords(contacts: [CNContact])
    {
        print(contacts)
        
        let json = [ "uid":"12345" , "contacts": contacts ] as [String : Any]
        
        let data = [AnyObject]()
        
        
        
         for contact in contacts{
            print("----------------------------")
         
            print(contact.givenName)
         
         //data.append(givenName: givenName)
            for email in contact.emailAddresses{
                print(email.label!)
                print(email.value)
        
            }
            print("----------------------------")
         
        }
        
         for contact in contacts as! [CNContact] {
            print("Contact ---> \(contact)")
         }
        
        do {
         
         
         jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
         
         print(jsonData)
         
         } catch let error as NSError {
         
         print(error)
         
         }
         
         let url:URL = URL(string: "https://unifyalphaapi.herokuapp.com/importContactRecords")!
         let session = URLSession.shared
         
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
         
         //let paramString = "fileUrl=\(fileUrl)&employeeId=hickmanTest&moveId=12345&notes=\(globalNotes!)&barcodeId=\(globalCode!)"
         
         //request.httpBody = contacts.data(using: String.Encoding.utf8)
         
         request.httpBody = jsonData
         
         
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
    
    // Pull contacts and sync to server
    
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
            let request = CNContactFetchRequest(keysToFetch: [CNContactIdentifierKey as NSString, CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey as CNKeyDescriptor, CNContactJobTitleKey as CNKeyDescriptor, CNContactImageDataAvailableKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor, CNContactImageDataKey as CNKeyDescriptor])
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
                print(formatter.string(from: contact) ?? "No Name")
                
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
            self.postContactListRefresh()
            
            // Test sort contacts code
            //self.sortContacts()
            //self.sort()
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
