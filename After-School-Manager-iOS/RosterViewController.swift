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
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rosterViewModel.getStudentsCount()
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        rosterViewModel.setForwardedStudentID(rosterViewModel.getStudent(indexPath.row).getStudentID())
        performSegueWithIdentifier("SpecificRosterToEditStudent", sender: self)
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
<<<<<<< HEAD
            let crvc = segue.destinationViewController as? CreateRosterViewController
            crvc?.setState(1)
            crvc?.setTitleValue("Edit Roster")
            crvc?.setExistingRoster(roster)
            crvc?.setCreateRosterButtonValue("Update Roster")
=======
            let aoervc = segue.destinationViewController as? AddOrEditRosterViewController
            aoervc?.setState(1)
            aoervc?.setTitleValue("Edit Roster")
            aoervc?.setExistingRoster(rosterViewModel.getRoster())
            aoervc?.setCreateRosterButtonValue("Edit Roster")
>>>>>>> 4e369837c0a35629579ed860773fcf56999fa870
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
