//
//  Absence.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 1/30/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import Foundation

class Absence {
    private var absenceID = 0
    private var studentFirstName = ""
    private var studentLastName = ""
    private var studentID = 0
    private var day = 0
    private var month = 0
    private var year = 0

    init() {
    }

    func getAbsenceID() -> Int {
        return absenceID
    }
    func getStudentFirstName() -> String {
        return studentFirstName
    }
    func getStudentLastName() -> String {
        return studentLastName
    }
    func getStudentID() -> Int {
        return studentID
    }
    func getDay() -> Int {
        return day
    }
    func getMonth() -> Int {
        return month
    }
    func getYear() -> Int {
        return year
    }
    func setAbsenceID(absenceID: Int) {
        self.absenceID = absenceID
    }
    func setStudentFirstName(studentFirstName: String) {
        self.studentFirstName = studentFirstName
    }
    func setStudentLastName(studentLastName: String) {
        self.studentLastName = studentLastName
    }
    func setStudentID(studentID: Int) {
        self.studentID = studentID
    }
    func setDay(day: Int) {
        self.day = day
    }
    func setMonth(month: Int) {
        self.month = month
    }
    func setYear(year: Int) {
        self.year = year
    }
}