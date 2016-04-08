//
//  SignOutViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class SignOutViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    private var signOutViewModel = SignOutViewModel()
    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var signatureBox: SignatureView!
    
    @IBOutlet weak var selectedGuardian: UILabel! // to store which Guardian they have selected
    @IBOutlet weak var guardianPicker: UIPickerView!
    var guardianPickerData = [String]() // string array of guardian names
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleBar.title = "Sign Out " + signOutViewModel.getTitleValue()
        signOutViewModel.resetGuardians()
        guardianPickerData = signOutViewModel.getGuardianNames()
        if (signOutViewModel.getGuardianNamesCount() > 0) {
            self.selectedGuardian.text = signOutViewModel.getGuardianName(0)
            self.signOutViewModel.setSignOutGuardian(signOutViewModel.getGuardianName(0))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setStudentID(id: Int) {
        signOutViewModel.setStudentID(id)
    }
    func setTitleValue(title: String) {
        signOutViewModel.setTitleValue(title)
    }
    func setRosterType(type: Int) {
        signOutViewModel.setRosterType(type)
    }
    func setRosterID(id: Int) {
        signOutViewModel.setRosterID(id)
    }

    private func latePickUp(timestamp: Date) -> Bool {
        if ((timestamp.getCurrentHour() > signOutViewModel.getPickUpHour()) || (timestamp.getCurrentHour() == signOutViewModel.getPickUpHour() && timestamp.getCurrentMinute() > signOutViewModel.getPickUpMinute())) {
            return true
        }
        return false
    }
    
    @IBAction func clearSignature(sender: AnyObject) {
        signatureBox.setLines([])
        signatureBox.setNeedsDisplay()
    }

    @IBAction func signOut(sender: AnyObject) {
        if (signOutViewModel.getSignOutGuardian() != "" && !signatureBox.getLines().isEmpty) {
            let timestamp = Date()
            var signOutType = 1
            if (latePickUp(timestamp)) {
                signOutType = 5
            }
            let signOutGuardian = signOutViewModel.getSignOutGuardian().stringByReplacingOccurrencesOfString("'", withString: "''")
            let signOutSQL = "INSERT INTO SIGNOUTS (studentID, rosterID, signOutGuardian, rosterType, signoutType, day, month, year, hour, minute) VALUES ('\(signOutViewModel.getStudentID())', '\(signOutViewModel.getRosterID())', '\(signOutGuardian)', '\(signOutViewModel.getRosterType())', '\(signOutType)', '\(timestamp.getCurrentDay())', '\(timestamp.getCurrentMonth())', '\(timestamp.getCurrentYear())', '\(timestamp.getCurrentHour())', '\(timestamp.getCurrentMinute())')"
            let result = database.update(signOutSQL)
            if (result) {
                self.performSegueWithIdentifier("SignOutToStudentSelectUnwind", sender: self)
            } else {
                let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Sign Out Student")
                errorAlert.displayError()
            }
        } else if (signOutViewModel.getSignOutGuardian() == "") {
            let errorAlert = ErrorAlert(viewController: self, errorString: "Please select Guardian")
            errorAlert.displayError()
        } else if (signatureBox.getLines().isEmpty) {
            let errorAlert = ErrorAlert(viewController: self, errorString: "Please Sign in the Sign Out Box")
            errorAlert.displayError()
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
            textField.placeholder = "Guardian Name"
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .Default) { (action) -> Void in
            name = ((alertController.textFields?.first)! as UITextField).text!
            self.selectedGuardian.text = name
            self.signOutViewModel.setSignOutGuardian(name)
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
        if(guardianPickerData.count > 0) {
            return guardianPickerData.count
        }
        return 1
    }
    // Data to show on scroll
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(guardianPickerData.count > 0) {
            return guardianPickerData[row]
        } else {
            return "No Approved Guardians"
        }
    }
    // Detect selection from user
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (signOutViewModel.getGuardianNamesCount() > 0) {
            self.selectedGuardian.text = guardianPickerData[row]
            self.signOutViewModel.setSignOutGuardian(guardianPickerData[row])
        }
    }
}
