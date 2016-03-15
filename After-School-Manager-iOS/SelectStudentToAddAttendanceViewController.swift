//
//  SelectStudentToAddAttendanceViewController.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 2/15/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import UIKit

class SelectStudentToAddAttendanceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var selectStudentToAddAttendanceModel = SelectStudentToAddAttendanceModel()
    @IBOutlet weak var studentListTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        selectStudentToAddAttendanceModel.resetStudents()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let student = selectStudentToAddAttendanceModel.getStudent(indexPath.row)
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = student.getFirstName() + " " + student.getLastName()
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectStudentToAddAttendanceModel.getStudentListCount()
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectStudentToAddAttendanceModel.setForwardedStudentID(selectStudentToAddAttendanceModel.getStudent(indexPath.row).getStudentID())
        performSegueWithIdentifier("SelectStudentToSelectRoster", sender: self)
    }

    @IBAction func selectStudentToAddUnwind(segue: UIStoryboardSegue) {
        selectStudentToAddAttendanceModel.resetStudents()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.studentListTable.reloadData()
        })
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "SelectStudentToSelectRoster") {
            let asavc = segue.destinationViewController as? AddSpecialAttendanceViewController
            asavc?.setStudentID(
                selectStudentToAddAttendanceModel.getForwardedStudentID())
        }
    }
}
