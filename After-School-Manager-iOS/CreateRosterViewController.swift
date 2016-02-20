//
//  CreateRosterViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 1/18/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class CreateRosterViewController: UIViewController {

    @IBOutlet weak var rosterName: UITextField!
    @IBOutlet weak var rosterType: UIPickerView!
    @IBOutlet weak var pickUpTime: UIDatePicker!
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var createRosterButton: UIButton!
    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var deleteRosterButton: UIButton!

    private var state = 0
    private var navTitle = ""
    private var buttonText = ""
    private var existingRoster = Roster()

    private var options = ["Day Camp", "Week Camp", "After School Program"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        endDate.hidden = true;
        endDateLabel.hidden = true;

        self.titleBar.title = navTitle
        self.createRosterButton!.setTitle(buttonText, forState: .Normal)

        if (state == 0) {
            hideElements()
        } else if (state == 1) {
            fillElements()
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent componenet: Int) -> Int {
        return options.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return options[row]
    }

    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int) {
        let selected = options[row]
        if (selected == "Day Camp") {
            endDate.hidden = true;
            endDateLabel.hidden = true;
        } else {
            endDate.hidden = false;
            endDateLabel.hidden = false;
        }
    }

    func setState(state: Int) {
        self.state = state
    }

    func setTitleValue(navTitle: String) {
        self.navTitle = navTitle
    }

    func setCreateRosterButtonValue(buttonText: String) {
        self.buttonText = buttonText
    }

    func setExistingRoster(roster: Roster) {
        existingRoster = roster
    }

    private func hideElements() {
        deleteRosterButton.hidden = true
    }

    private func fillElements() {
        //put stuff in proper fields
        let roster = existingRoster
        rosterName.text = roster.getName()

        rosterType.selectRow(roster.getRosterType(), inComponent: 0, animated: true)
        if (roster.getRosterType() > 0) {
            endDate.hidden = false;
            endDateLabel.hidden = false;
        }

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"

        var dateString = String(roster.getStartDay()) + "/" + String(roster.getStartMonth()) + "/" + String(roster.getStartYear())
        var convertedStartDate = dateFormatter.dateFromString(dateString)
        startDate.date = convertedStartDate!

        dateString = String(roster.getEndDay()) + "/" + String(roster.getEndMonth()) + "/" + String(roster.getEndYear())
        convertedStartDate = dateFormatter.dateFromString(dateString)
        endDate.date = convertedStartDate!

        var hour = roster.getPickUpHour()
        var ampm = "AM"
        if (hour > 12) {
            hour = hour - 12
            ampm = "PM"
        }
        dateFormatter.dateFormat = "h:m:a"
        dateString = String(hour) +  ":" + String(roster.getPickUpMinute()) + ":" + ampm
        convertedStartDate = dateFormatter.dateFromString(dateString)
        pickUpTime.date = convertedStartDate!
    }

    @IBAction func backButton(sender: AnyObject) {
        back()
    }

    private func back() {
        if (state == 0) {
            performSegueWithIdentifier("ReturnToAllRostersUnwind", sender: self)
        } else if (state == 1) {
            performSegueWithIdentifier("ReturnToRosterUnwind", sender: self)
        }
    }

    @IBAction func deleteRoster(sender: AnyObject) {
        let myAlertController = UIAlertController(title: "Delete Roster", message: "Are you sure you want to delete this roster?", preferredStyle: .Alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Do some stuff
        }
        myAlertController.addAction(cancelAction)

        let nextAction = UIAlertAction(title: "Delete", style: .Default) { action -> Void in
            let path = Util.getPath("AfterSchoolData.sqlite")
            let contactDB = FMDatabase(path: path)

            if contactDB.open() {
                let insertSQL = "DELETE FROM ROSTERS WHERE rosterID = '\(self.existingRoster.getRosterID())'"
                let deleteSignOut = "DELETE FROM SIGNOUTS WHERE rosterID = '\(self.existingRoster.getRosterID())'"
                let deleteStudentRosters = "DELETE FROM STUDENTROSTERS WHERE rosterID = '\(self.existingRoster.getRosterID())'"
                let result1 = contactDB.executeUpdate(insertSQL, withArgumentsInArray: nil)
                if !result1 {
                    print("Error: \(contactDB.lastErrorMessage())")
                } else {
                    print("Deleted")
                }
                let result2 = contactDB.executeUpdate(deleteSignOut, withArgumentsInArray: nil)
                if !result2 {
                    print("Error: \(contactDB.lastErrorMessage())")
                } else {
                    print("Deleted")
                }
                let result3 = contactDB.executeUpdate(deleteStudentRosters, withArgumentsInArray: nil)
                if !result3 {
                    print("Error: \(contactDB.lastErrorMessage())")
                } else {
                    print("Deleted")
                }
                contactDB.close()
                if (result1 && result2 && result3) {
                    self.back()
                }
            }
        }
        myAlertController.addAction(nextAction)
        presentViewController(myAlertController, animated: true, completion: nil)
        //also delete all relevant info

    }

    @IBAction func createRoster(sender: AnyObject) {
        let selected = rosterType.selectedRowInComponent(0)
        if (options[selected] == "Day Camp") {
            endDate.setDate(startDate.date, animated: true)
        }

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.dateFormat = "MM/dd/yyyy"

        var inputDate = dateFormatter.stringFromDate(startDate.date)
        var dateArr = inputDate.characters.split{$0 == "/"}.map(String.init)
        let startDay = Int(dateArr[1])!
        let startMonth = Int(dateArr[0])!
        let startYear = Int(dateArr[2])!

        inputDate = dateFormatter.stringFromDate(endDate.date)
        dateArr = inputDate.characters.split{$0 == "/"}.map(String.init)
        let endDay = Int(dateArr[1])!
        let endMonth = Int(dateArr[0])!
        let endYear = Int(dateArr[2])!

        dateFormatter.dateFormat = "h:mm:a"
        inputDate = dateFormatter.stringFromDate(pickUpTime.date)
        dateArr = inputDate.characters.split{$0 == ":"}.map(String.init)
        if (dateArr[2] == "PM") {
            dateArr[0] = String(Int(dateArr[0])! + 12)
        }
        let pickUpHour = Int(dateArr[0])!
        let pickUpMinute = Int(dateArr[1])!

        let path = Util.getPath("AfterSchoolData.sqlite")
        let contactDB = FMDatabase(path: path)
        var insertSQL = ""
        var updateSignOut = ""
        var updateStudentRosters = ""

        if contactDB.open() {
            if (rosterName.text != "") {
                if (state == 1) {
                    insertSQL = "UPDATE ROSTERS SET rosterType = '\(selected)', name = '\(rosterName.text!)', startDay = '\(startDay)', startMonth = '\(startMonth)', startYear = '\(startYear)', endDay = '\(endDay)', endMonth = '\(endMonth)', endYear = '\(endYear)', pickUpHour = '\(pickUpHour)', pickUpMinute = '\(pickUpMinute)' WHERE rosterID = '\(existingRoster.getRosterID())'"
                    existingRoster.setName(rosterName.text!)
                    updateSignOut = "UPDATE SIGNOUTS SET rosterType = '\(selected)' WHERE rosterID = '\(existingRoster.getRosterID())'"
                    updateStudentRosters = "UPDATE STUDENTROSTERS SET rosterName = '\(rosterName.text!)' WHERE rosterID = '\(existingRoster.getRosterID())'"
                } else if (state == 0) {
                    insertSQL = "INSERT INTO ROSTERS (rosterType, name, startDay, startMonth, startYear, endDay, endMonth, endYear, pickUpHour, pickUpMinute) VALUES ('\(selected)', '\(rosterName.text!)', '\(startDay)', '\(startMonth)', '\(startYear)', '\(endDay)', '\(endMonth)', '\(endYear)', '\(pickUpHour)', '\(pickUpMinute)')"
                }
            }

            let result1 = contactDB.executeUpdate(insertSQL, withArgumentsInArray: nil)
            if !result1 {
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                print("Successful")
            }
            let result2 = contactDB.executeUpdate(updateSignOut, withArgumentsInArray: nil)
            if !result2 {
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                print("Successful")
            }
            let result3 = contactDB.executeUpdate(updateStudentRosters, withArgumentsInArray: nil)
            if !result3 {
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                print("Successful")
            }
            contactDB.close()
            if (result1 && result2 && result3) {
                self.back()
            }
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }

    }
}
