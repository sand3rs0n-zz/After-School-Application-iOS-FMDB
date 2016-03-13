//
//  StudentInfoModel.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 3/12/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import Foundation

class StudentInfoModel {
    private var studentID = 0
    private var student = Student()
    private var guardians = [Guardian]()
    private var contactNumbers = [ContactNumber]()
    private var dob = Date()

    init() {
        getStudent()
        getGuardians()
        getContactNumbers()
        if (studentID != 0) {
            setDOB()
        }
    }

    func resetResults() {
        getStudent()
        getGuardians()
        getContactNumbers()
        if (studentID != 0) {
            setDOB()
        }
    }

    private func getStudent() {
        let querySQL = "SELECT * FROM STUDENTPROFILES WHERE studentID = '\(studentID)'"
        let results = database.search(querySQL)
        if (results.next()) {
            student.setStudentID(Int(results.intForColumn("studentID")))
            student.setFirstName(results.stringForColumn("firstName"))
            student.setLastName(results.stringForColumn("lastName"))
            student.setActive(Int(results.intForColumn("active")))
            student.setSchool(results.stringForColumn("school"))
            student.setBirthDay(Int(results.intForColumn("birthDay")))
            student.setBirthMonth(Int(results.intForColumn("birthMonth")))
            student.setBirthYear(Int(results.intForColumn("birthYear")))
            results.close()
        }
    }

    private func getGuardians() {
        let querySQL = "SELECT * FROM GUARDIANS WHERE studentID = '\(studentID)'"
        let results = database.search(querySQL)
        while (results.next()) {
            let cur = Guardian()
            cur.setGuardianID(Int(results.intForColumn("guardianID")))
            cur.setName(results.stringForColumn("name"))
            cur.setStudentID(Int(results.intForColumn("studentID")))
            guardians.append(cur)
        }
        results.close()
    }

    private func getContactNumbers() {
        let querySQL = "SELECT * FROM CONTACTNUMBERS WHERE studentID = '\(studentID)'"
        let results = database.search(querySQL)
        while (results.next()) {
            let cur = ContactNumber()
            cur.setContactID(Int(results.intForColumn("contactID")))
            cur.setName(results.stringForColumn("name"))
            cur.setPhoneNumber(results.stringForColumn("phoneNumber"))
            cur.setStudentID(Int(results.intForColumn("studentID")))
            contactNumbers.append(cur)
        }
        results.close()
    }

    func setStudentID(id: Int) {
        studentID = id
    }
    func getStudentID() -> Int {
        return studentID
    }
    private func setDOB(){
        dob = Date(day: student.getBirthDay(), month: student.getBirthMonth(), year: student.getBirthYear())
    }
    private func calcAge() -> Int {
        return dob.age()
    }
    func getGuardiansCount() -> Int {
        return guardians.count
    }
    func getGuardian(i: Int) -> Guardian {
        return guardians[i]
    }
    func getContactNumbersCount() -> Int {
        return contactNumbers.count
    }
    func getContactNumber(i: Int) -> ContactNumber {
        return contactNumbers[i]
    }
    func getFirstName() -> String {
        return student.getFirstName()
    }
    func getLastName() -> String {
        return student.getLastName()
    }
    func getSchool() -> String {
        return student.getSchool()
    }
    func getDOB() -> String {
        return dob.fullDateAmerican()
    }
    func getAge() -> String {
        return String(dob.age())
    }
}