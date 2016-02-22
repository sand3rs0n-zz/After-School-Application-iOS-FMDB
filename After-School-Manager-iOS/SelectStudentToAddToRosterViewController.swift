//
//  SelectChildToAddToRosterViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 1/22/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class SelectStudentToAddToRosterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var studentListTable: UITableView!

    private var forwardedStudentID = 0
    private var students = [Student]()
    private var rosterID = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        getStudents()
        // Do any additional setup after loading the view.
    }

    private func getStudents() {
        let querySQL = "SELECT * FROM STUDENTPROFILES WHERE studentID NOT IN (SELECT studentID FROM STUDENTROSTERS WHERE rosterID = '\(rosterID)') ORDER BY lastName, firstName ASC"
        let results = database.search(querySQL)
        while (results.next()) {
            let cur = Student()
            cur.setStudentID(Int(results.intForColumn("studentID")))
            cur.setFirstName(results.stringForColumn("firstName"))
            cur.setLastName(results.stringForColumn("lastName"))
            cur.setActive(Int(results.intForColumn("active")))
            cur.setSchool(results.stringForColumn("school"))
            cur.setBirthDay(Int(results.intForColumn("birthDay")))
            cur.setBirthMonth(Int(results.intForColumn("birthMonth")))
            cur.setBirthYear(Int(results.intForColumn("birthYear")))
            students.append(cur)
        }
        results.close()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setRosterID(rosterID: Int) {
        self.rosterID = rosterID
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let student = students[indexPath.row]
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = (student.getFirstName() + " " + student.getLastName())
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student = students[(indexPath.row)]
        forwardedStudentID = student.getStudentID()
        performSegueWithIdentifier("SelectStudentToAddToRoster", sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "SelectStudentToAddToRoster") {
        let aeavc = segue.destinationViewController as? AddOrEditAttendanceViewController
        aeavc?.setState(1)
        aeavc?.setTitleValue("Add Student to Roster")
        aeavc?.setStudentId(forwardedStudentID)
        aeavc?.setRosterId(rosterID)
        aeavc?.setButtonText("Add Attendance")
        }
    }

    @IBAction func returnToSelectStudentToAddToRosterUnwind(segue: UIStoryboardSegue) {
        students.removeAll()
        getStudents()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
        self.studentListTable.reloadData()
        })
    }
}
