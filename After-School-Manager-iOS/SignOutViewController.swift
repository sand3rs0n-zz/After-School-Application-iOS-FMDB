//
//  SignOutViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class SignOutViewController: UIViewController {

    private var studentID = 0
    private var rosterType = 0
    private var signOutGuardian = ""
    private var rosterID = 0

    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var signatureBox: SignatureView!
    private var navTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleBar.title = "Sign Out " + navTitle

        // Do any additional setup after loading the view.
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
}
