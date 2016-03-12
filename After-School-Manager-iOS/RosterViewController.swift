//
//  RosterViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 1/19/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class RosterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var studentListTable: UITableView!
    
    private var navTitle = ""
    private var rosterID = 0
    private var students = [StudentRoster]()
    private var roster = Roster()
    private var forwardedStudentID = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleBar.title = navTitle

        getStudents()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func getStudents() {
        let querySQL = "SELECT * FROM STUDENTROSTERS WHERE rosterID = '\(rosterID)' ORDER BY studentLastName ASC"
        let results = database.search(querySQL)
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
    }

    func setTitleValue(navTitle: String) {
        self.navTitle = navTitle
    }
    
    func setRosterID(rosterID: Int) {
        self.rosterID = rosterID
    }

    func setRoster(roster: Roster) {
        self.roster = roster
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let student = students[indexPath.row]
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = student.getStudentFirstName() + " " + student.getStudentLastName()
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student = students[(indexPath.row)]
        forwardedStudentID = student.getStudentID()
        performSegueWithIdentifier("SpecificRosterToEditStudent", sender: self)
    }

    @IBAction func returnToRosterUnwind(segue: UIStoryboardSegue) {
        students.removeAll()
        getStudents()
        navTitle = roster.getName()
        self.titleBar.title = navTitle
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.studentListTable.reloadData()
        })
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "RosterToEditRoster") {
            let aoervc = segue.destinationViewController as? AddOrEditRosterViewController
            aoervc?.setState(1)
            aoervc?.setTitleValue("Edit Roster")
            aoervc?.setExistingRoster(roster)
            aoervc?.setCreateRosterButtonValue("Edit Roster")
        } else if (segue.identifier == "SpecificRosterToEditStudent") {
            let aeavc = segue.destinationViewController as? AddOrEditAttendanceViewController
            aeavc?.setState(0)
            aeavc?.setTitleValue("Edit Student Attendance")
            aeavc?.setStudentId(forwardedStudentID)
            aeavc?.setRosterId(rosterID)
            aeavc?.setButtonText("Update Attendance")
        } else if (segue.identifier == "SelectNewStudentToAddToRoster") {
            let ssarvc = segue.destinationViewController as? SelectStudentToAddToRosterViewController
            ssarvc?.setRosterID(rosterID)
        }
    }
}
