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
        let path = Util.getPath("AfterSchoolData.sqlite")
        let contactDB = FMDatabase(path: path)

        if contactDB.open() {
            let date = Date()
            let querySQL = "SELECT * FROM ABSENCESLIST WHERE year >= '\(date.getCurrentYear())' ORDER BY year, month, day, studentLastName ASC"
            let results = contactDB.executeQuery(querySQL, withArgumentsInArray: nil)
            while (results.next()) {
                let cur = Absence()
                cur.setAbsenceID(Int(results.intForColumn("absenceID")))
                cur.setStudentFirstName(results.stringForColumn("studentFirstName"))
                cur.setStudentLastName(results.stringForColumn("studentLastName"))
                cur.setStudentID(Int(results.intForColumn("studentID")))
                cur.setDay(Int(results.intForColumn("day")))
                cur.setMonth(Int(results.intForColumn("month")))
                cur.setYear(Int(results.intForColumn("year")))
                absenceList.append(cur)
            }
            contactDB.close()
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        removeOldDates()
    }
    
    private func removeOldDates() {
        let year = date.getCurrentYear()
        let month = date.getCurrentMonth()
        let day = date.getCurrentDay()
        for (var i = 0; i < absenceList.count; i++) {
            let currentAbsence = absenceList[i]
            if (currentAbsence.getYear() < year) {
                absenceList.removeAtIndex(i)
                i--
            } else if (currentAbsence.getYear() == year && currentAbsence.getMonth() < month) {
                absenceList.removeAtIndex(i)
                i--
            } else if (currentAbsence.getYear() == year && currentAbsence.getMonth() == month && currentAbsence.getDay() < day) {
                absenceList.removeAtIndex(i)
                i--
            }
        }
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
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let text = cell?.textLabel?.text
        print(text)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "UpcomingAbsencesToScheduleAbsenceRosterSelect") {
            let srvc = segue.destinationViewController as? RosterTypeViewController
            srvc?.setState(2)
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
