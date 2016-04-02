//
//  SignOut.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 1/30/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import Foundation

class SignOut {
    private var signOutID = 0
    private var studentID = 0
    private var rosterID = 0
    private var signOutGuardian = ""
    private var campName = ""
    private var rosterType = 0
    private var signOutType = 0
    private var day = 0
    private var month = 0
    private var year = 0
    private var hour = 0
    private var minute = 0
    private var timeStamp = Date()

    init() {
    }

    func createTimeStamp() {
        timeStamp = Date(day: day, month: month, year: year, hour: hour, minute: minute)
    }
    func getTimeStamp() -> Date {
        return timeStamp
    }
    func getSignOutID() -> Int {
        return signOutID
    }
    func getStudentID() -> Int {
        return studentID
    }
    func getRosterID() -> Int {
        return rosterID
    }
    func getSignOutGuardian() -> String {
        return signOutGuardian
    }
    func getCampName() -> String {
        return campName
    }
    func getRosterType() -> Int {
        return rosterType
    }
    func getSignOutType() -> Int {
        return signOutType
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
    func getHour() -> Int {
        return hour
    }
    func getMinute() -> Int {
        return minute
    }
    func setSignOutID(signOutID: Int) {
        self.signOutID = signOutID
    }
    func setStudentID(studentID: Int) {
        self.studentID = studentID
    }
    func setRosterID(rosterID: Int) {
        self.rosterID = rosterID
    }
    func setSignOutGuaridan(signOutGuardian: String) {
        self.signOutGuardian = signOutGuardian
    }
    func setCampName(campName: String) {
        self.campName = campName
    }
    func setRosterType(rosterType: Int) {
        self.rosterType = rosterType
    }
    func setSignOutType(signOutType: Int) {
        self.signOutType = signOutType
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
    func setHour(hour: Int) {
        self.hour = hour
    }
    func setMinute(minute: Int) {
        self.minute = minute
    }
}