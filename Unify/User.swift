//
//  User.swift
//  Unify
//
//  Created by Kevin Fich on 6/6/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import Foundation

public class User{
    
    // Properties
    // ---------------------------------
    
    var scope : String = "user"
    var userId : String = ""
    var firstName : String = ""
    var lastName : String = ""
    var fullName : String = ""
    var emails = [[String : String]]()
    var phoneNumbers = [[String : String]]()
    
    // Main profile image
    
    // **************************** Add these to inits ****************************
    var profileImages = [[String : Any]]()
    var profileImageData : Data = Data()
    var profileImageId = String()
    
    // Cards suite
    var cards = [ContactCard]()
    
    // Card Profiles
    var userProfile = CardProfile()
    
    
    // Init
    
    init() {}
    
    init(firstName first:String, lastName last:String, email emailAddress:[[String : String]]){
        
        firstName = first
        lastName  = last
        emails = emailAddress
        
    }
    
    init(snapshot: NSDictionary) {
        
        userId = snapshot.object(forKey: "uuid") as? String ?? ""
        firstName = snapshot["first_name"] as? String ?? ""
        lastName = snapshot["last_name"] as? String ?? ""
        emails = snapshot["email"] as? [[String : String]] ?? [["":""]]
        phoneNumbers = snapshot["mobile_numbers"] as? [[String : String]] ?? [["":""]]
        scope = snapshot["scope"] as? String ?? ""
        //profileImages = (snapshot["profile_image"] as? [[String : Any]])!
        
        profileImageId = snapshot["profile_image_id"] as? String ?? ""
        
        // To get full username
        fullName = getName()
        // Testing to see if populated
        printUser()
    }
    
    init(withDefaultsSnapshot: NSDictionary) {
        
        userId = withDefaultsSnapshot.object(forKey: "uuid") as? String ?? ""
        firstName = withDefaultsSnapshot["first_name"] as? String ?? ""
        lastName = withDefaultsSnapshot["last_name"] as? String ?? ""
        emails = withDefaultsSnapshot["email"] as? [[String : String]] ?? [["":""]]
        phoneNumbers = withDefaultsSnapshot["mobile_numbers"] as? [[String : String]] ?? [["":""]]
        scope = withDefaultsSnapshot["scope"] as? String ?? ""
        profileImages = (withDefaultsSnapshot["profile_image"] as? [[String : Any]])!
        
        //profileImageId = withDefaultsSnapshot["profile_image_id"] as? String ?? ""
        
        // To get full username
        fullName = getName()
        // Testing to see if populated
        printUser()
        
        if userId != "" {
            Countly.sharedInstance().setNewDeviceID(userId, onServer:true)
        }
        
        
    }
    
    // Custom Methods
    // ---------------------------------
    
    func toAnyObject() -> NSDictionary {
        return [
            "first_name": firstName,
            "last_name": lastName,
            "email": emails,
            "uuid": userId,
            "mobile_numbers" : phoneNumbers,
            "email" : emails,
            "scope" : scope,
            "profile_image_id": profileImageId
            
        ]
    }
    
    
    func toAnyObjectWithImage() -> NSDictionary {
        return [
            "first_name": firstName,
            "last_name": lastName,
            "email": emails,
            "uuid": userId,
            "mobile_numbers" : phoneNumbers,
            "email" : emails,
            "scope" : scope,
            "profile_image": profileImages
            
        ]
    }
    
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
    

    // Scope
    func getScope()->String{
        return scope
    }
    
    func setScope(value : String){
        
        scope = value
    }
    
    // Names
    func getName()->String{
        return firstName + " " + lastName
    }
    
    func setName(first : String, last: String){
        
        firstName = first
        lastName = last
    }
    
    // UUIDs
    func getUserId()->String{
        return userId
    }
    // String for setting ID generated on API server
    func setUserId(newId : String){
        
        userId = newId
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
    
    // Images
    func getImages()->[[String : Any]]{
        return profileImages
    }
    
    func setImages(imageRecords : [String : Any]){
        profileImages.append(imageRecords)
    }
    
    
    // Testing
    
    func printUser(){
        print("")
        print("Scope :" + scope)
        print("\n")
        print("UserId :" + userId)
        print("Name :" + getName())
        print("Email :" )
        print(emails)
        print("Mobile Number : ")
        print(phoneNumbers)
        // Test image data
        print("Image Data -->")
        print(profileImages)
        
        
    }
    
    
}

