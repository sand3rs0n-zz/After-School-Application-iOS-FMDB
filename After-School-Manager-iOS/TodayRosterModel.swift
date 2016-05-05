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
    private var numberOfNonSignedOut = [Int]()
    private var sectionTitles = [String]()
    private var sectionSize = [Int]()
    private var studentList2D = [[StudentRoster]]()

    init(){

    }

    private func getStudents() {
        let year = date.getCurrentYear()
        let month = date.getCurrentMonth()
        let day = date.getCurrentDay()
        let weekday = date.getCurrentWeekday()

        let signOutQuery = "SELECT studentID, rosterID FROM SIGNOUTS WHERE day = '\(day)' AND month = '\(month)' AND year = '\(year)'"
        let results1 = database.search(signOutQuery)
        var signOuts = [SignOut]()
        while(results1.next()) {
            let cur = SignOut()
            cur.setRosterID(Int(results1.intForColumn("rosterID")))
            cur.setStudentID(Int(results1.intForColumn("studentID")))
            signOuts.append(cur)
        }
        results1.close()

        let querySQL = "SELECT STUDENTROSTERS.studentFirstName AS studentFirstName, STUDENTROSTERS.studentLastName AS studentLastName, STUDENTROSTERS.studentID AS studentID, STUDENTROSTERS.rosterID AS rosterID, ROSTERS.name AS name FROM STUDENTROSTERS LEFT OUTER JOIN ROSTERS ON STUDENTROSTERS.rosterID = ROSTERS.rosterID  WHERE (endYear > '\(year)' OR (endYear = '\(year)' AND endMonth > '\(month)') OR (endYear = '\(year)' AND endMonth = '\(month)' AND endDay >= '\(day)')) AND (startYear < '\(year)' OR (startYear = '\(year)' AND startMonth < '\(month)') OR (startYear = '\(year)' AND startMonth = '\(month)' AND startDay <= '\(day)')) AND \(weekday) = 1  AND studentID IN (SELECT studentID FROM STUDENTPROFILES WHERE active = 1) AND STUDENTROSTERS.rosterID NOT IN (SELECT rosterID FROM EVENTS WHERE day = '\(day)' AND month = '\(month)' AND year = '\(year)') UNION SELECT STUDENTPROFILES.firstName AS studentFirstName, STUDENTPROFILES.lastName AS studentLastName, STUDENTPROFILES.studentID AS studentID, ROSTERS.rosterID as rosterID, ROSTERS.name as name FROM ONETIMEATTENDANCE LEFT OUTER JOIN STUDENTPROFILES ON ONETIMEATTENDANCE.studentID = STUDENTPROFILES.studentID LEFT OUTER JOIN ROSTERS ON ONETIMEATTENDANCE.rosterID = ROSTERS.rosterID WHERE year = '\(year)' AND month = '\(month)' AND day = '\(day)' AND active = 1 AND ROSTERS.rosterID NOT IN (SELECT rosterID FROM EVENTS WHERE day = '\(day)' AND month = '\(month)' AND year = '\(year)') ORDER BY name, studentLastName, studentFirstName ASC"
        let results2 = database.search(querySQL)
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

        var signedOuts = [StudentRoster]()
        var notSignedOuts = [StudentRoster]()
        var rosterNames = [String]()

        for (var i = 0; i < studentList.count; i++) {
            if (!rosterNames.contains(studentList[i].getRosterName())) {
                rosterNames.append(studentList[i].getRosterName())
            }
        }

        for (var i = 0; i < studentList.count; i++) {
            var bool = false
            for (var k = 0; k < signOuts.count; k++) {
                if (signOuts[k].getStudentID() == studentList[i].getStudentID() && signOuts[k].getRosterID() == studentList[i].getRosterID()) {
                    signedOuts.append(studentList[i])
                    bool = true
                    break
                }
            }
            if (!bool) {
                notSignedOuts.append(studentList[i])
            }
        }

        rosterNames.sortInPlace({ (a: String, b: String) -> Bool in
            return a > b
        })

        for (var i = 0; i < rosterNames.count; i++) {
            var c = 0
            let currentTitle = rosterNames[i]
            for (var j = 0; j < notSignedOuts.count; j++) {
                let cur = notSignedOuts[j]
                if (cur.getRosterName() == currentTitle) {
                    c++
                }
            }
            numberOfNonSignedOut.append(c)
        }

        createTableSections(notSignedOuts, signedOuts: signedOuts)
    }

    private func createTableSections(notSignedOuts: [StudentRoster], signedOuts: [StudentRoster]) {
        if (notSignedOuts.count > 0) {
            var currentTitle = notSignedOuts[0].getRosterName()
            var count2 = 0
            studentList2D.append([StudentRoster]())
            for (var i = 0; i < notSignedOuts.count; i += 1) {
                let cur = notSignedOuts[i]
                if (cur.getRosterName() != currentTitle) {
                    sectionTitles.append(currentTitle)
                    currentTitle = cur.getRosterName()
                    count2++
                    currentTitle = cur.getRosterName()
                    studentList2D.append([StudentRoster]())
                }
                studentList2D[count2].append(cur)

            }
            sectionTitles.append(currentTitle)
        }
        if (signedOuts.count > 0) {
            var currentTitle = signedOuts[0].getRosterName()
            var count2 = 0
            var count = 0
            while (currentTitle != sectionTitles[count]) {
                count++
                count2++
            }
            for (var i = 0; i < signedOuts.count; i++) {
                let cur = signedOuts[i]
                if (cur.getRosterName() != currentTitle) {
                    currentTitle = cur.getRosterName()
                    count2++
                    currentTitle = cur.getRosterName()
                }
                studentList2D[count2].append(cur)
            }
        }
        for (var i = 0; i < studentList2D.count; i++) {
            sectionSize.append(studentList2D[i].count)
        }
    }

    func resetStudents() {
        studentList.removeAll()
        sectionSize.removeAll()
        sectionTitles.removeAll()
        numberOfNonSignedOut.removeAll()
        studentList2D.removeAll()
        getStudents()
    }

    func getStudent(i: Int, j: Int) -> StudentRoster {
        return studentList2D[i][j]
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
    func getNumberOfNonSignedOut(i:Int) -> Int {
        if (numberOfNonSignedOut.count > i) {
            return numberOfNonSignedOut[i]
        }
        return 0
    }
}