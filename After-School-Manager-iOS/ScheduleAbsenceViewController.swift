//
//  ScheduleAbsenceViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/15/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class ScheduleAbsenceViewController: UIViewController {

    private var studentID = 0
    private var state = 0
    private var rosterType = 0
    private var rosterID = 0
    private var signOutID = 0
    private var absence = Absence()
    private var roster = Roster()
    private var studentLastName = ""
    private var studentFirstName = ""
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var scheduleAbsenceButton: UIButton!
    @IBOutlet weak var deleteAbsenceButton: UIButton!
    private var buttonText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scheduleAbsenceButton!.setTitle(buttonText, forState: .Normal)
        if (state == 1) {
            fillValues()
            rosterID = absence.getRosterID()
            studentID = absence.getStudentID()
            let signOutSQL = "SELECT * FROM SIGNOUTS WHERE rosterID = '\(rosterID)' AND studentID = '\(studentID)' AND day = '\(absence.getDay())' AND month = '\(absence.getMonth())' AND year = '\(absence.getYear())'"
            let results = database.search(signOutSQL)
            results.next()
            signOutID = Int(results.intForColumn("signOutID"))
            results.close()
        } else if (state == 0) {
            deleteAbsenceButton.hidden = true
        }

        let rostersSQL = "SELECT * FROM ROSTERS WHERE rosterID = '\(rosterID)'"
        let results = database.search(rostersSQL)
        results.next()
        roster.setPickUpHour(Int(results.intForColumn("pickUpHour")))
        roster.setPickUpMinute(Int(results.intForColumn("pickUpMinute")))
        results.close()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func fillValues() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = String(absence.getDay()) + "/" + String(absence.getMonth()) + "/" + String(absence.getYear())
        let convertedDate = dateFormatter.dateFromString(dateString)
        datePicker.date = convertedDate!
    }

    func setAbsence(absence: Absence) {
        self.absence = absence
    }
    func setState(state: Int) {
        self.state = state
    }
    func setButtonText(text: String) {
        self.buttonText = text
    }
    func setRosterType(rosterType: Int) {
        self.rosterType = rosterType
    }
    func setStudentID(studentID: Int) {
        self.studentID = studentID
    }
    func setRosterID(rosterID: Int) {
        self.rosterID = rosterID
    }
    func setStudentLastName(name: String) {
        studentLastName = name
    }

    func setStudentFirstName(name: String) {
        studentFirstName = name
    }

    @IBAction func back(sender: AnyObject) {
        back()
    }
    
    private func back() {
        if (state == 0) {
            performSegueWithIdentifier("ScheduleAbsenceToStudentSelect", sender: self)
        } else if (state == 1) {
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
        if (state == 1) {
            absenceListSQL = "UPDATE ABSENCESLIST SET studentFirstName = '\(absence.getStudentFirstName())', studentLastName = '\(absence.getStudentLastName())', studentID = '\(absence.getStudentID())', rosterID = '\(rosterID)', day = '\(Int(dateArr[1])!)', month = '\(Int(dateArr[0])!)', year = '\(Int(dateArr[2])!)' WHERE absenceID = '\(absence.getAbsenceID())'"
            signOutSQL = "UPDATE SIGNOUTS SET studentID = '\(absence.getStudentID())', rosterID = '\(rosterID)', signOutGuardian = 'Instructor', rosterType = '\(rosterType)', signOutType = '2', day = '\(Int(dateArr[1])!)', month = '\(Int(dateArr[0])!)', year = '\(Int(dateArr[2])!)', hour = '\(roster.getPickUpHour())', minute = '\(roster.getPickUpMinute())' WHERE signOutID = '\(signOutID)'"
        } else if (state == 0) {
            absenceListSQL = "INSERT INTO ABSENCESLIST (studentFirstName, studentLastName, studentID, rosterID, day, month, year) VALUES ('\(studentFirstName)', '\(studentLastName)', '\(studentID)', '\(rosterID)', '\(Int(dateArr[1])!)', '\(Int(dateArr[0])!)', '\(Int(dateArr[2])!)')"
            signOutSQL = "INSERT INTO SIGNOUTS (studentID, rosterID, signOutGuardian, rosterType, signOutType, day, month, year, hour, minute) VALUES ('\(studentID)', '\(rosterID)', 'Instructor', '\(rosterType)', '2', '\(Int(dateArr[1])!)', '\(Int(dateArr[0])!)', '\(Int(dateArr[2])!)', '\(roster.getPickUpHour())', '\(roster.getPickUpMinute())')"
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
            let absenceListSQL = "DELETE FROM ABSENCESLIST WHERE absenceID = '\(self.absence.getAbsenceID())'"
            let signOutSQL = "DELETE FROM SIGNOUTS WHERE signOutID = '\(self.signOutID)'"
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
