//
//  Contact.swift
//  Unify
//
//  Created by Kevin Fich on 7/26/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import Foundation

public class Contact{
    // Properties
    var contactId : String = ""
    var name : String = ""
    var first = ""
    var last = ""
    var emails = [[String : String]]()
    var phoneNumbers = [[String : String]]()
    var titles = [[String : String]]()
    var organizations  = [[String : String]]()
    var socialLinks = [[String : String]]()
    var websites = [[String : String]]()
    var notes = [[String : String]]()
    
    // For image storage
    var imageId : String = ""
    var imageDictionary = [String : Any]()
    
    // Initializers
    init(){}
    
    // Exporting the object
    func toAnyObject() -> NSDictionary {
        return [
            "name" : name,
            "titles": titles,
            "emails" : emails,
            "phone_numbers" : phoneNumbers,
            "social_links" : socialLinks,
            "notes" : notes,
            "websites" : websites,
            "organizations" : organizations,
            "image_id": imageId
        ]
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
        print(phoneNumbers as Any)
        print("Social Links : ")
        print(socialLinks as Any)
        print("Notes : ")
        print(notes as Any)
        print("Websites : ")
        print(websites as Any)
        print("Organizations : ")
        print(organizations as Any)
        print("Image ID: ")
        print(imageId)
        print("--------------------")
        print("Images : ")
        print(imageDictionary as Any)
        
    }

    
    
}
