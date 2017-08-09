//
//  EditProfileContainerViewController.swift
//  Unify
//
//  Created by Kevin Fich on 6/13/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit
import Eureka

class EditProfileContainerViewController: FormViewController {
    
    // Properties
    // ----------------------------------
    
    var currentUser = User()
    
    // Parsed profile arrays
    var bios = [String]()
    var workInformation = [String]()
    var organizations = [String]()
    var titles = [String]()
    var phoneNumbers = [String]()
    var emails = [String]()
    var websites = [String]()
    var socialLinks = [String]()
    var notes = [String]()
    var tags = [String]()
    
    // To check user intent
    //var doneButtonSelected = false
    
    var count = 0
    
    // IBOutlets
    // ----------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Add observer for refresh
        self.addObservers()
        // Set current user
        currentUser = ContactManager.sharedManager.currentUser
        
        /*
        emails = ["example@gmail.com", "test@aol.com", "sample@gmail.com" ]
        phoneNumbers = ["1234567890", "6463597308", "3036558888"]
        socialLinks = ["facebook-link", "snapchat-link", "insta-link"]
        organizations = ["crane.ai", "Example Inc", "Sample LLC", "Boys and Girls Club"]
        bios = ["Created a company for doing blank for example usecase", "Full Stack Engineer at Crane.ai", "College Professor at the University of Application Building"]
        websites = ["example.co", "sample.ai", "excuse.me"]
        titles = ["Entrepreneur", "Salesman", "Full Stack Engineer"]
        workInformation = ["Job 1", "Job 2", "Example Job", "Sample Job"]*/
        
        
        // Parse card for profile info
        if ContactManager.sharedManager.userArrivedFromSocial {
            // Print Arrived form social
            print("Arrived from social")
            print("Arrived from social")
            print("Arrived from social")
       
        }else{
         
            // Parse bio info
            
            if currentUser.userProfile.bios.count > 0{
                // Iterate throught array and append available content
                for bio in currentUser.userProfile.bios{
                    bios.append(bio["bio"] as! String)
                }
            }
            // Parse work info
            if currentUser.userProfile.workInformationList.count > 0{
                for info in currentUser.userProfile.workInformationList{
                    workInformation.append(info["work"]!)
                }
            }
            // Parse work info
            if currentUser.userProfile.titles.count > 0{
                for info in currentUser.userProfile.titles{
                    titles.append((info["title"])!)
                }
            }
            
            // Parse phone numbers
            if currentUser.userProfile.phoneNumbers.count > 0{
                for number in currentUser.userProfile.phoneNumbers{
                    phoneNumbers.append(number["phone"]!)
                }
            }
            // Parse emails
            if currentUser.userProfile.emails.count > 0{
                for email in currentUser.userProfile.emails{
                    emails.append(email["email"]!)
                }
            }
            // Parse websites
            if currentUser.userProfile.websites.count > 0{
                for site in currentUser.userProfile.websites{
                    websites.append(site["website"]!)
                }
            }
            // Parse organizations
            if currentUser.userProfile.organizations.count > 0{
                for org in currentUser.userProfile.organizations{
                    organizations.append(org["organization"]!)
                }
            }
            // Parse Tags
            if currentUser.userProfile.tags.count > 0{
                for hashtag in currentUser.userProfile.tags{
                    tags.append(hashtag["tag"]!)
                }
            }
            // Parse notes
            if currentUser.userProfile.notes.count > 0{
                for note in currentUser.userProfile.notes{
                    notes.append(note["note"]!)
                }
            }
            // Parse socials links
            if currentUser.userProfile.socialLinks.count > 0{
                for link in currentUser.userProfile.socialLinks{
                    socialLinks.append(link["link"]!)
                }
            }
            
            
            
            title = "Multivalued Examples"
            form +++
                MultivaluedSection(multivaluedOptions: [.Insert, .Delete], header: "Bio Information", footer: "") {
                    $0.tag = "Bio Section"
                    $0.addButtonProvider = { section in
                        return ButtonRow(){
                            $0.title = "Add Bio Info"
                            //$0.tag = "Add Bio"
                            }.cellUpdate { cell, row in
                                cell.textLabel?.textAlignment = .left
                        }
                    }
                    $0.multivaluedRowToInsertAt = { index in
                        return NameRow("bioRow_\(index)") {
                            $0.placeholder = "Bio"
                            self.count = self.count + 1
                            //$0.tag = "Add Bio"
                            
                        }
                    }
                    
                    // Iterate through array and set val
                    
                    for val in bios{
                        print(val)
                        $0 <<< NameRow() {
                            $0.placeholder = "Bio"
                            $0.value = val
                            //$0.tag = "b_row\(IndexPath())"
                        }
                    }
                    
                    
                    
                }
                +++
                
                MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                                   header: "Titles",
                                   footer: "") {
                                    $0.tag = "Title Section"
                                    $0.addButtonProvider = { section in
                                        return ButtonRow(){
                                            $0.title = "Add Title"
                                            //$0.tag = "Add Titles"
                                            }.cellUpdate { cell, row in
                                                cell.textLabel?.textAlignment = .left
                                        }
                                    }
                                    
                                    $0.multivaluedRowToInsertAt = { index in
                                        return NameRow("titlesRow_\(index)") {
                                            $0.placeholder = "Title"
                                        }
                                    }
                                    // Iterate through array and set val
                                    for val in titles{
                                        $0 <<< NameRow() {
                                            $0.placeholder = "Title"
                                            $0.value = val
                                        }
                                    }
                }
                +++
                
                MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                                   header: "Phone Numbers",
                                   footer: "") {
                                    $0.tag = "Phone Section"
                                    $0.addButtonProvider = { section in
                                        return ButtonRow(){
                                            $0.title = "Add Phone Numbers"
                                            //$0.tag = "Phone Numbers"
                                            }.cellUpdate { cell, row in
                                                cell.textLabel?.textAlignment = .left
                                        }
                                    }
                                    $0.multivaluedRowToInsertAt = { index in
                                        return NameRow("numbersRow_\(index)") {
                                            $0.placeholder = "Number"
                                            //$0.tag = "Phone Numbers"
                                        }
                                    }
                                    // Iterate through array and set val
                                    for val in phoneNumbers{
                                        $0 <<< NameRow() {
                                            $0.placeholder = "Number"
                                            $0.value = val
                                            //$0.tag = "Phone Numbers"
                                        }
                                    }
                                    
                }
                +++
                
                MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                                   header: "Email Addresses",
                                   footer: "") {
                                    $0.tag = "Email Section"
                                    $0.addButtonProvider = { section in
                                        return ButtonRow(){
                                            $0.title = "Add Email"
                                            //$0.tag = "Add Emails"
                                            }.cellUpdate { cell, row in
                                                cell.textLabel?.textAlignment = .left
                                        }
                                    }
                                    $0.multivaluedRowToInsertAt = { index in
                                        return NameRow("emailsRow_\(index)") {
                                            $0.placeholder = "Address"
                                            //$0.tag = "Add Emails"
                                        }
                                    }
                                    
                                    // Iterate through array and set val
                                    for val in emails{
                                        $0 <<< NameRow() {
                                            $0.placeholder = "Address"
                                            //$0.tag = "Add Emails"
                                            $0.value = val
                                        }
                                    }
                }
                
                +++
                
                MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                                   header: "Work Info",
                                   footer: "") {
                                    $0.tag = "Work Section"
                                    $0.addButtonProvider = { section in
                                        return ButtonRow(){
                                            $0.title = "Add Work Info"
                                            //$0.tag = "Add Work Info"
                                            }.cellUpdate { cell, row in
                                                cell.textLabel?.textAlignment = .left
                                        }
                                    }
                                    $0.multivaluedRowToInsertAt = { index in
                                        return NameRow("workRow_\(index)") {
                                            $0.placeholder = "Work info"
                                            //$0.tag = "Add Work Info"
                                        }
                                    }
                                    // Iterate through array and set val
                                    for val in workInformation{
                                        $0 <<< NameRow() {
                                            $0.placeholder = "Work info"
                                            $0.value = val
                                            //$0.tag = "Add Work Info"
                                        }
                                    }
                }
                +++
                
                MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                                   header: "Websites",
                                   footer: "") {
                                    $0.tag = "Website Section"
                                    $0.addButtonProvider = { section in
                                        return ButtonRow(){
                                            $0.title = "Add Websites"
                                            //$0.tag = "Add Websites"
                                            }.cellUpdate { cell, row in
                                                cell.textLabel?.textAlignment = .left
                                        }
                                    }
                                    $0.multivaluedRowToInsertAt = { index in
                                        return NameRow("websitesRow_\(index)") {
                                            $0.placeholder = "Site"
                                            //$0.tag = "Add Websites"
                                        }
                                    }
                                    // Iterate through array and set val
                                    
                                    for val in websites{
                                        $0 <<< NameRow() {
                                            $0.placeholder = "Site"
                                            $0.value = val
                                            //$0.tag = "Add Websites"
                                        }
                                    }
                }
                
                +++
                
                MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                                   header: "Social Media Links",
                                   footer: "") {
                                    $0.tag = "Media Section"
                                    $0.addButtonProvider = { section in
                                        return ButtonRow(){
                                            $0.title = "Add Media Info"
                                            //$0.tag = "Add Media Info"
                                            }.cellUpdate { cell, row in
                                                cell.textLabel?.textAlignment = .left
                                        }
                                    }
                                    $0.multivaluedRowToInsertAt = { index in
                                        return NameRow("socialLinkRow_\(index)") {
                                            $0.placeholder = "Link"
                                            //$0.tag = "Add Media Info"
                                        }
                                    }
                                    
                                    // Iterate through array and set val
                                    for val in socialLinks{
                                        $0 <<< NameRow() {
                                            $0.placeholder = "Link"
                                            $0.value = val
                                            //$0.tag = "Add Media Info"
                                        }
                                    }
                }
                +++
                
                MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                                   header: "Organizations",
                                   footer: "") {
                                    $0.tag = "Organization Section"
                                    $0.addButtonProvider = { section in
                                        return ButtonRow(){
                                            $0.title = "Add Organizations"
                                            //$0.tag = "Add Organizations"
                                            }.cellUpdate { cell, row in
                                                cell.textLabel?.textAlignment = .left
                                        }
                                    }
                                    $0.multivaluedRowToInsertAt = { index in
                                        return NameRow("organizationRow_\(index)") {
                                            $0.placeholder = "Name"
                                            //$0.tag = "Add Organizations"
                                        }
                                    }
                                    
                                    // Iterate through array and set val
                                    for val in organizations{
                                        $0 <<< NameRow() {
                                            $0.placeholder = "Name"
                                            $0.value = val
                                            //$0.tag = "Add Organizations"
                                            
                                        }
                        }
                                    
            }
        }
        
        

    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
    if ContactManager.sharedManager.userSelectedEditCard{
            
        
        // Clear the arrays 
        self.removeAllFromArrays()
        
        // Assign all the items in each list to the contact profile on manager
        // Parse table section vals
        
        // Bios Section
        let bioValues = form.sectionBy(tag: "Bio Section")
        for val in bioValues! {
            
            print(val.baseValue ?? "")
            if let str = "\(val.baseValue ?? "")" as? String {
                // Append to user profile
                if str != "nil" && str != "" {
                    currentUser.userProfile.setBioRecords(emailRecords: ["bio": str])
                    bios.append(str)
                }
            }
        }
        
        // Titles Section
        let titleValues = form.sectionBy(tag: "Title Section")
        for val in titleValues! {
            print(val.baseValue ?? "")
            if let str = "\(val.baseValue ?? "")" as? String{
                if str != "nil" && str != "" {
                    currentUser.userProfile.titles.append(["title" : str])
                    titles.append(str)
                }
            }
        }
        
        // Phone Number section
        let phoneValues = form.sectionBy(tag: "Phone Section")
        for val in phoneValues! {
            print(val.baseValue ?? "")
            if let str = "\(val.baseValue ?? "")" as? String{
                if str != "nil" && str != "" {
                    currentUser.userProfile.setPhoneRecords(phoneRecords: ["phone" : str])
                    phoneNumbers.append(str)
                }
            }
        }
        
        // Email Section
        let emailValues = form.sectionBy(tag: "Email Section")
        for val in emailValues! {
            print(val.baseValue ?? "")
            if let str = "\(val.baseValue ?? "")" as? String{
                if str != "nil" && str != "" {
                    currentUser.userProfile.emails.append(["email" : str])
                    emails.append(str)
                }
            }
        }
        
        // Work Info Section
        let workValues = form.sectionBy(tag: "Work Section")
        for val in workValues! {
            print(val.baseValue ?? "")
            if let str = "\(val.baseValue ?? "")" as? String{
                if str != "nil" && str != "" {
                    currentUser.userProfile.workInformationList.append(["work" :str])
                    workInformation.append(str)
                }
            }
        }
        
        // Website Section
        let websiteValues = form.sectionBy(tag: "Website Section")
        for val in websiteValues! {
            print(val.baseValue ?? "")
            if let str = "\(val.baseValue ?? "")" as? String{
                if str != "nil" && str != "" {
                    currentUser.userProfile.setWebsites(websiteRecords: ["website": str])
                }
            }
        }
        
        // Social Media Section
        let mediaValues = form.sectionBy(tag: "Media Section")
        for val in mediaValues! {
            print(val.baseValue ?? "")
            if let str = "\(val.baseValue ?? "")" as? String{
                if str != "nil" && str != "" {
                    currentUser.userProfile.setSocialLinks(socialRecords: ["link": str])
                    socialLinks.append(str)
                }
            }
        }
        
        // Organization section
        let organizationValues = form.sectionBy(tag: "Organization Section")
        for val in organizationValues! {
            print(val.baseValue ?? "")
            if let str = "\(val.baseValue ?? "")" as? String{
                if str != "nil" && str != "" {
                    currentUser.userProfile.setOrganizations(organizationRecords: ["organization": str])
                    organizations.append(str)
                }
            }
        }
        
        // Set the array values as the profile
        
        /*UDWrapper.setArray("bios", value: bios as NSArray)
        UDWrapper.setArray("titles", value: titles as NSArray)
        UDWrapper.setArray("workInfo", value: workInformation as NSArray)
        UDWrapper.setArray("phoneNumbers", value: phoneNumbers as NSArray)
        UDWrapper.setArray("emails", value: emails as NSArray)
        UDWrapper.setArray("websites", value: websites as NSArray)
        UDWrapper.setArray("socialLinks", value: socialLinks as NSArray)
        UDWrapper.setArray("organizations", value: organizations as NSArray)*/
        
        // Set current user
        ContactManager.sharedManager.currentUser = self.currentUser
        
        // Test to print profile
        ContactManager.sharedManager.currentUser.userProfile.printProfle()
        
        // Update user
        self.updateCurrentUser()
        
        // Store user to device
        UDWrapper.setDictionary("user", value: self.currentUser.toAnyObjectWithImage())
        
        self.postNotification()
    }else{
        print("They chose to cancel")
        }
    }
    
    // Custom methods
    
    // Notifications
    
    func postNotification() {
        
        // Notification for radar screen
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshProfile"), object: self)
        
    }
    
    func addObservers() {
        // Refresh table
        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileContainerViewController.sayHello), name: NSNotification.Name(rawValue: "RefreshEditProfile"), object: nil)
        
        
    }
    func sayHello() {
        // Testing 
        print("Hello!")
        print("Hello!")
        print("Hello!")
        print("Hello!")
        
        // Remove all section of form
        form.removeAll()
    }
    
    func parseProfileData()  {
        // Clear arrays
        self.removeAllFromArrays()
        
        if currentUser.userProfile.bios.count > 0{
            // Iterate throught array and append available content
            for bio in currentUser.userProfile.bios{
                bios.append(bio["bio"]!)
            }
        }
        // Parse work info
        if currentUser.userProfile.workInformationList.count > 0{
            for info in currentUser.userProfile.workInformationList{
                workInformation.append(info["work"]!)
            }
        }
        // Parse work info
        if currentUser.userProfile.titles.count > 0{
            for info in currentUser.userProfile.titles{
                titles.append((info["title"])!)
            }
        }
        
        // Parse phone numbers
        if currentUser.userProfile.phoneNumbers.count > 0{
            for number in currentUser.userProfile.phoneNumbers{
                phoneNumbers.append(number["phone"]!)
            }
        }
        // Parse emails
        if currentUser.userProfile.emails.count > 0{
            for email in currentUser.userProfile.emails{
                emails.append(email["email"]!)
            }
        }
        // Parse websites
        if currentUser.userProfile.websites.count > 0{
            for site in currentUser.userProfile.websites{
                websites.append(site["website"]!)
            }
        }
        // Parse organizations
        if currentUser.userProfile.organizations.count > 0{
            for org in currentUser.userProfile.organizations{
                organizations.append(org["organization"]!)
            }
        }
        // Parse Tags
        if currentUser.userProfile.tags.count > 0{
            for hashtag in currentUser.userProfile.tags{
                tags.append(hashtag["tag"]!)
            }
        }
        // Parse notes
        if currentUser.userProfile.notes.count > 0{
            for note in currentUser.userProfile.notes{
                notes.append(note["note"]!)
            }
        }
        // Parse socials links
        if currentUser.userProfile.socialLinks.count > 0{
            for link in currentUser.userProfile.socialLinks{
                socialLinks.append(link["link"]!)
            }
        }
        
        // Reload Table
        
    }
    
    func removeAllFromArrays() {
        // Clear all profile info to prepare for override 
        currentUser.userProfile.bios.removeAll()
        currentUser.userProfile.titles.removeAll()
        currentUser.userProfile.emails.removeAll()
        currentUser.userProfile.phoneNumbers.removeAll()
        currentUser.userProfile.websites.removeAll()
        currentUser.userProfile.organizations.removeAll()
        currentUser.userProfile.socialLinks.removeAll()
        currentUser.userProfile.workInformationList.removeAll()
    }
    
    
    func updateCurrentUser() {
        // Configure to send to server
        
        
        // Send to server
        let parameters = ["data" : currentUser.toAnyObject(), "uuid" : currentUser.userId] as [String : Any]
        print("\n\nTHE CARD TO ANY - PARAMS")
        print(parameters)
        
        // Store current user cards to local device
        //let encodedData = NSKeyedArchiver.archivedData(withRootObject: ContactManager.sharedManager.currentUserCards)
        //UDWrapper.setData("contact_cards", value: encodedData)
        
        
        // Show progress hud
        //KVNProgress.show(withStatus: "Saving your new card...")
        
        // Save card to DB
        //let parameters = ["data": card.toAnyObject()]
        
        Connection(configuration: nil).updateUserCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Card Created Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                let dictionary : Dictionary = response as! [String : Any]
                print(dictionary)
                
                
                // Store user to device
                UDWrapper.setDictionary("user", value: self.currentUser.toAnyObjectWithImage())
                
                // Hide HUD
                KVNProgress.dismiss()
                
                // Nav out the view
                self.navigationController?.popViewController(animated: true)
                
                
            } else {
                print("Card Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error creating your card. Please try again.")
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
    }

    
    
    
}
