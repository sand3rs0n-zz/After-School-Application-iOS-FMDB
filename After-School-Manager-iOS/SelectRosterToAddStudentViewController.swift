//
//  SelectRosterToAddStudentViewController.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 2/5/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import UIKit

class SelectRosterToAddStudentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var rosterListTable: UITableView!
    private var rosterList = [Roster]()

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
        let querySQL = "SELECT * FROM ROSTERS WHERE rosterID NOT IN (SELECT rosterID FROM STUDENTROSTERS WHERE studentID = '\(studentID)') ORDER BY name ASC"

        let results = database.search(querySQL)
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
        cell.textLabel?.text = roster.getName()
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rosterList.count
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let roster = rosterList[(indexPath.row)]
        forwardedRosterID = roster.getRosterID()
        performSegueWithIdentifier("SelectRosterToAddStudentToAddAttendance", sender: self)
    }

    @IBAction func returnToSelectRosterToAddStudentUnwind(segue: UIStoryboardSegue) {
        rosterList.removeAll()
        getRosters()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.rosterListTable.reloadData()
        })
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "SelectRosterToAddStudentToAddAttendance") {
            let aeavc = segue.destinationViewController as? AddOrEditAttendanceViewController
            aeavc?.setState(3)
            aeavc?.setTitleValue("Add Student to Roster")
            aeavc?.setStudentId(studentID)
            aeavc?.setRosterId(forwardedRosterID)
            aeavc?.setButtonText("Add Attendance")
        }
    }
}
