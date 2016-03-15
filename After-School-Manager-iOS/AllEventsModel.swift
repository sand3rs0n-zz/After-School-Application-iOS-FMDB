//
//  AllEventsModel.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 3/12/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import Foundation

class AllEventsModel {
    private var eventList = [Event]()
    private var forwardedEvent = Event()

    init() {

    }

    private func getEvents() {
        let querySQL = "SELECT * FROM EVENTS ORDER BY year, month, day, name ASC"
        let results = database.search(querySQL)
        while (results.next()) {
            let cur = Event()
            cur.setEventID(Int(results.intForColumn("eventID")))
            cur.setEventType(Int(results.intForColumn("eventType")))
            cur.setName(results.stringForColumn("name"))
            cur.setDescription(results.stringForColumn("description"))
            cur.setDay(Int(results.intForColumn("day")))
            cur.setMonth(Int(results.intForColumn("month")))
            cur.setYear(Int(results.intForColumn("year")))
            cur.setRosterID(Int(results.intForColumn("rosterID")))
            eventList.append(cur)
        }
        results.close()
    }

    func resetEvents() {
        eventList.removeAll()
        getEvents()
    }

    func getForwardedEvent() -> Event {
        return forwardedEvent
    }
    func setForwardedEvent(forwardedEvent: Event) {
        self.forwardedEvent = forwardedEvent
    }
    func getEventListsCount() -> Int {
        return eventList.count
    }
    func getEvent(i: Int) -> Event {
        return eventList[i]
    }
}