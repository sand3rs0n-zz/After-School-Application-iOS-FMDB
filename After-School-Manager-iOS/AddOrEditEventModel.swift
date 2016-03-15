//
//  AddOrEditEventModel.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 3/12/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import Foundation
import UIKit

class AddOrEditEventModel {
    private var navTitle = ""
    private var buttonText = ""
    private var state = 0
    private var event = Event()
    private var rosters = [Roster]()
    private var selectedRoster = 0

    init() {

    }

    func resetRosters(datePicker: UIDatePicker) {
        rosters.removeAll()
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

    func setTitleValue(navTitle: String) {
        self.navTitle = navTitle
    }
    func getTitleValue() -> String {
        return navTitle
    }
    func setButtonText(buttonText: String) {
        self.buttonText = buttonText
    }
    func getButtonText() -> String {
        return buttonText
    }
    func setState(state: Int) {
        self.state = state
    }
    func getState() -> Int {
        return state
    }
    func setEvent(event: Event) {
        self.event = event
    }
    func getEvent() -> Event {
        return event
    }
    func setSelectedRoster(selectedRoster: Int) {
        self.selectedRoster = selectedRoster
    }
    func getSelectedRoster() -> Int {
        return selectedRoster
    }
    func getRosterCount() -> Int {
        return rosters.count
    }
    func getRoster(i: Int) -> Roster{
        return rosters[i]
    }
}