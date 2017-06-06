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
    
    var password : String = ""
    var userId : String = ""
    var firstName : String = ""
    var lastName : String = ""
    var fullName : String = ""
    var email : String = ""
    var mobileNumber : String = ""
    
    // Cards suite
    var cards = [ContactCard]()
    
    // Init
    
    init() {}
    
    init(firstName first:String, lastName last:String, email emailAddress:String){
        
        firstName = first
        lastName  = last
        email = emailAddress
        
    }
    
    init(snapshot: NSDictionary) {
        userId = snapshot["uuid"] as! String
        firstName = snapshot["first_name"] as! String
        lastName = snapshot["last_name"] as! String
        email = snapshot["email"] as! String
        mobileNumber = snapshot["mobile_number"] as! String
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
            "email": email,
            "uuid": userId
        ]
    }
    
    func getName()->String{
        return firstName + " " + lastName
    }
    
    func setName(first : String, last: String){
        
        firstName = first
        lastName = last
    }
    
    func getEmail()->String{
        return email
    }
    
    func setEmail(personEmail : String){
        
        email = personEmail
        
    }
    
    func getUserId()->String{
        return userId
    }
    
    func setUserId(newId : String){
        
        userId = newId
    }
    
    func getMobileNumber()->String{
        return mobileNumber
    }
    
    func setMobileNumber(newNumber : String){
        
        mobileNumber = newNumber
    }
    
    
    func setPassword(pass : String){
        
        password = pass
    }
    
    // Testing
    
    func printUser(){
        print("\n")
        print("UserId :" + userId)
        print("Name :" + fullName)
        print("Email :" + email)
        print("Password : " + password)
        print("Mobile Number : " + mobileNumber)
        
        
    }
    
    
}

