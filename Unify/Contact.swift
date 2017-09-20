//
//  Contact.swift
//  Unify
//
//  Created by Kevin Fich on 7/26/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import Foundation
import Contacts


public class Contact: Fuseable{
    // Properties
    var contactId : String = ""
    dynamic var name : String = ""
    dynamic var first = ""
    dynamic var last = ""
    var emails = [[String : String]]()
    var phoneNumbers = [[String : String]]()
    var titles = [[String : String]]()
    var organizations  = [[String : String]]()
    var socialLinks = [[String : String]]()
    var websites = [[String : String]]()
    var notes = [[String : String]]()
    var tags = [[String : String]]()
    var addresses = [[String : String]]()
    
    var emailList = NSArray()
    var phoneNumberList = NSArray()
    var titleList = NSArray()
    var organizationList  = NSArray()
    var socialLinkList = NSArray()
    var websiteList = NSArray()
    var noteList = NSArray()
    var tagList = NSArray()
    var addressList = NSArray()
    
    // Parsed profile arrays
    dynamic var bioList = String()
    dynamic var workInformation = String()
    dynamic var organization = String()
    dynamic var title = String()
    dynamic var phoneNumber = String()
    dynamic var email = String()
    dynamic var website = String()
    dynamic var socialLink = String()
    dynamic var note = String()
    dynamic var tag = String()
    dynamic var address = String()
    
    var origin : String = ""
    var verified = false
    var isVerified : String = "0"
    
    // For image storage
    var imageId : String = ""
    var imageDictionary = [String : Any]()
    var sections = [String]()
    var tableData = [String: [String]]()
    var formatter = CNContactFormatter()
    
    // Badges
    var badges = [String]()
    var badgeList = [Bagde]()
    var badgeDictionaryList = [NSDictionary]()
    
    // Badge struct
    public class Bagde {
        var pictureUrl: String
        var website: String
        var isHidden: Bool = false
        
        init(snapshot: NSDictionary) {
            pictureUrl = snapshot["image"] as? String ?? ""
            website = snapshot["url"] as? String ?? ""
        }
        
        init(){
            
            pictureUrl = ""
            website = ""
        }
        func toAnyObject() -> NSDictionary {
            return ["image": pictureUrl, "url": website]
        }
        
    }
    
    // Initializers
    init(){}
    
    public var properties: [FuseProperty] {
        return [
            FuseProperty(name: "first", weight: 1.0),
            FuseProperty(name: "last", weight: 1.0),
            FuseProperty(name: "name", weight: 1.0),
            FuseProperty(name: "phoneNumber", weight: 1.0),
            FuseProperty(name: "organization", weight: 1.0),
            FuseProperty(name: "title", weight: 1.0),
            FuseProperty(name: "email", weight: 1.0),
            //FuseProperty(name: "website", weight: 0.3),
            FuseProperty(name: "socialLink", weight: 1.0),
            FuseProperty(name: "note", weight: 1.0),
            FuseProperty(name: "tag", weight: 1.0)
            //FuseProperty(name: "address", weight: 0.5)
        ]
    }
    
    // Exporting the object
    func toAnyObject() -> NSDictionary {
        return [
            "name" : name,
            "titles": titles,
            "emails" : emails,
            "phone_numbers" : phoneNumbers,
            "social_links" : socialLinks,
            "notes" : notes,
            "tags" : tags,
            "websites" : websites,
            "addresses" : addresses,
            "organizations" : organizations,
            "origin" : origin,
            "image_id": imageId,
            "isVerified" : isVerified,
            "badges" : badges,
            "badge_list" : badgeDictionaryList
        ]
    }

