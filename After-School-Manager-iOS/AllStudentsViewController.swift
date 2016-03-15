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
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allStudentsModel.getStudentListCount()
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student = allStudentsModel.getStudent(indexPath.row)
        allStudentsModel.setForwardedStudentID(student.getStudentID())
        performSegueWithIdentifier("InstructorMenuStudentsToEditStudent", sender: self)
    }

    @IBAction func instructorMenuStudentsUnwind(segue: UIStoryboardSegue) {
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
