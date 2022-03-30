//
//  Event.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 15/03/2022.
//

import Foundation

var eventsList = [Event]()

class Event
{
    var id: Int!
    var name: String!
    var date: Date!
    
    func eventsForDate(date: Date) -> [Event]
    {
        var daysEvents = [Event]()
        for event in eventsList
        {
            if(Calendar.current.isDate(event.date, inSameDayAs:date))
            {
                daysEvents.append(event)
            }
        }
        return daysEvents
    }
}
