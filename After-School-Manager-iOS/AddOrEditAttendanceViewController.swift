//
//  AddOrEditAttendanceViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 1/22/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class AddOrEditAttendanceViewController: UIViewController {
    private var addOrEditAttendanceModel = AddOrEditAttendanceModel()

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

    override func viewDidLoad() {
        super.viewDidLoad()
        addOrEditAttendanceModel.setWeek([monday, tuesday, wednesday, thursday, friday, saturday, sunday])

        self.titleBar.title = addOrEditAttendanceModel.getTitleValue()
        self.updateAttendanceButton!.setTitle(addOrEditAttendanceModel.getButtonText(), forState: .Normal)

        let results = database.search("SELECT * FROM ROSTERS WHERE rosterID = '\(addOrEditAttendanceModel.getRosterID())'")
        results.next()
        rosterName.text = results.stringForColumn("name")
        addOrEditAttendanceModel.setRosterType(Int(results.intForColumn("rosterType")))


        //Xcode's white background is apparently not UIColor.whiteColor() so this forces the button to be white, allowing for proper toggles
        for (var i = 0; i < 7; i++) {
            let dayOfWeek = addOrEditAttendanceModel.getWeek(i)
            dayOfWeek.backgroundColor = UIColor.whiteColor()
            dayOfWeek.setTitleColor(UIColor.darkTextColor(), forState: UIControlState.Normal)
        }

        if (addOrEditAttendanceModel.getRosterType() == 0) {
            let date = Date(day: Int(results.intForColumn("startDay")), month: Int(results.intForColumn("startMonth")), year: Int(results.intForColumn("startYear")))
            dayCampButtons(date)
        }

        if (addOrEditAttendanceModel.getState() == 0 || addOrEditAttendanceModel.getState() == 2) {
            fillEditPage()
        } else if (addOrEditAttendanceModel.getState() == 1 || addOrEditAttendanceModel.getState() == 3) {
            fillAddPage()
        }
        results.close()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func dayCampButtons(date: Date) {
        addOrEditAttendanceModel.setWeekday(date.getWeekday())
        for (var i = 0; i < 7; i++) {
            if (addOrEditAttendanceModel.getWeek(i).titleLabel?.text! == addOrEditAttendanceModel.getWeekday().capitalizedString) {
                if (addOrEditAttendanceModel.getState() == 1 || addOrEditAttendanceModel.getState() == 3) {
                    toggleColor(addOrEditAttendanceModel.getWeek(i))
                    addOrEditAttendanceModel.setWeekBool(1, i: i)
                }
            } else {
                addOrEditAttendanceModel.getWeek(i).hidden = true
            }
        }
    }

    private func fillAddPage() {
        addOrEditAttendanceModel.getStudent()
        studentName.text =  addOrEditAttendanceModel.getStudentName()
        deleteFromRosterButton.hidden = true
    }

    private func fillEditPage() {
        addOrEditAttendanceModel.getStudentRoster()
        let schedule = addOrEditAttendanceModel.getSchedule()
        studentName.text = (schedule.getStudentFirstName() + " " + schedule.getStudentLastName())

        if (schedule.getMonday() == 1) {
            toggleColor(monday)
            addOrEditAttendanceModel.setWeekBool(1, i: 0)
        }
        if (schedule.getTuesday() == 1) {
            toggleColor(tuesday)
            addOrEditAttendanceModel.setWeekBool(1, i: 1)
        }
        if (schedule.getWednesday() == 1) {
            toggleColor(wednesday)
            addOrEditAttendanceModel.setWeekBool(1, i: 2)
        }
        if (schedule.getThursday() == 1) {
            toggleColor(thursday)
            addOrEditAttendanceModel.setWeekBool(1, i: 3)
        }
        if (schedule.getFriday() == 1) {
            toggleColor(friday)
            addOrEditAttendanceModel.setWeekBool(1, i: 4)
        }
        if (schedule.getSaturday() == 1) {
            toggleColor(saturday)
            addOrEditAttendanceModel.setWeekBool(1, i: 5)
        }
        if (schedule.getSunday() == 1) {
            toggleColor(sunday)
            addOrEditAttendanceModel.setWeekBool(1, i: 6)
        }
    }

    func setState(state: Int) {
        addOrEditAttendanceModel.setState(state)
    }
    func setTitleValue(navTitle: String) {
        addOrEditAttendanceModel.setTitleValue(navTitle)
    }
    func setButtonText(buttonText: String) {
        addOrEditAttendanceModel.setButtonText(buttonText)
    }
    func setStudentId(studentID: Int) {
        addOrEditAttendanceModel.setStudentID(studentID)
    }
    func setRosterId(rosterID: Int) {
        addOrEditAttendanceModel.setRosterID(rosterID)
    }

    @IBAction func backButton(sender: AnyObject) {
        back()
    }

    private func back() {
        if (addOrEditAttendanceModel.getState() == 0) {
            performSegueWithIdentifier("EditStudentFromAllRostersUnwind", sender: self)
        } else if (addOrEditAttendanceModel.getState() == 1) {
            performSegueWithIdentifier("ReturnToSelectStudentToAddToRosterUnwind", sender: self)
        } else if (addOrEditAttendanceModel.getState() == 2) {
            performSegueWithIdentifier("ReturnToRosterHistoryUnwind", sender: self)
        } else if (addOrEditAttendanceModel.getState() == 3) {
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
        if (addOrEditAttendanceModel.getWeekBool(day) == 1) {
            addOrEditAttendanceModel.setWeekBool(0, i: day)
        } else {
            addOrEditAttendanceModel.setWeekBool(1, i: day)
        }
        let dayOfWeek = addOrEditAttendanceModel.getWeek(day)
        toggleColor(dayOfWeek)
    }

    private func toggleColor(dayOfWeek: UIButton) {
        // Toggle attendance colors
        if(dayOfWeek.backgroundColor == UIColor.whiteColor()) {
            dayOfWeek.backgroundColor = UIColor.redColor()
            dayOfWeek.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        } else {
            dayOfWeek.backgroundColor = UIColor.whiteColor()
            dayOfWeek.setTitleColor(UIColor.darkTextColor(), forState: UIControlState.Normal)
        }
    }

    @IBAction func updateAttendance(sender: AnyObject) {
        var name = studentName.text?.componentsSeparatedByString(" ")
        var insertSQL = ""
        addOrEditAttendanceModel.getWeekBool(0)
        if (addOrEditAttendanceModel.getState() == 0 || addOrEditAttendanceModel.getState() == 2) {
            insertSQL = "UPDATE STUDENTROSTERS SET studentFirstName = '\(name![0])', studentLastName = '\(name![1])', studentID = '\(addOrEditAttendanceModel.getStudentID())', rosterID = '\(addOrEditAttendanceModel.getRosterID())', monday = '\(addOrEditAttendanceModel.getWeekBool(0))', tuesday = '\(addOrEditAttendanceModel.getWeekBool(1))', wednesday = '\(addOrEditAttendanceModel.getWeekBool(2))', thursday = '\(addOrEditAttendanceModel.getWeekBool(3))', friday = '\(addOrEditAttendanceModel.getWeekBool(4))', saturday = '\(addOrEditAttendanceModel.getWeekBool(5))', sunday = '\(addOrEditAttendanceModel.getWeekBool(6))' WHERE rosterID = '\(addOrEditAttendanceModel.getRosterID())' AND studentID = '\(addOrEditAttendanceModel.getStudentID())'"
        } else if (addOrEditAttendanceModel.getState() == 1 || addOrEditAttendanceModel.getState() == 3) {
            insertSQL = "INSERT INTO STUDENTROSTERS (studentFirstName, studentLastName, rosterName, studentID, rosterID, monday, tuesday, wednesday, thursday, friday, saturday, sunday) VALUES ('\(name![0])', '\(name![1])', '\(addOrEditAttendanceModel.getRosterName())', '\(addOrEditAttendanceModel.getStudentID())', '\(addOrEditAttendanceModel.getRosterID())', '\(addOrEditAttendanceModel.getWeekBool(0))', '\(addOrEditAttendanceModel.getWeekBool(1))', '\(addOrEditAttendanceModel.getWeekBool(2))', '\(addOrEditAttendanceModel.getWeekBool(3))', '\(addOrEditAttendanceModel.getWeekBool(4))', '\(addOrEditAttendanceModel.getWeekBool(5))', '\(addOrEditAttendanceModel.getWeekBool(6))')"
        }
        let result = database.update(insertSQL)

        if (result) {
            self.back()
        } else {
            let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Add Attendance to StudentRosters Database")
            errorAlert.displayError()
        }
    }

    @IBAction func deleteFromRoster(sender: AnyObject) {
        let myAlertController = UIAlertController(title: "Remove Student from Roster", message: "Are you sure you want to remove the student from this roster?", preferredStyle: .Alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Do some stuff
        }
        myAlertController.addAction(cancelAction)

        let nextAction = UIAlertAction(title: "Delete", style: .Default) { action -> Void in
            let deleteSQL = "DELETE FROM STUDENTROSTERS WHERE rosterID = '\(self.addOrEditAttendanceModel.getRosterID())' AND studentID = '\(self.addOrEditAttendanceModel.getStudentID())'"
            let deleteSignOuts = "DELETE FROM SIGNOUTS WHERE rosterID = '\(self.addOrEditAttendanceModel.getRosterID())' AND studentID = '\(self.addOrEditAttendanceModel.getStudentID())'"
            let result1 = database.update(deleteSQL)
            let result2 = database.update(deleteSignOuts)
            if (result1 && result2) {
                self.back()
            } else if (!result1) {
                let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Delete Student From StudentRosters Database")
                errorAlert.displayError()
            } else if (!result2) {
                let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Delete SignOuts From StudentRosters Database")
                errorAlert.displayError()
            }
        }
        myAlertController.addAction(nextAction)
        presentViewController(myAlertController, animated: true, completion: nil)
    }
}