    // Init with JSON Snapshot
    init(snapshot: NSDictionary) {
       
        name = snapshot["name"] as? String ?? "No name"
        titles = snapshot["titles"] as? [[String : String]] ?? [[String : String]]()
        emails = snapshot["emails"] as? [[String : String]] ?? [[String : String]]()
        phoneNumbers = snapshot["phone_numbers"] as? [[String : String]] ?? [[String : String]]()
        socialLinks = snapshot["social_links"] as? [[String : String]] ?? [[String : String]]()
            
        //let lastName = fullNameArr.count > 1 ? fullNameArr[1] : firstName
        
        
        tags = snapshot["tags"] as? [[String : String]] ?? [[String : String]]()
        notes = snapshot["notes"] as? [[String : String]] ?? [[String : String]]()
        websites = snapshot["websites"] as? [[String : String]] ?? [[String : String]]()
        organizations = snapshot["organizations"] as? [[String : String]] ?? [[String : String]]()
        addresses = snapshot["addresses"] as? [[String : String]] ?? [[String : String]]()
        imageId = snapshot["image_ids"] as? String ?? ""
        origin = snapshot["origin"] as? String ?? ""
        isVerified = snapshot["isVerified"] as? String ?? "0"
        
        badges = snapshot["badges"] as? [String] ?? [String]()
        badgeList = snapshot["badgeList"] as? [Bagde] ?? [Bagde]()
        
        badgeDictionaryList = snapshot["badge_list"] as? [NSDictionary] ?? [NSDictionary]()
        
        //images = snapshot["images"] as! [[String : Any]]
        
        //parseContactRecord()
        
        
        // Testing to see if populated
        
    }
    
    init(arraySnapshot: NSDictionary) {
        
        name = arraySnapshot["name"] as? String ?? "No name"
        titleList = arraySnapshot["titles"] as? NSArray ?? NSArray()
        emailList = arraySnapshot["emails"] as? NSArray ?? NSArray()
        phoneNumberList = arraySnapshot["phone_numbers"] as? NSArray ?? NSArray()
        socialLinkList = arraySnapshot["social_links"] as? NSArray ?? NSArray()
        
        //let lastName = fullNameArr.count > 1 ? fullNameArr[1] : firstName
        tagList = arraySnapshot["tags"] as? NSArray ?? NSArray()
        noteList = arraySnapshot["notes"] as? NSArray ?? NSArray()
        websiteList = arraySnapshot["websites"] as? NSArray ?? NSArray()
        organizationList = arraySnapshot["organizations"] as? NSArray ?? NSArray()
        addressList = arraySnapshot["addresses"] as? NSArray ?? NSArray()
        imageId = arraySnapshot["image_ids"] as? String ?? ""
        origin = arraySnapshot["origin"] as? String ?? ""
        isVerified = arraySnapshot["isVerified"] as? String ?? "0"
        
        badges = arraySnapshot["badges"] as? [String] ?? [String]()
        badgeList = arraySnapshot["badgeList"] as? [Bagde] ?? [Bagde]()
        
        badgeDictionaryList = arraySnapshot["badge_list"] as? [NSDictionary] ?? [NSDictionary]()
        
        
        parseContactRecordArrays()
        
    }
    
    init(snapshotLite: NSDictionary) {
        
        name = snapshotLite["name"] as? String ?? ""
        emails = snapshotLite["emails"] as? [[String : String]] ?? [[String : String]]()
        phoneNumbers = snapshotLite["phone_numbers"] as? [[String : String]] ?? [[String : String]]()
        
    }
    
    
    // Getters : Setters
    
    // Ids
    func getContactId()->String{
        return contactId 
    }
    
    // Contact ID gets set on server
    
    func setContactImageId(id : String){
        imageId = id
    }
    
    func getContactImageId()->String{
        return imageId
    }
    
    // Contact ID gets set on server
    
    func setCardId(id : String){
        contactId = id
    }
    
    // Titles array
    func getTitleRecords()->[[String : String]]{
        return titles
    }
    
    func setTitleRecords(title : String){
        titles.append(["title" : title])
    }
    
    // Emails
    func getEmailRecords()->[[String : String]]{
        return emails
    }
    
    func setEmailRecords(emailAddress : String){
        emails.append(["email" : emailAddress])
    }
    
    // Phone Numbers
    func getPhoneRecords()->[[String : String]]{
        return phoneNumbers
    }
    
    func setPhoneRecords(phoneRecord : String){
        phoneNumbers.append(["phone" : phoneRecord])
    }
    
