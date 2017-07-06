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
    var store: CNContactStore!
    var jsonData : Data = Data()
    
    // Nav management for notifications
    var userArrivedFromContactList = false
    var userArrivedFromRadar = false
    var userArrivedFromIntro = false
    var userArrivedFromRecipients = false
    var userDidCreateCard = false
    
    // Card and User Objects
    var currentUser = User()
    var selectedCard = ContactCard()
    var currentUserCards = [ContactCard]()
    
    
    
    // Initialize class
    init() {
    }
    
    
    // Custom methods
    
    func reset(){
        
        userArrivedFromIntro = false
        userArrivedFromRadar = false
        userArrivedFromContactList = false
        
    }
    
    // Phone Contact Access and Sync
    
    private func checkContactsAccess() {
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
    
    
    private func requestContactsAccess() {
        
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
    private func accessGrantedForContacts() {
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
            let predicate = CNContact.predicateForContactsInGroup(withIdentifier: groups[0].identifier)
            //let predicate = CNContact.predicateForContactsMatchingName("John")
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactEmailAddressesKey] as [Any]
            
            let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
            
            self.uploadContactRecords(contacts: (contacts as AnyObject) as! [CNContact])
            
            
        } catch {
            print(error)
        }
    }
    
    
    
    func getContacts() {
        let store = CNContactStore()
        
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
    
    
    
    
    
}
