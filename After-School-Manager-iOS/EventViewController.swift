//
//  EventViewController.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 2/5/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

    private var event = Event()
    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var eventType: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleBar.title = event.getName()
        fillValues()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setEvent(event: Event) {
        self.event = event
    }

    private func fillValues() {
        let date = Date(day: event.getDay(), month: event.getMonth(), year: event.getYear())
        eventDate.text = date.fullDateAmerican()
        eventDescription.text = event.getDescription()
        if (event.getEventType() == 0) {
            eventType.text = "Early Dismissal from School"
        } else if (event.getEventType() == 1) {
            eventType.text = "No School"
        } else if (event.getEventType() == 1) {
            eventType.text = "Some Other Event"
        }
    }
}
