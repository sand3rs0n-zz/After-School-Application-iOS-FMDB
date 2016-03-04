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
    @IBOutlet weak var rosterName: UILabel!

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
        let results = database.search("SELECT name FROM ROSTERS WHERE rosterID = '\(rosterID)'")
        results.next()
        rosterName.text = results.stringForColumn("name")
        results.close()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func fillAddPage() {
        let querySQL = "SELECT * FROM STUDENTPROFILES WHERE studentID = '\(studentID)'"
        let results = database.search(querySQL)
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
        studentName.text = (student.getFirstName() + " " + student.getLastName())
        deleteFromRosterButton.hidden = true
    }

    private func fillEditPage() {
        let querySQL = "SELECT * FROM STUDENTROSTERS WHERE rosterID = '\(rosterID)' AND studentID = '\(studentID)'"
        let results = database.search(querySQL)
        results.next()
        schedule.setStudentFirstName(results.stringForColumn("studentFirstName"))
        schedule.setStudentLastName(results.stringForColumn("studentLastName"))
        schedule.setRosterName(results.stringForColumn("rosterName"))
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
        studentName.text = (schedule.getStudentFirstName() + " " + schedule.getStudentLastName())

        if (schedule.getMonday() == 1) {
            toggleColor(monday)
            weekBool[0] = 1
        }
        if (schedule.getTuesday() == 1) {
            toggleColor(tuesday)
            weekBool[1] = 1
        }
        if (schedule.getWednesday() == 1) {
            toggleColor(wednesday)
            weekBool[2] = 1
        }
        if (schedule.getThursday() == 1) {
            toggleColor(thursday)
            weekBool[3] = 1
        }
        if (schedule.getFriday() == 1) {
            toggleColor(friday)
            weekBool[4] = 1
        }
        if (schedule.getSaturday() == 1) {
            toggleColor(saturday)
            weekBool[5] = 1
        }
        if (schedule.getSunday() == 1) {
            toggleColor(sunday)
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
        toggleColor(dayOfWeek)
    }

    private func toggleColor(dayOfWeek: UIButton) {
        // Toggle attendance colors
        if(dayOfWeek.backgroundColor == UIColor.groupTableViewBackgroundColor()) {
            dayOfWeek.backgroundColor = UIColor.redColor()
            dayOfWeek.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        } else {
            dayOfWeek.backgroundColor = UIColor.groupTableViewBackgroundColor()
            dayOfWeek.setTitleColor(UIColor.darkTextColor(), forState: UIControlState.Normal)
        }
    }

    @IBAction func updateAttendance(sender: AnyObject) {
        var name = studentName.text?.componentsSeparatedByString(" ")
        var insertSQL = ""
        if (state == 0 || state == 2) {
            insertSQL = "UPDATE STUDENTROSTERS SET studentFirstName = '\(name![0])', studentLastName = '\(name![1])', studentID = '\(studentID)', rosterID = '\(rosterID)', monday = '\(weekBool[0])', tuesday = '\(weekBool[1])', wednesday = '\(weekBool[2])', thursday = '\(weekBool[3])', friday = '\(weekBool[4])', saturday = '\(weekBool[5])', sunday = '\(weekBool[6])' WHERE rosterID = '\(rosterID)' AND studentID = '\(studentID)'"
        } else if (state == 1 || state == 3) {
            insertSQL = "INSERT INTO STUDENTROSTERS (studentFirstName, studentLastName, rosterName, studentID, rosterID, monday, tuesday, wednesday, thursday, friday, saturday, sunday) VALUES ('\(name![0])', '\(name![1])', '\(schedule.getRosterName())', '\(studentID)', '\(rosterID)', '\(weekBool[0])', '\(weekBool[1])', '\(weekBool[2])', '\(weekBool[3])', '\(weekBool[4])', '\(weekBool[5])', '\(weekBool[6])')"
        }
        let result = database.update(insertSQL)

        if (result) {
            self.back()
        }
    }

    @IBAction func deleteFromRoster(sender: AnyObject) {
        let myAlertController = UIAlertController(title: "Remove Student from Roster", message: "Are you sure you want to remove the student from this roster?", preferredStyle: .Alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Do some stuff
        }
        myAlertController.addAction(cancelAction)

        let nextAction = UIAlertAction(title: "Delete", style: .Default) { action -> Void in
            let deleteSQL = "DELETE FROM STUDENTROSTERS WHERE rosterID = '\(self.rosterID)' AND studentID = '\(self.studentID)'"
            let deleteSignOuts = "DELETE FROM SIGNOUTS WHERE rosterID = '\(self.rosterID)' AND studentID = '\(self.studentID)'"
            let result1 = database.update(deleteSQL)
            let result2 = database.update(deleteSignOuts)
            if (result1 && result2) {
                self.back()
            }
        }
        myAlertController.addAction(nextAction)
        presentViewController(myAlertController, animated: true, completion: nil)
    }
}
