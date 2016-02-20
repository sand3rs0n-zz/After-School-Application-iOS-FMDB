//
//  RosterListViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class RosterListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var rosterState = 0
    private var rosterList = [Roster]()
    private var rosterType = 0
    @IBOutlet weak var titleBar: UINavigationItem!
    private var navTitle = ""
    
    private var forwardedRosterID = 0
    private var forwardedRosterName = ""
    private let date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleBar.title = navTitle
        getRosters()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func getRosters() {
        let year = date.getCurrentYear()
        let month = date.getCurrentMonth()
        let day = date.getCurrentDay()

        let path = Util.getPath("AfterSchoolData.sqlite")
        let contactDB = FMDatabase(path: path)
        if contactDB.open() {
            let querySQL = "SELECT * FROM ROSTERS WHERE rosterType = '\(rosterType)' AND (endYear > '\(year)' OR (endYear = '\(year)' AND endMonth > '\(month)') OR (endYear = '\(year)' AND endMonth = '\(month)' AND endDay >= '\(day)')) AND (startYear < '\(year)' OR (startYear = '\(year)' AND startMonth < '\(month)') OR (startYear = '\(year)' AND startMonth = '\(month)' AND startDay <= '\(day)')) ORDER BY startMonth, startDay, name ASC"

            let results = contactDB.executeQuery(querySQL, withArgumentsInArray: nil)
            while (results.next()) {
                let cur = Roster()
                cur.setRosterID(Int(results.intForColumn("rosterID")))
                cur.setRosterType(Int(results.intForColumn("rosterType")))
                cur.setName(results.stringForColumn("name"))
                cur.setStartDay(Int(results.intForColumn("startDay")))
                cur.setStartMonth(Int(results.intForColumn("startMonth")))
                cur.setStartYear(Int(results.intForColumn("startYear")))
                cur.setEndDay(Int(results.intForColumn("endDay")))
                cur.setEndMonth(Int(results.intForColumn("endMonth")))
                cur.setEndYear(Int(results.intForColumn("endYear")))
                cur.setPickUpHour(Int(results.intForColumn("pickUpHour")))
                cur.setPickUpMinute(Int(results.intForColumn("pickUpMinute")))
                rosterList.append(cur)
            }
            results.close()
            contactDB.close()
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
    }

    func setState(state: Int) {
        rosterState = state
    }
    
    func setTitleValue(title: String) {
        navTitle = title
    }
    
    func setRosterType(type: Int) {
        rosterType = type
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let roster = rosterList[(indexPath.row)]
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = roster.getName()
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rosterList.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let roster = rosterList[(indexPath.row)]
        forwardedRosterName = roster.getName()
        forwardedRosterID = roster.getRosterID()
        performSegueWithIdentifier("RosterSelectToStudentRoster", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let srvc = segue.destinationViewController as? StudentRosterViewController
        srvc?.setState(rosterState)
        srvc?.setRosterID(forwardedRosterID)
        srvc?.setTitleValue(forwardedRosterName)
        srvc?.setRosterType(rosterType)
    }

    @IBAction func rosterSelectUnwind(segue: UIStoryboardSegue) {
    }
}
