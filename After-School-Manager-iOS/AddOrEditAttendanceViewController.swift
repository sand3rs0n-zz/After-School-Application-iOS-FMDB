//
//  AddOrEditAttendanceViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 1/22/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class AddOrEditAttendanceViewController: UIViewController {

    private var state = 0

    @IBOutlet weak var monday: UIButton!
    @IBOutlet weak var tuesday: UIButton!
    @IBOutlet weak var wednesday: UIButton!
    @IBOutlet weak var thursday: UIButton!
    @IBOutlet weak var friday: UIButton!
    @IBOutlet weak var saturday: UIButton!
    @IBOutlet weak var sunday: UIButton!

    @IBOutlet weak var deleteFromRosterButton: UIButton!
    @IBOutlet weak var updateAttendanceButton: UIButton!
    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var studentName: UILabel!

    private var week: [UIButton] = []
    private var weekBool = [0, 0, 0, 0, 0, 0, 0]
    private var navTitle = ""
    private var studentID = 0
    private var rosterID = 0
    private var schedule = StudentRoster()
    private var student = Student()
    private var buttonText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        week = [monday, tuesday, wednesday, thursday, friday, saturday, sunday]

        self.titleBar.title = navTitle
        self.updateAttendanceButton!.setTitle(buttonText, forState: .Normal)

        if (state == 0 || state == 2) {
            fillEditPage()
        } else if (state == 1 || state == 3) {
            fillAddPage()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func fillAddPage() {
        let path = Util.getPath("AfterSchoolData.sqlite")
        let contactDB = FMDatabase(path: path)

        if contactDB.open() {
            let querySQL = "SELECT * FROM STUDENTPROFILES WHERE studentID = '\(studentID)'"

            let results = contactDB.executeQuery(querySQL, withArgumentsInArray: nil)
            results.next()
            student.setStudentID(Int(results.intForColumn("studentID")))
            student.setFirstName(results.stringForColumn("firstName"))
            student.setLastName(results.stringForColumn("lastName"))
            student.setActive(Int(results.intForColumn("active")))
            student.setSchool(results.stringForColumn("school"))
            student.setBirthDay(Int(results.intForColumn("birthDay")))
            student.setBirthMonth(Int(results.intForColumn("birthMonth")))
            student.setBirthYear(Int(results.intForColumn("birthYear")))

            results.close()
            contactDB.close()
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        studentName.text = (student.getFirstName() + " " + student.getLastName())

        deleteFromRosterButton.hidden = true
    }

    private func fillEditPage() {
        let path = Util.getPath("AfterSchoolData.sqlite")
        let contactDB = FMDatabase(path: path)

        if contactDB.open() {
            let querySQL = "SELECT * FROM STUDENTROSTERS WHERE rosterID = '\(rosterID)' AND studentID = '\(studentID)'"
            let results = contactDB.executeQuery(querySQL, withArgumentsInArray: nil)
            results.next()
            schedule.setStudentFirstName(results.stringForColumn("studentFirstName"))
            schedule.setStudentLastName(results.stringForColumn("studentLastName"))
            schedule.setStudentID(Int(results.intForColumn("studentID")))
            schedule.setRosterID(Int(results.intForColumn("rosterID")))
            schedule.setMonday(Int(results.intForColumn("monday")))
            schedule.setTuesday(Int(results.intForColumn("tuesday")))
            schedule.setWednesday(Int(results.intForColumn("wednesday")))
            schedule.setThursday(Int(results.intForColumn("thursday")))
            schedule.setFriday(Int(results.intForColumn("friday")))
            schedule.setSaturday(Int(results.intForColumn("saturday")))
            schedule.setSunday(Int(results.intForColumn("sunday")))
            results.close()
            contactDB.close()
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        studentName.text = (schedule.getStudentFirstName() + " " + schedule.getStudentLastName())

        if (schedule.getMonday() == 1) {
            monday.backgroundColor = UIColor.greenColor()
            weekBool[0] = 1
        }
        if (schedule.getTuesday() == 1) {
            tuesday.backgroundColor = UIColor.greenColor()
            weekBool[1] = 1
        }
        if (schedule.getWednesday() == 1) {
            wednesday.backgroundColor = UIColor.greenColor()
            weekBool[2] = 1
        }
        if (schedule.getThursday() == 1) {
            thursday.backgroundColor = UIColor.greenColor()
            weekBool[3] = 1
        }
        if (schedule.getFriday() == 1) {
            friday.backgroundColor = UIColor.greenColor()
            weekBool[4] = 1
        }
        if (schedule.getSaturday() == 1) {
            saturday.backgroundColor = UIColor.greenColor()
            weekBool[5] = 1
        }
        if (schedule.getSunday() == 1) {
            sunday.backgroundColor = UIColor.greenColor()
            weekBool[6] = 1
        }
    }

    func setState(state: Int) {
        self.state = state
    }

    func setTitleValue(navTitle: String) {
        self.navTitle = navTitle
    }

    func setButtonText(buttonText: String) {
        self.buttonText = buttonText
    }

    func setStudentId(studentID: Int) {
        self.studentID = studentID
    }

    func setRosterId(rosterID: Int) {
        self.rosterID = rosterID
    }

    @IBAction func backButton(sender: AnyObject) {
        back()
    }

    private func back() {
        if (state == 0) {
            performSegueWithIdentifier("EditStudentFromAllRostersUnwind", sender: self)
        } else if (state == 1) {
            performSegueWithIdentifier("ReturnToSelectStudentToAddToRosterUnwind", sender: self)
        } else if (state == 2) {
            performSegueWithIdentifier("ReturnToRosterHistoryUnwind", sender: self)
        } else if (state == 3) {
            performSegueWithIdentifier("ReturnToSelectRosterToAddStudentUnwind", sender: self)
        }
    }

    @IBAction func mondaySelect(sender: AnyObject) {
        daySelected(0)
    }
    @IBAction func tuesdaySelect(sender: AnyObject) {
        daySelected(1)
    }
    @IBAction func wednesdaySelect(sender: AnyObject) {
        daySelected(2)
    }
    @IBAction func thursdaySelect(sender: AnyObject) {
        daySelected(3)
    }
    @IBAction func fridaySelect(sender: AnyObject) {
        daySelected(4)
    }
    @IBAction func saturdaySelect(sender: AnyObject) {
        daySelected(5)
    }
    @IBAction func sundaySelect(sender: AnyObject) {
        daySelected(6)
    }

    private func daySelected(day: Int) {
        if (weekBool[day] == 1) {
            weekBool[day] = 0
        } else {
            weekBool[day] = 1
        }
        let dayOfWeek = week[day]
        if (dayOfWeek.backgroundColor == UIColor.greenColor()) {
            dayOfWeek.backgroundColor = UIColor.grayColor()
        } else {
            dayOfWeek.backgroundColor = UIColor.greenColor()
        }
    }

    @IBAction func updateAttendance(sender: AnyObject) {
        //save/update selecetd student
        //loop through week to find which ones are "selected"
        var name = studentName.text?.componentsSeparatedByString(" ")

        let path = Util.getPath("AfterSchoolData.sqlite")
        let contactDB = FMDatabase(path: path)
        var insertSQL = ""

        if contactDB.open() {
                if (state == 0 || state == 2) {
                    insertSQL = "UPDATE STUDENTROSTERS SET studentFirstName = '\(name![0])', studentLastName = '\(name![1])', studentID = '\(studentID)', rosterID = '\(rosterID)', monday = '\(weekBool[0])', tuesday = '\(weekBool[1])', wednesday = '\(weekBool[2])', thursday = '\(weekBool[3])', friday = '\(weekBool[4])', saturday = '\(weekBool[5])', sunday = '\(weekBool[6])' WHERE rosterID = '\(rosterID)' AND studentID = '\(studentID)'"
                } else if (state == 1 || state == 3) {
                    insertSQL = "INSERT INTO STUDENTROSTERS (studentFirstName, studentLastName, studentID, rosterID, monday, tuesday, wednesday, thursday, friday, saturday, sunday) VALUES ('\(name![0])', '\(name![1])', '\(studentID)', '\(rosterID)', '\(weekBool[0])', '\(weekBool[1])', '\(weekBool[2])', '\(weekBool[3])', '\(weekBool[4])', '\(weekBool[5])', '\(weekBool[6])')"
                }
            let result = contactDB.executeUpdate(insertSQL, withArgumentsInArray: nil)

            if !result {
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                print("Successful")
            }
            contactDB.close()
            self.back()
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }

    }

    @IBAction func deleteFromRoster(sender: AnyObject) {
        let myAlertController = UIAlertController(title: "Remove Student from Roster", message: "Are you sure you want to remove the student from this roster?", preferredStyle: .Alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Do some stuff
        }
        myAlertController.addAction(cancelAction)

        let nextAction = UIAlertAction(title: "Delete", style: .Default) { action -> Void in
            let path = Util.getPath("AfterSchoolData.sqlite")
            let contactDB = FMDatabase(path: path)

            if contactDB.open() {
                let deleteSQL = "DELETE FROM STUDENTROSTERS WHERE rosterID = '\(self.rosterID)' AND studentID = '\(self.studentID)'"
                let result = contactDB.executeUpdate(deleteSQL, withArgumentsInArray: nil)
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
    }
}
