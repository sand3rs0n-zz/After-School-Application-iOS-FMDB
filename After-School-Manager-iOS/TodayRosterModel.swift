//
//  TodayRosterModel.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 3/12/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import Foundation

class TodayRosterModel {
    private var studentList = [StudentRoster]()
    private var date = Date()
    private var forwardedStudentID = 0
    private var forwardedRosterID = 0
    private var forwardedStudentFirstName = ""
    private var forwardedStudentLastName = ""
    private var numberOfNonSignedOut = 0
    private var sectionTitles = [String]()
    private var sectionSize = [Int]()

    init(){

    }

    private func getStudents() {
        let year = date.getCurrentYear()
        let month = date.getCurrentMonth()
        let day = date.getCurrentDay()
        let weekday = date.getCurrentWeekday()
        let querySQL = "SELECT STUDENTROSTERS.studentFirstName AS studentFirstName, STUDENTROSTERS.studentLastName AS studentLastName, STUDENTROSTERS.studentID AS studentID, STUDENTROSTERS.rosterID AS rosterID, ROSTERS.name AS name FROM STUDENTROSTERS LEFT OUTER JOIN ROSTERS ON STUDENTROSTERS.rosterID = ROSTERS.rosterID  WHERE (endYear > '\(year)' OR (endYear = '\(year)' AND endMonth > '\(month)') OR (endYear = '\(year)' AND endMonth = '\(month)' AND endDay >= '\(day)')) AND (startYear < '\(year)' OR (startYear = '\(year)' AND startMonth < '\(month)') OR (startYear = '\(year)' AND startMonth = '\(month)' AND startDay <= '\(day)')) AND \(weekday) = 1  AND studentID IN (SELECT studentID FROM STUDENTPROFILES WHERE active = 1) AND studentID NOT IN (SELECT studentID FROM SIGNOUTS WHERE day = '\(day)' AND month = '\(month)' AND year = '\(year)') AND STUDENTROSTERS.rosterID NOT IN (SELECT rosterID FROM EVENTS WHERE day = '\(day)' AND month = '\(month)' AND year = '\(year)') UNION SELECT STUDENTPROFILES.firstName AS studentFirstName, STUDENTPROFILES.lastName AS studentLastName, STUDENTPROFILES.studentID AS studentID, ROSTERS.rosterID as rosterID, ROSTERS.name as name FROM ONETIMEATTENDANCE LEFT OUTER JOIN STUDENTPROFILES ON ONETIMEATTENDANCE.studentID = STUDENTPROFILES.studentID LEFT OUTER JOIN ROSTERS ON ONETIMEATTENDANCE.rosterID = ROSTERS.rosterID WHERE year = '\(year)' AND month = '\(month)' AND day = '\(day)' AND active = 1 AND ONETIMEATTENDANCE.studentID NOT IN (SELECT studentID FROM SIGNOUTS WHERE day = '\(day)' AND month = '\(month)' AND year = '\(year)') AND ROSTERS.rosterID NOT IN (SELECT rosterID FROM EVENTS WHERE day = '\(day)' AND month = '\(month)' AND year = '\(year)') ORDER BY name, studentLastName, studentFirstName ASC"
        let signedOutSQL = "SELECT STUDENTROSTERS.studentFirstName AS studentFirstName, STUDENTROSTERS.studentLastName AS studentLastName, STUDENTROSTERS.studentID AS studentID, STUDENTROSTERS.rosterID AS rosterID, ROSTERS.name AS name FROM STUDENTROSTERS LEFT OUTER JOIN ROSTERS ON STUDENTROSTERS.rosterID = ROSTERS.rosterID  WHERE (endYear > '\(year)' OR (endYear = '\(year)' AND endMonth > '\(month)') OR (endYear = '\(year)' AND endMonth = '\(month)' AND endDay >= '\(day)')) AND (startYear < '\(year)' OR (startYear = '\(year)' AND startMonth < '\(month)') OR (startYear = '\(year)' AND startMonth = '\(month)' AND startDay <= '\(day)')) AND \(weekday) = 1  AND studentID IN (SELECT studentID FROM STUDENTPROFILES WHERE active = 1) AND studentID IN (SELECT studentID FROM SIGNOUTS WHERE day = '\(day)' AND month = '\(month)' AND year = '\(year)') AND STUDENTROSTERS.rosterID NOT IN (SELECT rosterID FROM EVENTS WHERE day = '\(day)' AND month = '\(month)' AND year = '\(year)') UNION SELECT STUDENTPROFILES.firstName AS studentFirstName, STUDENTPROFILES.lastName AS studentLastName, STUDENTPROFILES.studentID AS studentID, ROSTERS.rosterID as rosterID, ROSTERS.name as name FROM ONETIMEATTENDANCE LEFT OUTER JOIN STUDENTPROFILES ON ONETIMEATTENDANCE.studentID = STUDENTPROFILES.studentID LEFT OUTER JOIN ROSTERS ON ONETIMEATTENDANCE.rosterID = ROSTERS.rosterID WHERE year = '\(year)' AND month = '\(month)' AND day = '\(day)' AND active = 1 AND ONETIMEATTENDANCE.studentID IN (SELECT studentID FROM SIGNOUTS WHERE day = '\(day)' AND month = '\(month)' AND year = '\(year)') AND ROSTERS.rosterID NOT IN (SELECT rosterID FROM EVENTS WHERE day = '\(day)' AND month = '\(month)' AND year = '\(year)') ORDER BY name, studentLastName, studentFirstName ASC"

        let results = database.search(querySQL)
        while (results.next()) {
            let cur = StudentRoster()
            cur.setStudentFirstName(results.stringForColumn("studentFirstName"))
            cur.setStudentLastName(results.stringForColumn("studentLastName"))
            cur.setStudentID(Int(results.intForColumn("studentID")))
            cur.setRosterID(Int(results.intForColumn("rosterID")))
            cur.setRosterName(results.stringForColumn("name"))
            studentList.append(cur)
        }
        results.close()
        numberOfNonSignedOut = studentList.count
        let results2 = database.search(signedOutSQL)
        while (results2.next()) {
            let cur = StudentRoster()
            cur.setStudentFirstName(results2.stringForColumn("studentFirstName"))
            cur.setStudentLastName(results2.stringForColumn("studentLastName"))
            cur.setStudentID(Int(results2.intForColumn("studentID")))
            cur.setRosterID(Int(results2.intForColumn("rosterID")))
            cur.setRosterName(results2.stringForColumn("name"))
            studentList.append(cur)
        }
        results2.close()

        createTableSections()
    }

