//
//  Event.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 15/03/2022.
//

import Foundation

var eventsList = [Event]()

class Event {
    var id: String
    var client: String
    var project: String
    var task: String
    var time: String
    var date: String
    var userId: String
    var is_submitted : Bool

    init(id: String, client: String, project: String, task: String, time: String, date: String, userId: String, is_submitted : Bool) {
        self.id = id
        self.client = client
        self.project = project
        self.task = task
        self.time = time
        self.date = date
        self.userId = userId
        self.is_submitted = is_submitted
    }

    func eventsForDate(date: Date) -> [Event] {
        var daysEvents = [Event]()
        for event in eventsList {
            if Calendar.current.isDate(event.getDate()!, inSameDayAs: date) {
                daysEvents.append(event)
            }
        }
        return daysEvents
    }

    func getDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: date) // replace Date String
    }
}
