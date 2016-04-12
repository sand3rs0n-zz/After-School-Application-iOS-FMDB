//
//  SelectChildToAddToRosterViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 1/22/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class SelectStudentToAddToRosterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var selectStudentToAddToRosterModel = SelectStudentToAddToRosterModel()
    @IBOutlet weak var studentListTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        selectStudentToAddToRosterModel.resetStudents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setRosterID(rosterID: Int) {
        selectStudentToAddToRosterModel.setRosterID(rosterID)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let student = selectStudentToAddToRosterModel.getStudent(indexPath.row)
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = (student.getFirstName() + " " + student.getLastName())
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectStudentToAddToRosterModel.getStudentListCount()
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectStudentToAddToRosterModel.setForwardedStudentID(selectStudentToAddToRosterModel.getStudent(indexPath.row).getStudentID())
        performSegueWithIdentifier("SelectStudentToAddToRoster", sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "SelectStudentToAddToRoster") {
            let aeavc = segue.destinationViewController as? AddOrEditAttendanceViewController
            aeavc?.setState(1)
            aeavc?.setTitleValue("Add Student to Roster")
            aeavc?.setStudentId(selectStudentToAddToRosterModel.getForwardedStudentID())
            aeavc?.setRosterId(selectStudentToAddToRosterModel.getRosterID())
            aeavc?.setButtonText("Add Attendance")
        }
    }

    @IBAction func returnToSelectStudentToAddToRosterUnwind(segue: UIStoryboardSegue) {
        selectStudentToAddToRosterModel.resetStudents()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.studentListTable.reloadData()
        })
    }
}
