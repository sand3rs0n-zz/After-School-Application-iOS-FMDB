//
//  AddOrEditRosterModel.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 3/12/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import Foundation

class AddOrEditRosterModel {
    private var state = 0
    private var navTitle = ""
    private var buttonText = ""
    private var existingRoster = Roster()
    private var options = ["Day Camp", "Week Camp", "After School Program"]

    init() {

    }

    func getOption(i: Int) -> String {
        return options[i]
    }
    func getOptionCount() -> Int {
        return options.count
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
    func setExistingRoster(roster: Roster) {
        existingRoster = roster
    }
    func getExistingRoster() -> Roster {
        return existingRoster
    }
}