    // Links
    func getSocialLinks()->[[String : String]]{
        return socialLinks
    }
    
    func setSocialLinks(socialLink : String){
        socialLinks.append(["link" : socialLink])
    }
    
    // Notes
    func getNotes()->[[String : String]]{
        return notes
    }
    
    func setNotes(note : String){
        notes.append(["note" : note])
    }

    // Notes
    func getTags()->[[String : String]]{
        return tags
    }
    
    func setTags(tag : String){
        tags.append(["tag" : tag])
    }

    // Websites
    func getWebsites()->[[String : String]]{
        return websites
    }
    func setWebsites(websiteRecord : String){
        websites.append(["website" : websiteRecord])
    }
    
    // Organizations
    func getOrganizations()->[[String : String]]{
        return organizations
    }
    
    func setOrganizations(organization : String){
        organizations.append(["organization" : organization])
    }

    // Addresses
    func getAddresses()->[[String : String]]{
        return addresses
    }
    
    func setAddresses(address : String){
        addresses.append(["address" : address])
    }

    // Origin
    func getOrigin()-> String{
        return origin
    }
    
    func setOrigin(org : String){
        origin = org
    }
    
    // Custom Methods
    
    // Generate random string for transaction id
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    func parseContactRecordArrays(){
        
        // Iterate over lists and parse vals
        
        if titleList.count > 0 {
            
            let dict = titleList[0] as! NSDictionary
            
            let list = dict.value(forKey: "title")
            
            if list is String {
                print("Outhere string", list as! String)
                
                setTitleRecords(title: list as! String)
                
            }else{
                print("Outhere array", list as! NSArray)
                //
                let titlesArray = list as! NSArray
                
                for item in titlesArray {
                    
                    setTitleRecords(title: item as! String)
                }
                
                print("The titles")
                print(titles)
                
            }
            
            
        }
        
        
        if organizationList.count > 0 {
            
            let dict = organizationList[0] as! NSDictionary
            
            let list = dict.value(forKey: "organization")
            
            if list is String {
                print("Outhere string", list as! String)
                // Set org
                setOrganizations(organization: list as! String)
                
            }else{
                print("Outhere array", list as! NSArray)
                //
                let orgsArray = list as! NSArray
                
                for item in orgsArray {
                    
                    setOrganizations(organization: item as! String)
                }
                
                print("The orgs")
                print(organizations)
                
            }

        }
        
        // Check for count
        if phoneNumberList.count > 0 {
            
            let dict = phoneNumberList[0] as! NSDictionary
            
            let list = dict.value(forKey: "phone")
            
            if list is String {
                print("Outhere string", list as! String)
                // Set org
                setPhoneRecords(phoneRecord: list as! String)
                
            }else{
                print("Outhere array", list as! NSArray)
                //
                let phonesArray = list as! NSArray
                
                for item in phonesArray {
                    
                    setPhoneRecords(phoneRecord: item as! String)
                }
                
                print("The phones")
                print(phoneNumbers)
                
            }

            
            
        }
        if emailList.count > 0 {
            
            let dict = emailList[0] as! NSDictionary
            
            let list = dict.value(forKey: "email")
            
            if list is String {
                print("Outhere string", list as! String)
                // Set org
                setEmailRecords(emailAddress: list as! String)
                
            }else{
                print("Outhere array", list as! NSArray)
                //
                let emailsArray = list as! NSArray
                
                for item in emailsArray {
                    
                    setEmailRecords(emailAddress: item as! String)
                }
                
                print("The emails")
                print(emails)
                
            }
        }
        
        if websiteList.count > 0{
            
            let dict = websiteList[0] as! NSDictionary
            
            let list = dict.value(forKey: "website")
            
            if list is String {
                print("Outhere string", list as! String)
                // Set web
                setWebsites(websiteRecord: list as! String)
                
            }else{
                print("Outhere array", list as! NSArray)
                //
                let webArray = list as! NSArray
                
                for item in webArray {
                    // Set web
                    setWebsites(websiteRecord: item as! String)
                }
                
                print("The websites")
                print(websites)
                
            }

            
        }
        if socialLinkList.count > 0{
            
            let dict = socialLinkList[0] as! NSDictionary
            
            let list = dict.value(forKey: "link")
            
            if list is String {
                print("Outhere string", list as! String)
                // Set social
                setSocialLinks(socialLink: list as! String)
                
            }else{
                print("Outhere array", list as! NSArray)
                //
                let linkArray = list as! NSArray
                
                for item in linkArray {
                    // Set web
                    setSocialLinks(socialLink: item as! String)
                }
                
                print("The links")
                print(socialLinks)
                
            }
            
        }
        
        
        if noteList.count > 0 {
            
            let dict = noteList[0] as! NSDictionary
            
            let list = dict.value(forKey: "note")
            
            if list is String {
                print("Outhere string", list as! String)
                // Set social
                setNotes(note: list as! String)
                
            }else{
                print("Outhere array", list as! NSArray)
                //
                let noteArray = list as! NSArray
                
                for item in noteArray {
                    // Set web
                   setNotes(note: item as! String)
                }
                
                print("The links")
                print(notes)
                
            }
            
        }
        
        
        if tagList.count > 0 {
           
            let dict = tagList[0] as! NSDictionary
            
            let list = dict.value(forKey: "tag")
            
            if list is String {
                print("Outhere string", list as! String)
                // Set social
                setTags(tag: list as! String)
                
            }else{
                print("Outhere array", list as! NSArray)
                //
                let tagArray = list as! NSArray
                
                for item in tagArray {
                    // Set web
                    setTags(tag: item as! String)
                }
                
                print("The tags")
                print(tags)
                
            }
        }
        
        if addressList.count > 0 {
            
            let dict = addressList[0] as! NSDictionary
            
            let list = dict.value(forKey: "address")
            
            if list is String {
                print("Outhere string", list as! String)
                // Set social
                setAddresses(address: list as! String)
                
            }else{
                print("Outhere array", list as! NSArray)
                //
                let addArray = list as! NSArray
                
                for item in addArray {
                    // Set web
                    setAddresses(address: item as! String)
                }
                
                print("The addresses")
                print(addresses)
                
            }

            
        }
        
        // Parse for corp badges
        // Parse for corp
        for corp in badgeDictionaryList {
            // Init badge
            let badge = Contact.Bagde(snapshot: corp)
            
            // Add to list
            badgeList.append(badge)
        }

        
        
    }
    
