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
    private var absence = Absence()
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
        } else if (state == 0) {
            deleteAbsenceButton.hidden = true
        }
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

    func setStudentID(id: Int) {
        studentID = id
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

        let path = Util.getPath("AfterSchoolData.sqlite")
        let contactDB = FMDatabase(path: path)

        if contactDB.open() {
            var insertSQL = ""
            if (state == 1) {
                insertSQL = "UPDATE ABSENCESLIST SET studentFirstName = '\(absence.getStudentFirstName())', studentLastName = '\(absence.getStudentLastName())', studentID = '\(absence.getStudentID())', day = '\(Int(dateArr[1])!)', month = '\(Int(dateArr[0])!)', year = '\(Int(dateArr[2])!)' WHERE absenceID = '\(absence.getAbsenceID())'"
                //update other tables
            } else if (state == 0) {
                insertSQL = "INSERT INTO ABSENCESLIST (studentFirstName, studentLastName, studentID, day, month, year) VALUES ('\(studentFirstName)', '\(studentLastName)', '\(studentID)', '\(Int(dateArr[1])!)', '\(Int(dateArr[0])!)', '\(Int(dateArr[2])!)')"
            }
            let result = contactDB.executeUpdate(insertSQL, withArgumentsInArray: nil)

            if !result {
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                print("Successful")
                back()
            }
            contactDB.close()
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
    }

    @IBAction func deleteAbsence(sender: AnyObject) {
        let myAlertController = UIAlertController(title: "Delete Absence", message: "Are you sure you want to delete this scheduled absence?", preferredStyle: .Alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Do some stuff
        }
        myAlertController.addAction(cancelAction)

        let nextAction = UIAlertAction(title: "Delete", style: .Default) { action -> Void in
            let path = Util.getPath("AfterSchoolData.sqlite")
            let contactDB = FMDatabase(path: path)

            if contactDB.open() {
                let insertSQL = "DELETE FROM ABSENCESLIST WHERE absenceID = '\(self.absence.getAbsenceID())'"
                let result = contactDB.executeUpdate(insertSQL, withArgumentsInArray: nil)
                if !result {
                    print("Error: \(contactDB.lastErrorMessage())")
                } else {
                    print("Deleted")
                }
                contactDB.close()
                self.back()
            }
        }
        myAlertController.addAction(nextAction)
        presentViewController(myAlertController, animated: true, completion: nil)
        //also delete all relevant info
    }
}
