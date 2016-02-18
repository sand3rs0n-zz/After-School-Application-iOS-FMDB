//
//  OneTimeAttendance.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 2/16/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import Foundation

class OneTimeAttendance {
    private var studentID = 0
    private var rosterID = 0
    private var day = 0
    private var month = 0
    private var year = 0

    init() {
    }

    func getStudentID() -> Int {
        return studentID
    }
    func getRosterID() -> Int {
        return rosterID
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
    func setStudentID(studentID: Int) {
        self.studentID = studentID
    }
    func setRosterID(rosterID: Int) {
        self.rosterID = rosterID
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
}