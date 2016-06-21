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
    @IBOutlet weak var addToRoster: UIButton!
    @IBOutlet weak var signOutRecordsButton: UIButton!
    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var active: UISegmentedControl!
    @IBOutlet weak var guardianTable: UITableView!
    @IBOutlet weak var contactTable: UITableView!
    @IBOutlet weak var addFamilyButton: UIBarButtonItem!
    @IBOutlet weak var bottomToolbar: UIToolbar!

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
        addToRoster.hidden = true
        signOutRecordsButton.hidden = true
        bottomToolbar.items?.removeLast()
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


    @IBAction func addFamily(sender: AnyObject) {
        self.titleBar.title = "Add Family Member"
        self.addUpdateButton!.setTitle("Add Family Member", forState: .Normal)
        firstName.text = ""
        lastName.text = ""
        addOrEditStudentModel.setAddFamily()
        addOrEditStudentModel.setUpdate(false)
        addToRoster.hidden = true
        signOutRecordsButton.hidden = true
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

    @IBAction func addGuardian(sender: AnyObject) {
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
                let nameText = name.stringByReplacingOccurrencesOfString("'", withString: "''")
                let insertSQL = "INSERT INTO GUARDIANS (studentID, name) VALUES ('\(self.addOrEditStudentModel.getStudentID())', '\(nameText)')"
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

    @IBAction func addContact(sender: AnyObject) {
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
                let nameText = name.stringByReplacingOccurrencesOfString("'", withString: "''")
                let numberText = number.stringByReplacingOccurrencesOfString("'", withString: "''")
                let insertSQL = "INSERT INTO CONTACTNUMBERS (studentID, phoneNumber, name) VALUES ('\(self.addOrEditStudentModel.getStudentID())', '\(numberText)', '\(nameText)')"
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
            let firstNameText = firstName.text!.stringByReplacingOccurrencesOfString("'", withString: "''")
            let lastNameText = lastName.text!.stringByReplacingOccurrencesOfString("'", withString: "''")
            let schoolText = school.text!.stringByReplacingOccurrencesOfString("'", withString: "''")
            if (addOrEditStudentModel.getUpdate()) {
                insertSQL = "UPDATE STUDENTPROFILES SET firstName = '\(firstNameText)', lastName = '\(lastNameText)', active = '\(activeBool)', school = '\(schoolText)', birthDay = '\(Int(dateArr[1])!)', birthMonth = '\(Int(dateArr[0])!)', birthYear = '\(Int(dateArr[2])!)' WHERE studentID = '\(addOrEditStudentModel.getStudentID())'"
                absencesList = "UPDATE ABSENCESLIST SET studentFirstName = '\(firstNameText)', studentLastName = '\(lastNameText)' WHERE studentID = '\(addOrEditStudentModel.getStudentID())'"
                studentRosters = "UPDATE STUDENTROSTERS SET studentFirstName = '\(firstNameText)', studentLastName = '\(lastNameText)' WHERE studentID = '\(addOrEditStudentModel.getStudentID())'"
            } else {
                insertSQL = "INSERT INTO STUDENTPROFILES (firstName, lastName, active, school, birthDay, birthMonth, birthYear) VALUES ('\(firstNameText)', '\(lastNameText)', '\(activeBool)', '\(schoolText)', '\(Int(dateArr[1])!)', '\(Int(dateArr[0])!)', '\(Int(dateArr[2])!)')"
            }

            let result1 = database.update(insertSQL)
            var result2 = false
            var result3 = false
            if (addOrEditStudentModel.getUpdate()) {
                result2 = database.update(absencesList)
                result3 = database.update(studentRosters)
            }
            if (result1 && (!addOrEditStudentModel.getUpdate() || (result2 && result3))) {
                if (addOrEditStudentModel.getAddFamily()) {
                    let result = database.search("SELECT MAX(studentID) as id FROM STUDENTPROFILES")
                    result.next()
                    addOrEditStudentModel.setStudentID(Int(result.intForColumn("id")))
                    for i in 0 ..< addOrEditStudentModel.getGuardiansCount() {
                        let insertGuardians = "INSERT INTO GUARDIANS (studentID, name) VALUES ('\(self.addOrEditStudentModel.getStudentID())', '\(addOrEditStudentModel.getGuardian(i).getName())')"
                        if (database.update(insertGuardians)) {
                            continue
                        } else {
                            let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Add Guardian to Guardians Database")
                            errorAlert.displayError()
                        }

                    }
                    for i in 0 ..< addOrEditStudentModel.getContactNumbersCount() {
                        let insertContacts = "INSERT INTO CONTACTNUMBERS (studentID, phoneNumber, name) VALUES ('\(self.addOrEditStudentModel.getStudentID())', '\(addOrEditStudentModel.getContactNumber(i).getPhoneNumber())', '\(addOrEditStudentModel.getContactNumber(i).getName())')"
                        if (database.update(insertContacts)) {
                            continue
                        } else {
                            let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Add Contact to Contacts Database")
                            errorAlert.displayError()
                        }
                    }
                } else if (!addOrEditStudentModel.getUpdate()) {
                    let result = database.search("SELECT MAX(studentID) as id FROM STUDENTPROFILES")
                    result.next()
                    addOrEditStudentModel.setStudentID(Int(result.intForColumn("id")))
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
        } else {
            let errorAlert = ErrorAlert(viewController: self, errorString: "Ensure all fields have a value")
            errorAlert.displayError()
        }
    }

    private func validatFields() -> Bool {
        if (school.text == "") {
            school.text = "N/A"
        }
        if (firstName.text == "" || lastName.text == "") {
            return false
        }
        return true
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

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            if (tableView == self.guardianTable && addOrEditStudentModel.getGuardiansCount() > 0) {
                let deleteGuardians = "DELETE FROM GUARDIANS WHERE guardianID = '\(addOrEditStudentModel.getGuardian(indexPath.row).getGuardianID())'"
                let result = database.update(deleteGuardians)
                if (result) {
                    addOrEditStudentModel.removeGuardian(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    if (addOrEditStudentModel.getGuardiansCount() == 0) {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.guardianTable.reloadData()
                        })
                    }
                }
            } else if (tableView == self.contactTable && addOrEditStudentModel.getContactNumbersCount() > 0) {
                let deleteContacts = "DELETE FROM CONTACTNUMBERS WHERE contactID = '\(self.addOrEditStudentModel.getContactNumber(indexPath.row).getContactID())'"
                let result = database.update(deleteContacts)
                if (result) {
                    addOrEditStudentModel.removeContact(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    if (addOrEditStudentModel.getContactNumbersCount() == 0) {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.contactTable.reloadData()
                        })
                    }
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == self.guardianTable && addOrEditStudentModel.getGuardiansCount() > 0) {
            return addOrEditStudentModel.getGuardiansCount() + 1
        } else if(tableView == self.contactTable && addOrEditStudentModel.getContactNumbersCount() > 0) {
            return addOrEditStudentModel.getContactNumbersCount() + 1
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if(tableView == self.guardianTable) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
            cell.textLabel?.font  = UIFont(name: "Arial", size: 20.0)
            let row = indexPath.row

            if (addOrEditStudentModel.getGuardiansCount() == 0) {
                cell.textLabel?.text = "No Approved Guardians"
            }
            
            if (addOrEditStudentModel.getGuardiansCount() > 0 && row < addOrEditStudentModel.getGuardiansCount()) {
                let guardian = addOrEditStudentModel.getGuardian(row)
                let guardianName = guardian.getName()
                cell.textLabel?.text = guardianName
            }
        } else if (tableView == self.contactTable) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "contactCell")
            cell.textLabel?.font  = UIFont(name: "Arial", size: 20.0)
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
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    // Hide keyboard when done typing 
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
