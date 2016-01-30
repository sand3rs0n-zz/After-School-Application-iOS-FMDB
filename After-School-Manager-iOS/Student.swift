//
//  Student.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 1/30/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import Foundation

class Student {
    private var studentID = 0
    private var firstName = ""
    private var lastName = ""
    private var active = 0
    private var school = ""
    private var birthDay = 0
    private var birthMonth = 0
    private var birthYear = 0

    init() {
    }

    func getStudentID() -> Int {
        return studentID
    }
    func getFirstName() -> String {
        return firstName
    }
    func getLastName() -> String {
        return lastName
    }
    func getActive() -> Int {
        return active
    }
    func getSchool() -> String {
        return school
    }
    func getBirthDay() -> Int {
        return birthDay
    }
    func getBirthMonth() -> Int {
        return birthMonth
    }
    func getBirthYear() -> Int {
        return birthYear
    }
    func setStudentID(studentID: Int) {
        self.studentID = studentID
    }
    func setFirstName(firstName: String) {
        self.firstName = firstName
    }
    func setLastName(lastName: String) {
        self.lastName = lastName
    }
    func setActive(active: Int) {
        self.active = active
    }
    func setSchool(school: String) {
        self.school = school
    }
    func setBirthDay(birthDay: Int) {
        self.birthDay = birthDay
    }
    func setBirthMonth(birthMonth: Int) {
        self.birthMonth = birthMonth
    }
    func setBirthYear(birthYear: Int) {
        self.birthYear = birthYear
    }
}