//
//  AddEventViewController.swift
//  Unify
//
//  Created by Kevin Fich on 8/15/17.
//  Copyright © 2017 Kevin Fich. All rights reserved.
//

import UIKit
import EventKit

class AddEventViewController: UIViewController {
    // Properties
    // ---------------------------

    var calendar: EKCalendar!
    var delegate: EventAddedDelegate?
    var appointment = Appointment()
    var selectedContact = Contact()

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
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addEventButtonTapped(_ sender: UIBarButtonItem) {
        // Create an Event Store instance
        let eventStore = EKEventStore();
        
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
        }
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
}
