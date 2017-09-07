//
//  AddContactContainerViewController.swift
//  Unify
//
//  Created by Kevin Fich on 8/7/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit
import Eureka

class AddContactContainerViewController: FormViewController {
    
    // Properties
    // ----------------------------------
    
    var currentUser = User()
    var contact = Contact()
    
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
    var addresses = [String]()
    
    // To check user intent
    //var doneButtonSelected = false
    
    var count = 0
    
    // IBOutlets
    // ----------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Really, we parse the card and profile infos to extract the list
        // Fill profile with example info
        currentUser = ContactManager.sharedManager.currentUser
        
        
        // Parse card for profile info
        
        
        // Parse bio info
        
        /*if contact.bios.count > 0{
            // Iterate throught array and append available content
            for bio in currentUser.userProfile.bios{
                bios.append(bio["bio"]!)
            }
        }*/
        
        // Parse work info
        /*if contact.workInformationList.count > 0{
            for info in contact.workInformationList{
                workInformation.append(info["work"]!)
            }
        }*/
        
        // Parse work info
        if contact.titles.count > 0{
            for info in contact.titles{
                titles.append((info["title"])!)
            }
        }
        
        // Parse phone numbers
        if contact.phoneNumbers.count > 0{
            for number in contact.phoneNumbers{
                phoneNumbers.append(number["phone"]!)
            }
        }
        // Parse emails
        if contact.emails.count > 0{
            for email in contact.emails{
                emails.append(email["email"]!)
            }
        }
        // Parse websites
        if contact.websites.count > 0{
            for site in contact.websites{
                websites.append(site["website"]!)
            }
        }
        // Parse organizations
        if contact.organizations.count > 0{
            for org in contact.organizations{
                organizations.append(org["organization"]!)
            }
        }
        
        // Parse notes
        if contact.notes.count > 0{
            for note in contact.notes{
                notes.append(note["note"]!)
            }
        }
        // Parse socials links
        if contact.socialLinks.count > 0{
            for link in contact.socialLinks{
                socialLinks.append(link["link"]!)
            }
        }
        // Parse socials links
        if contact.tags.count > 0{
            for link in contact.tags{
                tags.append(link["tag"]!)
            }
        }
        // Parse addresses
        if contact.addresses.count > 0{
            for add in contact.addresses{
                addresses.append(add["address"]!)
            }
        }
        
        // Set bg
        tableView.backgroundColor = UIColor.white
        
        //title = "Multivalued Examples"
        form +++
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
                                        $0.cell.textField.autocorrectionType = UITextAutocorrectionType.no
                                        $0.cell.textField.autocapitalizationType = UITextAutocapitalizationType.none
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
                               header: "Company",
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
                                        $0.cell.textField.autocorrectionType = UITextAutocorrectionType.no
                                        $0.cell.textField.autocapitalizationType = UITextAutocapitalizationType.none
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
                                        $0.cell.textField.autocorrectionType = UITextAutocorrectionType.no
                                        $0.cell.textField.autocapitalizationType = UITextAutocapitalizationType.none
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
                                        $0.cell.textField.autocorrectionType = UITextAutocorrectionType.no
                                        $0.cell.textField.autocapitalizationType = UITextAutocapitalizationType.none
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
                                        $0.cell.textField.autocorrectionType = UITextAutocorrectionType.no
                                        $0.cell.textField.autocapitalizationType = UITextAutocapitalizationType.none
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
            
