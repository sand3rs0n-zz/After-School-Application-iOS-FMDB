//
//  SelectRosterToAddStudentModel.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 3/12/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import Foundation

class SelectRosterToAddStudentModel {
    private var rosterList = [Roster]()
    private var studentID = 0
    private var forwardedRosterID = 0

    init() {

    }

    private func getRosters() {
        let querySQL = "SELECT * FROM ROSTERS WHERE rosterID NOT IN (SELECT rosterID FROM STUDENTROSTERS WHERE studentID = '\(studentID)') ORDER BY name ASC"

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
            rosterList.append(cur)
        }
        results.close()
    }

    func resetRosters() {
        rosterList.removeAll()
        getRosters()
    }

    func setStudentID(studentID: Int) {
        self.studentID = studentID
    }
    func getStudentID() -> Int {
        return studentID
    }
    func setForwardedRosterID(forwardedRosterID: Int) {
        self.forwardedRosterID = forwardedRosterID
    }
    func getForwardedRosterID() -> Int {
        return forwardedRosterID
    }
    func getRoster(i: Int) -> Roster {
        return rosterList[i]
    }
    func getRosterListCount() -> Int {
        return rosterList.count
    }
}