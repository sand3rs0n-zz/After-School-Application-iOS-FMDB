//
//  AddOrEditStudentViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 1/18/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class AddOrEditStudentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var addOrEditStudentModel = AddOrEditStudentModel()

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    @IBOutlet weak var school: UITextField!
    @IBOutlet weak var addUpdateButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var addToRoster: UIButton!
    @IBOutlet weak var signOutRecordsButton: UIButton!
    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var active: UISegmentedControl!
    @IBOutlet weak var guardianTable: UITableView!
    @IBOutlet weak var contactTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleBar.title = addOrEditStudentModel.getTitleValue()
        self.addUpdateButton!.setTitle(addOrEditStudentModel.getButtonText(), forState: .Normal)
        if (addOrEditStudentModel.getUpdate()) {
            addOrEditStudentModel.resetResults()
            fillFields()
        } else {
            hideFields()
        }
        // Do any additional setup after loading the view.
    }

    private func fillFields() {
        let student = addOrEditStudentModel.getStudent()
        firstName.text = student.getFirstName()
        lastName.text = student.getLastName()
        school.text = student.getSchool()
        setBirthDate()
        let activeValue = student.getActive()
        if (activeValue == 1) {
            active.selectedSegmentIndex = 0
        } else {
            active.selectedSegmentIndex = 1
        }
    }

    private func hideFields() {
        deleteButton.hidden = true
        addToRoster.hidden = true
        signOutRecordsButton.hidden = true
    }

    private func setBirthDate() {
        let student = addOrEditStudentModel.getStudent()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = String(student.getBirthDay()) + "/" + String(student.getBirthMonth()) + "/" + String(student.getBirthYear())
        let convertedStartDate = dateFormatter.dateFromString(dateString)
        birthdayPicker.date = convertedStartDate!
    }

    func setTitleValue(navTitle: String) {
        addOrEditStudentModel.setTitleValue(navTitle)
    }
    func setAddUpdateButtonText(buttonText: String) {
        addOrEditStudentModel.setButtonText(buttonText)
    }
    func setUpdate(update: Bool) {
        addOrEditStudentModel.setUpdate(update)
    }
    func setStudentID(studentID: Int) {
        addOrEditStudentModel.setStudentID(studentID)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backButton(sender: AnyObject) {
        if (!addOrEditStudentModel.getUpdate()) {
            let deleteGuardians = "DELETE FROM GUARDIANS WHERE studentID = '\(self.addOrEditStudentModel.getStudentID())'"
            let deleteContactNumbers = "DELETE FROM CONTACTNUMBERS WHERE studentID = '\(self.addOrEditStudentModel.getStudentID())'"
            database.update(deleteGuardians)
            database.update(deleteContactNumbers)
        }
        back()
    }

    private func back() {
        performSegueWithIdentifier("AllStudentsUnwind", sender: self)
    }
    
    @IBAction func updateStudent(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let inputDate = dateFormatter.stringFromDate(birthdayPicker.date)
        let dateArr = inputDate.characters.split{$0 == "/"}.map(String.init)
        var activeBool = 0
        if (active.selectedSegmentIndex == 0) {
            activeBool = 1
        } else if (active.selectedSegmentIndex == 1) {
            activeBool = 0
        }

        var insertSQL = ""
        var absencesList = ""
        var studentRosters = ""

        if (validatFields()) {
            if (addOrEditStudentModel.getUpdate()) {
                insertSQL = "UPDATE STUDENTPROFILES SET firstName = '\(firstName.text!)', lastName = '\(lastName.text!)', active = '\(activeBool)', school = '\(school.text!)', birthDay = '\(Int(dateArr[1])!)', birthMonth = '\(Int(dateArr[0])!)', birthYear = '\(Int(dateArr[2])!)' WHERE studentID = '\(addOrEditStudentModel.getStudentID())'"
                absencesList = "UPDATE ABSENCESLIST SET studentFirstName = '\(firstName.text!)', studentLastName = '\(lastName.text!)' WHERE studentID = '\(addOrEditStudentModel.getStudentID())'"
                studentRosters = "UPDATE STUDENTROSTERS SET studentFirstName = '\(firstName.text!)', studentLastName = '\(lastName.text!)' WHERE studentID = '\(addOrEditStudentModel.getStudentID())'"
            } else {
                insertSQL = "INSERT INTO STUDENTPROFILES (firstName, lastName, active, school, birthDay, birthMonth, birthYear) VALUES ('\(firstName.text!)', '\(lastName.text!)', '\(activeBool)', '\(school.text!)', '\(Int(dateArr[1])!)', '\(Int(dateArr[0])!)', '\(Int(dateArr[2])!)')"
            }

            let result1 = database.update(insertSQL)
            var result2 = false
            var result3 = false
            if (addOrEditStudentModel.getUpdate()) {
                result2 = database.update(absencesList)
                result3 = database.update(studentRosters)
            }
            if (result1 && (!addOrEditStudentModel.getUpdate() || (result2 && result3))) {
                if (!addOrEditStudentModel.getUpdate()) {
                    addOrEditStudentModel.resetResults()
                    let updateGuardians = "UPDATE GUARDIANS SET studentID = '\(addOrEditStudentModel.getStudentID())' WHERE studentID = '\(0)'"
                    let updateContacts = "UPDATE CONTACTNUMBERS SET studentID = '\(addOrEditStudentModel.getStudentID())' WHERE studentID = '\(0)'"
                    database.update(updateGuardians)
                    database.update(updateContacts)
                }
                self.back()
            } else if (!result1) {
                let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Add Student to StudentProfiles Database")
                errorAlert.displayError()
            } else if (!result2) {
                let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Update Student in Absences Database")
                errorAlert.displayError()
            } else if (!result3) {
                let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Update Student in StudentRosters Database")
                errorAlert.displayError()
            }
        }
    }

    private func validatFields() -> Bool {
        if (firstName.text == "" || lastName.text == "" || school.text == ""){
            return false
        }
        return true
    }

    @IBAction func deleteStudent(sender: AnyObject) {
        let myAlertController = UIAlertController(title: "Delete Student", message: "Are you sure you want to delete the student?", preferredStyle: .Alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Do some stuff
        }
        myAlertController.addAction(cancelAction)

        let nextAction = UIAlertAction(title: "Delete", style: .Default) { action -> Void in
            let insertSQL = "DELETE FROM STUDENTPROFILES WHERE studentID = '\(self.addOrEditStudentModel.getStudentID())'"
            let deleteStudentRosters = "DELETE FROM STUDENTROSTERS WHERE studentID = '\(self.addOrEditStudentModel.getStudentID())'"
            let deleteSignOuts = "DELETE FROM SIGNOUTS WHERE studentID = '\(self.addOrEditStudentModel.getStudentID())'"
            let deleteOneTimeAttendance = "DELETE FROM ONETIMEATTENDANCE WHERE studentID = '\(self.addOrEditStudentModel.getStudentID())'"
            let deleteGuardians = "DELETE FROM GUARDIANS WHERE studentID = '\(self.addOrEditStudentModel.getStudentID())'"
            let deleteContactNumbers = "DELETE FROM CONTACTNUMBERS WHERE studentID = '\(self.addOrEditStudentModel.getStudentID())'"
            let deleteAbsencesList = "DELETE FROM ABSENCESLIST WHERE studentID = '\(self.addOrEditStudentModel.getStudentID())'"
            let result1 = database.update(insertSQL)
            let result2 = database.update(deleteStudentRosters)
            let result3 = database.update(deleteSignOuts)
            let result4 = database.update(deleteOneTimeAttendance)
            let result5 = database.update(deleteGuardians)
            let result6 = database.update(deleteContactNumbers)
            let result7 = database.update(deleteAbsencesList)

            if (result1 && result2 && result3 && result4 && result5 && result6 && result7) {
                self.back()
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

    @IBAction func editStudentInfoUnwind(segue: UIStoryboardSegue) {
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let student = addOrEditStudentModel.getStudent()
        if (segue.identifier == "EditStudentInfoToSignOuts") {
            let sohvc = segue.destinationViewController as? SignOutHistoryViewController
            sohvc?.setState(1)
            sohvc?.setStudentID(student.getStudentID())
            sohvc?.setStudentName(student.getFirstName() + " " + student.getLastName())
        } else if (segue.identifier == "EditStudentToRosterHistory") {
            let rhvc = segue.destinationViewController as? RosterHistoryViewController
            rhvc?.setStudentID(student.getStudentID())
        }
    }
    
    // Table functions
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == self.guardianTable && addOrEditStudentModel.getGuardiansCount() > 0) {
            return addOrEditStudentModel.getGuardiansCount() + 1
        } else if(tableView == self.contactTable && addOrEditStudentModel.getContactNumbersCount() > 0) {
            return addOrEditStudentModel.getContactNumbersCount() + 1
        } else {
            return 2
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if(tableView == self.guardianTable) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
            let row = indexPath.row

            if (addOrEditStudentModel.getGuardiansCount() == 0) {
                cell.textLabel?.text = "No Approved Guardians"
            }
            
            if (addOrEditStudentModel.getGuardiansCount() > 0 && row < addOrEditStudentModel.getGuardiansCount()) {
                let guardian = addOrEditStudentModel.getGuardian(row)
                let guardianName = guardian.getName()
                cell.textLabel?.text = guardianName
            }
            else if (row == addOrEditStudentModel.getGuardiansCount()) {
                cell.textLabel?.text = "Add New Guardian"
                cell.textLabel?.textColor = UIColor.redColor()
                cell.textLabel?.font = UIFont.boldSystemFontOfSize(17.0)
            }
        } else if (tableView == self.contactTable) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "contactCell")
            let row = indexPath.row

            if (addOrEditStudentModel.getContactNumbersCount() == 0) {
                cell.textLabel?.text = "No Emergency Contacts"
            }

            if (addOrEditStudentModel.getContactNumbersCount() > 0 && row < addOrEditStudentModel.getContactNumbersCount()) {
                let contact = addOrEditStudentModel.getContactNumber(row)
                let contactName = contact.getName()
                let contactPhone = contact.getPhoneNumber()
                cell.textLabel?.text = "\(contactName): \(contactPhone)"
            }
            else if (row == addOrEditStudentModel.getContactNumbersCount()){
                cell.textLabel?.text = "Add New Contact"
                cell.textLabel?.textColor = UIColor.redColor()
                cell.textLabel?.font = UIFont.boldSystemFontOfSize(17.0)
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView == self.guardianTable) {
            let indexPath = self.guardianTable.indexPathForSelectedRow
            let selectedCell = self.guardianTable.cellForRowAtIndexPath(indexPath!)! as UITableViewCell
            if(selectedCell.textLabel!.text == "Add New Guardian") {
                print("Add New Guardian Selected")
                var name:String = ""
                
                let alertController = UIAlertController(title: "New Guardian", message: "Please enter your name.", preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
                    print("Cancelled")
                }
                alertController.addAction(cancelAction)
                
                alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
                    textField.placeholder = "Guardian Name"
                }
                
                let submitAction = UIAlertAction(title: "Submit", style: .Default) { (action) -> Void in
                    name = ((alertController.textFields?.first)! as UITextField).text!
                    if(name != "") {
                        print("Added guardian \(name)")
                        let insertSQL = "INSERT INTO GUARDIANS (studentID, name) VALUES ('\(self.addOrEditStudentModel.getStudentID())', '\(name)')"
                        let result = database.update(insertSQL)
                        if (result) {
                            self.addOrEditStudentModel.resetGuardians()
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.guardianTable.reloadData()
                            })
                        }                    } else {
                        print("Please enter a name")
                    }
                }
                alertController.addAction(submitAction)
                
                self.presentViewController(alertController, animated: true) {
                }
            }

        } else if(tableView == self.contactTable) {
            let indexPath = self.contactTable.indexPathForSelectedRow
            let selectedCell = self.contactTable.cellForRowAtIndexPath(indexPath!)! as UITableViewCell
            if(selectedCell.textLabel!.text == "Add New Contact") {
                print("Add New Contact Selected")
                var name:String = ""
                var number:String = ""
                
                let alertController = UIAlertController(title: "New Contact", message: "Please enter your name.", preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
                    print("Cancelled")
                }
                alertController.addAction(cancelAction)
                
                alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
                    textField.placeholder = "Contact Name"
                }
                
                alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
                    textField.placeholder = "Phone Number"
                }
                
                let submitAction = UIAlertAction(title: "Submit", style: .Default) { (action) -> Void in
                    name = ((alertController.textFields?.first)! as UITextField).text!
                    number = ((alertController.textFields?.last)! as UITextField).text!
                    if(name != "" && number != "") {
                        print("Added contact \(name) with number \(number)")
                        let insertSQL = "INSERT INTO CONTACTNUMBERS (studentID, phoneNumber, name) VALUES ('\(self.addOrEditStudentModel.getStudentID())', '\(number)', '\(name)')"
                        let result = database.update(insertSQL)
                        if (result) {
                            self.addOrEditStudentModel.resetContactNumbers()
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.contactTable.reloadData()
                            })
                        }
                    } else {
                        print("Please enter a name and number")
                    }
                }
                alertController.addAction(submitAction)
                
                self.presentViewController(alertController, animated: true) {
                    // Not really sure what to do here, actually
                }
            }
        }
    }
    
}
