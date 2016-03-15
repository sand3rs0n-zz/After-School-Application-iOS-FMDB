//
//  SelectRosterToAddStudentViewController.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 2/5/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import UIKit

class SelectRosterToAddStudentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var selectRosterToAddStudentModel = SelectRosterToAddStudentModel()
    @IBOutlet weak var rosterListTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        selectRosterToAddStudentModel.resetRosters()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setStudentID(studentID: Int) {
        selectRosterToAddStudentModel.setStudentID(studentID)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let roster = selectRosterToAddStudentModel.getRoster(indexPath.row)
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = roster.getName()
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectRosterToAddStudentModel.getRosterListCount()
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectRosterToAddStudentModel.setForwardedRosterID(selectRosterToAddStudentModel.getRoster(indexPath.row).getRosterID())
        performSegueWithIdentifier("SelectRosterToAddStudentToAddAttendance", sender: self)
    }

    @IBAction func returnToSelectRosterToAddStudentUnwind(segue: UIStoryboardSegue) {
        selectRosterToAddStudentModel.resetRosters()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.rosterListTable.reloadData()
        })
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "SelectRosterToAddStudentToAddAttendance") {
            let aeavc = segue.destinationViewController as? AddOrEditAttendanceViewController
            aeavc?.setState(3)
            aeavc?.setTitleValue("Add Student to Roster")
            aeavc?.setStudentId(selectRosterToAddStudentModel.getStudentID())
            aeavc?.setRosterId(selectRosterToAddStudentModel.getForwardedRosterID())
            aeavc?.setButtonText("Add Attendance")
        }
    }
}
