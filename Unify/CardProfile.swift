 //
//  CardProfile.swift
//  Unify
//
//  Created by Kevin Fich on 6/29/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import Foundation

public class CardProfile{
    
    // Properties
    // --------------------------------
    var bio : String?
    var workInfo : String?
    var title : String?
    // Array of dictionaries
    var emails = [[String : String]]()
    var phoneNumbers = [[String : String]]()
    var socialLinks = [[String : String]]()
    var tags = [[String : String]]()
    var notes = [[String : String]]()
    var websites = [[String : String]]()
    var organizations = [[String : String]]()
    var addresses = [[String : String]]()
    var imageId = ""
    // Badges
    var badges = [String]()
    var badgeList = [Bagde]()
    var badgeDictionaryList = [NSDictionary]()
    
    
    var emailList = NSArray()
    var phoneNumberList = NSArray()
    var titleList = NSArray()
    var organizationList  = NSArray()
    var socialLinkList = NSArray()
    var websiteList = NSArray()
    var noteList = NSArray()
    var tagList = NSArray()
    var addressList = NSArray()
    var bioList = NSArray()
    
    
    
    // For user profiles
    var bios = [[String : String]]()
    var titles = [[String : String]]()
    var workInformationList = [[String : String]]()
    
    // Profile images
    var images = [[String : Any]]()
    var imageIds = [[String : Any]]()
    
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
    
    // For viewing mixed badges on carosel
    var corpImageList = [NSDictionary]()
    var socialImageList = [UIImage]()
    
    // Initializers
    
    init(){}
    
    // Init with JSON Snapshot
    init(snapshot: NSDictionary) {
        print("Hello")
        
        bios = snapshot["bios"] as? [[String : String]] ?? [[String : String]]()
        workInformationList = snapshot["work_info"] as? [[String : String]] ?? [[String : String]]()
        titles = snapshot["titles"] as? [[String : String]] ?? [[String : String]]()
        emails = snapshot["emails"] as? [[String : String]] ?? [[String : String]]()
        phoneNumbers = snapshot["phone_numbers"] as? [[String : String]] ?? [[String : String]]()
        socialLinks = snapshot["social_links"] as? [[String : String]] ?? [[String : String]]()
        tags = snapshot["tags"] as? [[String : String]] ?? [[String : String]]()
        notes = snapshot["notes"] as? [[String : String]] ?? [[String : String]]()
        websites = snapshot["websites"] as? [[String : String]] ?? [[String : String]]()
        organizations = snapshot["organizations"] as? [[String : String]] ?? [[String : String]]()
        addresses = snapshot["addresses"] as? [[String : String]] ?? [[String : String]]()
        imageIds = snapshot["image_ids"] as? [[String : String]] ?? [[String : String]]()
        //images = snapshot["images"] as! [[String : Any]]
        badges = snapshot["badges"] as? [String] ?? [String]()
        badgeList = snapshot["badgeList"] as? [Bagde] ?? [Bagde]()
        
        badgeDictionaryList = snapshot["badge_list"] as? [NSDictionary] ?? [NSDictionary]()
        
        // Testing to see if populated
    
    }
    
    init(withSnapshotLite: NSDictionary) {
        
        emails = withSnapshotLite["emails"] as? [[String : String]] ?? [[String : String]]()
        //print(emails1)
        phoneNumbers = withSnapshotLite["phone_numbers"] as? [[String : String]] ?? [[String : String]]()
        imageId = withSnapshotLite["profile_image_id"] as? String ?? ""
        
        print("Image Id for the shits >> ", imageId)
        
        // Testing to see if populated
        
    }

