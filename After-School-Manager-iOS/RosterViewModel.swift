//
//  RosterViewModel.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 3/12/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import Foundation

class RosterViewModel {
    private var navTitle = ""
    private var rosterID = 0
    private var students = [StudentRoster]()
    private var roster = Roster()
    private var forwardedStudentID = 0

    init() {

    }

    private func getStudents() {
        let querySQL = "SELECT * FROM STUDENTROSTERS WHERE rosterID = '\(rosterID)' ORDER BY studentLastName ASC"
        let results = database.search(querySQL)
        while (results.next()) {
            let cur = StudentRoster()
            cur.setStudentFirstName(results.stringForColumn("studentFirstName"))
            cur.setStudentLastName(results.stringForColumn("studentLastName"))
            cur.setStudentID(Int(results.intForColumn("studentID")))
            cur.setRosterID(Int(results.intForColumn("rosterID")))
            students.append(cur)
        }
        results.close()
    }

    func resetStudents() {
        students.removeAll()
        getStudents()
        navTitle = roster.getName()
    }

    func setTitleValue(navTitle: String) {
        self.navTitle = navTitle
    }
    func getTitleValue() -> String {
        return navTitle
    }
    func setRosterID(rosterID: Int) {
        self.rosterID = rosterID
    }
    func getRosterID() -> Int {
        return rosterID
    }
    func setRoster(roster: Roster) {
        self.roster = roster
    }
    func getRoster() -> Roster {
        return roster
    }
    func getStudentsCount() -> Int {
        return students.count
    }
    func getStudent(i: Int) -> StudentRoster {
        return students[i]
    }
    func setForwardedStudentID(forwardedStudentID: Int) {
        self.forwardedStudentID = forwardedStudentID
    }
    func getForwardedStudentID() -> Int {
        return forwardedStudentID
    }
    func removeStudent(index: Int) {
        students.removeAtIndex(index)
    }
}