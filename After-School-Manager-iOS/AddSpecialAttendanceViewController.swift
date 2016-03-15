//
//  AddSpecialAttendanceViewController.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 2/15/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import UIKit

class AddSpecialAttendanceViewController: UIViewController {
    private var addSpecialAttendanceModel = AddSpecialAttendanceModel()
    @IBOutlet weak var rosterList: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        addSpecialAttendanceModel.getRosters()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setStudentID(studentID: Int) {
        addSpecialAttendanceModel.setStudentID(studentID)
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent componenet: Int) -> Int {
        return addSpecialAttendanceModel.getRostersCount()
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return addSpecialAttendanceModel.getRoster(row).getName()
    }

    @IBAction func addToOneTimeAttendance(sender: AnyObject) {
        let timestamp = Date()
        let rosterID = addSpecialAttendanceModel.getRoster(rosterList.selectedRowInComponent(0)).getRosterID()
        let insertSQL = "INSERT INTO ONETIMEATTENDANCE VALUES ('\(addSpecialAttendanceModel.getStudentID())', '\(rosterID)', '\(timestamp.getCurrentDay())', '\(timestamp.getCurrentMonth())', '\(timestamp.getCurrentYear())')"
        let result = database.update(insertSQL)
        if (result) {
            self.performSegueWithIdentifier("SelectStudentToAddUnwind", sender: self)
        } else {
            let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Add Attendance to OneTimeAttendance Database")
            errorAlert.displayError()
        }
    }
}