    init(fromDefaultsWithDictionary: NSDictionary) {
        
        bios = fromDefaultsWithDictionary["bios"] as? [[String : String]] ?? [[String : String]]()
        workInformationList = fromDefaultsWithDictionary["work_info"] as? [[String : String]] ?? [[String : String]]()
        titles = fromDefaultsWithDictionary["titles"] as? [[String : String]] ?? [[String : String]]()
        emails = fromDefaultsWithDictionary["emails"] as? [[String : String]] ?? [[String : String]]()
        phoneNumbers = fromDefaultsWithDictionary["phone_numbers"] as? [[String : String]] ?? [[String : String]]()
        socialLinks = fromDefaultsWithDictionary["social_links"] as? [[String : String]] ?? [[String : String]]()
        tags = fromDefaultsWithDictionary["tags"] as? [[String : String]] ?? [[String : String]]()
        notes = fromDefaultsWithDictionary["notes"] as? [[String : String]] ?? [[String : String]]()
        websites = fromDefaultsWithDictionary["websites"] as? [[String : String]] ?? [[String : String]]()
        organizations = fromDefaultsWithDictionary["organizations"] as? [[String : String]] ?? [[String : String]]()
        addresses = fromDefaultsWithDictionary["addresses"] as? [[String : String]] ?? [[String : String]]()
        
        imageIds = fromDefaultsWithDictionary["image_ids"] as! [[String : Any]]
        
        images = fromDefaultsWithDictionary["images"] as? [[String : String]] ?? [[String : String]]()
        
        badges = fromDefaultsWithDictionary["badges"] as? [String] ?? [String]()
        badgeDictionaryList = fromDefaultsWithDictionary["badge_list"] as? [NSDictionary] ?? [NSDictionary]()
        
        
        // Testing to see if populated
        
    }
    
    init(arraySnapshot: NSDictionary) {
        
        bioList = arraySnapshot["bios"] as? NSArray ?? NSArray()
        titleList = arraySnapshot["titles"] as? NSArray ?? NSArray()
        emailList = arraySnapshot["emails"] as? NSArray ?? NSArray()
        phoneNumberList = arraySnapshot["phone_numbers"] as? NSArray ?? NSArray()
        socialLinkList = arraySnapshot["social_links"] as? NSArray ?? NSArray()
        tagList = arraySnapshot["tags"] as? NSArray ?? NSArray()
        noteList = arraySnapshot["notes"] as? NSArray ?? NSArray()
        websiteList = arraySnapshot["websites"] as? NSArray ?? NSArray()
        organizationList = arraySnapshot["organizations"] as? NSArray ?? NSArray()
        addressList = arraySnapshot["addresses"] as? NSArray ?? NSArray()
        imageId = arraySnapshot["image_id"] as? String ?? ""
        badges = arraySnapshot["badges"] as? [String] ?? [String]()
        badgeList = arraySnapshot["badgeList"] as? [Bagde] ?? [Bagde]()
        imageIds = arraySnapshot["image_ids"] as? [[String : Any]] ?? [[String : Any]]()
        
        badgeDictionaryList = arraySnapshot["badge_list"] as? [NSDictionary] ?? [NSDictionary]()
        
        
        // Flex the arrays
        parseProfileArrays()
        
    }


    
    // Exporting the object
    func toAnyObject() -> NSDictionary {
        
       /*
       // var tempBadgeList[]
        for badge in badgeList {
            // Create dictionary
            let dict = badge.toAnyObject()
            // Append to dict
            badgeDictionaryList.append(dict)
            // Test
            print(badgeDictionaryList)
        }*/
        
        
        return [
            "bios": bios,
            "work_info": workInformationList,
            "titles": titles,
            "emails" : emails,
            "phone_numbers" : phoneNumbers,
            "social_links" : socialLinks,
            "tags" : tags,
            "notes" : notes,
            "websites" : websites,
            "organizations" : organizations,
            "addresses" : addresses,
            "image_ids": imageIds,
            "badges" : badges,
            "badge_list" : badgeDictionaryList
        ]
    }

    func toAnyObjectWithImage() -> NSDictionary {
        
        /*
        // Iterate through list
        for badge in badgeList {
            // Create dictionary
            let dict = badge.toAnyObject()
            // Append to dict
            badgeDictionaryList.append(dict)
            // Test
            print(badgeDictionaryList)
        }*/

        
        return [
            "bios": bios,
            "work_info": workInformationList,
            "titles": titles,
            "emails" : emails,
            "phone_numbers" : phoneNumbers,
            "social_links" : socialLinks,
            "tags" : tags,
            "notes" : notes,
            "websites" : websites,
            "organizations" : organizations,
            "addresses" : addresses,
            "image_ids": imageIds,
            "images" : images,
            "badges" : badges,
            "badge_list" : badgeDictionaryList
        ]
    }

    
    // Bio
    func getBios()->[[String : String]]{
        return bios
    }
    
