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
            let path = Util.getPath("AfterSchoolData.sqlite")
            let contactDB = FMDatabase(path: path)
            if contactDB.open() {
                getStudent(contactDB)
                getGuardians(contactDB)
                getContactNumbers(contactDB)
                contactDB.close()
            } else {
                print("Error: \(contactDB.lastErrorMessage())")
            }

            fillFields()
        } else {
            hideFields()
        }
        // Do any additional setup after loading the view.
    }

    private func getStudent(contactDB: FMDatabase) {
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
    }

    private func getGuardians(contactDB: FMDatabase) {
        let querySQL = "SELECT * FROM GUARDIANS WHERE studentID = '\(studentID)'"
        let results = contactDB.executeQuery(querySQL, withArgumentsInArray: nil)
        while (results.next()) {
            let cur = Guardian()
            cur.setGuardianID(Int(results.intForColumn("guardianID")))
            cur.setName(results.stringForColumn("name"))
            cur.setStudentID(Int(results.intForColumn("studentID")))
            guardians.append(cur)
        }
    }

    private func getContactNumbers(contactDB: FMDatabase) {
        let querySQL = "SELECT * FROM CONTACTNUMBERS WHERE studentID = '\(studentID)'"
        let results = contactDB.executeQuery(querySQL, withArgumentsInArray: nil)
        while (results.next()) {
            let cur = ContactNumber()
            cur.setContactID(Int(results.intForColumn("contactID")))
            cur.setName(results.stringForColumn("name"))
            cur.setPhoneNumber(results.stringForColumn("phoneNumber"))
            cur.setStudentID(Int(results.intForColumn("studentID")))
            contactNumbers.append(cur)
        }
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
        let path = Util.getPath("AfterSchoolData.sqlite")
        let contactDB = FMDatabase(path: path)

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

        if contactDB.open() {
            if (validatFields()) {
                if (updateStudent) {
                    insertSQL = "UPDATE STUDENTPROFILES SET firstName = '\(firstName.text!)', lastName = '\(lastName.text!)', active = '\(activeBool)', school = '\(school.text!)', birthDay = '\(Int(dateArr[1])!)', birthMonth = '\(Int(dateArr[0])!)', birthYear = '\(Int(dateArr[2])!)' WHERE studentID = '\(studentID)'"
                    //update other tables
                } else {
                    insertSQL = "INSERT INTO STUDENTPROFILES (firstName, lastName, active, school, birthDay, birthMonth, birthYear) VALUES ('\(firstName.text!)', '\(lastName.text!)', '\(activeBool)', '\(school.text!)', '\(Int(dateArr[1])!)', '\(Int(dateArr[0])!)', '\(Int(dateArr[2])!)')"
                }
            }

            let result = contactDB.executeUpdate(insertSQL, withArgumentsInArray: nil)

            if !result {
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                print("Successful")
            }
            contactDB.close()
            self.performSegueWithIdentifier("instructorMenuStudentsUnwind", sender: self)
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
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
            let path = Util.getPath("AfterSchoolData.sqlite")
            let contactDB = FMDatabase(path: path)

            if contactDB.open() {
                let insertSQL = "DELETE FROM STUDENTPROFILES WHERE studentID = '\(self.studentID)'"
                let result = contactDB.executeUpdate(insertSQL, withArgumentsInArray: nil)
                if !result {
                    print("Error: \(contactDB.lastErrorMessage())")
                } else {
                    print("Deleted")
                }
                contactDB.close()
                self.performSegueWithIdentifier("instructorMenuStudentsUnwind", sender: self)
            } else {
                print("Error: \(contactDB.lastErrorMessage())")
            }
        }
        myAlertController.addAction(nextAction)
        presentViewController(myAlertController, animated: true, completion: nil)

        //also delete all relevant info
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
