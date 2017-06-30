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
    var emails : [[String : String]]?
    var phoneNumbers : [[String : String]]?
    var socialLinks : [[String : String]]?
    var tags : [[String : String]]?
    var notes : [[String : String]]?
    var websites : [[String : String]]?
    var organizations : [[String : String]]?

    
    // Initializers
    
    init(){}
    
    init(snapshot: NSDictionary) {
        
        bio = snapshot["bio"] as? String
        workInfo = snapshot["work_info"] as? String
        title = snapshot["title"] as? String
        emails = snapshot["emails"] as? [[String : String]]
        phoneNumbers = snapshot["phone_numbers"] as? [[String : String]]
        socialLinks = snapshot["social_links"] as? [[String : String]]
        tags = snapshot["tags"] as? [[String : String]]
        notes = snapshot["notes"] as? [[String : String]]
        websites = snapshot["websites"] as? [[String : String]]
        organizations = snapshot["organizations"] as? [[String : String]]
        
        
        // Testing to see if populated
    
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
    
    // Emails
    func getEmailRecords()->[[String : String]]{
        return emails!
    }
    
    func setEmailRecords(emailRecords : [[String : String]]){
        emails = emailRecords
    }
    
    // Phone Numbers
    func getPhoneRecords()->[[String : String]]{
        return phoneNumbers!
    }
    
    func setPhoneRecords(phoneRecords : [[String : String]]){
        phoneNumbers = phoneRecords
    }
    
    // Links
    func getSocialLinks()->[[String : String]]{
        return socialLinks ?? [["link" : ""]]
    }
    
    func setSocialLinks(socialRecords : [[String : String]]){
        socialLinks = socialRecords
    }
    
    // Tags
    func getTags()->[[String : String]]{
        return tags!
    }
    
    func setTags(tagRecords : [[String : String]]){
        tags = tagRecords
    }

    // Notes
    func getNotes()->[[String : String]]{
        return notes!
    }
    
    func setNotes(noteRecords : [[String : String]]){
        notes = noteRecords
    }
    
    // Websites
    func getWebsites()->[[String : String]]{
        return websites!
    }
    
    func setWebsites(websiteRecords : [[String : String]]){
        websites = websiteRecords
    }
    
    // Organizations
    func getOrganizations()->[[String : String]]{
        return organizations!
    }
    
    func setOrganizations(organizationRecords : [[String : String]]){
        organizations = organizationRecords
    }
    
    
    // Testing
    
    func printProfle(){
        print("\n")
        print("Bio :" + bio!)
        print("Work Info :" + workInfo!)
        print("Title :" + title!)
        print("Emails : ")
        print(emails ?? [["email" : ""]])
        print("Phones : ")
        print(phoneNumbers ?? ["number":""])
        print("Social Links : ")
        print(socialLinks ?? ["link":""])
        print("Tags : ")
        print(tags ?? ["tag":""])
        print("Notes : ")
        print(notes ?? ["note":""])
        print("Websites : ")
        print(websites ?? ["site":""])
        print("Organizations : ")
        print(organizations ?? ["name":""])
        
        
    }
    
    
}
