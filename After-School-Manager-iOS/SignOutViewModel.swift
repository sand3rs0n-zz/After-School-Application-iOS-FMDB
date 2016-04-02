//
//  SignOutViewModel.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 3/12/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import Foundation

class SignOutViewModel {
    private var studentID = 0
    private var rosterType = 0
    private var signOutGuardian = ""
    private var rosterID = 0
    private var guardianNames = [String]()
    private var navTitle = ""
    private var pickUpHour = 0
    private var pickUpMinute = 0

    init() {
        getGuardianNames()
        getRosterTimes()
    }

    private func getGuardians() {
        let querySQL = "SELECT * FROM GUARDIANS WHERE studentID = '\(studentID)'"
        let results = database.search(querySQL)
        while (results.next()) {
            let curname = results.stringForColumn("name")
            guardianNames.append(curname)
        }
        results.close()
    }

    private func getRosterTimes() {
        let querySQL = "SELECT * FROM ROSTERS WHERE rosterID = '\(rosterID)'"
        let results = database.search(querySQL)
        while (results.next()) {
            pickUpHour = Int(results.intForColumn("pickUpHour"))
            pickUpMinute = Int(results.intForColumn("pickUpMinute"))
        }
        results.close()
    }

    func resetGuardians() {
        getGuardians()
        getRosterTimes()
    }

    func getGuardianNames() -> [String] {
        return guardianNames
    }
    func getGuardianNamesCount() -> Int {
        return guardianNames.count
    }
    func getGuardianName(i: Int) -> String {
        return guardianNames[i]
    }
    func getStudentID() -> Int {
        return studentID
    }
    func setStudentID(id: Int) {
        studentID = id
    }
    func getTitleValue() -> String {
        return navTitle
    }
    func setTitleValue(title: String) {
        navTitle = title
    }
    func getRosterType() -> Int {
        return rosterType
    }
    func getPickUpHour() -> Int {
        return pickUpHour
    }
    func getPickUpMinute() -> Int {
        return pickUpMinute
    }
    func setRosterType(type: Int) {
        rosterType = type
    }
    func getRosterID() -> Int {
        return rosterID
    }
    func setRosterID(id: Int) {
        rosterID = id
    }
    func getSignOutGuardian() -> String {
        return signOutGuardian
    }
    func setSignOutGuardian(signOutGuardian: String) {
        self.signOutGuardian = signOutGuardian
    }
}