    func setBio(bioString : String){
        bios.append(["bio" : bioString])
    }
    
    // Title
    func getTitle()->[[String : String]]{
        return titles
    }
    func setTitle(titleString : String){
        titles.append(["title" : titleString])
    }
    
    // Work info
    func setWorkInfo(workString : String){
        workInformationList.append(["work" : workString])
    }
    
    func getWorkInfo()->[[String : String]]{
        return workInformationList
    }
   
    // Bios array
    func getBioRecords()->[[String : String]]{
        return bios
    }
    
    func setBioRecords(emailRecords : [String : String]){
        bios.append(emailRecords)
    }

    // Titles array
    func getTitleRecords()->[[String : String]]{
        return titles
    }
    
    func setTitleRecords(emailRecords : [String : String]){
        titles.append(emailRecords)
    }
    
    // Bios array
    func getWorkRecords()->[[String : String]]{
        return workInformationList
    }
    
    func setWorkRecords(emailRecords : [String : String]){
        workInformationList.append(emailRecords)
    }
    
    // Emails
    func getEmailRecords()->[[String : String]]{
        return emails
    }
    
    func setEmailRecords(emailRecords : [String : String]){
        emails.append(emailRecords)
    }
    
    // Phone Numbers
    func getPhoneRecords()->[[String : String]]{
        return phoneNumbers
    }
    
    func setPhoneRecords(phoneRecords : [String : String]){
        phoneNumbers.append(phoneRecords)
    }
    
    // Links
    func getSocialLinks()->[[String : String]]{
        return socialLinks
    }
    
    func setSocialLinks(socialRecords : [String : String]){
        socialLinks.append(socialRecords)
    }
    
    // Tags
    func getTags()->[[String : String]]{
        return tags
    }
    
    func setTags(tagRecords : [String : String]){
        tags.append(tagRecords)
    }

    // Notes
    func getNotes()->[[String : String]]{
        return notes
    }
    
    func setNotes(noteRecords : [String : String]){
        notes.append(noteRecords)
    }
    
    // Websites
    func getWebsites()->[[String : String]]{
        return websites
    }
    func setWebsites(websiteRecords : [String : String]){
        websites.append(websiteRecords)
    }
    
    // Organizations
    func getOrganizations()->[[String : String]]{
        return organizations
    }
    
    func setOrganizations(organizationRecords : [String : String]){
        organizations.append(organizationRecords)
    }
    
    // Addresses
    func getAddresses()->[[String : String]]{
        return addresses
    }
    
    func setAddresses(addressRecords : [String : String]){
        addresses.append(addressRecords)
    }
    
    // Images
    func getImages()->[[String : Any]]{
        return images
    }
    
    func setImages(imageRecords : [String : Any]){
        images.append(imageRecords)
    }
    
    // Image ids
    func getImageIds()->[[String : Any]]{
        return imageIds
    }
    
    func setImageIds(imageRecords : [String : Any]){
        imageIds.append(imageRecords)
    }
    
    
    
    // ==================
    
    
    func setTitleRecords(title : String){
        titles.append(["title" : title])
    }
    
    // Emails
    func getEmails()->[[String : String]]{
        return emails
    }
    
    func setEmails(emailAddress : String){
        emails.append(["email" : emailAddress])
    }
    
    func setPhoneRecords(phoneRecord : String){
        phoneNumbers.append(["phone" : phoneRecord])
    }
    
    
    func setSocialLinks(socialLink : String){
        socialLinks.append(["link" : socialLink])
    }
    
    
    func setNotes(note : String){
        notes.append(["note" : note])
    }
    
    func setTags(tag : String){
        tags.append(["tag" : tag])
    }
    

