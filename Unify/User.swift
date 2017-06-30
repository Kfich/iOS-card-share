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
    
    var userId : String = ""
    var firstName : String = ""
    var lastName : String = ""
    var fullName : String = ""
    var emails : [[String : String]]?
    var phoneNumbers : [[String : String]]?
    
    // Cards suite
    var cards = [ContactCard]()
    
    // Init
    
    init() {}
    
    init(firstName first:String, lastName last:String, email emailAddress:[[String : String]]){
        
        firstName = first
        lastName  = last
        emails = emailAddress
        
    }
    
    init(snapshot: NSDictionary) {
        
        userId = snapshot["uuid"] as! String
        firstName = snapshot["first_name"] as? String ?? ""
        lastName = snapshot["last_name"] as? String ?? ""
        emails = snapshot["emails"] as? [[String : String]]
        phoneNumbers = snapshot["mobile_numbers"] as? [[String : String]]
        
        
        // To get full username
        fullName = getName()
        // Testing to see if populated
        printUser()
    }
    
    
    // Custom Methods
    // ---------------------------------
    
    func toAnyObject() -> NSDictionary {
        return [
            "first_name": firstName,
            "last_name": lastName,
            "email": emails ?? [["" : ""]],
            "uuid": userId,
            "mobile_numbers" : phoneNumbers ?? [["number" : ""]],
            "email" : emails ?? [["email":""]]
            
        ]
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
    // Testing
    
    func printUser(){
        print("\n")
        print("UserId :" + userId)
        print("Name :" + fullName)
        print("Email :" )
        print(emails ?? [["email" : ""]])
        print("Mobile Number : ")
        print(phoneNumbers ?? ["number" : ""])
        
        
    }
    
    
}

