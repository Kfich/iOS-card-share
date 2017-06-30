//
//  ContactCard.swift
//  Unify
//
//  Created by Kevin Fich on 6/6/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import Foundation

public class ContactCard{
    
    // Properties
    // ---------------------------------
    
    var cardId : String?
    var cardName : String?
    var cardHolderName : String?
    var imageURL : Data?
    var image : UIImage?
    var profileDictionary : [String : Any]?
    
    // Card Profile Object containing all associated info
    
    var cardProfile : CardProfile = CardProfile()
    
    
    // Init
    
    init() {}
    
    
    // Init from server 
    init(snapshot: NSDictionary) {
        cardId = snapshot["uuid"] as? String
        cardName = snapshot["card_name"] as? String
        cardHolderName = snapshot["card_holder_name"] as? String
        imageURL = snapshot["image_url"] as? Data
        profileDictionary = snapshot["card_profile"] as? [String : Any]
        
        // Test if card populated
        printCard()
    }
    
    
    // Exporting the object
    
    func toAnyObject() -> NSDictionary {
        return [
            "uuid": cardId ?? "",
            "card_name": cardName ?? "",
            "card_holder_name": cardHolderName ?? "",
            "image_url" : imageURL ?? Data(),
            "card_profile" : profileDictionary ?? ["card_profile" : ""]
            
            
        ]
    }
    
    // Getters:Setters
    // ---------------------------------
    
    // Cards
    func getCardId()->String{
        return cardId ?? ""
    }
    
    // Card ID gets set on server
    
    func setCardId(id : String){
        cardId = randomString(length: 10) as String
    }
    
    // Name associated with card itself, not owner 
    func getCardName()->String{
        return cardName ?? ""
    }
    
    func setCardName(cName : String){
        cardName = cName
    }
    
    // Card Holder
    func getCardholderName()->String{
        return cardHolderName ?? ""
    }
    
    func setCardholderName(holderName : String){
        cardHolderName = holderName
    }
    
    // Profile
    func getCardProfile()->[String : Any]{
        return profileDictionary ?? [String : Any]()
    }
    
    func setCardProfile(profileRecord : [String : String]){
        profileDictionary = profileRecord
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
    
    func printCard(){
        print("\n")
        print("CardId :" + cardId!)
        print("Card Name :" + cardName!)
        print("CardHolder Name :" + cardHolderName!)
        print("")
        print("Card Profile :")
        print(profileDictionary ?? ["profle" : "nil"])
       
    }

}

