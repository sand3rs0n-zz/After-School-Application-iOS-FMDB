//
//  ScheduleAbsenceViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/15/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class ScheduleAbsenceViewController: UIViewController {
    private var scheduleAbsenceModel = ScheduleAbsenceModel()
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var scheduleAbsenceButton: UIButton!
    @IBOutlet weak var deleteAbsenceButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        self.scheduleAbsenceButton!.setTitle(scheduleAbsenceModel.getButtonText(), forState: .Normal)
        if (scheduleAbsenceModel.getState() == 1) {
            scheduleAbsenceModel.initializeAbsence()
            fillValues()
        } else if (scheduleAbsenceModel.getState() == 0) {
            deleteAbsenceButton.hidden = true
        }
        scheduleAbsenceModel.getRosters()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func fillValues() {
        let absence = scheduleAbsenceModel.getAbsence()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = String(absence.getDay()) + "/" + String(absence.getMonth()) + "/" + String(absence.getYear())
        let convertedDate = dateFormatter.dateFromString(dateString)
        datePicker.date = convertedDate!
    }

    func setAbsence(absence: Absence) {
        scheduleAbsenceModel.setAbsence(absence)
    }
    func setState(state: Int) {
        scheduleAbsenceModel.setState(state)
    }
    func setButtonText(text: String) {
        scheduleAbsenceModel.setButtonText(text)
    }
    func setRosterType(rosterType: Int) {
        scheduleAbsenceModel.setRosterType(rosterType)
    }
    func setStudentID(studentID: Int) {
        scheduleAbsenceModel.setStudentID(studentID)
    }
    func setRosterID(rosterID: Int) {
        scheduleAbsenceModel.setRosterID(rosterID)
    }
    func setStudentLastName(name: String) {
        scheduleAbsenceModel.setStudentLastName(name)
    }
    func setStudentFirstName(name: String) {
        scheduleAbsenceModel.setStudentFirstName(name)
    }

    @IBAction func back(sender: AnyObject) {
        back()
    }
    
    private func back() {
        if (scheduleAbsenceModel.getState() == 0) {
            performSegueWithIdentifier("ScheduleAbsenceToStudentSelect", sender: self)
        } else if (scheduleAbsenceModel.getState() == 1) {
            performSegueWithIdentifier("ScheduleAbsenceUnwind", sender: self)
        }
    }

    @IBAction func scheduleOrUpdateAbsence(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let inputDate = dateFormatter.stringFromDate(datePicker.date)
        let dateArr = inputDate.characters.split{$0 == "/"}.map(String.init)

        var absenceListSQL = ""
        var signOutSQL = ""
        if (scheduleAbsenceModel.getState() == 1) {
            let absence = scheduleAbsenceModel.getAbsence()
            absenceListSQL = "UPDATE ABSENCESLIST SET studentFirstName = '\(absence.getStudentFirstName())', studentLastName = '\(absence.getStudentLastName())', studentID = '\(absence.getStudentID())', rosterID = '\(scheduleAbsenceModel.getRosterID())', day = '\(Int(dateArr[1])!)', month = '\(Int(dateArr[0])!)', year = '\(Int(dateArr[2])!)' WHERE absenceID = '\(absence.getAbsenceID())'"
            signOutSQL = "UPDATE SIGNOUTS SET studentID = '\(absence.getStudentID())', rosterID = '\(scheduleAbsenceModel.getRosterID())', signOutGuardian = 'Instructor', rosterType = '\(scheduleAbsenceModel.getRosterType())', signOutType = '2', day = '\(Int(dateArr[1])!)', month = '\(Int(dateArr[0])!)', year = '\(Int(dateArr[2])!)', hour = '\(scheduleAbsenceModel.getPickUpHour())', minute = '\(scheduleAbsenceModel.getPickUpMinute())' WHERE signOutID = '\(scheduleAbsenceModel.getSignOutID())'"
        } else if (scheduleAbsenceModel.getState() == 0) {
            absenceListSQL = "INSERT INTO ABSENCESLIST (studentFirstName, studentLastName, studentID, rosterID, day, month, year) VALUES ('\(scheduleAbsenceModel.getStudentFirstName())', '\(scheduleAbsenceModel.getStudentLastName())', '\(scheduleAbsenceModel.getStudentID())', '\(scheduleAbsenceModel.getRosterID())', '\(Int(dateArr[1])!)', '\(Int(dateArr[0])!)', '\(Int(dateArr[2])!)')"
            signOutSQL = "INSERT INTO SIGNOUTS (studentID, rosterID, signOutGuardian, rosterType, signOutType, day, month, year, hour, minute) VALUES ('\(scheduleAbsenceModel.getStudentID())', '\(scheduleAbsenceModel.getRosterID())', 'Instructor', '\(scheduleAbsenceModel.getRosterType())', '2', '\(Int(dateArr[1])!)', '\(Int(dateArr[0])!)', '\(Int(dateArr[2])!)', '\(scheduleAbsenceModel.getPickUpHour())', '\(scheduleAbsenceModel.getPickUpMinute())')"
        }

        let result1 = database.update(absenceListSQL)
        let result2 = database.update(signOutSQL)
        if (result1 && result2) {
            self.back()
        } else if (!result1) {
            let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Schedule Absence")
            errorAlert.displayError()
        } else if (!result2) {
            let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Sign Student Out")
            errorAlert.displayError()
        }
    }

    @IBAction func deleteAbsence(sender: AnyObject) {
        let myAlertController = UIAlertController(title: "Delete Absence", message: "Are you sure you want to delete this scheduled absence?", preferredStyle: .Alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Do some stuff
        }
        myAlertController.addAction(cancelAction)

        let nextAction = UIAlertAction(title: "Delete", style: .Default) { action -> Void in
            let absenceListSQL = "DELETE FROM ABSENCESLIST WHERE absenceID = '\(self.scheduleAbsenceModel.getAbsence().getAbsenceID())'"
            let signOutSQL = "DELETE FROM SIGNOUTS WHERE signOutID = '\(self.scheduleAbsenceModel.getSignOutID())'"
            let result1 = database.update(absenceListSQL)
            let result2 = database.update(signOutSQL)
            if (result1 && result2) {
                self.back()
            } else if (!result1) {
                let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Delete Absence")
                errorAlert.displayError()
            } else if (!result2) {
                let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Delete SignOut From SignOuts Database")
                errorAlert.displayError()
            }
        }
        myAlertController.addAction(nextAction)
        presentViewController(myAlertController, animated: true, completion: nil)
    }
}