           /* +++
            
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
            }*/
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "Tags",
                               footer: "") {
                                $0.tag = "Tag Section"
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add Tag"
                                        //$0.tag = "Add Media Info"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow("tagRow_\(index)") {
                                        $0.placeholder = "Tag"
                                        $0.cell.textField.autocorrectionType = UITextAutocorrectionType.no
                                        $0.cell.textField.autocapitalizationType = UITextAutocapitalizationType.none
                                        //$0.tag = "Add Media Info"
                                    }
                                }
                                
                                // Iterate through array and set val
                                for val in tags{
                                    $0 <<< NameRow() {
                                        $0.placeholder = "Tag"
                                        $0.value = val
                                        //$0.tag = "Add Media Info"
                                    }
                                }
            }
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "Notes",
                               footer: "") {
                                $0.tag = "Notes Section"
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add Notes"
                                        //$0.tag = "Add Media Info"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow("notesRow_\(index)") {
                                        $0.placeholder = "Note"
                                        $0.cell.textField.autocorrectionType = UITextAutocorrectionType.no
                                        $0.cell.textField.autocapitalizationType = UITextAutocapitalizationType.none
                                        //$0.tag = "Add Media Info"
                                    }
                                }
                                
                                // Iterate through array and set val
                                for val in notes{
                                    $0 <<< NameRow() {
                                        $0.placeholder = "Link"
                                        $0.value = val
                                        //$0.tag = "Add Media Info"
                                    }
                                }
            }
            
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "Addresses",
                               footer: "") {
                                $0.tag = "Address Section"
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add Address"
                                        //$0.tag = "Add Media Info"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow("addressRow_\(index)") {
                                        $0.placeholder = "Address"
                                        $0.cell.textField.autocorrectionType = UITextAutocorrectionType.no
                                        $0.cell.textField.autocapitalizationType = UITextAutocapitalizationType.none
                                        //$0.tag = "Add Media Info"
                                    }
                                }
                                
                                // Iterate through array and set val
                                for val in addresses{
                                    $0 <<< NameRow() {
                                        $0.placeholder = "Address"
                                        $0.value = val
                                        //$0.tag = "Add Media Info"
                                    }
                                }
            }

        
        
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
            
            // Assign all the items in each list to the contact profile on manager
            // Parse table section vals
        
        if ContactManager.sharedManager.userCreatedNewContact {
            
        
            
            // Titles Section
            let titleValues = form.sectionBy(tag: "Title Section")
            for val in titleValues! {
                print(val.baseValue ?? "")
                if let str = "\(val.baseValue ?? "")" as? String{
                    if str != "nil" && str != "" {
                        contact.titles.append(["title" : str])
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
                        contact.setPhoneRecords(phoneRecord: str)
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
                        // Append to arrays
                        contact.setEmailRecords(emailAddress: str)
                        emails.append(str)
                    }
                }
            }
            
            // Website Section
            let websiteValues = form.sectionBy(tag: "Website Section")
            for val in websiteValues! {
                print(val.baseValue ?? "")
                if let str = "\(val.baseValue ?? "")" as? String{
                    if str != "nil" && str != "" {
                        // Append to array
                        contact.setWebsites(websiteRecord: str)
                    }
                }
            }
            
            /*// Social Media Section
            let mediaValues = form.sectionBy(tag: "Media Section")
            for val in mediaValues! {
                print(val.baseValue ?? "")
                if let str = "\(val.baseValue ?? "")" as? String{
                    if str != "nil" && str != "" {
                        // Append to array
                        contact.setSocialLinks(socialLink: str)
                        socialLinks.append(str)
                    }
                }
            }*/
            
            // Notes Section
            let noteValues = form.sectionBy(tag: "Notes Section")
            for val in noteValues! {
                print(val.baseValue ?? "")
                if let str = "\(val.baseValue ?? "")" as? String{
                    if str != "nil" && str != "" {
                        // Set values to arrays
                        contact.setNotes(note: str)
                        notes.append(str)
                    }
                }
            }
            
            // Social Media Section
            let tagValues = form.sectionBy(tag: "Tag Section")
            for val in tagValues! {
                print(val.baseValue ?? "")
                if let str = "\(val.baseValue ?? "")" as? String{
                    if str != "nil" && str != "" {
                        contact.setTags(tag: str)
                        tags.append(str)
                        
                        //print("Social links not needed here anymore")
                    }
                }
            }
            
            // Address Section
            let addressValues = form.sectionBy(tag: "Address Section")
            for val in addressValues! {
                print(val.baseValue ?? "")
                if let str = "\(val.baseValue ?? "")" as? String{
                    if str != "nil" && str != "" {
                        contact.setAddresses(address: str)
                        addresses.append(str)
                        
                        //print("Social links not needed here anymore")
                    }
                }
            }
            
            // Organization section
            let organizationValues = form.sectionBy(tag: "Organization Section")
            for val in organizationValues! {
                print(val.baseValue ?? "")
                if let str = "\(val.baseValue ?? "")" as? String{
                    if str != "nil" && str != "" {
                        // Append to arrays
                        contact.setOrganizations(organization: str)
                        organizations.append(str)
                    }
                }
            }
            
            // Add origin 
            self.contact.origin = "unify"
            
            // Set contact to shared manager
            ContactManager.sharedManager.newContact = self.contact
            
            
            // Test to print profile
            ContactManager.sharedManager.newContact.printContact()
            
            
            // Post Alert
            self.postNotification()
            
        }else{
            print("They cancelled")
        }
        
    }
    
    // Custom methods
    
    // Notifications
    
    func postNotification() {
        
        // Notification for radar screen
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewContactAdded"), object: self)
        
    }
    
    
}
