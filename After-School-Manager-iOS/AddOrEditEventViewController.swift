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
    @IBOutlet weak var suspendRosterButton: UIButton!
    @IBOutlet weak var rosterPicker: UIPickerView!

    private var navTitle = ""
    private var buttonText = ""
    private var state = 0
    private var event = Event()
    private var rosters = [Roster]()
    private var selectedRoster = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.createOrEditEventButton!.setTitle(buttonText, forState: .Normal)
        suspendRosterButton.backgroundColor = UIColor.grayColor()
        suspendRosterButton.hidden = true
        rosterPicker.hidden = true
        self.titleBar.title = navTitle
        if (state == 0) {
            deleteEventButton.hidden = true
        } else if (state == 1) {
            fillValues()
        }
        getRosters()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        rosterPicker.selectRow(selectedRoster, inComponent: 0, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func getRosters() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let inputDate = dateFormatter.stringFromDate(datePicker.date)
        let dateArr = inputDate.characters.split{$0 == "/"}.map(String.init)
        let day = Int(dateArr[0])!
        let month = Int(dateArr[1])!
        let year = Int(dateArr[2])!

        let querySQL = "SELECT * FROM ROSTERS WHERE (endYear > '\(year)' OR (endYear = '\(year)' AND endMonth > '\(month)') OR (endYear = '\(year)' AND endMonth = '\(month)' AND endDay >= '\(day)')) AND (startYear < '\(year)' OR (startYear = '\(year)' AND startMonth < '\(month)') OR (startYear = '\(year)' AND startMonth = '\(month)' AND startDay <= '\(day)')) ORDER BY name ASC"
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
            rosters.append(cur)
        }
        results.close()
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent componenet: Int) -> Int {
        return rosters.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if (event.getRosterID() == rosters[row].getRosterID()) {
            selectedRoster = row
        }
        return rosters[row].getName()
    }

    private func fillValues() {
        eventName.text = event.getName()
        eventDescription.text = event.getDescription()
        eventType.selectedSegmentIndex = event.getEventType()
        if (event.getEventType() == 1) {
            suspendRosterButton.backgroundColor = UIColor.greenColor()
            suspendRosterButton.hidden = false
            rosterPicker.hidden = false
        }
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

    @IBAction func eventTypeAction(sender: AnyObject) {
        if (eventType.selectedSegmentIndex == 1) {
            suspendRosterButton.hidden = false
            showPicker()
        } else {
            suspendRosterButton.hidden = true
            showPicker()
        }
    }

    @IBAction func suspendRoster(sender: AnyObject) {
        if (suspendRosterButton.backgroundColor == UIColor.greenColor()) {
            suspendRosterButton.backgroundColor = UIColor.lightGrayColor()
            showPicker()
        } else {
            suspendRosterButton.backgroundColor = UIColor.greenColor()
            showPicker()
        }
        showPicker()
    }

    @IBAction func datePickerChanged(sender: AnyObject) {
        rosters.removeAll()
        getRosters()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.rosterPicker.reloadAllComponents()
        })
    }

    private func showPicker() {
        if (suspendRosterButton.backgroundColor == UIColor.greenColor() && suspendRosterButton.hidden == false) {
            rosterPicker.hidden = false
        } else {
            rosterPicker.hidden = true
        }
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
        var rosterID = 0
        if (suspendRosterButton.backgroundColor == UIColor.greenColor() && suspendRosterButton.hidden == false) {
            rosterID = rosters[rosterPicker.selectedRowInComponent(0)].getRosterID()
        }

        var insertSQL = ""
        if (eventName.text != "" && eventDescription.text != "") {
            if (state == 1) {
                insertSQL = "UPDATE EVENTS SET name = '\(eventName.text!)', eventType = '\(selected)', description = '\(eventDescription.text!)', day = '\(day)', month = '\(month)', year = '\(year)', rosterID = '\(rosterID)' WHERE eventID = '\(event.getEventID())'"
                event.setName(eventName.text!)
            } else if (state == 0) {
                insertSQL = "INSERT INTO EVENTS (name, eventType, description, day, month, year, rosterID) VALUES ('\(eventName.text!)', '\(selected)', '\(eventDescription.text!)', '\(day)', '\(month)', '\(year)', '\(rosterID)')"
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