    func parseContactRecord(){
        
        // Init formatter
        let formatter = CNContactFormatter()
        formatter.style = .fullName
        
        // Iterate over list and itialize contact objects
        
        // Init temp contact object
        //let contactObject = Contact()
        
        // Set name
        //contactObject.name = formatter.string(from: contact) ?? "No Name"
        
        
        if titles.count > 0 {
            // Add section
            sections.append("Titles")
    
            title = titles[0]["title"]!
            
           /* for title in titles {
                // Print to test
                print("Title : \(title["title"]!)")
                
                // Append to list
                self.titleList.append(title["title"]!)
                print(titleList.count)
            }
            // Set list for section
            self.tableData["Titles"] = titleList */
        }
        
        if organizations.count > 0 {
            // Add section
            sections.append("Company")
            organization = organizations[0]["organization"]!
            /*for org in organizations {
                // Print to test
                print("Org : \(org["organization"]!)")
                
                // Append to list
                self.organizationList.append(org["organization"]!)
                print(organizationList.count)
            }
            // Set list for section
            self.tableData["Company"] = organizationList*/
        }
        
        // Check for count
        if phoneNumbers.count > 0 {
            // Add section
            sections.append("Phone Numbers")
            
            let digits = phoneNumbers[0]["phone"]!
            // Set phone number
            self.phoneNumber = digits
            
            // Iterate over items
            /*for number in phoneNumbers{
                // print to test
                //print("Number: \((number.value.value(forKey: "digits" )!))")
                
                // Init the number with formatting
                //let digits = self.format(phoneNumber: number["phone"]!)
                let digits = number["phone"]!
                
                self.phoneNumberList.append(digits)
                print(phoneNumberList.count)
            }*/
            // Create section data
            //self.tableData["Phone Numbers"] = phoneNumberList
            
        }
        if emails.count > 0 {
            // Add section
            sections.append("Emails")
            
            email = emails[0]["email"]!
            
            // Iterate over array and pull value
            /*for address in emails {
                // Print to test
                print("Email : \(address["email"])")
                
                // Append to array
                self.emailList.append(address["email"]!)
                print(emailList.count)
            }*/
            // Create section data
            //self.tableData["Emails"] = emailList
        }
        
        if websites.count > 0{
            
            website = websites[0]["website"]!
            
            // Add section
            sections.append("Websites")
            // Iterate over items
            /*for address in websites {
                // Print to test
                print("Website : \(address["website"]!)")
                
                // Append to list
                self.websiteList.append(address["website"]!)
                print(websiteList.count)
            }
            // Create section data
            self.tableData["Websites"] = websiteList*/
            
        }
        if socialLinks.count > 0{
            
            socialLink = socialLinks[0]["link"]!
            
            // Iterate over items
            /*for profile in socialLinks {
                // Print to test
                print("Social Profile : \(profile["link"]!)")
             
                // Append to list
                self.socialLinkList.append(profile["link"]!)
                print(socialLinkList.count)
            }*/
            
        }
        
        
        if notes.count > 0 {
            // Add section
            sections.append("Notes")
            
            note = notes[0]["note"]!
            
           /* for note in notes {
                // Print to test
                print("Note : \(note["note"]!)")
                
                // Append to list
                self.noteList.append(note["note"]!)
                print(noteList.count)
            }
            // Set list for section
            self.tableData["Notes"] = noteList*/
        }
        
        
        if tags.count > 0 {
            // Add section
            sections.append("Tags")
            tag = tags[0]["tag"]!
            
            /*for tag in tags {
                // Print to test
                print("Title : \(tag["tag"]!)")
                
                // Append to list
                self.tagList.append(tag["tag"]!)
                print(tagList.count)
            }
            // Set list for section
            self.tableData["Tags"] = tagList*/
        }
        
        if addresses.count > 0 {
            
            address = addresses[0]["address"]!
            
            // Add section
            sections.append("Addresses")
            /*for add in addresses {
                // Print to test
                print("Address : \(add["address"]!)")
                
                // Append to list
                self.addressList.append(add["address"]!)
                print(addressList.count)
            }
            // Set list for section
            self.tableData["Addresses"] = addressList*/
        }
        
        
        // Test object
        //print("Contact >> \n\(toAnyObject()))")
        
        printParsedContact()
        
       /* // Parse for badges
        self.parseForSocialIcons()
        
        // Parse for crop
        self.parseForCorpBadges()
        
        // Reload table data
        self.profileInfoTableView.reloadData()*/
        
        
    }
    
    
    // Testing
    
    func printContact(){
        print("\n")
        print("Name :")
        print(name)
        print("Titles :")
        print(titles)
        print("Emails : ")
        print(emails)
        print("Phones : ")
        print(phoneNumbers)
        print("Social Links : ")
        print(socialLinks)
        print("Notes : ")
        print(notes)
        print("Tags : ")
        print(tags)
        print("Addresses : ")
        print(addresses)
        print("Websites : ")
        print(websites)
        print("Organizations : ")
        print(organizations)
        print("Image ID: ")
        print(imageId)
        print("Origin :")
        print(origin)
        print("--------------------")
        print("Images : ")
        print(imageDictionary)
        
    }

    func printParsedContact(){
        print("\n")
        print("Name :")
        print(name)
        print("Titles :")
        print(title)
        print("Email : ")
        print(email)
        print("Phone : ")
        print(phoneNumber)
        print("Social Link : ")
        print(socialLink)
        print("Note : ")
        print(note)
        print("Tag : ")
        print(tag)
        print("Address : ")
        print(address)
        print("Website : ")
        print(website)
        print("Organization : ")
        print(organization)
        
        
    }

    
    
}
