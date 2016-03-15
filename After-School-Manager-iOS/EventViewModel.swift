//
//  EventViewModel.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 3/12/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import Foundation

class EventViewModel {
    private var event = Event()

    init() {
    }

    func getEvent() -> Event {
        return event
    }
    func setEvent(event: Event) {
        self.event = event
    }
    func getName() -> String {
        return event.getName()
    }
    func getEventType() -> Int {
        return event.getEventType()
    }
    func getDescription() -> String {
        return event.getDescription()
    }
    func getDay() -> Int {
        return event.getDay()
    }
    func getMonth() -> Int {
        return event.getMonth()
    }
    func getYear() -> Int {
        return event.getYear()
    }
}