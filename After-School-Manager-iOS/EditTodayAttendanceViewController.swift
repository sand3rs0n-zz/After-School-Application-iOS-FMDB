//
//  EditTodayAttendanceViewController.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 2/15/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import UIKit

class EditTodayAttendanceViewController: UIViewController {

    @IBOutlet weak var scheduleButton: UIButton!
    @IBOutlet weak var unscheduledButton: UIButton!
    @IBOutlet weak var instructorButton: UIButton!
    @IBOutlet weak var unscheduleButton: UIButton!
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
        let absenceListSQL = "SELECT * FROM ABSENCESLIST WHERE studentID = '\(studentID)' AND rosterID = '\(rosterID)' AND day = '\(date.getCurrentDay())' AND month = '\(date.getCurrentMonth())' AND year = '\(date.getCurrentYear())'"
        let signOutSQL = "SELECT * FROM SIGNOUTS WHERE  studentID = '\(studentID)' AND rosterID = '\(rosterID)' AND day = '\(date.getCurrentDay())' AND month = '\(date.getCurrentMonth())' AND year = '\(date.getCurrentYear())'"
        let result1 = database.search(absenceListSQL)
        result1.next()

        let result2 = database.search(signOutSQL)
        result2.next()
        if (result1.hasAnotherRow() || result2.hasAnotherRow()) {
            scheduleButton.enabled = false
            unscheduledButton.enabled = false
            instructorButton.enabled = false
        }
        if (!result1.hasAnotherRow()) {
            unscheduleButton.enabled = false
        }
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
        if (scheduleAbsence() && signOut(2)) {
            back()
        }
    }

    @IBAction func unscheduledAbsence(sender: AnyObject) {
        //perform an instructor signout and mark it as unscheduled absence
        if (scheduleAbsence() && signOut(3)) {
            back()
        }
    }

    @IBAction func instructorSignOut(sender: AnyObject) {
        if (signOut(4)) {
            back()
        }
    }

    private func back() {
        performSegueWithIdentifier("ReturnToTodayRosterFromEditAttendance", sender: self)

    }

    @IBAction func unscheduleAbsence(sender: AnyObject) {
        let deleteAbsenceListSQL = "DELETE FROM ABSENCESLIST WHERE studentID = '\(studentID)' AND rosterID = '\(rosterID)' AND day = '\(date.getCurrentDay())' AND month = '\(date.getCurrentMonth())' AND year = '\(date.getCurrentYear())'"
        let deleteSignOutSQL = "DELETE FROM SIGNOUTS WHERE  studentID = '\(studentID)' AND rosterID = '\(rosterID)' AND day = '\(date.getCurrentDay())' AND month = '\(date.getCurrentMonth())' AND year = '\(date.getCurrentYear())'"
        let result1 = database.update(deleteAbsenceListSQL)
        let result2 = database.update(deleteSignOutSQL)
        if (result1 && result2) {
            back()
        }
    }

    private func scheduleAbsence() -> Bool {
        let insertSQL = "INSERT INTO ABSENCESLIST (studentFirstName, studentLastName, studentID, rosterID, day, month, year) VALUES ('\(studentFirstName)', '\(studentLastName)', '\(studentID)', '\(rosterID)', '\(date.getCurrentDay())', '\(date.getCurrentMonth())', '\(date.getCurrentYear())')"
        return database.update(insertSQL)
    }

    private func signOut(signOutType: Int) -> Bool {
        var pickUpHour = roster.getPickUpHour()
        var pickUpMinute = roster.getPickUpMinute()
        if (signOutType == 4) {
            date = Date()
            pickUpHour = date.getCurrentHour()
            pickUpMinute = date.getCurrentMinute()
        }
        let insertSQL = "INSERT INTO SIGNOUTS (studentID, rosterID, signOutGuardian, rosterType, signOutType, day, month, year, hour, minute) VALUES ('\(studentID)', '\(rosterID)', 'Instructor', '\(roster.getRosterType())', '\(signOutType)', '\(date.getCurrentDay())', '\(date.getCurrentMonth())', '\(date.getCurrentYear())', '\(pickUpHour)', '\(pickUpMinute)')"
        return database.update(insertSQL)
    }
}
