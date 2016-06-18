//
//  AllRostersViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/17/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class AllRostersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var allRostersModel = AllRostersModel()
    @IBOutlet weak var rosterListTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        allRostersModel.resetRosters()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let roster = allRostersModel.getRoster(indexPath.row)
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        let name = roster.getName()
        let startDate = Date(day: roster.getStartDay(), month: roster.getStartMonth(), year: roster.getStartYear())
        let endDate = Date(day: roster.getEndDay(), month: roster.getEndMonth(), year: roster.getEndYear())
        var date = startDate.fullDateAmerican()
        if (roster.getRosterType() != 0) {
            date = date + " - " + endDate.fullDateAmerican()
        }
        cell.textLabel?.text = "\(name)"
        cell.textLabel?.font  = UIFont(name: "Arial", size: 30.0)
        cell.detailTextLabel?.text = "\(date)"
        cell.detailTextLabel?.font  = UIFont(name: "Arial", size: 30.0)
        cell.detailTextLabel?.textAlignment = NSTextAlignment.Right
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRostersModel.getRosterListsCount()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let roster = allRostersModel.getRoster(indexPath.row)
        allRostersModel.setForwardedRosterID(roster.getRosterID())
        allRostersModel.setForwardedRosterName(roster.getName())
        allRostersModel.setForwardedRoster(roster)
        performSegueWithIdentifier("AllRostersToSpecificRoster", sender: self)
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            let myAlertController = UIAlertController(title: "Delete Roster", message: "Are you sure you want to delete this roster?", preferredStyle: .Alert)

            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
                //Do some stuff
            }
            myAlertController.addAction(cancelAction)

            let nextAction = UIAlertAction(title: "Delete", style: .Default) { action -> Void in
                let roster = self.allRostersModel.getRoster(indexPath.row)
                let insertSQL = "DELETE FROM ROSTERS WHERE rosterID = '\(roster.getRosterID())'"
                let deleteSignOut = "DELETE FROM SIGNOUTS WHERE rosterID = '\(roster.getRosterID())'"
                let deleteStudentRosters = "DELETE FROM STUDENTROSTERS WHERE rosterID = '\(roster.getRosterID())'"
                let result1 = database.update(insertSQL)
                let result2 = database.update(deleteSignOut)
                let result3 = database.update(deleteStudentRosters)
                if (result1 && result2 && result3) {
                    self.allRostersModel.removeRoster(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    if (self.allRostersModel.getRosterListsCount() == 0) {
                        self.allRostersModel.resetRosters()
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.rosterListTable.reloadData()
                        })
                    }
                } else if (!result1) {
                    let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Delete Roster From Rosters Database")
                    errorAlert.displayError()
                } else if (!result2) {
                    let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Delete Roster From Sign Outs Database")
                    errorAlert.displayError()
                } else if (!result3) {
                    let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Delete Roster From Student Rosters Database")
                    errorAlert.displayError()
                }
            }
            myAlertController.addAction(nextAction)
            presentViewController(myAlertController, animated: true, completion: nil)
        }
    }

    @IBAction func returnToAllRostersUnwind(segue: UIStoryboardSegue) {
        allRostersModel.resetRosters()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.rosterListTable.reloadData()
        })
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "AllRostersToSpecificRoster") {
            let rvc = segue.destinationViewController as? RosterViewController
            rvc?.setTitleValue(allRostersModel.getForwardedRosterName())
            rvc?.setRosterID(allRostersModel.getForwardedRosterID())
            rvc?.setRoster(allRostersModel.getForwardedRoster())
        } else if (segue.identifier == "AllRostersToNewRoster") {
            let aoervc = segue.destinationViewController as? AddOrEditRosterViewController
            aoervc?.setState(0)
            aoervc?.setTitleValue("Create Roster")
            aoervc?.setCreateRosterButtonValue("Create Roster")
        }
    }
}
