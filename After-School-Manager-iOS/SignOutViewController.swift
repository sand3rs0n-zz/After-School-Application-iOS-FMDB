//
//  SignOutViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class SignOutViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    private var studentID = 0
    private var rosterType = 0
    private var signOutGuardian = ""
    private var rosterID = 0

    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var signatureBox: SignatureView!
    private var navTitle = ""
    
    @IBOutlet weak var selectedGuardian: UILabel! // to store which Guardian they have selected
    @IBOutlet weak var guardianPicker: UIPickerView!
    var guardianPickerData:[String] = [String]() // string array of guardian names
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleBar.title = "Sign Out " + navTitle

        // Do any additional setup after loading the view.
        
//        // Data connections
//        self.guardianPicker.delegate = self
//        self.guardianPicker.dataSource = self
        
        // Need to query for all guardians for this studentID
//        getAllGuardians()
        // First hardcoding this in
        guardianPickerData = ["Mom", "Dad", "Brother", "Sister", "Grandma"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setStudentID(id: Int) {
        studentID = id
    }

    func setTitleValue(title: String) {
        navTitle = title
    }

    func setRosterType(type: Int) {
        rosterType = type
    }

    func setRosterID(id: Int) {
        rosterID = id
    }
    
//    func getAllGuardians() {
//        // Will need to add a query to list all the guardians for this student w/ the particular student ID.
//    }

    @IBAction func clearSignature(sender: AnyObject) {
        signatureBox.setLines([])
        signatureBox.setNeedsDisplay()
    }

    @IBAction func signOut(sender: AnyObject) {
        if (/*signOutGuardian != "" ||*/ !signatureBox.getLines().isEmpty) {
            let timestamp = Date()
            let signOutSQL = "INSERT INTO SIGNOUTS (studentID, rosterID, signOutGuardian, rosterType, signoutType, day, month, year, hour, minute) VALUES ('\(studentID)', '\(rosterID)', '\(signOutGuardian)', '\(rosterType)', '1', '\(timestamp.getCurrentDay())', '\(timestamp.getCurrentMonth())', '\(timestamp.getCurrentYear())', '\(timestamp.getCurrentHour())', '\(timestamp.getCurrentMinute())')"
            database.update(signOutSQL)
            self.performSegueWithIdentifier("SignOutToStudentSelectUnwind", sender: self)
        } else {
            print("error message")
        }
    }
    
    // Actions for when user selects to add a One-Time Guardian
    @IBAction func selectOneTimeGuardian(sender: AnyObject) {
        var name:String = ""
        
        let alertController = UIAlertController(title: "One-Time Guardian", message: "Please enter your name.", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
                print("Cancelled")
        }
        alertController.addAction(cancelAction)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "<Your name here>"
            name = ((alertController.textFields?.first)! as UITextField).text!
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .Default) { (action) -> Void in
            self.selectedGuardian.text = name
        }
        alertController.addAction(submitAction)
        
        self.presentViewController(alertController, animated: true) {
            // Not really sure what to do here, actually
        }
    }
    
    // Necessary methods for using UIPicker
    // Columns of data - here just 1 
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    // Rows of data - here size of guardian list
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return guardianPickerData.count
    }
    // Data to show on scroll
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return guardianPickerData[row]
    }
    // Detect selection from user
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedGuardian.text = guardianPickerData[row]
    }
}
