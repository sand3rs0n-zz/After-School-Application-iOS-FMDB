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
    private var forwardedRosterID = 0
    private var forwardedStudentFirstName = ""
    private var forwardedStudentLastName = ""
    private var numberOfNonSignedOut = 0

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
        let year = date.getCurrentYear()
        let month = date.getCurrentMonth()
        let day = date.getCurrentDay()
        let weekday = date.getCurrentWeekday()
        let querySQL = "SELECT STUDENTROSTERS.studentFirstName AS studentFirstName, STUDENTROSTERS.studentLastName AS studentLastName, STUDENTROSTERS.studentID AS studentID, STUDENTROSTERS.rosterID AS rosterID, ROSTERS.name AS name FROM STUDENTROSTERS LEFT OUTER JOIN ROSTERS ON STUDENTROSTERS.rosterID = ROSTERS.rosterID  WHERE (endYear > '\(year)' OR (endYear = '\(year)' AND endMonth > '\(month)') OR (endYear = '\(year)' AND endMonth = '\(month)' AND endDay >= '\(day)')) AND (startYear < '\(year)' OR (startYear = '\(year)' AND startMonth < '\(month)') OR (startYear = '\(year)' AND startMonth = '\(month)' AND startDay <= '\(day)')) AND \(weekday) = 1  AND studentID IN (SELECT studentID FROM STUDENTPROFILES WHERE active = 1) AND studentID NOT IN (SELECT studentID FROM SIGNOUTS WHERE day = '\(day)' AND month = '\(month)' AND year = '\(year)') AND STUDENTROSTERS.rosterID NOT IN (SELECT rosterID FROM EVENTS WHERE day = '\(day)' AND month = '\(month)' AND year = '\(year)') UNION SELECT STUDENTPROFILES.firstName AS studentFirstName, STUDENTPROFILES.lastName AS studentLastName, STUDENTPROFILES.studentID AS studentID, ROSTERS.rosterID as rosterID, ROSTERS.name as name FROM ONETIMEATTENDANCE LEFT OUTER JOIN STUDENTPROFILES ON ONETIMEATTENDANCE.studentID = STUDENTPROFILES.studentID LEFT OUTER JOIN ROSTERS ON ONETIMEATTENDANCE.rosterID = ROSTERS.rosterID WHERE year = '\(year)' AND month = '\(month)' AND day = '\(day)' AND active = 1 AND ONETIMEATTENDANCE.studentID NOT IN (SELECT studentID FROM SIGNOUTS WHERE day = '\(day)' AND month = '\(month)' AND year = '\(year)') AND ROSTERS.rosterID NOT IN (SELECT rosterID FROM EVENTS WHERE day = '\(day)' AND month = '\(month)' AND year = '\(year)') ORDER BY studentLastName, studentFirstName, name ASC"
        let signedOutSQL = "SELECT STUDENTROSTERS.studentFirstName AS studentFirstName, STUDENTROSTERS.studentLastName AS studentLastName, STUDENTROSTERS.studentID AS studentID, STUDENTROSTERS.rosterID AS rosterID, ROSTERS.name AS name FROM STUDENTROSTERS LEFT OUTER JOIN ROSTERS ON STUDENTROSTERS.rosterID = ROSTERS.rosterID  WHERE (endYear > '\(year)' OR (endYear = '\(year)' AND endMonth > '\(month)') OR (endYear = '\(year)' AND endMonth = '\(month)' AND endDay >= '\(day)')) AND (startYear < '\(year)' OR (startYear = '\(year)' AND startMonth < '\(month)') OR (startYear = '\(year)' AND startMonth = '\(month)' AND startDay <= '\(day)')) AND \(weekday) = 1  AND studentID IN (SELECT studentID FROM STUDENTPROFILES WHERE active = 1) AND studentID IN (SELECT studentID FROM SIGNOUTS WHERE day = '\(day)' AND month = '\(month)' AND year = '\(year)') AND STUDENTROSTERS.rosterID NOT IN (SELECT rosterID FROM EVENTS WHERE day = '\(day)' AND month = '\(month)' AND year = '\(year)') UNION SELECT STUDENTPROFILES.firstName AS studentFirstName, STUDENTPROFILES.lastName AS studentLastName, STUDENTPROFILES.studentID AS studentID, ROSTERS.rosterID as rosterID, ROSTERS.name as name FROM ONETIMEATTENDANCE LEFT OUTER JOIN STUDENTPROFILES ON ONETIMEATTENDANCE.studentID = STUDENTPROFILES.studentID LEFT OUTER JOIN ROSTERS ON ONETIMEATTENDANCE.rosterID = ROSTERS.rosterID WHERE year = '\(year)' AND month = '\(month)' AND day = '\(day)' AND active = 1 AND ONETIMEATTENDANCE.studentID IN (SELECT studentID FROM SIGNOUTS WHERE day = '\(day)' AND month = '\(month)' AND year = '\(year)') AND ROSTERS.rosterID NOT IN (SELECT rosterID FROM EVENTS WHERE day = '\(day)' AND month = '\(month)' AND year = '\(year)') ORDER BY studentLastName, studentFirstName, name ASC"

        let results = database.search(querySQL)
        while (results.next()) {
            let cur = StudentRoster()
            cur.setStudentFirstName(results.stringForColumn("studentFirstName"))
            cur.setStudentLastName(results.stringForColumn("studentLastName"))
            cur.setStudentID(Int(results.intForColumn("studentID")))
            cur.setRosterID(Int(results.intForColumn("rosterID")))
            cur.setRosterName(results.stringForColumn("name"))
            studentList.append(cur)
        }
        results.close()
        numberOfNonSignedOut = studentList.count
        let results2 = database.search(signedOutSQL)
        while (results2.next()) {
            let cur = StudentRoster()
            cur.setStudentFirstName(results2.stringForColumn("studentFirstName"))
            cur.setStudentLastName(results2.stringForColumn("studentLastName"))
            cur.setStudentID(Int(results2.intForColumn("studentID")))
            cur.setRosterID(Int(results2.intForColumn("rosterID")))
            cur.setRosterName(results2.stringForColumn("name"))
            studentList.append(cur)
        }
        results2.close()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let student = studentList[indexPath.row]
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        var name = ""
        if (indexPath.row >= numberOfNonSignedOut) {
            name = student.getStudentFirstName() + " " + student.getStudentLastName() + " " + student.getRosterName() + " signed out!"
        } else {
            name = student.getStudentFirstName() + " " + student.getStudentLastName() + " " + student.getRosterName()
        }
        cell.textLabel?.text = name
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentList.count
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row < numberOfNonSignedOut) {
            let student = studentList[(indexPath.row)]
            forwardedStudentID = student.getStudentID()
            forwardedRosterID = student.getRosterID()
            forwardedStudentFirstName = student.getStudentFirstName()
            forwardedStudentLastName = student.getStudentLastName()
            performSegueWithIdentifier("TodayRosterToEditAttendance", sender: self)
        }
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
            etavc?.setRosterID(forwardedRosterID)
            etavc?.setStudentFirstName(forwardedStudentFirstName)
            etavc?.setStudentLastName(forwardedStudentLastName)
        }
    }
}
