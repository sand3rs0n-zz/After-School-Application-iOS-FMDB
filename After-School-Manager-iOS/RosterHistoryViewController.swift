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
        let name = roster.getRosterName()
        // ***** BUG *****
        // Student Rosters don't have the start and end date
//        let startDay = roster.
//        let startMonth = roster.getStartMonth()
//        let startYear = roster.getStartYear()
//        let endDay = roster.getEndDay()
//        let endMonth = roster.getEndMonth()
//        let endYear = roster.getEndYear()
//        let date = "\(startMonth)/\(startDay)/\(startYear) - \(endMonth)/\(endDay)/\(endYear)"
        cell.textLabel?.text = "\(name)"
        cell.textLabel?.font  = UIFont(name: "Arial", size: 30.0)
        
//        cell.detailTextLabel?.text = "\(date)"
//        cell.detailTextLabel?.textAlignment = NSTextAlignment.Right
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rosterHistoryModel.getRosterListCount()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        rosterHistoryModel.setForwardedRosterID(rosterHistoryModel.getRoster(indexPath.row).getRosterID())
        performSegueWithIdentifier("RosterHistoryToEditAttendance", sender: self)
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            let myAlertController = UIAlertController(title: "Remove Student from Roster", message: "Are you sure you want to remove the student from this roster?", preferredStyle: .Alert)

            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
                //Do some stuff
            }
            myAlertController.addAction(cancelAction)

            let nextAction = UIAlertAction(title: "Delete", style: .Default) { action -> Void in
                let deleteSQL = "DELETE FROM STUDENTROSTERS WHERE rosterID = '\(self.rosterHistoryModel.getRoster(indexPath.row).getRosterID())' AND studentID = '\(self.rosterHistoryModel.getStudentID())'"
                let deleteSignOuts = "DELETE FROM SIGNOUTS WHERE rosterID = '\(self.rosterHistoryModel.getRoster(indexPath.row).getRosterID())' AND studentID = '\(self.rosterHistoryModel.getRoster(indexPath.row).getStudentID())'"
                let result1 = database.update(deleteSQL)
                let result2 = database.update(deleteSignOuts)
                if (result1 && result2) {
                    self.rosterHistoryModel.removeRoster(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    if (self.rosterHistoryModel.getRosterListCount() == 0) {
                        self.rosterHistoryModel.resetRosters()
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.rosterListTable.reloadData()
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

