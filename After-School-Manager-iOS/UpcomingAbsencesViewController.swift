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
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        var name = (absence.getStudentFirstName() + " " + absence.getStudentLastName())
        upcomingAbsencesModel.setDate(absence.getDay(), month: absence.getMonth(), year: absence.getYear())
        name.appendContentsOf("\t\t")
        name.appendContentsOf(upcomingAbsencesModel.fullDateAmerican())
        cell.textLabel?.text = name
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingAbsencesModel.getAbsencesCount()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        upcomingAbsencesModel.setForwardedAbsence(upcomingAbsencesModel.getAbsence(indexPath.row))
        performSegueWithIdentifier("UpcomingAbsenceToUpdateAbsence", sender: self)
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
