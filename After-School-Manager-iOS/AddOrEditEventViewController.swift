//
//  AddOrEditEventViewController.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 2/5/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import UIKit

class AddOrEditEventViewController: UIViewController {

    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var eventDescription: UITextView!
    @IBOutlet weak var eventType: UISegmentedControl!
    @IBOutlet weak var createOrEditEventButton: UIButton!
    @IBOutlet weak var deleteEventButton: UIButton!

    private var navTitle = ""
    private var buttonText = ""
    private var state = 0
    private var event = Event()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.createOrEditEventButton!.setTitle(buttonText, forState: .Normal)
        self.titleBar.title = navTitle
        if (state == 0) {
            deleteEventButton.hidden = true
        } else if (state == 1) {
            fillValues()
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func fillValues() {
        eventName.text = event.getName()
        eventDescription.text = event.getDescription()
        eventType.selectedSegmentIndex = event.getEventType()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = String(event.getDay()) + "/" + String(event.getMonth()) + "/" + String(event.getYear())
        let convertedDate = dateFormatter.dateFromString(dateString)
        datePicker.date = convertedDate!
    }

    func setTitleValue(navTitle: String) {
        self.navTitle = navTitle
    }
    func setButtonText(buttonText: String) {
        self.buttonText = buttonText
    }
    func setState(state: Int) {
        self.state = state
    }
    func setEvent(event: Event) {
        self.event = event
    }

    private func back() {
        performSegueWithIdentifier("ReturnToAllEventsUnwind", sender: self)
    }
    
    @IBAction func createOrEditEvent(sender: AnyObject) {
        let selected = eventType.selectedSegmentIndex
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let inputDate = dateFormatter.stringFromDate(datePicker.date)
        let dateArr = inputDate.characters.split{$0 == "/"}.map(String.init)
        let day = Int(dateArr[0])!
        let month = Int(dateArr[1])!
        let year = Int(dateArr[2])!

        var insertSQL = ""
        if (eventName.text != "" && eventDescription.text != "") {
            if (state == 1) {
                insertSQL = "UPDATE EVENTS SET name = '\(eventName.text!)', eventType = '\(selected)', description = '\(eventDescription.text!)', day = '\(day)', month = '\(month)', year = '\(year)' WHERE eventID = '\(event.getEventID())'"
                event.setName(eventName.text!)
                //update other tables
            } else if (state == 0) {
                insertSQL = "INSERT INTO EVENTS (name, eventType, description, day, month, year) VALUES ('\(eventName.text!)', '\(selected)', '\(eventDescription.text!)', '\(day)', '\(month)', '\(year)')"
            }
        }

        let result = database.update(insertSQL)
        if (result) {
            self.back()
        }
    }
    
    @IBAction func deleteEvent(sender: AnyObject) {
        let myAlertController = UIAlertController(title: "Delete Event", message: "Are you sure you want to delete this event?", preferredStyle: .Alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Do some stuff
        }
        myAlertController.addAction(cancelAction)

        let nextAction = UIAlertAction(title: "Delete", style: .Default) { action -> Void in
            let insertSQL = "DELETE FROM EVENTS WHERE eventID = '\(self.event.getEventID())'"
            database.update(insertSQL)
            self.back()
        }
        myAlertController.addAction(nextAction)
        presentViewController(myAlertController, animated: true, completion: nil)
        //also delete all relevant info
    }

}
