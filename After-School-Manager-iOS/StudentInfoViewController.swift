//
//  StudentInfoViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class StudentInfoViewController: UIViewController {
    
    private var studentID = 0
    private var student = Student()
    private var guardians = [Guardian]()
    private var contactNumbers = [ContactNumber]()
    private var dob = Date()
    

    @IBOutlet weak var studentFirstName: UILabel!
    @IBOutlet weak var studentLastName: UILabel!
    @IBOutlet weak var studentDOB: UILabel!
    @IBOutlet weak var studentSchool: UILabel!
    @IBOutlet weak var studentGuardians: UILabel!
    @IBOutlet weak var studentContacts: UILabel!
    @IBOutlet weak var studentAge: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        setDOB()
        fillPage()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func fillPage() {
        studentFirstName.text = student.getFirstName()
        studentLastName.text = student.getLastName()
        studentSchool.text = student.getSchool()
        studentDOB.text = dob.fullDateAmerican()
        studentAge.text = String(calcAge())
        studentGuardians.text = guardianList()
        studentContacts.text = contactList()
    }
    
    func setStudentID(id: Int) {
       studentID = id
    }

    private func setDOB(){
        dob = Date(day: student.getBirthDay(), month: student.getBirthMonth(), year: student.getBirthYear())
    }
    
    private func calcAge() -> Int {
        return dob.age()
    }

    private func guardianList() -> String {
        var guardianList = ""
        for (var i = 0; i < guardians.count; i++) {
            let guardian = guardians[i]
            guardianList.appendContentsOf(guardian.getName())
            if ((i + 1) < guardians.count) {
                guardianList.appendContentsOf(", ")
            }
        }
        return guardianList
    }

    private func contactList() -> String {
        var contactList = ""
        for (var i = 0; i < contactNumbers.count; i++) {
            let contact = contactNumbers[i]
            contactList.appendContentsOf(contact.getName())
            contactList.appendContentsOf(": ")
            contactList.appendContentsOf(contact.getPhoneNumber())
            if ((i + 1) < contactNumbers.count) {
                contactList.appendContentsOf(", ")
            }
        }
        return contactList
    }

    @IBAction func studentInfoUnwind(segue: UIStoryboardSegue) {
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "StudentInfoToSignOuts") {
            let sohvc = segue.destinationViewController as? SignOutHistoryViewController
            sohvc?.setState(0)
            sohvc?.setStudentID(studentID)
        }
    }
}
