//
//  StudentInfoViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class StudentInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var studentInfoModel = StudentInfoModel()
    @IBOutlet weak var studentFullName: UILabel!
    @IBOutlet weak var studentDOB: UILabel!
    @IBOutlet weak var studentSchool: UILabel!
    @IBOutlet weak var studentAge: UILabel!
    @IBOutlet weak var guardianTable: UITableView!
    @IBOutlet weak var contactTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        studentInfoModel.resetResults()
        fillPage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func fillPage() {
        studentFullName.text = studentInfoModel.getFirstName() + " " + studentInfoModel.getLastName()
        studentSchool.text = studentInfoModel.getSchool()
        studentDOB.text = studentInfoModel.getDOB()
        studentAge.text = studentInfoModel.getAge()
    }
    
    func setStudentID(id: Int) {
       studentInfoModel.setStudentID(id)
    }

    @IBAction func studentInfoUnwind(segue: UIStoryboardSegue) {
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "StudentInfoToSignOuts") {
            let sohvc = segue.destinationViewController as? SignOutHistoryViewController
            sohvc?.setState(0)
            sohvc?.setStudentID(studentInfoModel.getStudentID())
            sohvc?.setStudentName(studentFullName.text!)
        }
    }
    
    // Table functions 
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == self.guardianTable && studentInfoModel.getGuardiansCount() > 0) {
            return studentInfoModel.getGuardiansCount()
        } else if (tableView == self.contactTable && studentInfoModel.getContactNumbersCount() > 0){
            return studentInfoModel.getContactNumbersCount()
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if(tableView == self.guardianTable) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
            let row = indexPath.row
            
            if(studentInfoModel.getGuardiansCount() > 0 && row < studentInfoModel.getGuardiansCount()) {
                let guardian = studentInfoModel.getGuardian(row)
                let guardianName = guardian.getName()
                cell.textLabel?.text = guardianName
            } else {
                cell.textLabel?.text = "No Approved Guardians"
            }
        } else if(tableView == self.contactTable) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "contactCell")
            let row = indexPath.row
            
            // Fix this
            if(studentInfoModel.getContactNumbersCount() > 0 && row < studentInfoModel.getContactNumbersCount()) {
                let contact = studentInfoModel.getContactNumber(row)
                let contactName = contact.getName()
                let contactPhone = contact.getPhoneNumber()
                cell.textLabel?.text = "\(contactName): \(contactPhone)"
            } else {
                cell.textLabel?.text = "No Emergency Contacts"
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        // here do something when the person selects a Guardian?
    }
    
}
