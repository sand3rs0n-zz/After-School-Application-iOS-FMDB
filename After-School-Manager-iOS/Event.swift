//
//  Event.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 2/5/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import Foundation

class Event {
    private var eventID = 0
    private var name = ""
    private var eventType = 0
    private var description = ""
    private var day = 0
    private var month = 0
    private var year = 0
    private var rosterID = 0

    init() {
    }

    func getEventID() -> Int {
        return eventID
    }
    func getName() -> String {
        return name
    }
    func getEventType() -> Int {
        return eventType
    }
    func getDescription() -> String {
        return description
    }
    func getDay() -> Int {
        return day
    }
    func getMonth() -> Int {
        return month
    }
    func getYear() -> Int {
        return year
    }
    func getRosterID() -> Int {
        return rosterID
    }
    func setEventID(eventID: Int) {
        self.eventID = eventID
    }
    func setName(name: String) {
        self.name = name
    }
    func setEventType(eventType: Int) {
        self.eventType = eventType
    }
    func setDescription(description: String) {
        self.description = description
    }
    func setDay(day: Int) {
        self.day = day
    }
    func setMonth(month: Int) {
        self.month = month
    }
    func setYear(year: Int) {
        self.year = year
    }
    func setRosterID(rosterID: Int) {
        self.rosterID = rosterID
    }
}