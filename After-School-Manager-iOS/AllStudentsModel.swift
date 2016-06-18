//
//  AllStudentsModel.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 3/12/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import Foundation

class AllStudentsModel {
    private var studentList = [Student]()
    private var forwardedStudentID = 0

    init(){

    }

    func resetStudents() {
        studentList.removeAll()
        getStudents()
    }

    private func getStudents() {
        let querySQL = "SELECT * FROM STUDENTPROFILES ORDER BY lastName, firstName ASC"

        let results = database.search(querySQL)
        while (results.next()) {
            let cur = Student()
            cur.setStudentID(Int(results.intForColumn("studentID")))
            cur.setFirstName(results.stringForColumn("firstName"))
            cur.setLastName(results.stringForColumn("lastName"))
            studentList.append(cur)
        }
        results.close()
    }

    func getStudentListCount() -> Int {
        return studentList.count
    }
    func getStudent(i: Int) -> Student {
        return studentList[i]
    }
    func getForwardedStudentID () -> Int {
        return forwardedStudentID
    }
    func setForwardedStudentID(forwardedStudentID: Int) {
        self.forwardedStudentID = forwardedStudentID
    }
    func removeStudent(index: Int) {
        studentList.removeAtIndex(index)
    }
}