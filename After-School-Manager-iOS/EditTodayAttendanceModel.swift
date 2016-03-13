//
//  EditTodayAttendanceModel.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 3/12/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import Foundation

class EditTodayAttendanceModel {
    private var studentID = 0
    private var studentFirstName = ""
    private var studentLastName = ""
    private var rosterID = 0
    private var date = Date()
    private var roster = Roster()

    init() {

    }

    func getRosters() {
        let querySQL = "SELECT * FROM ROSTERS WHERE rosterID = '\(rosterID)'"
        let result = database.search(querySQL)
        result.next()
        roster.setRosterType(Int(result.intForColumn("rosterType")))
        roster.setPickUpHour(Int(result.intForColumn("pickUpHour")))
        roster.setPickUpMinute(Int(result.intForColumn("pickUpMinute")))
        result.close()
    }

    func getRoster() -> Roster {
        return roster
    }
    func setStudentID(studentID: Int) {
        self.studentID = studentID
    }
    func getStudentID() -> Int {
        return studentID
    }
    func setStudentFirstName(studentFirstName: String) {
        self.studentFirstName = studentFirstName
    }
    func getStudentFirstName() -> String {
        return studentFirstName
    }
    func setStudentLastName(studentLastName: String) {
        self.studentLastName = studentLastName
    }
    func getStudentLastName() -> String {
        return studentLastName
    }
    func setRosterID(rosterID: Int) {
        self.rosterID = rosterID
    }
    func getRosterID() ->  Int{
        return rosterID
    }
    func getDate() -> Date {
        return date
    }
    func setDate(date: Date) {
        self.date = date
    }
}