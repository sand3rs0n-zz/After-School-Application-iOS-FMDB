//
//  AllRostersViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/17/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class AllRostersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var rosterListTable: UITableView!
    private var rosterList = [Roster]()

    private var forwardedRosterID = 0
    private var forwardedRosterName = ""
    private var forwardedRoster = Roster()

    override func viewDidLoad() {
        super.viewDidLoad()
        getRosters()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func getRosters() {
        let querySQL = "SELECT * FROM ROSTERS ORDER BY startYear, startMonth, startDay, name ASC"

        let results = database.search(querySQL)
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
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let roster = rosterList[indexPath.row]
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = roster.getName()
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rosterList.count
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let roster = rosterList[(indexPath.row)]
        forwardedRosterID = roster.getRosterID()
        forwardedRosterName = roster.getName()
        forwardedRoster = roster
        performSegueWithIdentifier("AllRostersToSpecificRoster", sender: self)
    }

    @IBAction func returnToAllRostersUnwind(segue: UIStoryboardSegue) {
        rosterList.removeAll()
        getRosters()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.rosterListTable.reloadData()
        })
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "AllRostersToSpecificRoster") {
            let rvc = segue.destinationViewController as? RosterViewController
            rvc?.setTitleValue(forwardedRosterName)
            rvc?.setRosterID(forwardedRosterID)
            rvc?.setRoster(forwardedRoster)
        } else if (segue.identifier == "AllRostersToNewRoster") {
            let aoervc = segue.destinationViewController as? AddOrEditRosterViewController
            aoervc?.setState(0)
            aoervc?.setTitleValue("Create Roster")
            aoervc?.setCreateRosterButtonValue("Create Roster")
        }
    }
}
