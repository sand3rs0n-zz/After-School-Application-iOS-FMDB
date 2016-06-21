//
//  EventViewController.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 2/5/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {
    private var eventViewModel = EventViewModel()
    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var eventType: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleBar.title = eventViewModel.getName()
        fillValues()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLayoutSubviews() {
        self.eventDescription.sizeToFit()
    }

    func setEvent(event: Event) {
        eventViewModel.setEvent(event)
    }

    private func fillValues() {
        let date = Date(day: eventViewModel.getDay(), month: eventViewModel.getMonth(), year: eventViewModel.getYear())
        eventDate.text = date.fullDateAmerican()
        eventDescription.text = eventViewModel.getDescription()
        if (eventViewModel.getEventType() == 0) {
            eventType.text = "Early Out from School"
        } else if (eventViewModel.getEventType() == 1) {
            eventType.text = "No School"
        } else if (eventViewModel.getEventType() == 2) {
            eventType.text = "Other"
        }
    }
}
