//
//  StudentRoster.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 1/30/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import Foundation

class StudentRoster {
    private var studentFirstName = ""
    private var studentLastName = ""
    private var studentID = 0
    private var rosterID = 0
    private var monday = 0
    private var tuesday = 0
    private var wednesday = 0
    private var thursday = 0
    private var friday = 0
    private var saturday = 0
    private var sunday = 0

    init () {
    }

    func getStudentFirstName() -> String {
        return studentFirstName
    }
    func getStudentLastName() -> String {
        return studentLastName
    }
    func getStudentID() -> Int {
        return studentID
    }
    func getRosterID() -> Int {
        return rosterID
    }
    func getMonday() -> Int {
        return monday
    }
    func getTuesday() -> Int {
        return tuesday
    }
    func getWednesday() -> Int {
        return wednesday
    }
    func getThursday() -> Int {
        return thursday
    }
    func getFriday() -> Int {
        return friday
    }
    func getSaturday() -> Int {
        return saturday
    }
    func getSunday() -> Int {
        return sunday
    }
    func setStudentFirstName(studentFirstName: String) {
        self.studentFirstName = studentFirstName
    }
    func setStudentLastName(studentLastName: String) {
        self.studentLastName = studentLastName
    }
    func setStudentID(studentID: Int) {
        self.studentID = studentID
    }
    func setRosterID(rosterID: Int) {
        self.rosterID = rosterID
    }
    func setMonday(monday: Int) {
        self.monday = monday
    }
    func setTuesday(tuesday: Int) {
        self.tuesday = tuesday
    }
    func setWednesday(wednesday: Int) {
        self.wednesday = wednesday
    }
    func setThursday(thursday: Int) {
        self.thursday = thursday
    }
    func setFriday(friday: Int) {
        self.friday = friday
    }
    func setSaturday(saturday: Int) {
        self.saturday = saturday
    }
    func setSunday(sunday: Int) {
        self.sunday = sunday
    }
}