    func setWebsites(websiteRecord : String){
        websites.append(["website" : websiteRecord])
    }
    
    
    func setOrganizations(organization : String){
        organizations.append(["organization" : organization])
    }
    
    
    func setAddresses(address : String){
        addresses.append(["address" : address])
    }
    
    
    // ==================
    
     
    func parseProfileArrays(){
        
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
            
            print("Phone numbers list raw On Profile>", dict)
            
            if dict.count > 0{
                //print("The phone list raw >")
                // Loop through and grab keys
                for number in dict {
                    
                    // Check if value is a string
                    if number.value is String {
                    
                        let stringDict = [number.key as? String ?? "": number.value as? String ?? ""]
                        print("Phone numbers list parsed >", stringDict)
                        
                        // Add dict values to list
                        phoneNumbers.append(stringDict)
                        
                    }else{
                        // If not string then its an array
                        let list = number.value as? NSArray ?? NSArray()
                        
                        print("The phone list after check > Not a string: ", list)
                        
                        // Iterate over list
                        for item in list{
                            // Init phone record
                            let phoneRecord = [number.key as? String ?? "phone" : item as? String ?? ""]
                            
                            // Store to array
                            phoneNumbers.append(phoneRecord)
                        }
                        
                    }
                    // Test
                    print("Phone list after additions", phoneNumbers)
                    
                }
            }
            
                /*
            else{
                
                let list = dict.value(forKey: dict.allKeys.first as! String)
                
                if list is String {
                    print("Outhere phone string", list as! String)
                    // Set org
                    setPhoneRecords(phoneRecord: list as! String)
                    
                }
                
            }*/
            
            // Test output
            print("The phones")
            print(phoneNumbers)
            
        }
        
        
        if emailList.count > 0 {
            
            let dict = emailList[0] as! NSDictionary
            
            let list = dict.value(forKey: "email")
            
            if list is String {
                print("Outhere string", list as! String)
                // Set email
                setEmails(emailAddress: list as! String)
                
            }else{
                // Init array
                let emailsArray = list as? NSArray ?? NSArray()
                
                print("Outhere emails array", emailsArray)
                
                
                // Fetch each item
                for item in emailsArray {
                    
                    if item is String {
                        // Loop and collect
                        print("Email item > \(item)")
                        setEmails(emailAddress: item as! String)
                    }else{
                        
                        let value = item as! NSDictionary
                        
                        let record = ["email": value["email"] as! String, "type" : value["type"] as! String]
                        print("Email record", record)
                        emails.append(record)
                        
                    }
                    
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
            
            print("Address list count greater then 0")
            
            for item in addressList {
                
                let value = item as! NSDictionary
                
                print("Address list dict raw > \(value)")
                
                // Init all values for the cells
                let street = value["street"] ?? ""
                let city = value["city"] ?? ""
                let state = value["state"] ?? ""
                let zip = value["zip"] ?? ""
                let country = value["country"] ?? ""
                
                // Init address
                let addy = "\(street), \(city) \(state), \(zip), \(country)"
                
                
                // Set web
                //setAddresses(address: item as! [NSDictionary])
                
                print("The new address \n\([value["type"] as? String ?? "home" : addy])")
                addresses.append([value["type"] as? String ?? "home" : addy])
            }
            
            print("The addresses")
            print(addresses)
            
            
        }
        
        // Parse for corp badges
        // Parse for corp
        for corp in badgeDictionaryList {
            // Init badge
            let badge = CardProfile.Bagde(snapshot: corp)
            
            // Add to list
            badgeList.append(badge)
        }
        
        
        
    }
    
    func downloadUserImage(idString: String) -> UIImageView {

        
        // Init imageview
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 90, height: 90)
        
        // Set image for contact
        let url = URL(string: "\(ImageURLS.sharedManager.getFromDevelopmentURL)\(idString ).jpg")!
        let placeholderImage = UIImage(named: "profile")!
        
        
        
        // Set image
        imageView.setImageWith(url, placeholderImage: placeholderImage)
        
        return imageView
    }
    
    
    // Testing
    
    func printProfle(){
        print("\n")
        print("Bio :")
        print(bios)
        print("Work Info :")
        print(workInformationList)
        print("Title :")
        print(titles)
        print("Emails : ")
        print(emails)
        print("Phones : ")
        print(phoneNumbers as Any)
        print("Social Links : ")
        print(socialLinks as Any)
        print("Tags : ")
        print(tags as Any)
        print("Notes : ")
        print(notes as Any)
        print("Websites : ")
        print(websites as Any)
        print("Organizations : ")
        print(organizations as Any)
        print("Addresses : ")
        print(addresses as Any)
        print("Badges : ")
        print(badges)
        print("Badge List : ")
        print(badgeList)
        
        print("Images : ")
        //print(images as Any)
        
    }
    
    
}
