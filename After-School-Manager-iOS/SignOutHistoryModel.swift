//
//  SignOutHistoryModel.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 3/12/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import Foundation
import UIKit

class SignOutHistoryModel {
    private var studentID = 0
    private var state = 0
    private var signOuts = [SignOut]()
    private var studentName = ""
    private var rosterBool = [1, 1, 1]
    private var rosterTypes = [UIButton]()
    private var rosterTypeString = "( 0, 1, 2 )"

    init() {
    }

    private func getSignOuts() {
        let date = Date()
        let year = date.getCurrentYear()
        let month = date.getCurrentMonth()
        let day = date.getCurrentDay()

        let querySQL = "SELECT SIGNOUTS.*, ROSTERS.name FROM SIGNOUTS LEFT OUTER JOIN ROSTERS ON SIGNOUTS.rosterID = ROSTERS.rosterID WHERE (year < '\(year)' OR (year = '\(year)' AND month < '\(month)') OR (year = '\(year)' AND month = '\(month)' AND day <= '\(day)')) AND studentID = '\(studentID)' AND SIGNOUTS.rosterType IN \(rosterTypeString) ORDER BY year, month, day, name ASC"

        let results = database.search(querySQL)
        while (results.next()) {
            let cur = SignOut()
            cur.setRosterID(Int(results.intForColumn("studentID")))
            cur.setRosterID(Int(results.intForColumn("rosterID")))
            cur.setSignOutGuaridan(results.stringForColumn("signOutGuardian"))
            cur.setCampName(results.stringForColumn("name"))
            cur.setRosterType(Int(results.intForColumn("rosterType")))
            cur.setDay(Int(results.intForColumn("day")))
            cur.setMonth(Int(results.intForColumn("month")))
            cur.setYear(Int(results.intForColumn("year")))
            cur.setHour(Int(results.intForColumn("hour")))
            cur.setMinute(Int(results.intForColumn("minute")))
            cur.createTimeStamp()
            signOuts.append(cur)
        }
        results.close()
    }

    func setRosterTypes(rosterTypes: [UIButton]) {
        self.rosterTypes = rosterTypes
    }
    func getRosterTypes(i: Int) -> UIButton {
        return rosterTypes[i]
    }
    func getRosterBool(i: Int) -> Int {
        return rosterBool[i]
    }
    func setRosterBool(val: Int, i: Int) {
        rosterBool[i] = val
    }
    func getRosterTypeString() -> String {
        return rosterTypeString
    }
    func setRosterTypeString(rosterTypeString: String) {
        self.rosterTypeString = rosterTypeString
    }

    func resetSignOuts() {
        signOuts.removeAll()
        getSignOuts()
    }
    func getSignOut(i: Int) -> SignOut {
        return signOuts[i]
    }
    func getSignOutsCount() -> Int {
        return signOuts.count
    }
    func getStudentID() -> Int {
        return studentID
    }
    func getState() -> Int {
        return state
    }
    func getStudentName() -> String {
        return studentName
    }
    func setStudentID(studentID: Int) {
        self.studentID = studentID
    }
    func setState(state: Int) {
        self.state = state
    }
    func setStudentName(studentName: String) {
        self.studentName = studentName
    }
}