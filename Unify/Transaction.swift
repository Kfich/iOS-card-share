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
    var senderName : String = ""
    
    // Lat and Long for location
    var latitude = Double()
    var longitude = Double()
    var location : String = ""
    
    //var sender : User = User()
    //var recipient : User = User()
    var senderCard : ContactCard = ContactCard()
    var recipientCard : ContactCard? //= ContactCard()
    
    var recipientList = [String]()
    
    // Make a dict [string:any] due to timestamps
    var notes : [[String : String]]?
    
    // Hashtags
    var tags : [String]?
    
    // Retrieve user and cards IDs in order to populate the 
    // objects above
    
    var senderId : String = ""
    var recipientId : String = ""
    var senderCardId : String = ""
    var recipientCardId : String = ""

    var contactDictionary = NSDictionary()
    
    // Approval
    var approved = false
    var rejected = false
    
    
    // Init
    
    init() {
    
        // Set date
        setTransactionDate()
    
    }
    
    
    init(snapshot: NSDictionary) {
        
        transactionId = snapshot["unify_uuid"] as! String
        date = snapshot["date"] as! String
        location = snapshot["location"] as! String
        //notes = snapshot["notes"] as! String
        senderId = snapshot["sender_id"] as! String
        senderCardId = snapshot["sender_card_id"] as! String
        type = snapshot["type"] as! String
        // Set recipient list
        recipientList = snapshot["recipient_list"] as! [String]
        //latitude = snapshot["latitude"] as! String
        //longitude = snapshot["latitude"] as! String
        
        contactDictionary = (snapshot["recipientCard"] as? NSDictionary)!
        print("THE CONTACT DICT .. >> \(contactDictionary)")
        
        recipientCard = ContactCard.init(withSnapshotLite: contactDictionary)
        
        print(recipientCard?.cardHolderName ?? "No name")
        
        let approval = snapshot["approved"] as! String ?? "0"
        let reject = snapshot["rejected"] as! String ?? "0"
        
        if approval == "0"{
            approved = false
        }else{
            approved = true
        }
        
        if reject == "0"{
            rejected = false
        }else{
            rejected = true
        }
        
        senderName = snapshot["sender_name"] as! String
        
        // Testing to see if populated
        printTransaction()
    }
    
    
    // Exporting the object
    
    func toAnyObject() -> NSDictionary {
        return [
            "unify_uuid": transactionId,
            "sender_name" : senderName,
            "date": date,
            "location": location,
            "sender_id": senderId,
            "sender_card_id": senderCardId,
            "type": type,
            "latitude" : latitude,
            "longitude" : longitude,
            "recipient_list": recipientList,
            "rejected" : rejected,
            "approved" : approved
            
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
    
    // Sender Name
    func getSenderName()->String{
        return senderName
    }
    func setSenderName(value : String){
        senderName = value
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
        return recipientCard!
    }
    func setRecipientCard(cardObject : ContactCard){
        recipientCard = cardObject
    }
    
    // Phone Numbers
    func getRecipients()->[String]{
        return recipientList
    }
    
    func setRecipients(contactRecords : String){
        //recipientList.append(contactRecords)
    }

    // Approval
    func getApprovalStatus() -> Bool{
        return approved
    }
    
    func setApprovalStatus(status : Bool){
        approved = status
    }
    
    // Rejection
    func getRejectionStatus() -> Bool{
        return rejected
    }
    
    func setRejectionStatus(status : Bool){
        rejected = status
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
        print("Sender Name :" + senderName)
        print("TransId :" + transactionId)
        print("Type : " + type)
        print("Date :" + date)
        print("Location :" + location)
        print("SenderID :" + senderId)
        print("SenderCardId : " + senderCardId)
        print("Lat :  \(latitude)")
        print("Long :  + \(longitude)")
        print("\nRecipient List :")
        print("\nRecipient Card :")
        recipientCard?.printCard()
        
        print(recipientList)

        print("\nApproval Status :")
        print(approved)

        
        // Testing
        print("\n======================================\n\n")
        //print("Sender Card :")
        //print(senderCard)


    }
    
    
}

