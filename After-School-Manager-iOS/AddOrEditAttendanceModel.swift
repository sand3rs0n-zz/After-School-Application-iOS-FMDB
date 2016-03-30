//
//  AddOrEditAttendanceModel.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 3/12/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import Foundation
import UIKit

class AddOrEditAttendanceModel {
    private var state = 0
    private var week: [UIButton] = []
    private var weekBool = [0, 0, 0, 0, 0, 0, 0]
    private var navTitle = ""
    private var studentID = 0
    private var rosterID = 0
    private var schedule = StudentRoster()
    private var student = Student()
    private var buttonText = ""
    private var rosterType = 0
    private var weekday = ""

    init() {

    }

    func getStudent() {
        let querySQL = "SELECT * FROM STUDENTPROFILES WHERE studentID = '\(studentID)'"
        let results = database.search(querySQL)
        results.next()
        student.setStudentID(Int(results.intForColumn("studentID")))
        student.setFirstName(results.stringForColumn("firstName"))
        student.setLastName(results.stringForColumn("lastName"))
        results.close()
    }

    func getStudentRoster() {
        let querySQL = "SELECT * FROM STUDENTROSTERS WHERE rosterID = '\(rosterID)' AND studentID = '\(studentID)'"
        let results = database.search(querySQL)
        results.next()
        schedule.setStudentFirstName(results.stringForColumn("studentFirstName"))
        schedule.setStudentLastName(results.stringForColumn("studentLastName"))
        schedule.setRosterName(results.stringForColumn("rosterName"))
        schedule.setStudentID(Int(results.intForColumn("studentID")))
        schedule.setRosterID(Int(results.intForColumn("rosterID")))
        schedule.setMonday(Int(results.intForColumn("monday")))
        schedule.setTuesday(Int(results.intForColumn("tuesday")))
        schedule.setWednesday(Int(results.intForColumn("wednesday")))
        schedule.setThursday(Int(results.intForColumn("thursday")))
        schedule.setFriday(Int(results.intForColumn("friday")))
        schedule.setSaturday(Int(results.intForColumn("saturday")))
        schedule.setSunday(Int(results.intForColumn("sunday")))
        results.close()
    }

    func setState(state: Int) {
        self.state = state
    }
    func getState() -> Int {
        return state
    }
    func setTitleValue(navTitle: String) {
        self.navTitle = navTitle
    }
    func getTitleValue() -> String {
        return navTitle
    }
    func setButtonText(buttonText: String) {
        self.buttonText = buttonText
    }
    func getButtonText() -> String {
        return buttonText
    }
    func setStudentID(studentID: Int) {
        self.studentID = studentID
    }
    func getStudentID() -> Int {
        return studentID
    }
    func setRosterID(rosterID: Int) {
        self.rosterID = rosterID
    }
    func getRosterID() -> Int {
        return rosterID
    }
    func setRosterType(rosterType: Int) {
        self.rosterType = rosterType
    }
    func getRosterType() -> Int {
        return rosterType
    }
    func setWeek(week: [UIButton]) {
        self.week = week
    }
    func getWeek(i: Int) -> UIButton {
        return week[i]
    }
    func getWeekBool(i: Int) -> Int {
        return weekBool[i]
    }
    func setWeekBool(val: Int, i: Int) {
        weekBool[i] = val
    }
    func setWeekday(weekday: String) {
        self.weekday = weekday
    }
    func getWeekday() -> String {
        return weekday
    }
    func getStudentName() -> String {
        return student.getFirstName() + " " + student.getLastName()
    }
    func getSchedule() -> StudentRoster {
        return schedule
    }
    func getRosterName() -> String {
        return schedule.getRosterName()
    }
}
