//
//  RosterViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 1/19/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class RosterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var rosterViewModel = RosterViewModel()

    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var studentListTable: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleBar.title = rosterViewModel.getTitleValue()
        rosterViewModel.resetStudents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setTitleValue(navTitle: String) {
        rosterViewModel.setTitleValue(navTitle)
    }
    func setRosterID(rosterID: Int) {
        rosterViewModel.setRosterID(rosterID)
    }
    func setRoster(roster: Roster) {
        rosterViewModel.setRoster(roster)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let student = rosterViewModel.getStudent(indexPath.row)
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = student.getStudentFirstName() + " " + student.getStudentLastName()
        cell.textLabel?.font  = UIFont(name: "Arial", size: 30.0)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rosterViewModel.getStudentsCount()
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        rosterViewModel.setForwardedStudentID(rosterViewModel.getStudent(indexPath.row).getStudentID())
        performSegueWithIdentifier("SpecificRosterToEditStudent", sender: self)
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            let myAlertController = UIAlertController(title: "Remove Student from Roster", message: "Are you sure you want to remove the student from this roster?", preferredStyle: .Alert)

            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
                //Do some stuff
            }
            myAlertController.addAction(cancelAction)

            let nextAction = UIAlertAction(title: "Delete", style: .Default) { action -> Void in
                let deleteSQL = "DELETE FROM STUDENTROSTERS WHERE rosterID = '\(self.rosterViewModel.getStudent(indexPath.row).getRosterID())' AND studentID = '\(self.rosterViewModel.getStudent(indexPath.row).getStudentID())'"
                let deleteSignOuts = "DELETE FROM SIGNOUTS WHERE rosterID = '\(self.rosterViewModel.getStudent(indexPath.row).getRosterID())' AND studentID = '\(self.rosterViewModel.getStudent(indexPath.row).getStudentID())'"
                let result1 = database.update(deleteSQL)
                let result2 = database.update(deleteSignOuts)
                if (result1 && result2) {
                    self.rosterViewModel.removeStudent(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    if (self.rosterViewModel.getStudentsCount() == 0) {
                        self.rosterViewModel.resetStudents()
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.studentListTable.reloadData()
                        })
                    }
                } else if (!result1) {
                    let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Delete Student From StudentRosters Database")
                    errorAlert.displayError()
                } else if (!result2) {
                    let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Delete SignOuts From StudentRosters Database")
                    errorAlert.displayError()
                }
            }
            myAlertController.addAction(nextAction)
            presentViewController(myAlertController, animated: true, completion: nil)
        }
    }

    @IBAction func returnToRosterUnwind(segue: UIStoryboardSegue) {
        rosterViewModel.resetStudents()
        self.titleBar.title = rosterViewModel.getTitleValue()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.studentListTable.reloadData()
        })
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "RosterToEditRoster") {
            let aoervc = segue.destinationViewController as? AddOrEditRosterViewController
            aoervc?.setState(1)
            aoervc?.setTitleValue("Edit Roster")
            aoervc?.setExistingRoster(rosterViewModel.getRoster())
            aoervc?.setCreateRosterButtonValue("Edit Roster")
        } else if (segue.identifier == "SpecificRosterToEditStudent") {
            let aeavc = segue.destinationViewController as? AddOrEditAttendanceViewController
            aeavc?.setState(0)
            aeavc?.setTitleValue("Edit Student Attendance")
            aeavc?.setStudentId(rosterViewModel.getForwardedStudentID())
            aeavc?.setRosterId(rosterViewModel.getRosterID())
            aeavc?.setButtonText("Update Attendance")
        } else if (segue.identifier == "SelectNewStudentToAddToRoster") {
            let ssarvc = segue.destinationViewController as? SelectStudentToAddToRosterViewController
            ssarvc?.setRosterID(rosterViewModel.getRosterID())
        }
    }
}
