//
//  EventsCalendarViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class EventsCalendarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var eventsCalendarModel = EventsCalendarModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let event = eventsCalendarModel.getEvent(indexPath.row)
        var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        let name = event.getName()
        let date = Date(day: event.getDay(), month: event.getMonth(), year: event.getYear())
        cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = "\(name)"
        cell.detailTextLabel?.text = "\(date.fullDateAmerican())"
        cell.detailTextLabel?.textAlignment = NSTextAlignment.Right
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsCalendarModel.getEventCount()
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        eventsCalendarModel.setForwardedEvent(eventsCalendarModel.getEvent(indexPath.row))
        performSegueWithIdentifier("UpcomingEventsToSpecificEvent", sender: self)
    }

    @IBAction func upcomingEventsUnwind(segue: UIStoryboardSegue) {
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "UpcomingEventsToSpecificEvent") {
            let evc = segue.destinationViewController as? EventViewController
            evc?.setEvent(eventsCalendarModel.getForwardedEvent())
        }
    }
}
