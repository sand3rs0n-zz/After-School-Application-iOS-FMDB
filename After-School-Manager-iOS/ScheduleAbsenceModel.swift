//
//  ScheduleAbsenceModel.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 3/12/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import Foundation

class ScheduleAbsenceModel {
    private var absence = Absence()
    private var state = 0
    private var buttonText = ""
    private var rosterType = 0
    private var studentID = 0
    private var rosterID = 0
    private var signOutID = 0
    private var studentLastName = ""
    private var studentFirstName = ""
    private var roster = Roster()

    init() {
    }

    func getRosters() {
        let rostersSQL = "SELECT * FROM ROSTERS WHERE rosterID = '\(rosterID)'"
        let results = database.search(rostersSQL)
        results.next()
        roster.setPickUpHour(Int(results.intForColumn("pickUpHour")))
        roster.setPickUpMinute(Int(results.intForColumn("pickUpMinute")))
        results.close()
    }

    func initializeAbsence() {
        rosterID = absence.getRosterID()
        studentID = absence.getStudentID()
        let signOutSQL = "SELECT * FROM SIGNOUTS WHERE rosterID = '\(rosterID)' AND studentID = '\(studentID)' AND day = '\(absence.getDay())' AND month = '\(absence.getMonth())' AND year = '\(absence.getYear())'"
        let results = database.search(signOutSQL)
        results.next()
        signOutID = Int(results.intForColumn("signOutID"))
        results.close()
    }

    func setAbsence(absence: Absence) {
        self.absence = absence
    }
    func getAbsence() -> Absence {
        return absence
    }
    func setState(state: Int) {
        self.state = state
    }
    func getState() -> Int {
        return state
    }
    func setButtonText(text: String) {
        self.buttonText = text
    }
    func getButtonText() -> String {
        return buttonText
    }
    func setRosterType(rosterType: Int) {
        self.rosterType = rosterType
    }
    func getRosterType() -> Int {
        return rosterType
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
    func setStudentLastName(name: String) {
        studentLastName = name
    }
    func getStudentLastName() -> String {
        return studentLastName
    }
    func setStudentFirstName(name: String) {
        studentFirstName = name
    }
    func getStudentFirstName() -> String {
        return studentFirstName
    }
    func getSignOutID() -> Int{
        return signOutID
    }
    func getPickUpMinute() -> Int {
        return roster.getPickUpMinute()
    }
    func getPickUpHour() -> Int {
        return roster.getPickUpHour()
    }

}