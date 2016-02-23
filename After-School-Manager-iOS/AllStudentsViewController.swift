//
//  AllStudentsViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/17/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class AllStudentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var studentListTable: UITableView!

    private var studentList = [Student]()
    private var forwardedStudentID = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        getStudents()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func getStudents() {
        let querySQL = "SELECT * FROM STUDENTPROFILES ORDER BY lastName, firstName ASC"

        let results = database.search(querySQL)
        while (results.next()) {
            let cur = Student()
            cur.setStudentID(Int(results.intForColumn("studentID")))
            cur.setFirstName(results.stringForColumn("firstName"))
            cur.setLastName(results.stringForColumn("lastName"))
            cur.setActive(Int(results.intForColumn("active")))
            cur.setSchool(results.stringForColumn("school"))
            cur.setBirthDay(Int(results.intForColumn("birthDay")))
            cur.setBirthMonth(Int(results.intForColumn("birthMonth")))
            cur.setBirthYear(Int(results.intForColumn("birthYear")))
            studentList.append(cur)
        }
        results.close()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let student = studentList[indexPath.row]
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = (student.getFirstName() + " " + student.getLastName())
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentList.count
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student = studentList[(indexPath.row)]
        forwardedStudentID = student.getStudentID()
        performSegueWithIdentifier("InstructorMenuStudentsToEditStudent", sender: self)
    }

    @IBAction func instructorMenuStudentsUnwind(segue: UIStoryboardSegue) {
        studentList.removeAll()
        getStudents()
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
            aesvc?.setStudentID(forwardedStudentID)
        }
    }
}
