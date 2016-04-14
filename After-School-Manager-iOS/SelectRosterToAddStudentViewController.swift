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
        var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        let name = roster.getName()
        let startDay = roster.getStartDay()
        let startMonth = roster.getStartMonth()
        let startYear = roster.getStartYear()
        let endDay = roster.getEndDay()
        let endMonth = roster.getEndMonth()
        let endYear = roster.getEndYear()
        let date = "\(startMonth)/\(startDay)/\(startYear) - \(endMonth)/\(endDay)/\(endYear)"
        cell.textLabel?.text = "\(name)"
        
        // ***** BUG *****
        // Date not passed in correctly, again here? 
//        cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
//        cell.detailTextLabel?.text = "\(date)"
//        cell.detailTextLabel?.textAlignment = NSTextAlignment.Right
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectRosterToAddStudentModel.getRosterListCount()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
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
