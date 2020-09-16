//
//  Appointment.swift
//  Unify
//


import Foundation

class Appointment{
    
    // Properties 
    var name : String = ""
    var appointmentId : String = ""
    var senderId : String = ""
    var senderName : String = ""
    var senderCardId : String = ""
    var startDate : Date = Date()
    var endDate : Date = Date()
    var createdAt : String = ""
    // String version of date
    var start : String = ""
    var end : String = ""
    var notes : String = ""
    
    // Debating these 
    var recipientName : String = ""
    var recipientId : String = ""
    var recipientPhone : String = ""
    var recipientEmail : String = ""
    
    // Initializers
    init() {}
    
    // Init with JSON Snapshot
    init(snapshot: NSDictionary) {
        
        name = snapshot["name"] as! String
        appointmentId = snapshot["appointmentId"] as! String
        senderId = snapshot["senderId"] as! String
        senderName = snapshot["sender_name"] as! String
        senderCardId = snapshot["sender_card_id"] as! String
        start = snapshot["start_date"] as! String
        end = snapshot["end_date"] as! String
        createdAt = snapshot["createdAt"] as! String
        notes = snapshot["notes"] as! String
        recipientEmail = snapshot["recipient_email"] as! String
        recipientPhone = snapshot["recipient_phone"] as! String
        recipientId = snapshot["recipientId"] as! String
        recipientName = snapshot["recipient_name"] as! String
        
        // Testing to see if populated
        
    }
    
    
    // Exporting the object
    func toAnyObject() -> NSDictionary {
        return [
            "name" : name,
            "appointmentId" : appointmentId,
            "senderId": senderId,
            "sender_name" : senderName,
            "sender_card_id" : senderCardId,
            "createdAt" : createdAt,
            "start_date" : start,
            "end_date" : end,
            "recipient_name" : recipientName,
            "recipientId" : recipientId,
            "notes" : notes,
            "recipient_phone": recipientPhone,
            "recipient_email": recipientEmail
        ]
    }
    
    // Custom methods 
    func randomStringWithLength (_ len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for _ in 0 ..< 10 {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        //  print(randomString)
        return randomString
    }
    
    // Testing
    func printAppointment() {
        // Export to dictionary
        let export = self.toAnyObject()
        // Print
        print("\n\nAppointment Object\n")
        print("Dictionary >> \n\(export)")
    }
    
    
}

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        return dateFormatter.string(from: self)
    }
}
