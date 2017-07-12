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
    
    // For user profiles
    var bios = [[String : String]]()
    var titles = [[String : String]]()
    var workInformationList = [[String : String]]()
    
    // Profile images
    var images = [[String : Any]]()
    var imageIds = [[String : Any]]()
    
    // Initializers
    
    init(){}
    
    // Init with JSON Snapshot
    init(snapshot: NSDictionary) {
        
        bio = snapshot["bio"] as? String
        workInfo = snapshot["work_info"] as? String
        title = snapshot["title"] as? String
        emails = snapshot["emails"] as! [[String : String]]
        phoneNumbers = snapshot["phone_numbers"] as! [[String : String]]
        socialLinks = snapshot["social_links"] as! [[String : String]]
        tags = snapshot["tags"] as! [[String : String]]
        notes = snapshot["notes"] as! [[String : String]]
        websites = snapshot["websites"] as! [[String : String]]
        organizations = snapshot["organizations"] as! [[String : String]]
        imageIds = snapshot["image_ids"] as! [[String : Any]]
        //images = snapshot["images"] as! [[String : Any]]
        
        
        // Testing to see if populated
    
    }

    init(fromDefaultsWithDictionary: NSDictionary) {
        
        bio = fromDefaultsWithDictionary["bio"] as? String
        workInfo = fromDefaultsWithDictionary["work_info"] as? String
        title = fromDefaultsWithDictionary["title"] as? String
        emails = fromDefaultsWithDictionary["emails"] as! [[String : String]]
        phoneNumbers = fromDefaultsWithDictionary["phone_numbers"] as! [[String : String]]
        socialLinks = fromDefaultsWithDictionary["social_links"] as! [[String : String]]
        tags = fromDefaultsWithDictionary["tags"] as! [[String : String]]
        notes = fromDefaultsWithDictionary["notes"] as! [[String : String]]
        websites = fromDefaultsWithDictionary["websites"] as! [[String : String]]
        organizations = fromDefaultsWithDictionary["organizations"] as! [[String : String]]
        //imageIds = fromDefaultsWithDictionary["image_ids"] as! [[String : Any]]
        images = fromDefaultsWithDictionary["images"] as! [[String : Any]]
        // Testing to see if populated
        
    }

    
    // Exporting the object
    func toAnyObject() -> NSDictionary {
        return [
            "bio": bio ?? "",
            "work_info": workInfo ?? "",
            "title": title ?? "",
            "emails" : emails,
            "phone_numbers" : phoneNumbers,
            "social_links" : socialLinks,
            "tags" : tags,
            "notes" : notes,
            "websites" : websites,
            "organizations" : organizations,
            "image_ids": imageIds
            //"images" : images
        ]
    }

    func toAnyObjectWithImage() -> NSDictionary {
        return [
            "bio": bio ?? "",
            "work_info": workInfo ?? "",
            "title": title ?? "",
            "emails" : emails,
            "phone_numbers" : phoneNumbers,
            "social_links" : socialLinks,
            "tags" : tags,
            "notes" : notes,
            "websites" : websites,
            "organizations" : organizations,
            "image_ids": imageIds,
            "images" : images
        ]
    }

    
    // Bio
    func getBio()->String{
        return bio ?? ""
    }
    
    func setBio(bioString : String){
        bio = bioString
    }
    
    // Title
    func getTitle()->String{
        return title ?? ""
    }
    func setTitle(titleString : String){
        title = titleString
    }
    
    // Work info
    func setWorkInfo(titleString : String){
        title = titleString
    }
    
    func getWorkInfo()->String{
        return workInfo ?? ""
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
        print(bio ?? "")
        print("Work Info :")
        print(workInfo ?? "")
        print("Title :")
        print(title ?? "")
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
        
        print("Images : ")
        //print(images as Any)
        
    }
    
    
}
