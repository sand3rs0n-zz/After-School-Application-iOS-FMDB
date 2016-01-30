//
//  Guardian.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 1/30/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import Foundation

class Guardian {
    private var guardianID = 0
    private var studentID = 0
    private var name = ""

    init() {
    }

    func getGuardianID() -> Int {
        return guardianID
    }
    func getStudentID() -> Int {
        return studentID
    }
    func getName() -> String {
        return name
    }
    func setGuardianID(guardianID: Int) {
        self.guardianID = guardianID
    }
    func setStudentID(studentID: Int) {
        self.studentID = studentID
    }
    func setName(name: String) {
        self.name = name
    }
}