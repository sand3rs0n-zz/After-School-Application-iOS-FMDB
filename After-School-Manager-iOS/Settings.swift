//
//  Settings.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 1/30/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import Foundation

class Settings {
    private var pin = ""
    private var emailAddress = ""

    init() {
    }

    func getPin() -> String {
        return pin
    }
    func getEmailAddress() -> String {
        return emailAddress
    }
    func setPin(pin: String) {
        self.pin = pin
    }
    func setEmailAddress(emailAddress: String) {
        self.emailAddress = emailAddress
    }
}