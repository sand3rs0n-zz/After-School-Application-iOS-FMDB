//
//  RosterTypeViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class RosterTypeViewController: UIViewController {
    
    private var rosterState = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setState(state: Int) {
        rosterState = state
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let rlvc = segue.destinationViewController as? RosterListViewController
            rlvc?.setState(rosterState)
        if (segue.identifier == "RosterTypesToDayCamps") {
            rlvc?.setTitleValue("Day Camps")
            rlvc?.setRosterType(0)
        } else if (segue.identifier == "RosterTypesToWeekCamps") {
            rlvc?.setTitleValue("Week Camps")
            rlvc?.setRosterType(1)
        } else if (segue.identifier == "RosterTypesToAfterSchoolPrograms") {
            rlvc?.setTitleValue("After School Program")
            rlvc?.setRosterType(2)
        }
    }
    
    @IBAction func back(sender: AnyObject) {
        if (rosterState == 2) {
            performSegueWithIdentifier("returnToScheduleAbsences", sender: self)
        } else {
            performSegueWithIdentifier("returnToHomePage", sender: self)
        }
    }
    
    @IBAction func rosterTypeSelectUnwind(segue: UIStoryboardSegue) {
    }
}
