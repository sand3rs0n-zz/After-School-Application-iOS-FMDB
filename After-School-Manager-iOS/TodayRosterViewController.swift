//
//  TodayRosterViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/17/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class TodayRosterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var todayRosterModel = TodayRosterModel()
    @IBOutlet weak var studentListTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        todayRosterModel.resetStudents()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let student = todayRosterModel.getStudent(indexPath.section, j: indexPath.row)
        var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        if (indexPath.row >= todayRosterModel.getNumberOfNonSignedOut(indexPath.section)) {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
            cell.detailTextLabel?.text = "Signed Out"
            cell.detailTextLabel?.textColor = UIColor.redColor()
            cell.detailTextLabel?.textAlignment = NSTextAlignment.Right
        }
        let name = student.getStudentFirstName() + " " + student.getStudentLastName()
        cell.textLabel?.text = name
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todayRosterModel.getSectionSize(section)
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return todayRosterModel.getSectionTitle(section)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return todayRosterModel.getSectionSizeCount()
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student = todayRosterModel.getStudent(indexPath.section, j: indexPath.row)
        todayRosterModel.setForwardedStudentID(student.getStudentID())
        todayRosterModel.setForwardedRosterID(student.getRosterID())
        todayRosterModel.setForwardedStudentFirstName(student.getStudentFirstName())
        todayRosterModel.setForwardedStudentLastName(student.getStudentLastName())
        performSegueWithIdentifier("TodayRosterToEditAttendance", sender: self)

    }

    @IBAction func returnToTodayRosterUnwind(segue: UIStoryboardSegue) {
        todayRosterModel.resetStudents()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.studentListTable.reloadData()
        })
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "TodayRosterToEditAttendance") {
            let etavc = segue.destinationViewController as? EditTodayAttendanceViewController
            etavc?.setStudentID(todayRosterModel.getForwardedStudentID())
            etavc?.setRosterID(todayRosterModel.getForwardedRosterID())
            etavc?.setStudentFirstName(todayRosterModel.getForwardedStudentFirstName())
            etavc?.setStudentLastName(todayRosterModel.getForwardedStudentLastName())
        }
    }
}
