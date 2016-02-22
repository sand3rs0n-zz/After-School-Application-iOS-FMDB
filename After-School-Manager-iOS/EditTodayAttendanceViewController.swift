//
//  EditTodayAttendanceViewController.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 2/15/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import UIKit

class EditTodayAttendanceViewController: UIViewController {

    private var studentID = 0
    private var studentFirstName = ""
    private var studentLastName = ""
    private var rosterID = 0
    private var date = Date()
    private var roster = Roster()

    override func viewDidLoad() {
        super.viewDidLoad()
        let querySQL = "SELECT * FROM ROSTERS WHERE rosterID = '\(rosterID)'"
        let result = database.search(querySQL)
        result.next()
        roster.setRosterType(Int(result.intForColumn("rosterType")))
        roster.setPickUpHour(Int(result.intForColumn("pickUpHour")))
        roster.setPickUpMinute(Int(result.intForColumn("pickUpMinute")))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setStudentID(studentID: Int) {
        self.studentID = studentID
    }
    func setStudentFirstName(studentFirstName: String) {
        self.studentFirstName = studentFirstName
    }
    func setStudentLastName(studentLastName: String) {
        self.studentLastName = studentLastName
    }
    func setRosterID(rosterID: Int) {
        self.rosterID = rosterID
    }

    @IBAction func scheduleAbsenceToday(sender: AnyObject) {
        scheduleAbsence()
        signOut(2)
    }

    @IBAction func unscheduledAbsence(sender: AnyObject) {
        //perform an instructor signout and mark it as unscheduled absence
        scheduleAbsence()
        signOut(3)
    }

    @IBAction func instructorSignOut(sender: AnyObject) {
        signOut(4)
    }

    private func scheduleAbsence() {
        let insertSQL = "INSERT INTO ABSENCESLIST (studentFirstName, studentLastName, studentID, rosterID, day, month, year) VALUES ('\(studentFirstName)', '\(studentLastName)', '\(studentID)', '\(rosterID)', '\(date.getCurrentDay())', '\(date.getCurrentMonth())', '\(date.getCurrentYear())')"
        database.update(insertSQL)
    }

    private func signOut(signOutType: Int) {
        var pickUpHour = roster.getPickUpHour()
        var pickUpMinute = roster.getPickUpMinute()
        if (signOutType == 4) {
            date = Date()
            pickUpHour = date.getCurrentHour()
            pickUpMinute = date.getCurrentMinute()
        }
        let insertSQL = "INSERT INTO SIGNOUTS (studentID, rosterID, signOutGuardian, rosterType, signOutType, day, month, year, hour, minute) VALUES ('\(studentID)', '\(rosterID)', 'Instructor', '\(roster.getRosterType())', '\(signOutType)', '\(date.getCurrentDay())', '\(date.getCurrentMonth())', '\(date.getCurrentYear())', '\(pickUpHour)', '\(pickUpMinute)')"
        database.update(insertSQL)
    }
}
