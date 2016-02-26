//
//  StudentRosterViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class StudentRosterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var rosterState = 0
    private var students = [StudentRoster]()
    private var rosterID = 0
    private var rosterType = 0
    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var studentListTable: UITableView!

    private var navTitle = ""
    private var forwardedStudentID = 0
    private var forwardedStudentLastName = ""
    private var forwardedStudentFirstName = ""
    private var numberOfNonSignedOut = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleBar.title = navTitle
        getStudents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func getStudents() {
        let date = Date()
        let day = date.getCurrentDay()
        let month = date.getCurrentMonth()
        let year = date.getCurrentYear()
        var querySQL = ""
        var signedOutSQL = ""
        if (rosterState == 1) {
            querySQL = "SELECT STUDENTROSTERS.studentFirstName AS studentFirstName, STUDENTROSTERS.studentLastName AS studentLastName, STUDENTROSTERS.studentID AS studentID FROM STUDENTROSTERS WHERE rosterID = '\(rosterID)' AND studentID NOT IN (SELECT studentID FROM SIGNOUTS WHERE day = '\(day)' AND month = '\(month)' AND year = '\(year)' AND rosterID = '\(rosterID)') AND \(date.getCurrentWeekday()) = 1 AND studentID IN (SELECT studentID FROM STUDENTPROFILES WHERE active = 1) AND STUDENTROSTERS.rosterID NOT IN (SELECT rosterID FROM EVENTS WHERE day = '\(day)' AND month = '\(month)' AND year = '\(year)') UNION SELECT STUDENTPROFILES.firstName AS studentFirstName, STUDENTPROFILES.lastName AS studentLastName, STUDENTPROFILES.studentID AS studentID FROM ONETIMEATTENDANCE LEFT OUTER JOIN STUDENTPROFILES ON ONETIMEATTENDANCE.studentID = STUDENTPROFILES.studentID LEFT OUTER JOIN ROSTERS ON ONETIMEATTENDANCE.rosterID = ROSTERS.rosterID WHERE year = '\(year)' AND month = '\(month)' AND day = '\(day)' AND active = 1 AND ONETIMEATTENDANCE.studentID NOT IN (SELECT studentID FROM SIGNOUTS WHERE day = '\(date.getCurrentDay())' AND month = '\(date.getCurrentMonth())' AND year = '\(date.getCurrentYear())' AND rosterID = '\(rosterID)') AND ROSTERS.rosterID NOT IN (SELECT rosterID FROM EVENTS WHERE day = '\(day)' AND month = '\(month)' AND year = '\(year)') ORDER BY studentLastName, studentFirstName ASC"
            signedOutSQL = "SELECT STUDENTROSTERS.studentFirstName AS studentFirstName, STUDENTROSTERS.studentLastName AS studentLastName, STUDENTROSTERS.studentID AS studentID FROM STUDENTROSTERS WHERE rosterID = '\(rosterID)' AND studentID IN (SELECT studentID FROM SIGNOUTS WHERE day = '\(day)' AND month = '\(month)' AND year = '\(year)' AND rosterID = '\(rosterID)') AND \(date.getCurrentWeekday()) = 1 AND studentID IN (SELECT studentID FROM STUDENTPROFILES WHERE active = 1) AND STUDENTROSTERS.rosterID NOT IN (SELECT rosterID FROM EVENTS WHERE day = '\(day)' AND month = '\(month)' AND year = '\(year)') UNION SELECT STUDENTPROFILES.firstName AS studentFirstName, STUDENTPROFILES.lastName AS studentLastName, STUDENTPROFILES.studentID AS studentID FROM ONETIMEATTENDANCE LEFT OUTER JOIN STUDENTPROFILES ON ONETIMEATTENDANCE.studentID = STUDENTPROFILES.studentID LEFT OUTER JOIN ROSTERS ON ONETIMEATTENDANCE.rosterID = ROSTERS.rosterID WHERE year = '\(year)' AND month = '\(month)' AND day = '\(day)' AND active = 1 AND ONETIMEATTENDANCE.studentID IN (SELECT studentID FROM SIGNOUTS WHERE day = '\(date.getCurrentDay())' AND month = '\(date.getCurrentMonth())' AND year = '\(date.getCurrentYear())' AND rosterID = '\(rosterID)') AND ROSTERS.rosterID NOT IN (SELECT rosterID FROM EVENTS WHERE day = '\(day)' AND month = '\(month)' AND year = '\(year)') ORDER BY studentLastName, studentFirstName ASC"
        } else {
            querySQL = "SELECT * FROM STUDENTROSTERS WHERE rosterID = '\(rosterID)' AND studentID IN (SELECT studentID FROM STUDENTPROFILES WHERE active = 1) ORDER BY studentLastName, studentFirstName ASC"
        }
        let results = database.search(querySQL)
        while (results.next()) {
            let cur = StudentRoster()
            cur.setStudentFirstName(results.stringForColumn("studentFirstName"))
            cur.setStudentLastName(results.stringForColumn("studentLastName"))
            cur.setStudentID(Int(results.intForColumn("studentID")))
            students.append(cur)
        }
        results.close()

        if (rosterState == 1) {
            numberOfNonSignedOut = students.count
            let results2 = database.search(signedOutSQL)
            while (results2.next()) {
                let cur = StudentRoster()
                cur.setStudentFirstName(results2.stringForColumn("studentFirstName"))
                cur.setStudentLastName(results2.stringForColumn("studentLastName"))
                cur.setStudentID(Int(results2.intForColumn("studentID")))
                students.append(cur)
            }
            results2.close()
        }
    }
    
    func setState(state: Int) {
        rosterState = state
    }
    
    func setTitleValue(title: String) {
        navTitle = title
    }
    
    func setRosterID(id: Int) {
        rosterID = id
    }

    func setRosterType(type: Int) {
        rosterType = type
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let student: StudentRoster = students[indexPath.row]
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        var name: String
        if (indexPath.row >= numberOfNonSignedOut && rosterState == 1) {
            name = student.getStudentFirstName() + " " + student.getStudentLastName() + " signed out!"
        } else {
            name = student.getStudentFirstName() + " " + student.getStudentLastName()
        }
        cell.textLabel?.text = name
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row < numberOfNonSignedOut || rosterState != 1) {
            let student: StudentRoster = students[(indexPath.row)]
            forwardedStudentID = student.getStudentID()
            forwardedStudentLastName = student.getStudentLastName()
            forwardedStudentFirstName = student.getStudentFirstName()
            segue()
        }
    }
    
    private func segue() {
        if (rosterState == 0) {
            performSegueWithIdentifier("StudentRosterToStudentProfile", sender: self)
        } else if (rosterState == 1) {
            performSegueWithIdentifier("StudentRosterToSignOut", sender: self)
        } else if (rosterState == 2) {
            performSegueWithIdentifier("StudentRosterToScheduleAbsence", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (rosterState == 2) {
            let savc = segue.destinationViewController as? ScheduleAbsenceViewController
            savc?.setState(0)
            savc?.setButtonText("Schedule Absence")
            savc?.setStudentID(forwardedStudentID)
            savc?.setStudentLastName(forwardedStudentLastName)
            savc?.setStudentFirstName(forwardedStudentFirstName)
            savc?.setRosterType(rosterType)
            savc?.setRosterID(rosterID)
        } else if (rosterState == 0) {
            let sivc = segue.destinationViewController as? StudentInfoViewController
            sivc?.setStudentID(forwardedStudentID)
        } else if (rosterState == 1) {
            let sovc = segue.destinationViewController as? SignOutViewController
            sovc?.setStudentID(forwardedStudentID)
            sovc?.setTitleValue(forwardedStudentFirstName + " " + forwardedStudentLastName)
            sovc?.setRosterType(rosterType)
            sovc?.setRosterID(rosterID)
        }
    }
    
    @IBAction func studentSelectUnwind(segue: UIStoryboardSegue) {
        students.removeAll()
        getStudents()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.studentListTable.reloadData()
        })
    }
}
