//
//  AddSpecialAttendanceViewController.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 2/15/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import UIKit

class AddSpecialAttendanceViewController: UIViewController {

    @IBOutlet weak var rosterList: UIPickerView!
    private var studentID = 0
    private var rosters = [Roster]()
    private var date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        getRosters()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func getRosters() {
        let path = Util.getPath("AfterSchoolData.sqlite")
        let contactDB = FMDatabase(path: path)

        let year = date.getCurrentYear()
        let month = date.getCurrentMonth()
        let day = date.getCurrentDay()
        let weekday = date.getCurrentWeekday()

        if contactDB.open() {
            let querySQL = "SELECT * FROM ROSTERS WHERE (endYear > '\(year)' OR (endYear = '\(year)' AND endMonth > '\(month)') OR (endYear = '\(year)' AND endMonth = '\(month)' AND endDay >= '\(day)')) AND (startYear < '\(year)' OR (startYear = '\(year)' AND startMonth < '\(month)') OR (startYear = '\(year)' AND startMonth = '\(month)' AND startDay <= '\(day)')) AND rosterID NOT IN (SELECT rosterID FROM STUDENTROSTERS WHERE studentID = '\(studentID)' AND \(weekday) = 1) AND rosterID NOT IN (SELECT rosterID FROM ONETIMEATTENDANCE WHERE studentID = '\(studentID)' AND year = '\(year)' AND month = '\(month)' AND day = '\(day)') ORDER BY name ASC"

            let results = contactDB.executeQuery(querySQL, withArgumentsInArray: nil)
            while (results.next()) {
                let cur = Roster()
                cur.setRosterID(Int(results.intForColumn("rosterID")))
                cur.setRosterType(Int(results.intForColumn("rosterType")))
                cur.setName(results.stringForColumn("name"))
                cur.setStartDay(Int(results.intForColumn("startDay")))
                cur.setStartMonth(Int(results.intForColumn("startMonth")))
                cur.setStartYear(Int(results.intForColumn("startYear")))
                cur.setEndDay(Int(results.intForColumn("endDay")))
                cur.setEndMonth(Int(results.intForColumn("endMonth")))
                cur.setEndYear(Int(results.intForColumn("endYear")))
                cur.setPickUpHour(Int(results.intForColumn("pickUpHour")))
                cur.setPickUpMinute(Int(results.intForColumn("pickUpMinute")))
                rosters.append(cur)
            }
            results.close()
            contactDB.close()
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
    }

    func setStudentID(studentID: Int) {
        self.studentID = studentID
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent componenet: Int) -> Int {
        return rosters.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return rosters[row].getName()
    }

    @IBAction func addToOneTimeAttendance(sender: AnyObject) {
        //grab current picker value, add value to one time attendance table
        let timestamp = Date()
        let path = Util.getPath("AfterSchoolData.sqlite")
        let contactDB = FMDatabase(path: path)
        let rosterID = rosters[rosterList.selectedRowInComponent(0)].getRosterID()

        if contactDB.open() {
            let insertSQL = "INSERT INTO ONETIMEATTENDANCE VALUES ('\(studentID)', '\(rosterID)', '\(timestamp.getCurrentDay())', '\(timestamp.getCurrentMonth())', '\(timestamp.getCurrentYear())')"
            let result = contactDB.executeUpdate(insertSQL, withArgumentsInArray: nil)

            if !result {
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                print("Successful")
            }
            contactDB.close()
            self.performSegueWithIdentifier("SelectStudentToAddUnwind", sender: self)
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
    }
}
