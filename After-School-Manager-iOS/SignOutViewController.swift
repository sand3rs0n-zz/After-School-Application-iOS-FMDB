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
            let path = Util.getPath("AfterSchoolData.sqlite")
            let contactDB = FMDatabase(path: path)

            if contactDB.open() {
                let insertSQL = "INSERT INTO SIGNOUTS VALUES ('\(studentID)', '\(rosterID)', '\(signOutGuardian)', '\(rosterType)', '\(timestamp.getCurrentDay())', '\(timestamp.getCurrentMonth())', '\(timestamp.getCurrentYear())', '\(timestamp.getCurrentHour())', '\(timestamp.getCurrentMinute())')"
                let result = contactDB.executeUpdate(insertSQL, withArgumentsInArray: nil)

                if !result {
                    print("Error: \(contactDB.lastErrorMessage())")
                } else {
                    print("Successful")
                }
                contactDB.close()
                self.performSegueWithIdentifier("SignOutToStudentSelectUnwind", sender: self)
            } else {
                print("Error: \(contactDB.lastErrorMessage())")
            }
        } else {
            print("error message")
        }
    }
}
