//
//  AddOrEditStudentModel.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 3/12/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import Foundation

class AddOrEditStudentModel {
    private var updateStudent = false
    private var studentID = 0
    private var student = Student()
    private var guardians = [Guardian]()
    private var contactNumbers = [ContactNumber]()
    private var navTitle = ""
    private var buttonText = ""

    init() {
        getStudent()
        getGuardians()
        getContactNumbers()
    }

    func resetResults() {
        getStudents()
        getGuardians()
        getContactNumbers()
    }
    func resetGuardians() {
        guardians.removeAll()
        getGuardians()
    }
    func resetContactNumbers() {
        contactNumbers.removeAll()
        getContactNumbers()
    }

    private func getStudents() {
        let querySQL = "SELECT * FROM STUDENTPROFILES WHERE studentID = '\(studentID)'"
        let results = database.search(querySQL)
        while(results.next()) {
            student.setStudentID(Int(results.intForColumn("studentID")))
            student.setFirstName(results.stringForColumn("firstName"))
            student.setLastName(results.stringForColumn("lastName"))
            student.setActive(Int(results.intForColumn("active")))
            student.setSchool(results.stringForColumn("school"))
            student.setBirthDay(Int(results.intForColumn("birthDay")))
            student.setBirthMonth(Int(results.intForColumn("birthMonth")))
            student.setBirthYear(Int(results.intForColumn("birthYear")))
        }
        results.close()
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

    func setTitleValue(navTitle: String) {
        self.navTitle = navTitle
    }
    func getTitleValue() -> String {
        return navTitle
    }
    func getButtonText() -> String {
        return buttonText
    }
    func setButtonText(buttonText: String) {
        self.buttonText = buttonText
    }
    func setUpdate(update: Bool) {
        updateStudent = update
    }
    func getUpdate() -> Bool {
        return updateStudent
    }
    func setStudentID(id: Int) {
        studentID = id
    }
    func getStudentID() -> Int {
        return studentID
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
    func getStudent() -> Student {
        return student
    }
}