//
//  EventManager.swift
//  Unify
//

import Foundation
import EventKit

class EventManager{
    
    
    // Properties
    // ================================
    
    static let sharedManager = EventManager()
    
    
    var calendarDelegate: CalendarAddedDelegate?
    var eventDelegate: EventAddedDelegate?
    var calendars: [EKCalendar]?
    var events: [EKEvent]?
    
    
    // Init 
    init() {}
    
    // Access control
    
    func checkCalendarAuthorizationStatus() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            // This happens on first-run
            requestAccessToCalendar()
        case EKAuthorizationStatus.authorized:
            // Things are in line with being able to show the calendars in the table view
            loadCalendars()
            //refreshTableView()
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            print("Access Denied")
            // We need to help them give us permission
            //needPermissionView.fadeIn()
        }
    }
    
    func requestAccessToCalendar() {
        EKEventStore().requestAccess(to: .event, completion: {
            (accessGranted: Bool, error: Error?) in
            
            if accessGranted == true {
                DispatchQueue.main.async(execute: {
                    self.loadCalendars()
                    //self.refreshTableView()
                })
            } else {
                DispatchQueue.main.async(execute: {
                    //self.needPermissionView.fadeIn()
                })
            }
        })
    }
    
    
    // Fetching event objects
    func loadCalendars() {
        self.calendars = EKEventStore().calendars(for: EKEntityType.event).sorted() { (cal1, cal2) -> Bool in
            return cal1.title < cal2.title
        }
    }
    
    func loadEvents(fromCalendar: EKCalendar) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let startDate = dateFormatter.date(from: "2016-01-01")
        let endDate = dateFormatter.date(from: "2017-12-31")
        
        if let startDate = startDate, let endDate = endDate {
            let eventStore = EKEventStore()
            
            let eventsPredicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: [fromCalendar])
            
            self.events = eventStore.events(matching: eventsPredicate).sorted {
                (e1: EKEvent, e2: EKEvent) in
                
                return e1.startDate.compare(e2.startDate) == ComparisonResult.orderedAscending
            }
        }
    }

    // Creating events
    
    func createNewCaldendar(withName: String) {
        // Create an Event Store instance
        let eventStore = EKEventStore();
        
        // Use Event Store to create a new calendar instance
        // Configure its title
        let newCalendar = EKCalendar(for: .event, eventStore: eventStore)
        
        // Probably want to prevent someone from saving a calendar
        // if they don't type in a name...
        newCalendar.title = "Unify Appointments"//calendarNameTextField.text ?? "Some Calendar Name"
        
        // Access list of available sources from the Event Store
        let sourcesInEventStore = eventStore.sources
        
        // Filter the available sources and select the "Local" source to assign to the new calendar's
        // source property
        newCalendar.source = sourcesInEventStore.filter{
            (source: EKSource) -> Bool in
            source.sourceType.rawValue == EKSourceType.local.rawValue
            }.first!
        
        // Save the calendar using the Event Store instance
        do {
            try eventStore.saveCalendar(newCalendar, commit: true)
            UserDefaults.standard.set(newCalendar.calendarIdentifier, forKey: "UnifyPrimaryCalendar")
            calendarDelegate?.calendarDidAdd()
            //self.dismiss(animated: true, completion: nil)
        
        } catch {
            let alert = UIAlertController(title: "Calendar could not save", message: (error as NSError).localizedDescription, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OKAction)
            
            
            
            //self.present(alert, animated: true, completion: nil)
        }
    }
    
    func createCalendarEvent(withIdentifier: String, eventName: String, start: Date, end: Date) {
        // Create an Event Store instance
        let eventStore = EKEventStore();
        
        // Use Event Store to create a new calendar instance
        if let calendarForEvent = eventStore.calendar(withIdentifier: withIdentifier)
        {
            let newEvent = EKEvent(eventStore: eventStore)
            
            newEvent.calendar = calendarForEvent
            newEvent.title = eventName
            newEvent.startDate = start
            newEvent.endDate = end
            
            // Save the event using the Event Store instance
            do {
                try eventStore.save(newEvent, span: .thisEvent, commit: true)
                eventDelegate?.eventDidAdd()
                
                //self.dismiss(animated: true, completion: nil)
            } catch {
                let alert = UIAlertController(title: "Event could not save", message: (error as NSError).localizedDescription, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(OKAction)
                
                //self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: Calendar Added Delegate
    func calendarDidAdd() {
        self.loadCalendars()
        // Test output
        print("The caldendar added successfully")
    }
    
    
    // MARK: Event Added Delegate
    func eventDidAdd() {
        //self.loadEvents()
        
        // Test output
        print("Event added")
    }
    
    // Testing
    
    func printEvents() {
        // Test events
        for event in self.events!{
            print(event)
        }
    }

    func printCalendars() {
        // Test events
        for cal in self.calendars!{
            print(cal)
        }
    }

    
    
    
    
}
