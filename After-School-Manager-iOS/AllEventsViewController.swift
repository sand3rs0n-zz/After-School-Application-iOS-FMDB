//
//  AllEventsViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/17/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class AllEventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var allEventsModel = AllEventsModel()
    @IBOutlet weak var eventsListTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        allEventsModel.resetEvents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let event = allEventsModel.getEvent(indexPath.row)
        var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        let name = event.getName()
        let day = event.getDay()
        let month = event.getMonth()
        let year = event.getYear()
        let date = "\(month)/\(day)/\(year)"
        cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = "\(name)"
        cell.detailTextLabel?.text = "\(date)"
        cell.detailTextLabel?.textAlignment = NSTextAlignment.Right
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEventsModel.getEventListsCount()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        allEventsModel.setForwardedEvent(allEventsModel.getEvent(indexPath.row))
        performSegueWithIdentifier("AllEventsToEditEvent", sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let aoeevc = segue.destinationViewController as? AddOrEditEventViewController
        if (segue.identifier == "AllEventsToAddEvent") {
            aoeevc?.setTitleValue("Add Event")
            aoeevc?.setButtonText("Create Event")
        } else if (segue.identifier == "AllEventsToEditEvent") {
            aoeevc?.setTitleValue("Edit Event")
            aoeevc?.setButtonText("Update Event")
            aoeevc?.setEvent(allEventsModel.getForwardedEvent())
            aoeevc?.setState(1)
        }
    }

    @IBAction func allEventsUnwind(segue: UIStoryboardSegue) {
        allEventsModel.resetEvents()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.eventsListTable.reloadData()
        })
    }
}
