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
    private var studentLastName = ""
    private var studentFirstName = ""
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    @IBAction func schedule(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let inputDate = dateFormatter.stringFromDate(datePicker.date)
        let dateArr = inputDate.characters.split{$0 == "/"}.map(String.init)

        let path = Util.getPath("AfterSchoolData.sqlite")
        let contactDB = FMDatabase(path: path)

        if contactDB.open() {
            let insertSQL = "INSERT INTO ABSENCESLIST (studentFirstName, studentLastName, studentID, day, month, year) VALUES ('\(studentFirstName)', '\(studentLastName)', '\(studentID)', '\(Int(dateArr[1])!)', '\(Int(dateArr[0])!)', '\(Int(dateArr[2])!)')"
            let result = contactDB.executeUpdate(insertSQL, withArgumentsInArray: nil)

            if !result {
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                print("Successful")
                self.performSegueWithIdentifier("ScheduleAbsenceToStudentSelect", sender: self)
            }
            contactDB.close()
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
    }
}
