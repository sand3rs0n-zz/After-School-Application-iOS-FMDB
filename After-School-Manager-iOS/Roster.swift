//
//  Roster.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 1/30/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import Foundation

class Roster {
    private var rosterID = 0
    private var rosterType = 0
    private var name = ""
    private var startDay = 0
    private var startMonth = 0
    private var startYear = 0
    private var endDay = 0
    private var endMonth = 0
    private var endYear = 0
    private var pickUpHour = 0
    private var pickUpMinute = 0

    init () {
    }

    func getRosterID() -> Int {
        return rosterID
    }
    func getRosterType() -> Int {
        return rosterType
    }
    func getName() -> String {
        return name
    }
    func getStartDay() -> Int {
        return startDay
    }
    func getStartMonth() -> Int {
        return startMonth
    }
    func getStartYear() -> Int {
        return startYear
    }
    func getEndDay() -> Int {
        return endDay
    }
    func getEndMonth() -> Int {
        return endMonth
    }
    func getEndYear() -> Int {
        return endYear
    }
    func getPickUpHour() -> Int {
        return pickUpHour
    }
    func getPickUpMinute() -> Int {
        return pickUpMinute
    }
    func setRosterID(rosterID: Int) {
        self.rosterID = rosterID
    }
    func setRosterType(rosterType: Int) {
        self.rosterType = rosterType
    }
    func setName(name: String) {
        self.name = name
    }
    func setStartDay(startDay: Int) {
        self.startDay = startDay
    }
    func setStartMonth(startMonth: Int) {
        self.startMonth = startMonth
    }
    func setStartYear(startYear: Int) {
        self.startYear = startYear
    }
    func setEndDay(endDay: Int) {
        self.endDay = endDay
    }
    func setEndMonth(endMonth: Int) {
        self.endMonth = endMonth
    }
    func setEndYear(endYear: Int) {
        self.endYear = endYear
    }
    func setPickUpHour(pickUpHour: Int) {
        self.pickUpHour = pickUpHour
    }
    func setPickUpMinute(pickUpMinute: Int) {
        self.pickUpMinute = pickUpMinute
    }
}