//
//  RosterHistoryModel.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 3/12/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import Foundation

class RosterHistoryModel {
    private var rosterList = [StudentRoster]()
    private var studentID = 0
    private var forwardedRosterID = 0

    init() {

    }

    private func getRosters() {
        let querySQL = "SELECT STUDENTROSTERS.*, ROSTERS.name FROM STUDENTROSTERS LEFT OUTER JOIN ROSTERS ON STUDENTROSTERS.rosterID = ROSTERS.rosterID WHERE STUDENTROSTERS.studentID = '\(studentID)'"

        let results = database.search(querySQL)
        while (results.next()) {
            let cur = StudentRoster()
            cur.setStudentFirstName(results.stringForColumn("studentFirstName"))
            cur.setStudentLastName(results.stringForColumn("studentLastName"))
            cur.setStudentID(Int(results.intForColumn("studentID")))
            cur.setRosterID(Int(results.intForColumn("rosterID")))
            cur.setRosterName(results.stringForColumn("name"))
            rosterList.append(cur)
        }
        results.close()
    }

    func resetRosters() {
        rosterList.removeAll()
        getRosters()
    }

    func getRosterListCount() -> Int {
        return rosterList.count
    }
    func getRoster(i: Int) -> StudentRoster {
        return rosterList[i]
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
    func removeRoster(index: Int) {
        rosterList.removeAtIndex(index)
    }
}