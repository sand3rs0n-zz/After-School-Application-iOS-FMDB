//
//  UpcomingAbsencesViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class UpcomingAbsencesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var absenceList = [Absence]()
    private let date = Date()
    private let calendar = NSCalendar.currentCalendar()

    private var forwardedAbsence = Absence()
    
    @IBOutlet weak var upcomingAbsencesListTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        getUpcomingAbsences()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func getUpcomingAbsences() {
        let date = Date()
        let querySQL = "SELECT * FROM ABSENCESLIST WHERE year > '\(date.getCurrentYear())' OR (year = '\(date.getCurrentYear())' AND month > '\(date.getCurrentMonth())') OR (year = '\(date.getCurrentYear())' AND month = '\(date.getCurrentMonth())' AND day >= '\(date.getCurrentDay())') ORDER BY year, month, day, studentLastName ASC"
        let results = database.search(querySQL)
        while (results.next()) {
            let cur = Absence()
            cur.setAbsenceID(Int(results.intForColumn("absenceID")))
            cur.setStudentFirstName(results.stringForColumn("studentFirstName"))
            cur.setStudentLastName(results.stringForColumn("studentLastName"))
            cur.setStudentID(Int(results.intForColumn("studentID")))
            cur.setRosterID(Int(results.intForColumn("rosterID")))
            cur.setAbsenceID(Int(results.intForColumn("absenceID")))
            cur.setDay(Int(results.intForColumn("day")))
            cur.setMonth(Int(results.intForColumn("month")))
            cur.setYear(Int(results.intForColumn("year")))
            absenceList.append(cur)
        }
        results.close()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let absence = absenceList[indexPath.row]
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        var name = (absence.getStudentFirstName() + " " + absence.getStudentLastName())
        let date = Date(day: absence.getDay(), month: absence.getMonth(), year: absence.getYear())
        name.appendContentsOf("\t\t")
        name.appendContentsOf(date.fullDateAmerican())
        cell.textLabel?.text = name
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return absenceList.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let absence = absenceList[(indexPath.row)]
        forwardedAbsence = absence
        performSegueWithIdentifier("UpcomingAbsenceToUpdateAbsence", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ScheduleAbsenceToRosterSelect") {
            let rlvc = segue.destinationViewController as? RosterListViewController
            rlvc?.setState(2)
            rlvc?.setTitleValue("Select Roster ")
        } else if (segue.identifier == "UpcomingAbsenceToUpdateAbsence") {
            let savc = segue.destinationViewController as? ScheduleAbsenceViewController
            savc?.setState(1)
            savc?.setButtonText("Update Absence")
            savc?.setAbsence(forwardedAbsence)
        }
    }
    
    @IBAction func scheduleAbsenceUnwind(segue: UIStoryboardSegue) {
        absenceList.removeAll()
        getUpcomingAbsences()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.upcomingAbsencesListTable.reloadData()
        })
    }
}
