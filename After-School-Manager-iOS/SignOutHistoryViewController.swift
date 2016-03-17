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
        dayCampButton.backgroundColor = UIColor.redColor()
        weekCampButton.backgroundColor = UIColor.redColor()
        afterSchoolButton.backgroundColor = UIColor.redColor()

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
        return timeStamp.fullDateAmerican() + "\t" + timeStamp.fullTime() + "\t" + signOut.getCampName() + "\t" + signOut.getSignOutGuardian()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let signOut = signOutHistoryModel.getSignOut(indexPath.row)
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = tableString(signOut)
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
//        if (roster.backgroundColor == UIColor.greenColor()) {
//            roster.backgroundColor = UIColor.lightGrayColor()
//        } else {
//            roster.backgroundColor = UIColor.greenColor()
//        }

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
        mailComposerVC.setMessageBody(signOutEmail, isHTML: false)

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
        var text = signOutHistoryModel.getStudentName() + " Sign Out Records\nDate    Time    Camp    Who Signed Out  Event\n"
        for (var i = 0; i < signOutHistoryModel.getSignOutsCount(); i++) {
            text += tableString(signOutHistoryModel.getSignOut(i)) + "\n"
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
