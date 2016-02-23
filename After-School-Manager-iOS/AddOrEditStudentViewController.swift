//
//  AddOrEditStudentViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 1/18/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class AddOrEditStudentViewController: UIViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    @IBOutlet weak var school: UITextField!
    @IBOutlet weak var addUpdateButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var addToRoster: UIButton!
    @IBOutlet weak var signOutRecordsButton: UIButton!

    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var active: UISegmentedControl!

    private var updateStudent = false
    private var studentID = 0
    private var student = Student()
    private var guardians = [Guardian]()
    private var contactNumbers = [ContactNumber]()
    private var navTitle = ""
    private var buttonText = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleBar.title = navTitle
        self.addUpdateButton!.setTitle(buttonText, forState: .Normal)
        if (updateStudent) {
            getStudent()
            getGuardians()
            getContactNumbers()
            fillFields()
        } else {
            hideFields()
        }
        // Do any additional setup after loading the view.
    }

    private func getStudent() {
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
    }

    private func getGuardians() {
        let querySQL = "SELECT * FROM GUARDIANS WHERE studentID = '\(studentID)'"
        let results = database.search(querySQL)
        while (results.next()) {
            let cur = Guardian()
            cur.setGuardianID(Int(results.intForColumn("guardianID")))
            cur.setName(results.stringForColumn("name"))
            cur.setStudentID(Int(results.intForColumn("studentID")))
            guardians.append(cur)
        }
        results.close()
    }

    private func getContactNumbers() {
        let querySQL = "SELECT * FROM CONTACTNUMBERS WHERE studentID = '\(studentID)'"
        let results = database.search(querySQL)
        while (results.next()) {
            let cur = ContactNumber()
            cur.setContactID(Int(results.intForColumn("contactID")))
            cur.setName(results.stringForColumn("name"))
            cur.setPhoneNumber(results.stringForColumn("phoneNumber"))
            cur.setStudentID(Int(results.intForColumn("studentID")))
            contactNumbers.append(cur)
        }
        results.close()
    }

    private func fillFields() {
        firstName.text = student.getFirstName()
        lastName.text = student.getLastName()
        school.text = student.getSchool()
        setBirthDate()
        let activeValue = student.getActive()
        if (activeValue == 1) {
            active.selectedSegmentIndex = 0
        } else {
            active.selectedSegmentIndex = 1
        }
    }

    private func hideFields() {
        deleteButton.hidden = true
        addToRoster.hidden = true
        signOutRecordsButton.hidden = true
    }

    private func setBirthDate() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = String(student.getBirthDay()) + "/" + String(student.getBirthMonth()) + "/" + String(student.getBirthYear())
        let convertedStartDate = dateFormatter.dateFromString(dateString)
        birthdayPicker.date = convertedStartDate!
    }

    func setTitleValue(navTitle: String) {
        self.navTitle = navTitle
    }

    func setAddUpdateButtonText(buttonText: String) {
        self.buttonText = buttonText
    }

    func setUpdate(update: Bool) {
        updateStudent = update
    }

    func setStudentID(studentID: Int) {
        self.studentID = studentID
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateStudent(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let inputDate = dateFormatter.stringFromDate(birthdayPicker.date)
        let dateArr = inputDate.characters.split{$0 == "/"}.map(String.init)
        var activeBool = 0
        if (active.selectedSegmentIndex == 0) {
            activeBool = 1
        } else if (active.selectedSegmentIndex == 1) {
            activeBool = 0
        }

        var insertSQL = ""
        var absencesList = ""
        var studentRosters = ""

        if (validatFields()) {
            if (updateStudent) {
                insertSQL = "UPDATE STUDENTPROFILES SET firstName = '\(firstName.text!)', lastName = '\(lastName.text!)', active = '\(activeBool)', school = '\(school.text!)', birthDay = '\(Int(dateArr[1])!)', birthMonth = '\(Int(dateArr[0])!)', birthYear = '\(Int(dateArr[2])!)' WHERE studentID = '\(studentID)'"
                absencesList = "UPDATE ABSENCESLIST SET studentFirstName = '\(firstName.text!)', studentLastName = '\(lastName.text!)' WHERE studentID = '\(studentID)'"
                studentRosters = "UPDATE STUDENTROSTERS SET studentFirstName = '\(firstName.text!)', studentLastName = '\(lastName.text!)' WHERE studentID = '\(studentID)'"
            } else {
                insertSQL = "INSERT INTO STUDENTPROFILES (firstName, lastName, active, school, birthDay, birthMonth, birthYear) VALUES ('\(firstName.text!)', '\(lastName.text!)', '\(activeBool)', '\(school.text!)', '\(Int(dateArr[1])!)', '\(Int(dateArr[0])!)', '\(Int(dateArr[2])!)')"
            }

            let result1 = database.update(insertSQL)
            var result2 = false
            var result3 = false
            if (updateStudent) {
                result2 = database.update(absencesList)
                result3 = database.update(studentRosters)
            }
            if (result1 && (!updateStudent || (result2 && result3))) {
                self.performSegueWithIdentifier("instructorMenuStudentsUnwind", sender: self)
            }
        }
    }

    private func validatFields() -> Bool {
        if (firstName.text == "" || lastName.text == "" || school.text == ""){
            return false
        }
        return true
    }

    @IBAction func deleteStudent(sender: AnyObject) {
        let myAlertController = UIAlertController(title: "Delete Student", message: "Are you sure you want to delete the student?", preferredStyle: .Alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Do some stuff
        }
        myAlertController.addAction(cancelAction)

        let nextAction = UIAlertAction(title: "Delete", style: .Default) { action -> Void in
            let insertSQL = "DELETE FROM STUDENTPROFILES WHERE studentID = '\(self.studentID)'"
            let deleteStudentRosters = "DELETE FROM STUDENTROSTERS WHERE studentID = '\(self.studentID)'"
            let deleteSignOuts = "DELETE FROM SIGNOUTS WHERE studentID = '\(self.studentID)'"
            let deleteOneTimeAttendance = "DELETE FROM ONETIMEATTENDANCE WHERE studentID = '\(self.studentID)'"
            let deleteGuardians = "DELETE FROM GUARDIANS WHERE studentID = '\(self.studentID)'"
            let deleteContactNumbers = "DELETE FROM CONTACTNUMBERS WHERE studentID = '\(self.studentID)'"
            let deleteAbsencesList = "DELETE FROM ABSENCESLIST WHERE studentID = '\(self.studentID)'"
            let result1 = database.update(insertSQL)
            let result2 = database.update(deleteStudentRosters)
            let result3 = database.update(deleteSignOuts)
            let result4 = database.update(deleteOneTimeAttendance)
            let result5 = database.update(deleteGuardians)
            let result6 = database.update(deleteContactNumbers)
            let result7 = database.update(deleteAbsencesList)

            if (result1 && result2 && result3 && result4 && result5 && result6 && result7) {
                self.performSegueWithIdentifier("instructorMenuStudentsUnwind", sender: self)
            }
        }
        myAlertController.addAction(nextAction)
        presentViewController(myAlertController, animated: true, completion: nil)
    }

    @IBAction func editStudentInfoUnwind(segue: UIStoryboardSegue) {
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "EditStudentInfoToSignOuts") {
            let sohvc = segue.destinationViewController as? SignOutHistoryViewController
            sohvc?.setState(1)
            sohvc?.setStudentID(studentID)
        } else if (segue.identifier == "EditStudentToRosterHistory") {
            let rhvc = segue.destinationViewController as? RosterHistoryViewController
            rhvc?.setStudentID(studentID)
        }
    }
}
