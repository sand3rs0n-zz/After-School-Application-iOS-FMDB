//
//  SignOutHistoryViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import MessageUI

class SignOutHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    private var signOutHistoryModel = SignOutHistoryModel()
    @IBOutlet weak var dayCampButton: UIButton!
    @IBOutlet weak var weekCampButton: UIButton!
    @IBOutlet weak var afterSchoolButton: UIButton!
    @IBOutlet weak var signOutsListTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        signOutHistoryModel.setRosterTypes([dayCampButton, weekCampButton, afterSchoolButton])
//        dayCampButton.backgroundColor = UIColor.redColor()
//        weekCampButton.backgroundColor = UIColor.redColor()
//        afterSchoolButton.backgroundColor = UIColor.redColor()
        

        signOutHistoryModel.resetSignOuts()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setStudentID(studentID: Int) {
        signOutHistoryModel.setStudentID(studentID)
    }
    func setState(state: Int) {
        signOutHistoryModel.setState(state)
    }
    func setStudentName(studentName: String) {
        signOutHistoryModel.setStudentName(studentName)
    }

    private func tableString(signOut: SignOut) -> String {
        let timeStamp = signOut.getTimeStamp()
        var string = ""
        string += timeStamp.fullDateAmerican() + "\t\t"
        string += timeStamp.fullTime() + "\t\t\t"
        string += signOut.getCampName()
        for (var i = signOut.getCampName().characters.count - 1; i < 19; i++) {
            string += " "
            if (i < 8) {
                string += "\t"
            }
        }
        string += "\t\t" + signOut.getSignOutGuardian()
        for (var i = signOut.getSignOutGuardian().characters.count - 1; i < 20; i++) {
            string += " "
            if (i < 5) {
                 string += "\t"
            }
        }
        string += "\t       " + specialSignOutType(signOut)
        return string
    }

    private func emailString(signOut: SignOut) -> String {
        let timeStamp = signOut.getTimeStamp()
        var string = ""
        string += timeStamp.fullDateAmerican() + " &nbsp;&nbsp;&nbsp;&nbsp;"
        string += timeStamp.fullTime() + " &nbsp;&nbsp;&nbsp;&nbsp;"
        string += signOut.getCampName()
        for (var i = signOut.getCampName().characters.count - 1; i < 19; i++) {
            string += "&nbsp;"
            if (i < 8) {
                string += "&nbsp;"
            }
        }
        string += "&nbsp;&nbsp;&nbsp;" + signOut.getSignOutGuardian()
        for (var i = signOut.getSignOutGuardian().characters.count - 1; i < 20; i++) {
            string += "&nbsp;"
            if (i < 5) {
                string += "&nbsp;"
            }
        }
        string += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + specialSignOutType(signOut)
        return string
    }

    private func specialSignOutType(signOut: SignOut) -> String {
        var signOutType = ""
        if (signOut.getSignOutType() == 2) {
            signOutType = "Scheduled Absence"
        } else if (signOut.getSignOutType() == 3) {
            signOutType = "Unscheduled Absence"
        } else if (signOut.getSignOutType() == 4) {
            signOutType = "Instructor Sign Out"
        } else if (signOut.getSignOutType() == 5) {
            signOutType = "Late Sign Out"
        }
        return signOutType
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let signOut = signOutHistoryModel.getSignOut(indexPath.row)
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = tableString(signOut)
        if (signOut.getSignOutType() == 2) {
            cell.backgroundColor = UIColor.init(red: 0, green: 233, blue: 255, alpha: 1)
        } else if (signOut.getSignOutType() == 3) {
            cell.backgroundColor = UIColor.init(red: 127/255, green: 255, blue: 76/255, alpha: 1)
        } else if (signOut.getSignOutType() == 5) {
            cell.backgroundColor = UIColor.init(red: 255, green: 76/255, blue: 76/255, alpha: 1)
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return signOutHistoryModel.getSignOutsCount()
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //let signOut = signOuts[(indexPath.row)]
    }

    @IBAction func dayCamp(sender: AnyObject) {
        resetResults(0)
    }

    @IBAction func weekCamp(sender: AnyObject) {
        resetResults(1)
    }

    @IBAction func afterSchool(sender: AnyObject) {
        resetResults(2)
    }

    private func resetResults(rosterType: Int) {
        if (signOutHistoryModel.getRosterBool(rosterType) == 1) {
            signOutHistoryModel.setRosterBool(0, i: rosterType)
        } else {
            signOutHistoryModel.setRosterBool(1, i: rosterType)
        }
        let roster = signOutHistoryModel.getRosterTypes(rosterType)
        toggleColor(roster)

        resetRosterTypeString()

        signOutHistoryModel.resetSignOuts()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.signOutsListTable.reloadData()
        })
    }
    
    private func toggleColor(roster: UIButton) {
        // Toggle attendance colors
        if(roster.backgroundColor == UIColor.whiteColor()) {
            roster.backgroundColor = UIColor.redColor()
            roster.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        } else {
            roster.backgroundColor = UIColor.whiteColor()
            roster.setTitleColor(UIColor.darkTextColor(), forState: UIControlState.Normal)
        }
    }

    private func resetRosterTypeString() {
        var rosterTypeString = "( "
        if (signOutHistoryModel.getRosterBool(0) == 1) {
            rosterTypeString.appendContentsOf("0")
            if (signOutHistoryModel.getRosterBool(1) == 1 || signOutHistoryModel.getRosterBool(2) == 1) {
                rosterTypeString.appendContentsOf(", ")
            }
        }
        if (signOutHistoryModel.getRosterBool(1) == 1) {
            rosterTypeString.appendContentsOf("1")
            if (signOutHistoryModel.getRosterBool(2) == 1) {
                rosterTypeString.appendContentsOf(", ")
            }
        }
        if (signOutHistoryModel.getRosterBool(2) == 1) {
            rosterTypeString.appendContentsOf("2")
        }
        rosterTypeString.appendContentsOf(" )")
        signOutHistoryModel.setRosterTypeString(rosterTypeString)
    }

    @IBAction func backButton(sender: AnyObject) {
        back()
    }

    @IBAction func emailSignOuts(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }

    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property

        let signOutEmail = createEmail()
        mailComposerVC.setToRecipients([settings.getEmailAddress()])
        mailComposerVC.setSubject(signOutHistoryModel.getStudentName() + " Sign Out Records")
        mailComposerVC.setMessageBody(signOutEmail, isHTML: true)
        return mailComposerVC
    }

    func showSendMailErrorAlert() {
        let error = ErrorAlert(viewController: self, errorString: "Your device could not send e-mail.  Please check e-mail configuration and try again.")
        error.displayError()
    }

    // MARK: MFMailComposeViewControllerDelegate

    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

    private func createEmail() -> String{
        var text = "<h2 style='line-height:100%'>" + signOutHistoryModel.getStudentName() + " Sign Out Records</h2>"
        text += "<h3>Date &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Time &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Camp &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Guardian &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Special Note</h3>"
        for (var i = 0; i < signOutHistoryModel.getSignOutsCount(); i++) {
            text += "<p style='line-height:50%; font-size:105%"
            if (signOutHistoryModel.getSignOut(i).getSignOutType() == 2) {
                text += "; color:blue"
            } else if (signOutHistoryModel.getSignOut(i).getSignOutType() == 3) {
                text += "; color:green"
            } else if (signOutHistoryModel.getSignOut(i).getSignOutType() == 5) {
                text += "; color:red"
            }
            text += "'>" + emailString(signOutHistoryModel.getSignOut(i)) + "</p>"
        }

        return text
    }

    private func back() {
        if (signOutHistoryModel.getState() == 0) {
            performSegueWithIdentifier("SignOutsToStudentInfoUnwind", sender: self)
        } else if (signOutHistoryModel.getState() == 1) {
            performSegueWithIdentifier("SignOutsToEditStudentInfoUnwind", sender: self)
        }
    }
}
