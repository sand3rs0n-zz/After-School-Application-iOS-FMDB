//
//  EditTodayAttendanceViewController.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 2/15/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import UIKit

class EditTodayAttendanceViewController: UIViewController {

    private var studentID = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setStudentID(studentID: Int) {
        self.studentID = studentID
    }

    @IBAction func unscheduledAbsence(sender: AnyObject) {
        //perform an instructor signout and mark it as unscheduled absence
    }

    @IBAction func instructorSignOut(sender: AnyObject) {
        //perform an instructor signout
    }
}
