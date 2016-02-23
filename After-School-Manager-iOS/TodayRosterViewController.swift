//
//  TodayRosterViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/17/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class TodayRosterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var studentListTable: UITableView!
    private var studentList = [StudentRoster]()
    private var date = Date()
    private var forwardedStudentID = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        getStudents()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func getStudents() {
        let path = Util.getPath("AfterSchoolData.sqlite")
        let contactDB = FMDatabase(path: path)
        let year = date.getCurrentYear()
        let month = date.getCurrentMonth()
        let day = date.getCurrentDay()
        let weekday = date.getCurrentWeekday()

        if contactDB.open() {
            let querySQL = "SELECT STUDENTROSTERS.studentFirstName, STUDENTROSTERS.studentLastName, STUDENTROSTERS.studentID, STUDENTROSTERS.rosterID, ROSTERS.name FROM STUDENTROSTERS LEFT OUTER JOIN ROSTERS ON STUDENTROSTERS.rosterID = ROSTERS.rosterID WHERE (endYear > '\(year)' OR (endYear = '\(year)' AND endMonth > '\(month)') OR (endYear = '\(year)' AND endMonth = '\(month)' AND endDay >= '\(day)')) AND (startYear < '\(year)' OR (startYear = '\(year)' AND startMonth < '\(month)') OR (startYear = '\(year)' AND startMonth = '\(month)' AND startDay <= '\(day)')) AND \(weekday) = 1 ORDER BY studentLastName, studentFirstName ASC"

            let secondQuery = "SELECT STUDENTPROFILES.firstName, STUDENTPROFILES.lastName, STUDENTPROFILES.studentID, ROSTERS.rosterID, ROSTERS.name FROM ONETIMEATTENDANCE LEFT OUTER JOIN STUDENTPROFILES ON ONETIMEATTENDANCE.studentID = STUDENTPROFILES.studentID LEFT OUTER JOIN ROSTERS ON ONETIMEATTENDANCE.rosterID = ROSTERS.rosterID WHERE year = '\(year)' AND month = '\(month)' AND day = '\(day)' ORDER BY lastName, firstName ASC"

            var results = contactDB.executeQuery(querySQL, withArgumentsInArray: nil)
            while (results.next()) {
                let cur = StudentRoster()
                cur.setStudentFirstName(results.stringForColumn("studentFirstName"))
                cur.setStudentLastName(results.stringForColumn("studentLastName"))
                cur.setStudentID(Int(results.intForColumn("studentID")))
                cur.setRosterID(Int(results.intForColumn("rosterID")))
                cur.setRosterName(results.stringForColumn("name"))
                studentList.append(cur)
            }
            results = contactDB.executeQuery(secondQuery, withArgumentsInArray: nil)

            while (results.next()) {
                let cur = StudentRoster()
                cur.setStudentFirstName(results.stringForColumn("firstName"))
                cur.setStudentLastName(results.stringForColumn("lastName"))
                cur.setStudentID(Int(results.intForColumn("studentID")))
                cur.setRosterID(Int(results.intForColumn("rosterID")))
                cur.setRosterName(results.stringForColumn("name"))
                studentList.append(cur)
            }
            results.close()
            
            studentList.sortInPlace({ $0.getStudentLastName() == $1.getStudentLastName() ? ($0.getStudentFirstName() < $1.getStudentFirstName()) : ($0.getStudentLastName() < $1.getStudentLastName()) })
            contactDB.close()
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let student = studentList[indexPath.row]
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = student.getStudentFirstName() + " " + student.getStudentLastName() + " " + student.getRosterName()
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentList.count
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student = studentList[(indexPath.row)]
        forwardedStudentID = student.getStudentID()
        performSegueWithIdentifier("TodayRosterToEditAttendance", sender: self)
    }

    @IBAction func returnToTodayRosterUnwind(segue: UIStoryboardSegue) {
        studentList.removeAll()
        getStudents()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.studentListTable.reloadData()
        })
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "TodayRosterToEditAttendance") {
            let etavc = segue.destinationViewController as? EditTodayAttendanceViewController
            etavc?.setStudentID(forwardedStudentID)
        }
    }
}
