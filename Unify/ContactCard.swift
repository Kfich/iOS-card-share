//
//  ContactCard.swift
//  Unify
//
//  Created by Kevin Fich on 6/6/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import Foundation

public class ContactCard: NSObject, NSCoding{

    
    // Properties
    // ---------------------------------
    
    var cardId : String?
    var cardName : String?
    var cardHolderName : String?
    var imageURL : Data?
    var image : UIImage?
    var profileDictionary = NSDictionary()
    
    // Card Profile Object containing all associated info
    
    var cardProfile : CardProfile = CardProfile()
    
    
    // Init
    
    override init() {
        cardId = "1234567890"
        cardHolderName = "Kevin Fich"
        cardName = "Card 1"
    
        
    }
    
    init(card_id: String, holder_name: String, card_name: String, card_image: UIImage/*, card_profile: CardProfile*/) {
        cardId = card_id
        cardHolderName = holder_name
        cardName = card_name
        //image = card_image
       // cardProfile = card_profile
    }
    
    
    // Init from server 
    init(snapshot: NSDictionary) {
        cardId = snapshot["uuid"] as? String
        cardName = snapshot["card_name"] as? String
        cardHolderName = snapshot["card_holder_name"] as? String
        imageURL = snapshot["image_url"] as? Data
        profileDictionary = (snapshot["card_profile"] as? NSDictionary)!
        // Create card profile
        cardProfile = CardProfile(snapshot: profileDictionary)
        
        // Test if card populated
        //printCard()
    }
    
    // MARK: NSCoding
   
    required convenience public init?(coder decoder: NSCoder) {
        guard let cardId = decoder.decodeObject(forKey: "card_id") as? String,
            let cardHolderName = decoder.decodeObject(forKey: "card_holder_name") as? String,
            let cardName = decoder.decodeObject(forKey: "card_name") as? String,
            let image = decoder.decodeObject(forKey: "card_image") as? UIImage
            //let card_profile = decoder.decodeObject(forKey: "card_profile") as? CardProfile
            else { return nil }
        
        self.init(
            card_id: cardId,
            holder_name: cardHolderName,
            card_name: cardName,
            card_image: image
            /*, card_profile: card_profile*/)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.cardId, forKey: "card_id")
        aCoder.encode(self.cardName, forKey: "card_name")
        aCoder.encode((self.cardHolderName), forKey: "card_holder_name")
        aCoder.encode(self.image, forKey: "card_image")
        ///aCoder.encode(self.cardProfile, forKey: "card_profile")

    }
    
    /*func encodeWithCoder(coder: NSCoder) {
        coder.encode(self.cardId, forKey: "card_id")
        coder.encode(self.cardName, forKey: "card_name")
        coder.encode((self.cardHolderName), forKey: "card_holder_name")
        coder.encode(self.image, forKey: "card_image")
        coder.encode(self.cardProfile, forKey: "card_profile")
    }*/
 
    
    // Exporting the object
    
    func toAnyObject() -> NSDictionary {
        return [
            "uuid": cardId ?? "",
            "card_name": cardName ?? "",
            "card_holder_name": cardHolderName ?? "",
            "image_url" : imageURL ?? Data(),
            "card_profile" : cardProfile.toAnyObject()
            
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
    func getCardProfile()->NSDictionary{
        return profileDictionary 
    }
    
    func setCardProfile(profileRecord : NSDictionary){
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
        
        cardProfile.printProfle()
       
    }

}