    private func createTableSections() {
        studentList.sortInPlace({ $0.getRosterName() > $1.getRosterName() })
        var currentTitle = studentList[0].getRosterName()
        var count = 0
        for (var i = 0; i < studentList.count; i++) {
            let cur = studentList[i]
            if (cur.getRosterName() == currentTitle) {
                count++
            } else if (cur.getRosterName() != currentTitle) {
                sectionTitles.append(currentTitle)
                sectionSize.append(count)
                currentTitle = cur.getRosterName()
                count = 1
            }
        }
        sectionTitles.append(currentTitle)
        sectionSize.append(count)
    }

    func resetStudents() {
        studentList.removeAll()
        sectionSize.removeAll()
        sectionTitles.removeAll()
        getStudents()
    }

    func setForwardedStudentID(forwardedStudentID: Int) {
        self.forwardedStudentID = forwardedStudentID
    }
    func getForwardedStudentID() -> Int {
        return forwardedStudentID
    }
    func setForwardedRosterID(forwardedRosterID: Int) {
        self.forwardedRosterID = forwardedRosterID
    }
    func getForwardedRosterID() -> Int {
        return forwardedRosterID
    }
    func setForwardedStudentFirstName(forwardedStudentFirstName: String) {
        self.forwardedStudentFirstName = forwardedStudentFirstName
    }
    func getForwardedStudentFirstName() -> String {
        return forwardedStudentFirstName
    }
    func setForwardedStudentLastName(forwardedStudentLastName: String) {
        self.forwardedStudentLastName = forwardedStudentLastName
    }
    func getForwardedStudentLastName() -> String {
        return forwardedStudentLastName
    }
    func getSectionSize(i: Int) -> Int {
        return sectionSize[i]
    }
    func getSectionSizeCount() -> Int {
        return sectionSize.count
    }
    func getSectionTitle(i: Int) -> String {
        return sectionTitles[i]
    }
    func getStudent(i: Int) -> StudentRoster {
        return studentList[i]
    }
    func getNumberOfNonSignedOut() -> Int {
        return numberOfNonSignedOut
    }
}