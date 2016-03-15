//
//  RosterHistoryViewController.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 2/5/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import UIKit

class RosterHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var rosterHistoryModel = RosterHistoryModel()
    @IBOutlet weak var rosterListTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        rosterHistoryModel.resetRosters()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setStudentID(studentID: Int) {
        rosterHistoryModel.setStudentID(studentID)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let roster = rosterHistoryModel.getRoster(indexPath.row)
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = roster.getRosterName()
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rosterHistoryModel.getRosterListCount()
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        rosterHistoryModel.setForwardedRosterID(rosterHistoryModel.getRoster(indexPath.row).getRosterID())
        performSegueWithIdentifier("RosterHistoryToEditAttendance", sender: self)
    }

    @IBAction func returnToRosterHistoryUnwind(segue: UIStoryboardSegue) {
        rosterHistoryModel.resetRosters()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.rosterListTable.reloadData()
        })
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "RosterHistoryToEditAttendance") {
            let aeavc = segue.destinationViewController as? AddOrEditAttendanceViewController
            aeavc?.setState(2)
            aeavc?.setTitleValue("Edit Student Attendance")
            aeavc?.setStudentId(rosterHistoryModel.getStudentID())
            aeavc?.setRosterId(rosterHistoryModel.getForwardedRosterID())
            aeavc?.setButtonText("Update Attendance")
        } else if (segue.identifier == "RosterHistoryToAddRoster") {
            let srtasvc = segue.destinationViewController as? SelectRosterToAddStudentViewController
            srtasvc?.setStudentID(rosterHistoryModel.getStudentID())
        }
    }
}

