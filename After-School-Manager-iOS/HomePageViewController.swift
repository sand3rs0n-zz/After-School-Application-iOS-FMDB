/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
var settings = Settings()

class HomePageViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        image.image = UIImage(named:"img/logo.png")!
        let settingsSQL = "SELECT * FROM USERSETTINGS"
        let results = database.search(settingsSQL)
        results.next()
        settings.setPin(results.stringForColumn("pin"))
        settings.setEmailAddress(results.stringForColumn("emailAddress"))
        results.close()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func returnHomeUnwind(segue: UIStoryboardSegue) {
    }
    
    @IBAction func goToInstructorMenu(sender: AnyObject) {
        var pin:String = ""

        let alertController = UIAlertController(title: "Instructor Menu", message: "Please enter pin.", preferredStyle: .Alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
            print("Cancelled")
        }
        alertController.addAction(cancelAction)

        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Pin"
            textField.keyboardType =  UIKeyboardType.DecimalPad
            textField.secureTextEntry = true
        }

        let submitAction = UIAlertAction(title: "Submit", style: .Default) { (action) -> Void in
            pin = ((alertController.textFields?.last)! as UITextField).text!
            if (pin == settings.getPin()) {
                self.performSegueWithIdentifier("HomePageToInstructorMenu", sender: self)
            } else if (pin != settings.getPin()) {
                print("Please enter correct pin")
            }
        }
        alertController.addAction(submitAction)

        let resetPinAction = UIAlertAction(title: "Reset Pin", style: .Destructive) { (action) -> Void in
            print("PIN reset")
            let resetPinQuery = "UPDATE USERSETTINGS SET pin = '0000'"
            let result = database.update(resetPinQuery)
            if (result) {
                settings.setPin("0000")
            } else {
                let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Reset Pin")
                errorAlert.displayError()
            }

        }
        alertController.addAction(resetPinAction)

        self.presentViewController(alertController, animated: true) {
            // Not really sure what to do here, actually
        }
        performSegueWithIdentifier("HomePageToInstructorMenu", sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "HomePageToSignOutRosterSelect") {
            let rlvc = segue.destinationViewController as? RosterListViewController
            rlvc?.setState(1)
            rlvc?.setTitleValue("Select Roster")
        } else if (segue.identifier == "HomePageToStudentRoster") {
            let srvc = segue.destinationViewController as? StudentRosterViewController
            srvc?.setTitleValue("Student Roster")
        }
    }
}
