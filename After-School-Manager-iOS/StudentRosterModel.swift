//
//  StudentRosterModel.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 3/12/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import Foundation

class StudentRosterModel {
    private var rosterState = 0
    private var students = [StudentRoster]()
    private var rosterID = 0
    private var rosterType = 0
    private var navTitle = ""
    private var forwardedStudentID = 0
    private var forwardedStudentLastName = ""
    private var forwardedStudentFirstName = ""
    private var numberOfNonSignedOut = 0

    init() {
        getStudentList()
    }

    private func getStudentList() {
        let date = Date()
        let day = date.getCurrentDay()
        let month = date.getCurrentMonth()
        let year = date.getCurrentYear()
        var querySQL = ""
        var signedOutSQL = ""
        if (rosterState == 1) {
            querySQL = "SELECT STUDENTROSTERS.studentFirstName AS studentFirstName, STUDENTROSTERS.studentLastName AS studentLastName, STUDENTROSTERS.studentID AS studentID FROM STUDENTROSTERS WHERE rosterID = '\(rosterID)' AND studentID NOT IN (SELECT studentID FROM SIGNOUTS WHERE day = '\(day)' AND month = '\(month)' AND year = '\(year)' AND rosterID = '\(rosterID)') AND \(date.getCurrentWeekday()) = 1 AND studentID IN (SELECT studentID FROM STUDENTPROFILES WHERE active = 1) AND STUDENTROSTERS.rosterID NOT IN (SELECT rosterID FROM EVENTS WHERE day = '\(day)' AND month = '\(month)' AND year = '\(year)') UNION SELECT STUDENTPROFILES.firstName AS studentFirstName, STUDENTPROFILES.lastName AS studentLastName, STUDENTPROFILES.studentID AS studentID FROM ONETIMEATTENDANCE LEFT OUTER JOIN STUDENTPROFILES ON ONETIMEATTENDANCE.studentID = STUDENTPROFILES.studentID LEFT OUTER JOIN ROSTERS ON ONETIMEATTENDANCE.rosterID = ROSTERS.rosterID WHERE year = '\(year)' AND month = '\(month)' AND day = '\(day)' AND active = 1 AND ONETIMEATTENDANCE.studentID NOT IN (SELECT studentID FROM SIGNOUTS WHERE day = '\(date.getCurrentDay())' AND month = '\(date.getCurrentMonth())' AND year = '\(date.getCurrentYear())' AND rosterID = '\(rosterID)') AND ROSTERS.rosterID NOT IN (SELECT rosterID FROM EVENTS WHERE day = '\(day)' AND month = '\(month)' AND year = '\(year)') ORDER BY studentLastName, studentFirstName ASC"
            signedOutSQL = "SELECT STUDENTROSTERS.studentFirstName AS studentFirstName, STUDENTROSTERS.studentLastName AS studentLastName, STUDENTROSTERS.studentID AS studentID FROM STUDENTROSTERS WHERE rosterID = '\(rosterID)' AND studentID IN (SELECT studentID FROM SIGNOUTS WHERE day = '\(day)' AND month = '\(month)' AND year = '\(year)' AND rosterID = '\(rosterID)') AND \(date.getCurrentWeekday()) = 1 AND studentID IN (SELECT studentID FROM STUDENTPROFILES WHERE active = 1) AND STUDENTROSTERS.rosterID NOT IN (SELECT rosterID FROM EVENTS WHERE day = '\(day)' AND month = '\(month)' AND year = '\(year)') UNION SELECT STUDENTPROFILES.firstName AS studentFirstName, STUDENTPROFILES.lastName AS studentLastName, STUDENTPROFILES.studentID AS studentID FROM ONETIMEATTENDANCE LEFT OUTER JOIN STUDENTPROFILES ON ONETIMEATTENDANCE.studentID = STUDENTPROFILES.studentID LEFT OUTER JOIN ROSTERS ON ONETIMEATTENDANCE.rosterID = ROSTERS.rosterID WHERE year = '\(year)' AND month = '\(month)' AND day = '\(day)' AND active = 1 AND ONETIMEATTENDANCE.studentID IN (SELECT studentID FROM SIGNOUTS WHERE day = '\(date.getCurrentDay())' AND month = '\(date.getCurrentMonth())' AND year = '\(date.getCurrentYear())' AND rosterID = '\(rosterID)') AND ROSTERS.rosterID NOT IN (SELECT rosterID FROM EVENTS WHERE day = '\(day)' AND month = '\(month)' AND year = '\(year)') ORDER BY studentLastName, studentFirstName ASC"
        } else if (rosterState == 0) {
            querySQL = "SELECT * FROM STUDENTROSTERS WHERE studentID IN (SELECT studentID FROM STUDENTPROFILES WHERE active = 1) GROUP BY studentID ORDER BY studentLastName, studentFirstName ASC"
        } else if (rosterState == 2) {
            querySQL = "SELECT * FROM STUDENTROSTERS WHERE studentID IN (SELECT studentID FROM STUDENTPROFILES WHERE active = 1) AND rosterID = '\(rosterID)' ORDER BY studentLastName, studentFirstName ASC"
        }
        let results = database.search(querySQL)
        while (results.next()) {
            let cur = StudentRoster()
            cur.setStudentFirstName(results.stringForColumn("studentFirstName"))
            cur.setStudentLastName(results.stringForColumn("studentLastName"))
            cur.setStudentID(Int(results.intForColumn("studentID")))
            students.append(cur)
        }
        results.close()

        if (rosterState == 1) {
            numberOfNonSignedOut = students.count
            let results2 = database.search(signedOutSQL)
            while (results2.next()) {
                let cur = StudentRoster()
                cur.setStudentFirstName(results2.stringForColumn("studentFirstName"))
                cur.setStudentLastName(results2.stringForColumn("studentLastName"))
                cur.setStudentID(Int(results2.intForColumn("studentID")))
                students.append(cur)
            }
            results2.close()
        }
    }

    func resetStudentRoster() {
        students.removeAll()
        getStudentList()
    }
    func getStudent(i: Int) -> StudentRoster {
        return students[i]
    }
    func getStudentCount() -> Int {
        return students.count
    }

    func getState() -> Int {
        return rosterState
    }
    func setState(state: Int) {
        rosterState = state
    }
    func getTitleValue() -> String {
        return navTitle
    }
    func setTitleValue(title: String) {
        navTitle = title
    }
    func getRosterID() -> Int {
        return rosterID
    }
    func setRosterID(id: Int) {
        rosterID = id
    }
    func getRosterType() -> Int {
        return rosterType
    }
    func setRosterType(type: Int) {
        rosterType = type
    }
    func getForwardedStudentLastName() -> String {
        return forwardedStudentLastName
    }
    func setForwardedStudentLastName(lastName: String) {
        forwardedStudentLastName = lastName
    }
    func getForwardedStudentFirstName() -> String {
        return forwardedStudentFirstName
    }
    func setForwardedStudentFirstName(firstName: String) {
        forwardedStudentFirstName = firstName
    }
    func getForwardedStudentID() -> Int {
        return forwardedStudentID
    }
    func setForwardedStudentID(id: Int) {
        forwardedStudentID = id
    }
    func getNumberOfNonSignedOut() -> Int {
        return numberOfNonSignedOut
    }
}