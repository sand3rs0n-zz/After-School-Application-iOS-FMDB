//
//  AllRostersModel.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 3/12/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import Foundation

class AllRostersModel {
    private var rosterList = [Roster]()
    private var forwardedRosterID = 0
    private var forwardedRosterName = ""
    private var forwardedRoster = Roster()

    init(){

    }

    func resetRosters() {
        rosterList.removeAll()
        getRosters()
    }
    private func getRosters() {
        let querySQL = "SELECT * FROM ROSTERS ORDER BY startYear, startMonth, startDay, name ASC"
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

    func getRosterListsCount() -> Int {
        return rosterList.count
    }
    func getRoster(i: Int) -> Roster {
        return rosterList[i]
    }
    func getForwardedRosterID() -> Int {
        return forwardedRosterID
    }
    func getForwardedRosterName() -> String {
        return forwardedRosterName
    }
    func getForwardedRoster() -> Roster {
        return forwardedRoster
    }
    func setForwardedRosterID(forwardedRosterID: Int) {
        self.forwardedRosterID = forwardedRosterID
    }
    func setForwardedRosterName(forwardedRosterName: String) {
        self.forwardedRosterName = forwardedRosterName
    }
    func setForwardedRoster(forwardedRoster: Roster) {
        self.forwardedRoster = forwardedRoster
    }
    func removeRoster(index: Int) {
        rosterList.removeAtIndex(index)
    }
}