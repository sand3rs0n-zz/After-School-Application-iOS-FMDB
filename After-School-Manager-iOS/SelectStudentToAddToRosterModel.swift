//
//  SelectStudentToAddToRosterModel.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 3/12/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import Foundation

class SelectStudentToAddToRosterModel {
    private var forwardedStudentID = 0
    private var students = [Student]()
    private var rosterID = 0

    init() {

    }

    private func getStudents() {
        let querySQL = "SELECT * FROM STUDENTPROFILES WHERE studentID NOT IN (SELECT studentID FROM STUDENTROSTERS WHERE rosterID = '\(rosterID)') ORDER BY lastName, firstName ASC"
        let results = database.search(querySQL)
        while (results.next()) {
            let cur = Student()
            cur.setStudentID(Int(results.intForColumn("studentID")))
            cur.setFirstName(results.stringForColumn("firstName"))
            cur.setLastName(results.stringForColumn("lastName"))
            cur.setActive(Int(results.intForColumn("active")))
            cur.setSchool(results.stringForColumn("school"))
            cur.setBirthDay(Int(results.intForColumn("birthDay")))
            cur.setBirthMonth(Int(results.intForColumn("birthMonth")))
            cur.setBirthYear(Int(results.intForColumn("birthYear")))
            students.append(cur)
        }
        results.close()
    }

    func resetStudents() {
        students.removeAll()
        getStudents()
    }

    func setForwardedStudentID(forwardedStudentID: Int) {
        self.forwardedStudentID = forwardedStudentID
    }
    func getForwardedStudentID() -> Int {
        return forwardedStudentID
    }
    func getStudent(i: Int) -> Student {
        return students[i]
    }
    func getStudentListCount() -> Int {
        return students.count
    }
    func setRosterID(rosterID: Int) {
        self.rosterID = rosterID
    }
    func getRosterID() -> Int {
        return rosterID
    }
}