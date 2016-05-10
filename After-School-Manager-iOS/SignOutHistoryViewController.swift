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
        signOutHistoryModel.resetSignOuts()
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
        let cell = tableView.dequeueReusableCellWithIdentifier("signOut", forIndexPath: indexPath) as! SignOutViewCell

        let timeStamp = signOut.getTimeStamp()
        cell.date.text = timeStamp.fullDateAmerican()
        cell.time.text = timeStamp.fullTime()
        cell.camp.text = signOut.getCampName()
        cell.guardian.text = signOut.getSignOutGuardian()
        cell.specialNote.text = specialSignOutType(signOut)
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

    private func emailString(signOut: SignOut) -> String {
        // This fixes a weird bug where the Time Stamp was changing to AM for no reason
        signOut.createTimeStamp()

        let timeStamp = signOut.getTimeStamp()
        var string = ""
        string += "<td style='max-width:13px;'>" + timeStamp.fullDateAmerican() + "</td>"
        string += "<td style='max-width:10px;'>" + timeStamp.fullTime() + "</td>"
        string += "<td style='max-width:50px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>" + signOut.getCampName() + "</td>"
        string += "<td style='max-width:35px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>" + signOut.getSignOutGuardian() + "</td>"
        string += "<td style='max-width:30px;'>" + specialSignOutType(signOut) + "</td>"
        return string
    }

    private func createEmail() -> String{
        var text = ""
        text += "<h2 style='line-height:100%'>" + signOutHistoryModel.getStudentName() + " Sign Out Records</h2>"
        text += "<table style='width:100%'><tr><th style='text-align: left;'>Date</th> <th style='text-align: left;'>Time</th> <th style='text-align: left;'>Camp</th> <th style='text-align: left;'>Guardian</th> <th style='text-align: left;'>Special Note</th></tr>"
        for i in 0 ..< signOutHistoryModel.getSignOutsCount() {
            text += "<tr style='color:"
            if (signOutHistoryModel.getSignOut(i).getSignOutType() == 2) {
                text += "blue"
            } else if (signOutHistoryModel.getSignOut(i).getSignOutType() == 3) {
                text += "green"
            } else if (signOutHistoryModel.getSignOut(i).getSignOutType() == 5) {
                text += "red"
            }
            text += "'>" + emailString(signOutHistoryModel.getSignOut(i)) + "</tr>"
        }

        return text + "</table>"
    }

    private func back() {
        if (signOutHistoryModel.getState() == 0) {
            performSegueWithIdentifier("SignOutsToStudentInfoUnwind", sender: self)
        } else if (signOutHistoryModel.getState() == 1) {
            performSegueWithIdentifier("SignOutsToEditStudentInfoUnwind", sender: self)
        }
    }
}
