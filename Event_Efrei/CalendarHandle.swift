//
//  CalendarHandle.swift
//  Event_Efrei
//
//  Created by CGalbon on 06/01/2023.
//


import EventKit
import EventKitUI

import Combine
import Foundation


class CalendarHandle {
    
    var store = EKEventStore.init()
    @Published var events: [EKEvent] = []
    var granted: Bool = false
    
    init() {
  
    }
    
    func requestAccessToCalendar() {
        if self.granted==true{return}
        self.store.requestAccess(to: .event) { (granted, error) in
          if let error = error {
            print("Error accessing the calendar: \(error)")
          } else if granted {
            print("Access granted")
              self.granted=true
          } else {
            print("Access denied")
              self.granted=false
          }
        }
    }
    
    private func checkEventExists(store: EKEventStore, event eventToCheck: EKEvent) -> Bool {
        let predicate = store.predicateForEvents(withStart: eventToCheck.startDate, end: eventToCheck.endDate, calendars: nil)
        let existingEvents = self.store.events(matching: predicate)

        let exists = existingEvents.contains { (event) -> Bool in
            return eventToCheck.title == event.title && event.startDate == eventToCheck.startDate && event.endDate == eventToCheck.endDate
        }
        return exists
    }

    func addEventToCalendar(startDate: Date?, endDate: Date?, title:String?, location: String?, speakers: [SpeakerRecord]?, activity_type: String?) -> String {
        let event = EKEvent(eventStore: self.store)
        event.title = title
        event.startDate = startDate
        event.location = location
        event.endDate = endDate
        event.calendar = self.store.defaultCalendarForNewEvents
        var descriptionString: String = ""
        if let local_authors = speakers
        {
            if(local_authors.count > 0)
            {
                descriptionString = "This \(activity_type!) will be animated by the following speakers : \n"
                for author in local_authors
                {
                    descriptionString += "\(author.fields.name)\n"
                }
            }
            else{
                descriptionString = "Come enjoy this \(activity_type!) at this year's event !\n This activity is a meeting place so do not hesitate to interact with your fellow attendants ! \n"
            }
        }
        else
        {
            descriptionString = "Come enjoy this \(activity_type!) at this year's event !\n This activity is a meeting place so do not hesitate to interact with your fellow attendants ! \n"
        }
        descriptionString += "This event is part of the Corporate Meeting Convention. Ensure you have your tickets ready at https://corporatemeeting.com."
        event.notes = descriptionString
        event.addAlarm(EKAlarm(relativeOffset: TimeInterval(-15 * 60))) // permet d'avoir une notification 15 minutes avant l'évènement
        if(checkEventExists(store: self.store, event: event)){return "Event is already in your schedule !"}
        if(self.granted == false){self.requestAccessToCalendar()}
        do
        {
            try self.store.save(event, span: .thisEvent)
            print("Event saved.")
        }
        catch{
            print("Error while saving: \(error)")
            return "\(error)"
        }
        return "OK"
    }
}
