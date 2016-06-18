//
//  UpcomingAbsencesViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class UpcomingAbsencesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var upcomingAbsencesModel = UpcomingAbsencesModel()
    @IBOutlet weak var upcomingAbsencesListTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let absence = upcomingAbsencesModel.getAbsence(indexPath.row)
        var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        let name = (absence.getStudentFirstName() + " " + absence.getStudentLastName())
        upcomingAbsencesModel.setDate(absence.getDay(), month: absence.getMonth(), year: absence.getYear())
        let date = upcomingAbsencesModel.fullDateAmerican()
        cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = name
        cell.textLabel?.font  = UIFont(name: "Arial", size: 30.0)
        cell.detailTextLabel?.text = "\(date)"
        cell.detailTextLabel?.font  = UIFont(name: "Arial", size: 30.0)
        cell.detailTextLabel?.textAlignment = NSTextAlignment.Right
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingAbsencesModel.getAbsencesCount()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        upcomingAbsencesModel.setForwardedAbsence(upcomingAbsencesModel.getAbsence(indexPath.row))
        performSegueWithIdentifier("UpcomingAbsenceToUpdateAbsence", sender: self)
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            let myAlertController = UIAlertController(title: "Delete Absence", message: "Are you sure you want to delete this scheduled absence?", preferredStyle: .Alert)

            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
                //Do some stuff
            }
            myAlertController.addAction(cancelAction)

            let nextAction = UIAlertAction(title: "Delete", style: .Default) { action -> Void in
                let absenceListSQL = "DELETE FROM ABSENCESLIST WHERE absenceID = '\(self.upcomingAbsencesModel.getAbsence(indexPath.row).getAbsenceID())'"
                let signOutSQL = "DELETE FROM SIGNOUTS WHERE signOutID = '\(self.upcomingAbsencesModel.getAbsence(indexPath.row).getAbsenceID())'"
                let result1 = database.update(absenceListSQL)
                let result2 = database.update(signOutSQL)
                if (result1 && result2) {
                    self.upcomingAbsencesModel.removeAbsence(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    if (self.upcomingAbsencesModel.getAbsencesCount() == 0) {
                        self.upcomingAbsencesModel.resetAbsences()
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.upcomingAbsencesListTable.reloadData()
                        })

                    }
                } else if (!result1) {
                    let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Delete Absence")
                    errorAlert.displayError()
                } else if (!result2) {
                    let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Delete SignOut From SignOuts Database")
                    errorAlert.displayError()
                }
            }
            myAlertController.addAction(nextAction)
            presentViewController(myAlertController, animated: true, completion: nil)

        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ScheduleAbsenceToRosterSelect") {
            let rlvc = segue.destinationViewController as? RosterListViewController
            rlvc?.setState(2)
            rlvc?.setTitleValue("Select Roster ")
        } else if (segue.identifier == "UpcomingAbsenceToUpdateAbsence") {
            let savc = segue.destinationViewController as? ScheduleAbsenceViewController
            savc?.setState(1)
            savc?.setButtonText("Update Absence")
            savc?.setAbsence(upcomingAbsencesModel.getForwardedAbsence())
        }
    }
    
    @IBAction func scheduleAbsenceUnwind(segue: UIStoryboardSegue) {
        upcomingAbsencesModel.resetAbsences()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.upcomingAbsencesListTable.reloadData()
        })
    }
}
