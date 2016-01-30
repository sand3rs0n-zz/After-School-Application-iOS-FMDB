//
//  ContactNumber.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 1/30/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import Foundation

class ContactNumber {
    private var contactID = 0
    private var studentID = 0
    private var phoneNumber = ""
    private var name = ""

    init() {
    }

    func getContactID() -> Int {
        return contactID
    }
    func getStudentID() -> Int {
        return studentID
    }
    func getPhoneNumber() -> String {
        return phoneNumber
    }
    func getName() -> String {
        return name
    }
    func setContactID(contactID: Int) {
        self.contactID = contactID
    }
    func setStudentID(studentID: Int) {
        self.studentID = studentID
    }
    func setPhoneNumber(phoneNumber: String) {
        self.phoneNumber = phoneNumber
    }
    func setName(name: String) {
        self.name = name
    }
}
