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
        let path = Util.getPath("AfterSchoolData.sqlite")
        let contactDB = FMDatabase(path: path)

        if contactDB.open() {
            let date = Date()
            var querySQL = ""
            if (rosterState == 1) {
                querySQL = "SELECT * FROM STUDENTROSTERS WHERE rosterID = '\(rosterID)' AND studentID NOT IN (SELECT studentID FROM SIGNOUTS WHERE day = '\(date.getCurrentDay())' AND month = '\(date.getCurrentMonth())' AND year = '\(date.getCurrentYear())' AND rosterID = '\(rosterID)') AND \(date.getCurrentWeekday()) = 1 ORDER BY studentLastName ASC"
            } else {
                querySQL = "SELECT * FROM STUDENTROSTERS WHERE rosterID = '\(rosterID)' ORDER BY studentLastName ASC"
            }
            let results = contactDB.executeQuery(querySQL, withArgumentsInArray: nil)
            while (results.next()) {
                let cur = StudentRoster()
                cur.setStudentFirstName(results.stringForColumn("studentFirstName"))
                cur.setStudentLastName(results.stringForColumn("studentLastName"))
                cur.setStudentID(Int(results.intForColumn("studentID")))
                cur.setRosterID(Int(results.intForColumn("rosterID")))
                cur.setMonday(Int(results.intForColumn("monday")))
                cur.setTuesday(Int(results.intForColumn("tuesday")))
                cur.setWednesday(Int(results.intForColumn("wednesday")))
                cur.setThursday(Int(results.intForColumn("thursday")))
                cur.setFriday(Int(results.intForColumn("friday")))
                cur.setSaturday(Int(results.intForColumn("saturday")))
                cur.setSunday(Int(results.intForColumn("sunday")))
                students.append(cur)
            }
            results.close()
            contactDB.close()
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
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
        let name = student.getStudentFirstName() + " " + student.getStudentLastName()
        cell.textLabel?.text = name
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student: StudentRoster = students[(indexPath.row)]
        forwardedStudentID = student.getStudentID()
        forwardedStudentLastName = student.getStudentLastName()
        forwardedStudentFirstName = student.getStudentFirstName()
        segue()
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
