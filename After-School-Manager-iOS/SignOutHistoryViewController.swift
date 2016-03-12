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

    private var studentID = 0
    private var state = 0
    private var signOuts = [SignOut]()
    private var studentName = ""
    @IBOutlet weak var dayCampButton: UIButton!
    @IBOutlet weak var weekCampButton: UIButton!
    @IBOutlet weak var afterSchoolButton: UIButton!
    @IBOutlet weak var signOutsListTable: UITableView!

    private var rosterBool = [1, 1, 1]
    private var rosterTypes = [UIButton]()
    private var rosterTypeString = "( 0, 1, 2 )"

    override func viewDidLoad() {
        super.viewDidLoad()
        rosterTypes = [dayCampButton, weekCampButton, afterSchoolButton]
        dayCampButton.backgroundColor = UIColor.greenColor()
        weekCampButton.backgroundColor = UIColor.greenColor()
        afterSchoolButton.backgroundColor = UIColor.greenColor()

        getSignOuts()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func getSignOuts() {
        let date = Date()
        let year = date.getCurrentYear()
        let month = date.getCurrentMonth()
        let day = date.getCurrentDay()

        let querySQL = "SELECT SIGNOUTS.*, ROSTERS.name FROM SIGNOUTS LEFT OUTER JOIN ROSTERS ON SIGNOUTS.rosterID = ROSTERS.rosterID WHERE (year < '\(year)' OR (year = '\(year)' AND month < '\(month)') OR (year = '\(year)' AND month = '\(month)' AND day <= '\(day)')) AND studentID = '\(studentID)' AND SIGNOUTS.rosterType IN \(rosterTypeString) ORDER BY year, month, day, name ASC"

        let results = database.search(querySQL)
        while (results.next()) {
            let cur = SignOut()
            cur.setRosterID(Int(results.intForColumn("studentID")))
            cur.setRosterID(Int(results.intForColumn("rosterID")))
            cur.setSignOutGuaridan(results.stringForColumn("signOutGuardian"))
            cur.setCampName(results.stringForColumn("name"))
            cur.setRosterType(Int(results.intForColumn("rosterType")))
            cur.setDay(Int(results.intForColumn("day")))
            cur.setMonth(Int(results.intForColumn("month")))
            cur.setYear(Int(results.intForColumn("year")))
            cur.setHour(Int(results.intForColumn("hour")))
            cur.setMinute(Int(results.intForColumn("minute")))
            cur.createTimeStamp()
            signOuts.append(cur)
        }
        results.close()
    }

    func setStudentID(studentID: Int) {
        self.studentID = studentID
    }
    func setState(state: Int) {
        self.state = state
    }
    func setStudentName(studentName: String) {
        self.studentName = studentName
    }

    private func tableString(signOut: SignOut) -> String {
        let timeStamp = signOut.getTimeStamp()
        return timeStamp.fullDateAmerican() + "\t" + timeStamp.fullTime() + "\t" + signOut.getCampName() + "\t" + signOut.getSignOutGuardian()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let signOut = signOuts[(indexPath.row)]
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = tableString(signOut)
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return signOuts.count
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
        if (rosterBool[rosterType] == 1) {
            rosterBool[rosterType] = 0
        } else {
            rosterBool[rosterType] = 1
        }
        let roster = rosterTypes[rosterType]
        if (roster.backgroundColor == UIColor.greenColor()) {
            roster.backgroundColor = UIColor.lightGrayColor()
        } else {
            roster.backgroundColor = UIColor.greenColor()
        }

        resetRosterTypeString()

        signOuts.removeAll()
        getSignOuts()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.signOutsListTable.reloadData()
        })
    }

    private func resetRosterTypeString() {
        rosterTypeString = "( "
        if (rosterBool[0] == 1) {
            rosterTypeString.appendContentsOf("0")
            if (rosterBool[1] == 1 || rosterBool[2] == 1) {
                rosterTypeString.appendContentsOf(", ")
            }
        }
        if (rosterBool[1] == 1) {
            rosterTypeString.appendContentsOf("1")
            if (rosterBool[2] == 1) {
                rosterTypeString.appendContentsOf(", ")
            }
        }
        if (rosterBool[2] == 1) {
            rosterTypeString.appendContentsOf("2")
        }
        rosterTypeString.appendContentsOf(" )")
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
        mailComposerVC.setSubject(studentName + " Sign Out Records")
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
        var text = studentName + " Sign Out Records\nDate    Time    Camp    Who Signed Out  Event\n"
        for (var i = 0; i < signOuts.count; i++) {
            text += tableString(signOuts[i]) + "\n"
        }

        return text
    }

    private func back() {
        if (state == 0) {
            performSegueWithIdentifier("SignOutsToStudentInfoUnwind", sender: self)
        } else if (state == 1) {
            performSegueWithIdentifier("SignOutsToEditStudentInfoUnwind", sender: self)
        }
    }
}
