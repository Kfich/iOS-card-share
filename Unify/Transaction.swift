//
//  Transaction.swift
//  Unify
//
//  Created by Kevin Fich on 6/6/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import Foundation

public class Transaction{
    
    // Properties
    // ---------------------------------
    
    var scope : String = "transaction"
    var transactionId : String = ""
    var date : String = ""
    var type : String = ""


    var location : String = ""
    //var sender : User = User()
    //var recipient : User = User()
    var senderCard : ContactCard = ContactCard()
    var recipientCard : ContactCard = ContactCard()
    
    var recipientList = [[String : String]]()
    
    // Make a dict [string:any] due to timestamps
    var notes : [String : String]?
    
    // Hashtags
    var tags : [String]?
    
    // Retrieve user and cards IDs in order to populate the 
    // objects above
    
    var senderId : String = ""
    var recipientId : String = ""
    var senderCardId : String = ""
    var recipientCardId : String = ""

    
    // Init
    
    init() {
    
        // Set date
        setTransactionDate()
    
    }
    
    
    init(snapshot: NSDictionary) {
        
        transactionId = snapshot["uuid"] as! String
        date = snapshot["date"] as! String
        location = snapshot["location"] as! String
        //notes = snapshot["notes"] as! String
        recipientId = snapshot["recipient_id"] as! String
        senderId = snapshot["sender_id"] as! String
        recipientCardId = snapshot["recipient_card_id"] as! String
        senderCardId = snapshot["sender_card_id"] as! String
        type = snapshot["type"] as! String
        
        
        // Testing to see if populated
        printTransaction()
    }
    
    
    // Exporting the object
    
    func toAnyObject() -> NSDictionary {
        return [
            "uuid": transactionId,
            "date": setTransactionDate(),
            "location": location,
            "sender_id": senderId,
            "sender_card_id": senderCardId,
            "recipient_id": recipientId,
            "recipient_card_id": recipientCardId,
            "type": type,
            "notes": notes ?? ["notes" : ""]
        ]
    }
    
    // Getters:Setters
    // ---------------------------------
    
    // Scope
    // Scope
    func getScope()->String{
        return scope
    }
    
    func setScope(value : String){
        scope = value
    }
    
    
    // UUID
    func getTransactionId()->String{
        return transactionId
    }
    // Method used to generate transID
    func setTransactionId(){
        transactionId = randomString(length: 10) as String
    }
    
    
    // Dates
    func getDate()->String{
        return date
    }
    
    
    // Method to set date when object is first initialized or exported
    func setTransactionDate(){
        let temp = NSDate ()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let strDate = String(dateFormatter.string(from: temp as Date))
        
        date = strDate!
        
    }
    
    func getTransactionLocation()->String{
        return location
    }
    
    func setTransactionLocation(loc : String){
        location = loc
    }
    /*
    func getNotes()->String{
        return notes
    }
    
    func setNotes(note : String){
        notes = note
    }*/
    
    // Recipient & Sender logics
    
    /*
    func getSender()->User{
        return sender
    }
    func setSender(senderObject : User){
        sender = senderObject
    }*/
    
    func getSenderId()->String{
        return senderId
    }
    
    func setSenderId(idString : String){
        senderId = idString
    }
    
    func getSenderCard()->ContactCard{
        return senderCard
    }
    func setSendercard(cardObject : ContactCard){
        senderCard = cardObject
    }
    /*
    func getRecipient()->User{
        return recipient
    }
    func setRecipient(recipientObject : User){
        recipient = recipientObject
    }*/
    
    func getRecipientId()->String{
        return recipientId
    }
    
    func setRecipientId(idString : String){
        recipientId = idString
    }
    
    func getRecipientCard()->ContactCard{
        return recipientCard
    }
    func setRecipientCard(cardObject : ContactCard){
        recipientCard = cardObject
    }
    
    // Phone Numbers
    func getRecipients()->[[String : String]]{
        return recipientList
    }
    
    func setRecipients(contactRecords : [String : String]){
        recipientList.append(contactRecords)
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
    
    func printTransaction(){
        print("\n")
        print("TransId :" + transactionId)
        print("Date :" + date)
        print("Location :" + location)
        print("SenderID :" + transactionId)
        print("RecipientID :" + transactionId)
        print("SenderCardId : " + senderCardId)
        print("RecipientCardId : " + recipientCardId)
        
        // Testing
        print("\n======================================\n\n")
        print("Sender Card :")
        print(senderCard)
        print("\nRecipient Card :")
        print(recipientCard)
        
        print("\nRecipient List :")
        print(recipientList)

    }
    
    
}

