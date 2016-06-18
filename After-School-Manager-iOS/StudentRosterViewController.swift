//
//  StudentRosterViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class StudentRosterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var studentRosterModel = StudentRosterModel()
    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var studentListTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleBar.title = studentRosterModel.getTitleValue()
        studentRosterModel.resetStudentRoster()
        if(studentRosterModel.getState() == 0) {
            self.titleBar.rightBarButtonItem = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setState(state: Int) {
        studentRosterModel.setState(state)
    }
    func setTitleValue(title: String) {
        studentRosterModel.setTitleValue(title)
    }
    func setRosterID(id: Int) {
        studentRosterModel.setRosterID(id)
    }
    func setRosterType(type: Int) {
        studentRosterModel.setRosterType(type)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let student = studentRosterModel.getStudent(indexPath.row)
        var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        if (indexPath.row >= studentRosterModel.getNumberOfNonSignedOut() && studentRosterModel.getState() == 1) {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
            cell.detailTextLabel?.text = "Signed Out"
            cell.detailTextLabel?.font  = UIFont(name: "Arial", size: 30.0)
            cell.detailTextLabel?.textColor = UIColor.redColor()
            cell.detailTextLabel?.textAlignment = NSTextAlignment.Right

        }
        let name = student.getStudentFirstName() + " " + student.getStudentLastName()
        cell.textLabel?.text = name
        cell.textLabel?.font  = UIFont(name: "Arial", size: 30.0)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentRosterModel.getStudentCount()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row < studentRosterModel.getNumberOfNonSignedOut() || studentRosterModel.getState() != 1) {
            let student: StudentRoster = studentRosterModel.getStudent(indexPath.row)
            studentRosterModel.setForwardedStudentID(student.getStudentID())
            studentRosterModel.setForwardedStudentLastName(student.getStudentLastName())
            studentRosterModel.setForwardedStudentFirstName(student.getStudentFirstName())
            segue()
        }
    }
    
    private func segue() {
        if (studentRosterModel.getState() == 0) {
            performSegueWithIdentifier("StudentRosterToStudentProfile", sender: self)
        } else if (studentRosterModel.getState() == 1) {
            performSegueWithIdentifier("StudentRosterToSignOut", sender: self)
        } else if (studentRosterModel.getState() == 2) {
            performSegueWithIdentifier("StudentRosterToScheduleAbsence", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (studentRosterModel.getState() == 2) {
            let savc = segue.destinationViewController as? ScheduleAbsenceViewController
            savc?.setState(0)
            savc?.setButtonText("Schedule Absence")
            savc?.setStudentID(studentRosterModel.getForwardedStudentID())
            savc?.setStudentLastName(studentRosterModel.getForwardedStudentLastName())
            savc?.setStudentFirstName(studentRosterModel.getForwardedStudentFirstName())
            savc?.setRosterType(studentRosterModel.getRosterType())
            savc?.setRosterID(studentRosterModel.getRosterID())
        } else if (studentRosterModel.getState() == 0) {
            let sivc = segue.destinationViewController as? StudentInfoViewController
            sivc?.setStudentID(studentRosterModel.getForwardedStudentID())
        } else if (studentRosterModel.getState() == 1) {
            let sovc = segue.destinationViewController as? SignOutViewController
            sovc?.setStudentID(studentRosterModel.getForwardedStudentID())
            sovc?.setTitleValue(studentRosterModel.getForwardedStudentFirstName() + " " + studentRosterModel.getForwardedStudentLastName())
            sovc?.setRosterType(studentRosterModel.getRosterType())
            sovc?.setRosterID(studentRosterModel.getRosterID())
        }
    }

    @IBAction func back(sender: AnyObject) {
        if (studentRosterModel.getState() == 0) {
            performSegueWithIdentifier("ReturnHomeFromStudentRoster", sender: self)
        } else if (studentRosterModel.getState() == 1) {
            performSegueWithIdentifier("ReturnToRosterSelectFromStudentRoster", sender: self)
        } else if (studentRosterModel.getState() == 2) {
            performSegueWithIdentifier("ReturnToRosterSelectFromStudentRoster", sender: self)
        }
    }
    
    @IBAction func studentSelectUnwind(segue: UIStoryboardSegue) {
        studentRosterModel.resetStudentRoster()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.studentListTable.reloadData()
        })
    }
}
