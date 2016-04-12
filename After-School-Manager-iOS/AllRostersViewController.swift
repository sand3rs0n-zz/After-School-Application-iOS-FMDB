//
//  AllRostersViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/17/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class AllRostersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var allRostersModel = AllRostersModel()
    @IBOutlet weak var rosterListTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        allRostersModel.resetRosters()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let roster = allRostersModel.getRoster(indexPath.row)
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        let name = roster.getName()
        let startDay = roster.getStartDay()
        let startMonth = roster.getStartMonth()
        let startYear = roster.getStartYear()
        let endDay = roster.getEndDay()
        let endMonth = roster.getEndMonth()
        let endYear = roster.getEndYear()
        let date = "\(startMonth)/\(startDay)/\(startYear) - \(endMonth)/\(endDay)/\(endYear)"
        cell.textLabel?.text = "\(name)"
        
        cell.detailTextLabel?.text = "\(date)"
        cell.detailTextLabel?.textAlignment = NSTextAlignment.Right
        
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRostersModel.getRosterListsCount()
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let roster = allRostersModel.getRoster(indexPath.row)
        allRostersModel.setForwardedRosterID(roster.getRosterID())
        allRostersModel.setForwardedRosterName(roster.getName())
        allRostersModel.setForwardedRoster(roster)
        performSegueWithIdentifier("AllRostersToSpecificRoster", sender: self)
    }

    @IBAction func returnToAllRostersUnwind(segue: UIStoryboardSegue) {
        allRostersModel.resetRosters()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.rosterListTable.reloadData()
        })
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "AllRostersToSpecificRoster") {
            let rvc = segue.destinationViewController as? RosterViewController
            rvc?.setTitleValue(allRostersModel.getForwardedRosterName())
            rvc?.setRosterID(allRostersModel.getForwardedRosterID())
            rvc?.setRoster(allRostersModel.getForwardedRoster())
        } else if (segue.identifier == "AllRostersToNewRoster") {
            let aoervc = segue.destinationViewController as? AddOrEditRosterViewController
            aoervc?.setState(0)
            aoervc?.setTitleValue("Create Roster")
            aoervc?.setCreateRosterButtonValue("Create Roster")
        }
    }
}
