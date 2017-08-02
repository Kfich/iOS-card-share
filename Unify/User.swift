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
    //var emails = [[String : String]]()
    //var phoneNumbers = [[String : String]]()
    
    var incognitoData = IncognitoData()
    
    // Bools to check user state
    var userPhoneVerified: Bool = false
    var userPhoneForVerification: String = ""
    var userIsIncognito = false
    
    // For radar 
    var distance = Double()
    var direction = Double()
    
    // Main profile image
    
    // **************************** Add these to inits ****************************
    var profileImages = [[String : Any]]()
    var profileImageData : Data = Data()
    var profileImageId = String()
    
    // Cards suite
    var cards = [ContactCard]()
    
    // Card Profiles
    var userProfile = CardProfile()
    
    
    // Struct to carry incognito data
    struct IncognitoData {
        // Properties
        // --------------------
        var name: String
        var image: UIImage

        // Init
        // --------------------
        init() {
            self.name = ""
            self.image = UIImage()
        }
        
        init(name: String, image: UIImage) {
            self.name = name
            self.image = image
        }
    }
    
    // Init
    
    init() {}
    
    init(firstName first:String, lastName last:String/*, email emailAddress:[[String : String]]*/){
        
        firstName = first
        lastName  = last
        //emails = emailAddress
        
    }
    
    init(snapshot: NSDictionary) {
        
        userId = snapshot.object(forKey: "unify_uuid") as? String ?? ""
        firstName = snapshot["first_name"] as? String ?? ""
        lastName = snapshot["last_name"] as? String ?? ""
        
        // Removed and added to user profile
        //emails = snapshot["email"] as? [[String : String]] ?? [["":""]]
        //phoneNumbers = snapshot["mobile_numbers"] as? [[String : String]] ?? [["":""]]
        
        scope = snapshot["scope"] as? String ?? ""
        //profileImages = (snapshot["profile_image"] as? [[String : Any]])!
        
        profileImageId = snapshot["profile_image_id"] as? String ?? ""
        
        userPhoneForVerification = snapshot.object(forKey: "userPhoneVerified") as? String ?? ""
        userPhoneVerified = snapshot.object(forKey: "userPhoneVerified") as? Bool ?? false
        
        // Create card profile
        userProfile = CardProfile(snapshot: snapshot["profile"] as! NSDictionary) 
        
        
        // To get full username
        fullName = getName()
        // Testing to see if populated
        //printUser()
    }
    
    init(snapshotWithLiteProfile: NSDictionary) {
        
        userId = snapshotWithLiteProfile.object(forKey: "unify_uuid") as? String ?? ""
        firstName = snapshotWithLiteProfile["first_name"] as? String ?? ""
        lastName = snapshotWithLiteProfile["last_name"] as? String ?? ""
        
        // Removed and added to user profile
        //emails = snapshot["email"] as? [[String : String]] ?? [["":""]]
        //phoneNumbers = snapshot["mobile_numbers"] as? [[String : String]] ?? [["":""]]
        
        scope = snapshotWithLiteProfile["scope"] as? String ?? ""
        //profileImages = (snapshot["profile_image"] as? [[String : Any]])!
        
        profileImageId = snapshotWithLiteProfile["profile_image_id"] as? String ?? ""
        
        userPhoneForVerification = snapshotWithLiteProfile.object(forKey: "userPhoneVerified") as? String ?? ""
        userPhoneVerified = snapshotWithLiteProfile.object(forKey: "userPhoneVerified") as? Bool ?? false
        
        // Create card profile
        userProfile = CardProfile(withSnapshotLite: snapshotWithLiteProfile["profile"] as! NSDictionary)
        
        
        // To get full username
        fullName = getName()
        // Testing to see if populated
        //printUser()
    }
    
    init(withRadarSnapshot: NSDictionary) {
        
        userId = withRadarSnapshot.object(forKey: "unify_uuid") as? String ?? ""
        firstName = withRadarSnapshot["first_name"] as? String ?? ""
        lastName = withRadarSnapshot["last_name"] as? String ?? ""
        
        // Removed and added to user profile
        //emails = withRadarSnapshot["email"] as? [[String : String]] ?? [["":""]]
        //phoneNumbers = withRadarSnapshot["mobile_numbers"] as? [[String : String]] ?? [["":""]]
        
        scope = withRadarSnapshot["scope"] as? String ?? ""
        //profileImages = (snapshot["profile_image"] as? [[String : Any]])!
        
        profileImageId = withRadarSnapshot["profile_image_id"] as? String ?? ""
        
        // Keys for distance plotting 
        distance = withRadarSnapshot["distance"] as? Double ?? 0.0
        direction = withRadarSnapshot["direction"] as? Double ?? 0.0
        
        userPhoneForVerification = withRadarSnapshot.object(forKey: "userPhoneVerified") as? String ?? ""
        userPhoneVerified = withRadarSnapshot.object(forKey: "userPhoneVerified") as? Bool ?? false
        
        // To get full username
        fullName = getName()
        // Testing to see if populated
        //printUser()
    }
    
    
    init(withDefaultsSnapshot: NSDictionary) {
        
        userId = withDefaultsSnapshot.object(forKey: "unify_uuid") as? String ?? ""
        firstName = withDefaultsSnapshot["first_name"] as? String ?? ""
        lastName = withDefaultsSnapshot["last_name"] as? String ?? ""
        
        // Removed and added to user profile
        //emails = withDefaultsSnapshot["email"] as? [[String : String]] ?? [["":""]]
        //phoneNumbers = withDefaultsSnapshot["mobile_numbers"] as? [[String : String]] ?? [["":""]]
        
        scope = withDefaultsSnapshot["scope"] as? String ?? ""
        profileImages = (withDefaultsSnapshot["profile_image"] as? [[String : Any]])!
        
        //profileImageId = withDefaultsSnapshot["profile_image_id"] as? String ?? ""
        
        userPhoneForVerification = withDefaultsSnapshot.object(forKey: "userPhoneVerified") as? String ?? ""
        userPhoneVerified = withDefaultsSnapshot.object(forKey: "userPhoneVerified") as? Bool ?? false
        
        // Create card profile
        userProfile = CardProfile(snapshot: withDefaultsSnapshot["profile"] as! NSDictionary)
        
        // To get full username
        fullName = getName()
        // Testing to see if populated
        //printUser()
        
        if userId != ""
        {
            Countly.sharedInstance().setNewDeviceID(userId, onServer:true)
        }
        if firstName != "" && lastName != ""
        {
            Countly.user().name = (firstName+" "+lastName) as CountlyUserDetailsNullableString

        }
       
        
        
    }
    
    // Custom Methods
    // ---------------------------------
    
    func toAnyObject() -> NSDictionary {
        return [
            "first_name": firstName,
            "last_name": lastName,
            //"email": emails,
            "unify_uuid": userId,
            //"mobile_numbers" : phoneNumbers,
            //"email" : emails,
            "scope" : scope,
            "profile_image_id": profileImageId,
            "userPhoneVerified": userPhoneVerified,
            "userPhoneForVerification": userPhoneForVerification,
            "profile" : userProfile.toAnyObject()
            
        ]
    }
    
    
    func toAnyObjectWithImage() -> NSDictionary {
        return [
            "first_name": firstName,
            "last_name": lastName,
            //"email": emails,
            "unify_uuid": userId,
            //"mobile_numbers" : phoneNumbers,
            //"email" : emails,
            "scope" : scope,
            "profile_image": profileImages,
            "userPhoneVerified": userPhoneVerified,
            "userPhoneForVerification": userPhoneForVerification,
            "profile" : userProfile.toAnyObject()
      
            
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
    
    //Verification
    func getVerificationPhone()->String{
        return userPhoneForVerification
    }
    
    func getVerificationStatus()->Bool{
        return userPhoneVerified
    }
    
    func setVerificationPhone(phone : String)
    {
        userPhoneForVerification = phone
    }
   
    func setVerificationPhoneStatus(status : Bool)
    {
        userPhoneVerified = status
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
        return userProfile.getEmailRecords()
    }
    
    func setEmailRecords(emailRecords : [String : String]){
        userProfile.setEmailRecords(emailRecords: emailRecords)
    }
    
    // Phone Numbers
    func getPhoneRecords()->[[String : String]]{
        return userProfile.getPhoneRecords()
    }
    
    func setPhoneRecords(phoneRecords : [String : String]){
        userProfile.setPhoneRecords(phoneRecords: phoneRecords)
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
        //print("Email :" )
        //print(emails)
        //print("Mobile Number : ")
        //print(phoneNumbers)
        // Test image data
        print("Image Data -->")
        print(profileImages)
        
        print("Verification Data -->")
        print("userPhoneVerified", userPhoneVerified )
        print("userPhoneForVerification", userPhoneForVerification )
        
        print("")
        userProfile.printProfle()
        
    }
    
    func printIncognito() {
        print("")
        print("Incognito Name: \(incognitoData.name)")
        print("Incognito Image: \(incognitoData.image)")
    }
    
    
}

