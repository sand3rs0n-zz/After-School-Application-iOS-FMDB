//
//  SettingsViewController.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 3/12/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var pin: UITextView!
    @IBOutlet weak var emailAddress: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        pin.text = settings.getPin()
        emailAddress.text = settings.getEmailAddress()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func updateSettings(sender: AnyObject) {
        if (pin.text != "" && emailAddress.text != "") {
            let insertSQL = "UPDATE USERSETTINGS SET pin = '\(pin.text!.stringByReplacingOccurrencesOfString("'", withString: "''"))', emailAddress = '\(emailAddress.text!.stringByReplacingOccurrencesOfString("'", withString: "''"))'"

            let result = database.update(insertSQL)

            if (result) {
                settings.setPin(pin.text!)
                settings.setEmailAddress(emailAddress.text!)
                performSegueWithIdentifier("returnToInstructorMenuFromSettings", sender: self)
            } else {
                let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Update Settings")
                errorAlert.displayError()
            }
        } else {
            let errorAlert = ErrorAlert(viewController: self, errorString: "Please give an email address and a pin")
            errorAlert.displayError()
        }
    }
    
    // Hide keyboard when done typing
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}
