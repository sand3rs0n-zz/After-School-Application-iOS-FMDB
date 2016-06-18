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
        let date = Date(day: event.getDay(), month: event.getMonth(), year: event.getYear())
        cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = "\(name)"
        cell.textLabel?.font  = UIFont(name: "Arial", size: 30.0)
        cell.detailTextLabel?.text = "\(date.fullDateAmerican())"
        cell.detailTextLabel?.font  = UIFont(name: "Arial", size: 30.0)
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

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            let myAlertController = UIAlertController(title: "Delete Event", message: "Are you sure you want to delete this event?", preferredStyle: .Alert)

            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
                //Do some stuff
            }
            myAlertController.addAction(cancelAction)

            let nextAction = UIAlertAction(title: "Delete", style: .Default) { action -> Void in
                let insertSQL = "DELETE FROM EVENTS WHERE eventID = '\(self.allEventsModel.getEvent(indexPath.row).getEventID())'"
                let result = database.update(insertSQL)
                if (result) {
                    self.allEventsModel.removeEvent(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    if (self.allEventsModel.getEventListsCount() == 0) {
                        self.allEventsModel.resetEvents()
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.eventsListTable.reloadData()
                        })

                    }
                } else {
                    let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Delete Event From Events Database")
                    errorAlert.displayError()
                }
            }
            myAlertController.addAction(nextAction)
            presentViewController(myAlertController, animated: true, completion: nil)
            
        }
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
