//
//  RosterListModel.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 3/12/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import Foundation

class RosterListModel {
    private var rosterState = 0
    private var rosterList = [Roster]()
    private var navTitle = ""
    private var forwardedRosterID = 0
    private var forwardedRosterName = ""
    private var forwardedRosterType = 0
    private let date = Date()

    init() {
    }

    func getRosters() {
        let year = date.getCurrentYear()
        let month = date.getCurrentMonth()
        let day = date.getCurrentDay()
        let querySQL = "SELECT * FROM ROSTERS WHERE (endYear > '\(year)' OR (endYear = '\(year)' AND endMonth > '\(month)') OR (endYear = '\(year)' AND endMonth = '\(month)' AND endDay >= '\(day)')) AND (startYear < '\(year)' OR (startYear = '\(year)' AND startMonth < '\(month)') OR (startYear = '\(year)' AND startMonth = '\(month)' AND startDay <= '\(day)')) ORDER BY startMonth, startDay, name ASC"

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
            rosterList.append(cur)
        }
        results.close()
    }

    func getRoster(i: Int) -> Roster {
        return rosterList[i]
    }
    func getRosterCount() -> Int {
        return rosterList.count
    }

    func setState(state: Int) {
        rosterState = state
    }
    func getState() -> Int {
        return rosterState
    }
    func setTitleValue(title: String) {
        navTitle = title
    }
    func getTitleValue() -> String {
        return navTitle
    }
    func setForwardedRosterID(id: Int) {
        forwardedRosterID = id
    }
    func getForwardedRosterID() -> Int {
        return forwardedRosterID
    }
    func setForwardedRosterName(name: String) {
        forwardedRosterName = name
    }
    func getForwardedRosterName() -> String {
        return forwardedRosterName
    }
    func setForwardedRosterType(type: Int) {
        forwardedRosterType = type
    }
    func getForwardedRosterType() -> Int {
        return forwardedRosterType
    }
}