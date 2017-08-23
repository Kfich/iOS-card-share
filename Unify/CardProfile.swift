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
    
    // Badges
    var badges = [String]()
    var badgeList = [Bagde]()
    
    // For user profiles
    var bios = [[String : String]]()
    var titles = [[String : String]]()
    var workInformationList = [[String : String]]()
    
    // Profile images
    var images = [[String : Any]]()
    var imageIds = [[String : Any]]()
    
    // Badge struct
    struct Bagde {
        var pictureUrl: String
        var website: String
        var isHidden: Bool?
        
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
        imageIds = snapshot["image_ids"] as? [[String : String]] ?? [[String : String]]()
        //images = snapshot["images"] as! [[String : Any]]
        badges = snapshot["badges"] as? [String] ?? [String]()
        badgeList = snapshot["badgeList"] as? [Bagde] ?? [Bagde]()
        
        // Testing to see if populated
    
    }
    
    init(withSnapshotLite: NSDictionary) {
        
        let emails1 = withSnapshotLite["emails"] as! NSArray
        print(emails1)
        phoneNumbers = withSnapshotLite["phone_numbers"] as! [[String : String]]
        
        // Testing to see if populated
        
    }

    init(fromDefaultsWithDictionary: NSDictionary) {
        
        bios = fromDefaultsWithDictionary["bios"] as! [[String : String]]
        workInformationList = fromDefaultsWithDictionary["work_info"] as! [[String : String]]
        titles = fromDefaultsWithDictionary["titles"] as! [[String : String]]
        emails = fromDefaultsWithDictionary["emails"] as! [[String : String]]
        phoneNumbers = fromDefaultsWithDictionary["phone_numbers"] as! [[String : String]]
        socialLinks = fromDefaultsWithDictionary["social_links"] as! [[String : String]]
        tags = fromDefaultsWithDictionary["tags"] as! [[String : String]]
        notes = fromDefaultsWithDictionary["notes"] as! [[String : String]]
        websites = fromDefaultsWithDictionary["websites"] as! [[String : String]]
        organizations = fromDefaultsWithDictionary["organizations"] as! [[String : String]]
        //imageIds = fromDefaultsWithDictionary["image_ids"] as! [[String : Any]]
        
        images = fromDefaultsWithDictionary["images"] as! [[String : Any]]
        badges = fromDefaultsWithDictionary["badges"] as? [String] ?? [String]()
        
        
        // Testing to see if populated
        
    }

    
    // Exporting the object
    func toAnyObject() -> NSDictionary {
        
       // var tempBadgeList[]
        
        
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
            "image_ids": imageIds,
            "badges" : badges
        ]
    }

    func toAnyObjectWithImage() -> NSDictionary {
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
            "image_ids": imageIds,
            "images" : images,
            "badges" : badges
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
        print("Badges : ")
        print(badges)
        print("Badge List : ")
        print(badgeList)
        
        
        print("Images : ")
        //print(images as Any)
        
    }
    
    
}
