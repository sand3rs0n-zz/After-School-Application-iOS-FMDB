//
//  EditTodayAttendanceViewController.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 2/15/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import UIKit

class EditTodayAttendanceViewController: UIViewController {
    private var editTodayAttendanceModel = EditTodayAttendanceModel()
    @IBOutlet weak var scheduleButton: UIButton!
    @IBOutlet weak var unscheduledButton: UIButton!
    @IBOutlet weak var instructorButton: UIButton!
    @IBOutlet weak var unscheduleButton: UIButton!
    @IBOutlet weak var cancelSignOutButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        editTodayAttendanceModel.getRosters()
        let date = editTodayAttendanceModel.getDate()
        let absenceListSQL = "SELECT * FROM ABSENCESLIST WHERE studentID = '\(editTodayAttendanceModel.getStudentID())' AND rosterID = '\(editTodayAttendanceModel.getRosterID())' AND day = '\(date.getCurrentDay())' AND month = '\(date.getCurrentMonth())' AND year = '\(date.getCurrentYear())'"
        let signOutSQL = "SELECT * FROM SIGNOUTS WHERE  studentID = '\(editTodayAttendanceModel.getStudentID())' AND rosterID = '\(editTodayAttendanceModel.getRosterID())' AND day = '\(date.getCurrentDay())' AND month = '\(date.getCurrentMonth())' AND year = '\(date.getCurrentYear())'"
        let result1 = database.search(absenceListSQL)
        result1.next()
        let result2 = database.search(signOutSQL)
        result2.next()
        if (result1.hasAnotherRow() || result2.hasAnotherRow()) {
            disableButton(scheduleButton)
            disableButton(unscheduledButton)
            disableButton(instructorButton)
        }
        if (!result1.hasAnotherRow()) {
            disableButton(unscheduleButton)
        }
        if (!result2.hasAnotherRow() || result1.hasAnotherRow()) {
            disableButton(cancelSignOutButton)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func disableButton(button: UIButton) {
        button.enabled = false
        button.backgroundColor = UIColor.whiteColor()
        button.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Disabled)
    }

    func setStudentID(studentID: Int) {
        editTodayAttendanceModel.setStudentID(studentID)
    }
    func setStudentFirstName(studentFirstName: String) {
        editTodayAttendanceModel.setStudentFirstName(studentFirstName)
    }
    func setStudentLastName(studentLastName: String) {
        editTodayAttendanceModel.setStudentLastName(studentLastName)
    }
    func setRosterID(rosterID: Int) {
        editTodayAttendanceModel.setRosterID(rosterID)
    }

    @IBAction func scheduleAbsenceToday(sender: AnyObject) {
        let result1 = scheduleAbsence()
        let result2 = signOut(2)
        if (result1 && result2) {
            back()
        }  else if (!result1) {
            let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Schedule Absence")
            errorAlert.displayError()
        } else if (!result2) {
            let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Sign Out Student")
            errorAlert.displayError()
        }
    }

    @IBAction func unscheduledAbsence(sender: AnyObject) {
        let result1 = scheduleAbsence()
        let result2 = signOut(3)
        if (result1 && result2) {
            back()
        } else if (!result1) {
            let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Schedule Absence")
            errorAlert.displayError()
        } else if (!result2) {
            let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Sign Out Student")
            errorAlert.displayError()
        }
    }

    @IBAction func instructorSignOut(sender: AnyObject) {
        if (signOut(4)) {
            back()
        } else {
            let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Sign Student Out")
            errorAlert.displayError()
        }
    }

    @IBAction func cancelSignOut(sender: AnyObject) {
        let date = editTodayAttendanceModel.getDate()
        let deleteSignOutSQL = "DELETE FROM SIGNOUTS WHERE  studentID = '\(editTodayAttendanceModel.getStudentID())' AND rosterID = '\(editTodayAttendanceModel.getRosterID())' AND day = '\(date.getCurrentDay())' AND month = '\(date.getCurrentMonth())' AND year = '\(date.getCurrentYear())'"
        let result = database.update(deleteSignOutSQL)
        if (result) {
            back()
        } else if (!result) {
            let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Delete SignOut From SignOuts Database")
            errorAlert.displayError()
        }
    }

    private func back() {
        performSegueWithIdentifier("ReturnToTodayRosterFromEditAttendance", sender: self)

    }

    @IBAction func unscheduleAbsence(sender: AnyObject) {
        let date = editTodayAttendanceModel.getDate()
        let deleteAbsenceListSQL = "DELETE FROM ABSENCESLIST WHERE studentID = '\(editTodayAttendanceModel.getStudentID())' AND rosterID = '\(editTodayAttendanceModel.getRosterID())' AND day = '\(date.getCurrentDay())' AND month = '\(date.getCurrentMonth())' AND year = '\(date.getCurrentYear())'"
        let deleteSignOutSQL = "DELETE FROM SIGNOUTS WHERE  studentID = '\(editTodayAttendanceModel.getStudentID())' AND rosterID = '\(editTodayAttendanceModel.getRosterID())' AND day = '\(date.getCurrentDay())' AND month = '\(date.getCurrentMonth())' AND year = '\(date.getCurrentYear())'"
        let result1 = database.update(deleteAbsenceListSQL)
        let result2 = database.update(deleteSignOutSQL)
        if (result1 && result2) {
            back()
        } else if (!result1) {
            let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Unschedule Absence")
            errorAlert.displayError()
        } else if (!result2) {
            let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Delete SignOut From SignOuts Database")
            errorAlert.displayError()
        }
    }

    private func scheduleAbsence() -> Bool {
        let date = editTodayAttendanceModel.getDate()
        let insertSQL = "INSERT INTO ABSENCESLIST (studentFirstName, studentLastName, studentID, rosterID, day, month, year) VALUES ('\(editTodayAttendanceModel.getStudentFirstName())', '\(editTodayAttendanceModel.getStudentLastName())', '\(editTodayAttendanceModel.getStudentID())', '\(editTodayAttendanceModel.getRosterID())', '\(date.getCurrentDay())', '\(date.getCurrentMonth())', '\(date.getCurrentYear())')"
        return database.update(insertSQL)
    }

    private func signOut(signOutType: Int) -> Bool {
        var pickUpHour = editTodayAttendanceModel.getRoster().getPickUpHour()
        var pickUpMinute = editTodayAttendanceModel.getRoster().getPickUpMinute()
        let date = editTodayAttendanceModel.getDate()
        if (signOutType == 4) {
            editTodayAttendanceModel.setDate(Date())
            pickUpHour = editTodayAttendanceModel.getDate().getCurrentHour()
            pickUpMinute = editTodayAttendanceModel.getDate().getCurrentMinute()
        }
        let insertSQL = "INSERT INTO SIGNOUTS (studentID, rosterID, signOutGuardian, rosterType, signOutType, day, month, year, hour, minute) VALUES ('\(editTodayAttendanceModel.getStudentID())', '\(editTodayAttendanceModel.getRosterID())', 'Instructor', '\(editTodayAttendanceModel.getRoster().getRosterType())', '\(signOutType)', '\(date.getCurrentDay())', '\(date.getCurrentMonth())', '\(date.getCurrentYear())', '\(pickUpHour)', '\(pickUpMinute)')"
        return database.update(insertSQL)
    }
}
