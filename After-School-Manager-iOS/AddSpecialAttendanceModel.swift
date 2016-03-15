//
//  AddSpecialAttendanceModel.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 3/12/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import Foundation

class AddSpecialAttendanceModel {
    private var studentID = 0
    private var rosters = [Roster]()
    init() {

    }

    func getRosters() {
        let date = Date()
        let year = date.getCurrentYear()
        let month = date.getCurrentMonth()
        let day = date.getCurrentDay()
        let weekday = date.getCurrentWeekday()

        let querySQL = "SELECT * FROM ROSTERS WHERE (endYear > '\(year)' OR (endYear = '\(year)' AND endMonth > '\(month)') OR (endYear = '\(year)' AND endMonth = '\(month)' AND endDay >= '\(day)')) AND (startYear < '\(year)' OR (startYear = '\(year)' AND startMonth < '\(month)') OR (startYear = '\(year)' AND startMonth = '\(month)' AND startDay <= '\(day)')) AND rosterID NOT IN (SELECT rosterID FROM STUDENTROSTERS WHERE studentID = '\(studentID)' AND \(weekday) = 1) AND rosterID NOT IN (SELECT rosterID FROM ONETIMEATTENDANCE WHERE studentID = '\(studentID)' AND year = '\(year)' AND month = '\(month)' AND day = '\(day)') ORDER BY name ASC"
        let results = database.search(querySQL)
        while (results.next()) {
            let cur = Roster()
            cur.setRosterID(Int(results.intForColumn("rosterID")))
            cur.setRosterType(Int(results.intForColumn("rosterType")))
            cur.setName(results.stringForColumn("name"))
            cur.setStartDay(Int(results.intForColumn("startDay")))
            cur.setStartMonth(Int(results.intForColumn("startMonth")))
            cur.setStartYear(Int(results.intForColumn("startYear")))
            cur.setEndDay(Int(results.intForColumn("endDay")))
            cur.setEndMonth(Int(results.intForColumn("endMonth")))
            cur.setEndYear(Int(results.intForColumn("endYear")))
            cur.setPickUpHour(Int(results.intForColumn("pickUpHour")))
            cur.setPickUpMinute(Int(results.intForColumn("pickUpMinute")))
            rosters.append(cur)
        }
        results.close()
    }

    func setStudentID(studentID: Int) {
        self.studentID = studentID
    }
    func getStudentID() -> Int {
        return studentID
    }
    func getRostersCount() -> Int {
        return rosters.count
    }
    func getRoster(i: Int) -> Roster {
        return rosters[i]
    }
}