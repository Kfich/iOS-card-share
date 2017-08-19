//
//  AddEventViewController.swift
//  Unify
//
//  Created by Kevin Fich on 8/15/17.
//  Copyright © 2017 Kevin Fich. All rights reserved.
//

import UIKit
import EventKit
import MessageUI

class AddEventViewController: UIViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    // Properties
    // ---------------------------

    var calendar: EKCalendar!
    var delegate: EventAddedDelegate?
    var appointment = Appointment()
    var selectedContact = Contact()
    
    //var selectedContact = CNContact()
    let formatter = CNContactFormatter()
    var contact = Contact()
    var cardLink = "https://project-unify-node-server.herokuapp.com/card/render/"
    
    // var selectedCard = ContactCard()
    
    // This contact card is really a transaction object
    var card = ContactCard()
    var transaction = Transaction()
    var currentUser = User()
    
    var selectedUserPhone = ""
    var selectedUserEmail = ""


    // IBOutlets
    // ---------------------------
    
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventStartDatePicker: UIDatePicker!
    @IBOutlet weak var eventEndDatePicker: UIDatePicker!
    
    
    
    // Page Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.eventStartDatePicker.setDate(initialDatePickerValue(), animated: false)
        self.eventEndDatePicker.setDate(initialDatePickerValue(), animated: false)
        
        // Create calen
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addEventButtonTapped(_ sender: UIBarButtonItem) {
        // Create an Event Store instance
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let start = dateFormatter.string(from: self.eventStartDatePicker.date)
        let end = dateFormatter.string(from: self.eventEndDatePicker.date)

        
        let appointment = ["data" : ["event_name" : self.eventNameTextField.text ?? "Some Event Name", "username": ContactManager.sharedManager.currentUser.getName(), "start": start, "end": end]]
        
        // Upload
        self.uploadEvent(params: appointment as NSDictionary)
        
        /*let eventStore = EKEventStore();
        
        // Use Event Store to create a new calendar instance
        if let calendarForEvent = eventStore.calendar(withIdentifier: self.calendar.calendarIdentifier)
        {
            // Init new event
            let newEvent = EKEvent(eventStore: eventStore)
            
            // Configure new event
            newEvent.calendar = calendarForEvent
            newEvent.title = self.eventNameTextField.text ?? "Some Event Name"
            newEvent.startDate = self.eventStartDatePicker.date
            newEvent.endDate = self.eventEndDatePicker.date
            
            // Save the event using the Event Store instance
            do {
                // Store the event
                try eventStore.save(newEvent, span: .thisEvent, commit: true)
                // Delegate Callback func
                delegate?.eventDidAdd()
                
            } catch {
                
                // Init error alert
                let alert = UIAlertController(title: "Event could not save", message: (error as NSError).localizedDescription, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(OKAction)
                
                // Show error
                self.present(alert, animated: true, completion: nil)
            }
        }*/
     }
    
    func uploadEvent(params: NSDictionary){
        
        print("hello World")
        
        // Send to server
        Connection(configuration: nil).uploadEventCall(params as! [AnyHashable : Any]){ response, error in
            if error == nil {
                // Call successful
                print("Transaction Created Response ---> \(String(describing: response))")
                
                // Show success
                KVNProgress.showSuccess(withStatus: "Appointment sent!")
                
                //Dimiss vc
                self.dismiss(animated: true , completion: nil)
                
            } else {
                // Error occured
                print("Transaction Created Error Response ---> \(String(describing: error))")
                KVNProgress.showError(withStatus: "There was a problem sending your invite. Please try again.")
                // Show user popup of error message
                
                
            }
            // Hide indicator
        }
        
        // Check if we're at the end of the list
        
    }
    
    // MARK: Event Added Delegate
    func eventDidAdd() {
        //self.loadEvents()
        
        // Test output
        print("Event added")
        
        // Upload appointment
        self.createAppointment()
    }
    
    // Custom Methods
    
    func createAppointment() {
        // Configure appointment
        appointment.name = self.eventNameTextField.text ?? "Unify Appointment"
        appointment.start = self.eventStartDatePicker.date.toString()
        appointment.end = self.eventEndDatePicker.date.toString()
        appointment.notes = "Invitation to follow up"
        appointment.createdAt = Date().toString()
        appointment.senderName = ContactManager.sharedManager.currentUser.getName()
        appointment.recipientName = self.selectedContact.name
        appointment.recipientPhone = self.selectedContact.phoneNumbers[0]["phone"] ?? ""
        appointment.recipientEmail = self.selectedContact.emails[0]["email"] ?? ""
        
        
        // Show progress hud
        KVNProgress.show(withStatus: "Sending your invite...")
        
        // Save card to DB
        let parameters = ["data": self.appointment.toAnyObject()]
        print(parameters)
        
        // Send to server
        
        Connection(configuration: nil).uploadEventCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Appointment Created Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                let dictionary : Dictionary = response as! [String : Any]
                // Test print
                print("Returned Dictionary >> \(dictionary)")
                
                // Show success
                KVNProgress.showSuccess(withStatus: "Invite sent!")
                
                // Dismiss VC
                self.dismiss(animated: true, completion: nil)
                
            } else {
                print("Transaction Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error with your connection. Please try again.")
                
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
    }
    
    func initialDatePickerValue() -> Date {
        let calendarUnitFlags: NSCalendar.Unit = [.year, .month, .day, .hour, .minute, .second]
        
        var dateComponents = (Calendar.current as NSCalendar).components(calendarUnitFlags, from: Date())
        
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        
        return Calendar.current.date(from: dateComponents)!
    }
    
    func createTransaction(type: String) {
        
        // Set type & Transaction data
        transaction.type = type
        transaction.setTransactionDate()
        transaction.senderName = ContactManager.sharedManager.currentUser.getName()
        transaction.senderId = ContactManager.sharedManager.currentUser.userId
        transaction.type = "connection"
        transaction.scope = "transaction"
        transaction.senderCardId = ContactManager.sharedManager.selectedCard.cardId!
        
        // Show progress hud
        KVNProgress.show(withStatus: "Making the connection...")
        
        // Save card to DB
        let parameters = ["data": self.transaction.toAnyObject()]
        print(parameters)
        
        // Send to server
        
        Connection(configuration: nil).createTransactionCall(parameters as! [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Card Created Response ---> \(response)")
                
                // Set card uuid with response from network
                /*let dictionary : Dictionary = response as! [String : Any]
                 self.transaction.transactionId = (dictionary["uuid"] as? String)!*/
                
                // Hide HUD
                KVNProgress.showSuccess()
                
            } else {
                print("Card Created Error Response ---> \(error)")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error with your connection request. Please try again.")
                
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
    }

    
    // Message Composer Functions
    
    func showEmailCard() {
        
        print("EMAIL CARD SELECTED")
        
        // Send post notif
        // Create instance of controller
        let mailComposeViewController = configuredMailComposeViewController()
        
        // Check if deviceCanSendMail
        if MFMailComposeViewController.canSendMail() {
            
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }
    
    func showSMSCard() {
        // Set Selected Card
        
        //selectedCardIndex = cardCollectionView.inde
        
        
        print("SMS CARD SELECTED")
        // Send post notif
        
        let composeVC = MFMessageComposeViewController()
        if(MFMessageComposeViewController .canSendText()){
            
            composeVC.messageComposeDelegate = self
            
            // 6468251231
            
            // Check for nil vals
            
            var name = ""
            var recipientName = ""
            var phone = ""
            var email = ""
            //var title = ""
            
            
            // CNContact Objects
            let contact = ContactManager.sharedManager.contactToIntro
            let recipient = ContactManager.sharedManager.recipientToIntro
            
            // Check if they both have email
            name = formatter.string(from: contact) ?? "No Name"
            recipientName = formatter.string(from: recipient) ?? ""
            
            /* if contact.phoneNumbers.count > 0 && recipient.phoneNumbers.count > 0 {
             
             let contactPhone = (contact.phoneNumbers[0].value).value(forKey: "digits") as? String
             // Set contact phone number
             phone = contactPhone!
             
             let recipientPhone = (recipient.phoneNumbers[0].value).value(forKey: "digits") as? String
             
             // Launch text client
             composeVC.recipients = [contactPhone!, recipientPhone!]
             }
             
             if contact.emailAddresses.count > 0 {
             email = (contact.emailAddresses[0].value as String)
             }*/
            
            
            // Set card link from cardID
            cardLink = "https://project-unify-node-server.herokuapp.com/card/render/\(card.cardId!)"
            
            // Test String
            let str = "Hi, I'd like to connect with you. Here's my information \n\n\(String(describing: currentUser.getName()))\n\n\nBest, \n\(currentUser.getName()) \n\n \(cardLink)"
            
            // Set string as message body
            composeVC.body = str
            // Set recipient phone
            composeVC.recipients = [selectedUserPhone]
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }
        
    }
    
    
    // Email Composer Delegate Methods
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
        // Create Instance of controller
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        // Check for nil vals
        
        var name = ""
        var emailContact = ""
        //var title = ""
        
        
        // CNContact Objects
        let contact = self.selectedContact
        
        // Check if they both have email
        name = formatter.string(from: contact) ?? "No Name"
        
        if contact.emailAddresses.count > 0{
            // Set email string
            let contactEmail = contact.emailAddresses[0].value as String
            
            // Set variable
            emailContact = contactEmail
        }
        
        // Create Message
        
        //let str = "Hi, I'd like to connect with you. Here's my information \n\n\(String(describing: card.cardHolderName))\n\(String(describing: card.cardProfile.emails[0]["email"]))\n\(String(describing: card.cardProfile.title))\n\nBest, \n\(currentUser.getName()) \n\n"
        
        // Set card link from cardID
        cardLink = "https://project-unify-node-server.herokuapp.com/card/render/\(card.cardId!)"
        
        // Test String
        let str = "Hi, I'd like to connect with you. Here's my information \n\n\(String(describing: currentUser.getName()))\n\n\nBest, \n\(currentUser.getName()) \n\n\(cardLink)"
        
        // Create Message
        mailComposerVC.setToRecipients([emailContact])
        mailComposerVC.setSubject("Unify Connection - I'd like to connect with you")
        mailComposerVC.setMessageBody(str, isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    
    // MARK: MFMailComposeViewControllerDelegate Method
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if result == .cancelled {
            // User cancelled
            print("User cancelled")
            
        }else if result == .sent{
            // User sent
            self.createTransaction(type: "connection")
            // Dimiss vc
            self.dismiss(animated: true, completion: nil)
            
        }else{
            // There was an error
            KVNProgress.showError(withStatus: "There was an error sending your message. Please try again.")
            
        }
        
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    // Message Composer Delegate
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        if result == .cancelled {
            // User cancelled
            print("Cancelled")
            
        }else if result == .sent{
            // User sent
            // Create transaction
            self.createTransaction(type: "connection")
            // Dismiss VC
            self.dismiss(animated: true, completion: nil)
            
        }else{
            // There was an error
            KVNProgress.showError(withStatus: "There was an error sending your message. Please try again.")
            
        }
        
        
        // Make checks here for
        controller.dismiss(animated: true) {
            print("Message composer dismissed")
        }
    }

}
