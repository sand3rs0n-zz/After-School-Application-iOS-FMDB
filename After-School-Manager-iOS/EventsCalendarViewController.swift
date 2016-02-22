//
//  EventsCalendarViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class EventsCalendarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var eventList = [Event]()
    private var forwardedEvent = Event()
    private var date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        getEvents()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func getEvents() {
        let querySQL = "SELECT * FROM EVENTS WHERE (year > '\(date.getCurrentYear())' OR (year = '\(date.getCurrentYear())' AND month > '\(date.getCurrentMonth())') OR (year = '\(date.getCurrentYear())' AND month = '\(date.getCurrentMonth())' AND day >= '\(date.getCurrentDay())')) ORDER BY year, month, day, name ASC"
        let results = database.search(querySQL)
        while (results.next()) {
            let cur = Event()
            cur.setEventID(Int(results.intForColumn("eventID")))
            cur.setEventType(Int(results.intForColumn("eventType")))
            cur.setName(results.stringForColumn("name"))
            cur.setDescription(results.stringForColumn("description"))
            cur.setDay(Int(results.intForColumn("day")))
            cur.setMonth(Int(results.intForColumn("month")))
            cur.setYear(Int(results.intForColumn("year")))
            eventList.append(cur)
        }
        results.close()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let roster = eventList[(indexPath.row)]
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = roster.getName()
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList.count
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let event = eventList[(indexPath.row)]
        forwardedEvent = event
        performSegueWithIdentifier("UpcomingEventsToSpecificEvent", sender: self)
    }

    @IBAction func upcomingEventsUnwind(segue: UIStoryboardSegue) {
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "UpcomingEventsToSpecificEvent") {
            let evc = segue.destinationViewController as? EventViewController
            evc?.setEvent(forwardedEvent)
        }
    }
}
