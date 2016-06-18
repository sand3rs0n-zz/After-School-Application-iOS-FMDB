//
//  AllStudentsViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/17/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class AllStudentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var allStudentsModel = AllStudentsModel()
    @IBOutlet weak var studentListTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        allStudentsModel.resetStudents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let student = allStudentsModel.getStudent(indexPath.row)
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = (student.getFirstName() + " " + student.getLastName())
        cell.textLabel?.font  = UIFont(name: "Arial", size: 30.0)
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allStudentsModel.getStudentListCount()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student = allStudentsModel.getStudent(indexPath.row)
        allStudentsModel.setForwardedStudentID(student.getStudentID())
        performSegueWithIdentifier("InstructorMenuStudentsToEditStudent", sender: self)
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            let myAlertController = UIAlertController(title: "Delete Student", message: "Are you sure you want to delete the student?", preferredStyle: .Alert)

            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
                //Do some stuff
            }
            myAlertController.addAction(cancelAction)

            let nextAction = UIAlertAction(title: "Delete", style: .Default) { action -> Void in
                let insertSQL = "DELETE FROM STUDENTPROFILES WHERE studentID = '\(self.allStudentsModel.getStudent(indexPath.row).getStudentID())'"
                let deleteStudentRosters = "DELETE FROM STUDENTROSTERS WHERE studentID = '\(self.allStudentsModel.getStudent(indexPath.row).getStudentID())'"
                let deleteSignOuts = "DELETE FROM SIGNOUTS WHERE studentID = '\(self.allStudentsModel.getStudent(indexPath.row).getStudentID())'"
                let deleteOneTimeAttendance = "DELETE FROM ONETIMEATTENDANCE WHERE studentID = '\(self.allStudentsModel.getStudent(indexPath.row).getStudentID())'"
                let deleteGuardians = "DELETE FROM GUARDIANS WHERE studentID = '\(self.allStudentsModel.getStudent(indexPath.row).getStudentID())'"
                let deleteContactNumbers = "DELETE FROM CONTACTNUMBERS WHERE studentID = '\(self.allStudentsModel.getStudent(indexPath.row).getStudentID())'"
                let deleteAbsencesList = "DELETE FROM ABSENCESLIST WHERE studentID = '\(self.allStudentsModel.getStudent(indexPath.row).getStudentID())'"
                let result1 = database.update(insertSQL)
                let result2 = database.update(deleteStudentRosters)
                let result3 = database.update(deleteSignOuts)
                let result4 = database.update(deleteOneTimeAttendance)
                let result5 = database.update(deleteGuardians)
                let result6 = database.update(deleteContactNumbers)
                let result7 = database.update(deleteAbsencesList)

                if (result1 && result2 && result3 && result4 && result5 && result6 && result7) {
                    self.allStudentsModel.removeStudent(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    if (self.allStudentsModel.getStudentListCount() == 0) {
                        self.allStudentsModel.resetStudents()
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.studentListTable.reloadData()
                        })
                    }
                } else if (!result1) {
                    let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Delete Roster From StudentProfiles Database")
                    errorAlert.displayError()
                } else if (!result2) {
                    let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Delete Roster From StudentRosters Database")
                    errorAlert.displayError()
                } else if (!result3) {
                    let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Delete Roster From SignOuts Database")
                    errorAlert.displayError()
                } else if (!result4) {
                    let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Delete Roster From OneTimeAttendance Database")
                    errorAlert.displayError()
                } else if (!result5) {
                    let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Delete Roster From Guardians Database")
                    errorAlert.displayError()
                } else if (!result6) {
                    let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Delete Roster From ContactNumbers Database")
                    errorAlert.displayError()
                } else if (!result7) {
                    let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Delete Roster From AbsencesList Database")
                    errorAlert.displayError()
                }
            }
            myAlertController.addAction(nextAction)
            presentViewController(myAlertController, animated: true, completion: nil)
        }
    }

    @IBAction func allStudentsUnwind(segue: UIStoryboardSegue) {
        allStudentsModel.resetStudents()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.studentListTable.reloadData()
        })
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let aesvc = segue.destinationViewController as? AddOrEditStudentViewController
        if (segue.identifier == "InstructorMenuStudentsToAddStudent") {
            aesvc?.setTitleValue("Add New Student")
            aesvc?.setAddUpdateButtonText("Add Student")
        } else if (segue.identifier == "InstructorMenuStudentsToEditStudent") {
            aesvc?.setTitleValue("Edit Student")
            aesvc?.setAddUpdateButtonText("Update Student")
            aesvc?.setUpdate(true)
            aesvc?.setStudentID(allStudentsModel.getForwardedStudentID())
        }
    }
}
