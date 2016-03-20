//
//  AddOrEditEventViewController.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 2/5/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import UIKit

class AddOrEditEventViewController: UIViewController {
    private var addOrEditEventModel = AddOrEditEventModel()

    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var eventDescription: UITextView!
    @IBOutlet weak var eventType: UISegmentedControl!
    @IBOutlet weak var createOrEditEventButton: UIButton!
    @IBOutlet weak var deleteEventButton: UIButton!
    @IBOutlet weak var suspendRosterButton: UIButton!
    @IBOutlet weak var rosterPicker: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createOrEditEventButton!.setTitle(addOrEditEventModel.getButtonText(), forState: .Normal)
        suspendRosterButton.backgroundColor = UIColor.grayColor()
        suspendRosterButton.hidden = true
        rosterPicker.hidden = true
        self.titleBar.title = addOrEditEventModel.getTitleValue()
        if (addOrEditEventModel.getState() == 0) {
            deleteEventButton.hidden = true
        } else if (addOrEditEventModel.getState() == 1) {
            fillValues()
        }
        addOrEditEventModel.resetRosters(datePicker)

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        rosterPicker.selectRow(addOrEditEventModel.getSelectedRoster(), inComponent: 0, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent componenet: Int) -> Int {
        return addOrEditEventModel.getRosterCount()
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if (addOrEditEventModel.getEvent().getRosterID() == addOrEditEventModel.getRoster(row).getRosterID()) {
            addOrEditEventModel.setSelectedRoster(row)
        }
        return addOrEditEventModel.getRoster(row).getName()
    }

    private func fillValues() {
        let event = addOrEditEventModel.getEvent()
        eventName.text = event.getName()
        eventDescription.text = event.getDescription()
        eventType.selectedSegmentIndex = event.getEventType()
        if (event.getEventType() == 1 && event.getRosterID() != 0) {
            suspendRosterButton.backgroundColor = UIColor.greenColor()
            suspendRosterButton.hidden = false
            rosterPicker.hidden = false
        } else if (event.getEventType() == 1) {
            suspendRosterButton.backgroundColor = UIColor.lightGrayColor()
            suspendRosterButton.hidden = false
        }
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = String(event.getDay()) + "/" + String(event.getMonth()) + "/" + String(event.getYear())
        let convertedDate = dateFormatter.dateFromString(dateString)
        datePicker.date = convertedDate!
    }

    func setTitleValue(navTitle: String) {
        addOrEditEventModel.setTitleValue(navTitle)
    }
    func setButtonText(buttonText: String) {
        addOrEditEventModel.setButtonText(buttonText)
    }
    func setState(state: Int) {
        addOrEditEventModel.setState(state)
    }
    func setEvent(event: Event) {
        addOrEditEventModel.setEvent(event)
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
        addOrEditEventModel.resetRosters(datePicker)
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
            rosterID = addOrEditEventModel.getRoster(rosterPicker.selectedRowInComponent(0)).getRosterID()
        }

        var insertSQL = ""
        if (eventName.text != "" && eventDescription.text != "") {
            if (addOrEditEventModel.getState() == 1) {
                insertSQL = "UPDATE EVENTS SET name = '\(eventName.text!)', eventType = '\(selected)', description = '\(eventDescription.text!)', day = '\(day)', month = '\(month)', year = '\(year)', rosterID = '\(rosterID)' WHERE eventID = '\(addOrEditEventModel.getEvent().getEventID())'"
                addOrEditEventModel.getEvent().setName(eventName.text!)
            } else if (addOrEditEventModel.getState() == 0) {
                insertSQL = "INSERT INTO EVENTS (name, eventType, description, day, month, year, rosterID) VALUES ('\(eventName.text!)', '\(selected)', '\(eventDescription.text!)', '\(day)', '\(month)', '\(year)', '\(rosterID)')"
            }
        }

        let result = database.update(insertSQL)
        if (result) {
            self.back()
        } else {
            let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Add Event to Events Database")
            errorAlert.displayError()
        }
    }

    @IBAction func deleteEvent(sender: AnyObject) {
        let myAlertController = UIAlertController(title: "Delete Event", message: "Are you sure you want to delete this event?", preferredStyle: .Alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Do some stuff
        }
        myAlertController.addAction(cancelAction)

        let nextAction = UIAlertAction(title: "Delete", style: .Default) { action -> Void in
            let insertSQL = "DELETE FROM EVENTS WHERE eventID = '\(self.addOrEditEventModel.getEvent().getEventID())'"
            let result = database.update(insertSQL)
            if (result) {
                self.back()
            } else {
                let errorAlert = ErrorAlert(viewController: self, errorString: "Failed to Delete Event From Events Database")
                errorAlert.displayError()
            }
        }
        myAlertController.addAction(nextAction)
        presentViewController(myAlertController, animated: true, completion: nil)
        //also delete all relevant info
    }
    
    // Hide keyboard when done typing
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

}
