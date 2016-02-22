//
//  RosterHistoryViewController.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 2/5/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import UIKit

class RosterHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var rosterListTable: UITableView!
    private var rosterList = [StudentRoster]()

    private var studentID = 0
    private var forwardedRosterID = 0

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
        let querySQL = "SELECT STUDENTROSTERS.*, ROSTERS.name FROM STUDENTROSTERS LEFT OUTER JOIN ROSTERS ON STUDENTROSTERS.rosterID = ROSTERS.rosterID WHERE STUDENTROSTERS.studentID = '\(studentID)'"

        let results = database.search(querySQL)
        while (results.next()) {
            let cur = StudentRoster()
            cur.setStudentFirstName(results.stringForColumn("studentFirstName"))
            cur.setStudentLastName(results.stringForColumn("studentLastName"))
            cur.setStudentID(Int(results.intForColumn("studentID")))
            cur.setRosterID(Int(results.intForColumn("rosterID")))
            cur.setRosterName(results.stringForColumn("name"))
            cur.setMonday(Int(results.intForColumn("monday")))
            cur.setTuesday(Int(results.intForColumn("tuesday")))
            cur.setWednesday(Int(results.intForColumn("wednesday")))
            cur.setThursday(Int(results.intForColumn("thursday")))
            cur.setFriday(Int(results.intForColumn("friday")))
            cur.setSaturday(Int(results.intForColumn("saturday")))
            cur.setSunday(Int(results.intForColumn("sunday")))
            rosterList.append(cur)
        }
        results.close()
    }

    func setStudentID(studentID: Int) {
        self.studentID = studentID
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let roster = rosterList[indexPath.row]
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = roster.getRosterName()
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rosterList.count
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let roster = rosterList[(indexPath.row)]
        forwardedRosterID = roster.getRosterID()
        performSegueWithIdentifier("RosterHistoryToEditAttendance", sender: self)
    }

    @IBAction func returnToRosterHistoryUnwind(segue: UIStoryboardSegue) {
        rosterList.removeAll()
        getRosters()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.rosterListTable.reloadData()
        })
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "RosterHistoryToEditAttendance") {
            let aeavc = segue.destinationViewController as? AddOrEditAttendanceViewController
            aeavc?.setState(2)
            aeavc?.setTitleValue("Edit Student Attendance")
            aeavc?.setStudentId(studentID)
            aeavc?.setRosterId(forwardedRosterID)
            aeavc?.setButtonText("Update Attendance")
        } else if (segue.identifier == "RosterHistoryToAddRoster") {
            let srtasvc = segue.destinationViewController as? SelectRosterToAddStudentViewController
            srtasvc?.setStudentID(studentID)
        }
    }
}

