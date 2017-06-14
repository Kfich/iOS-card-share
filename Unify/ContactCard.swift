//
//  ContactCard.swift
//  Unify
//
//  Created by Kevin Fich on 6/6/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import Foundation

import Foundation

public class ContactCard{
    
    // Properties
    // ---------------------------------
    
    var cardId : String = ""
    var type : String = ""
    var cardName : String = ""
    var email : [String : String]?
    var phone : [String : String]?
    var title : String = ""
    var cardHolderName : String = ""
    
    // Init
    
    init() {}
    
    /*
    init(firstName first:String, lastName last:String, email emailAddress:String){
        
        firstName = first
        lastName  = last
        email = emailAddress
        
    }*/
    
    
    init(snapshot: NSDictionary) {
        cardId = snapshot["card_id"] as! String
        type = snapshot["card_type"] as! String
        cardName = snapshot["card_name"] as! String
        email = snapshot["email"] as? Dictionary
        phone = snapshot["phone"] as? Dictionary
        // To get full username
        title = snapshot["card_title"] as! String
        cardHolderName = snapshot["card_holder_name"] as! String
        
        // Testing to see if populated

        // printContactCard()
    }
    
    
    // Exporting the object
    
    func toAnyObject() -> NSDictionary {
        return [
            "card_id": cardId,
            "card_type": type,
            "card_name": cardName,
            "email": email,
            "phone": phone,
            "title": title,
            "card_holder_name": cardHolderName
        ]
    }
    
    // Getters:Setters
    // ---------------------------------
    
    func getCardId()->String{
        return cardId
    }
    
    func setCardId(id : String){
        cardId = randomString(length: 10) as String
    }
    
    func getType()->String{
        return type
    }
    
    func setType(typeString : String){
        type = typeString
    }
    
    // Name associated with card itself, not owner 
    func getCardName()->String{
        return cardName
    }
    
    func setCardName(cName : String){
        cardName = cName
    }
    
    // Card Holder
    func getCardholderName()->String{
        return cardHolderName
    }
    
    func setCardholderName(holderName : String){
        cardHolderName = holderName
    }
    
    func getTitle()->String{
        return title
    }
    
    func setTitle(titleString : String){
        title = titleString
    }
    
    // Dictionary parsing for email and phone records
    func getEmailRecords()->[String : String]{
        return email!
    }
    
    func setEmailRecords(emailRecords : [String : String]){
        email = emailRecords
    }
    
    func getPhoneRecords()->[String : String]{
        return phone!
    }
    
    func setPhoneRecords(phoneRecords : [String : String]){
        phone = phoneRecords
    }
    
    
    // Custom Methods
    // ---------------------------------
    
    
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
    
    func printUser(){
        print("\n")
        print("CardId :" + cardId)
        print("Card Name :" + cardName)
        print("CardHolder Name :" + cardHolderName)
        print("Card Type :" + type)
        print("Title : " + title)
        print("\n\n=====================\n :")
        print("")
        print(email)
        print("")
        print(phone)
    }

}

