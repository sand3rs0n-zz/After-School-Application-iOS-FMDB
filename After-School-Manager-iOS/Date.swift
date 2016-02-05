//
//  Date.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 1/13/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation

class Date {
    private var day: Int
    private var month: Int
    private var year: Int
    private var hour: Int
    private var minute: Int

    private var currentYear = 1900
    private var currentMonth = 1
    private var currentDay = 1
    private var currentHour = 0
    private var currentMinute = 0

    private var currentWeekDay = "monday"

    init () {
        day = 1
        month = 1
        year = 1900
        hour = 0
        minute = 0
        setCurrentDate()
    }

    init (hour: Int, minute: Int) {
        self.day = 1
        self.month = 1
        self.year = 1900
        self.hour = hour
        self.minute = minute
        setCurrentDate()
    }

    init (day: Int, month: Int, year: Int) {
        self.day = day
        self.month = month
        self.year = year
        self.hour = 0
        self.minute = 0
        setCurrentDate()
    }

    init (day: Int, month: Int, year: Int, hour: Int, minute: Int) {
        self.day = day
        self.month = month
        self.year = year
        self.hour = hour
        self.minute = minute
        setCurrentDate()
    }

    func dayAsString() -> String {
        if (day < 10) {
            return "0" + String(day)
        }
        return String(day)
    }

    func monthAsString() -> String {
        if (month < 10) {
            return "0" + String(month)
        }
        return String(month)
    }

    func yearAsString() -> String {
        return String(year)
    }

    func hourAsString() -> String {
        if (hour < 10) {
            return "0" + String(hour)
        }
        return String(hour)
    }

    func minuteAsString() -> String {
        if (minute < 10) {
            return "0" + String(minute)
        }
        return String(minute)
    }

    func fullDateAmerican() -> String {
        return monthAsString() + "/" + dayAsString() + "/" + yearAsString()
    }

    func fullDateEuropean() -> String {
        return dayAsString() + "/" + monthAsString() + "/" + yearAsString()
    }

    func fullTime() -> String {
        var ampm = "AM"
        if (hour > 12) {
            hour = hour - 12
            ampm = "PM"
        }
        return hourAsString() + ":" + minuteAsString() + " " + ampm
    }

    func age() -> Int {
        var age = currentYear - year
        if (month > currentMonth) {
            age = age - 1
        }
        if (month == currentMonth && day > currentDay) {
            age = age - 1
        }
        return age
    }

    func setCurrentDate() {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        currentYear = calendar.components(.Year, fromDate: date).year
        currentMonth = calendar.components(.Month, fromDate: date).month
        currentDay = calendar.components(.Day, fromDate: date).day
        currentHour = calendar.components(.Hour, fromDate: date).hour
        currentMinute = calendar.components(.Minute, fromDate: date).minute
        let weekday = calendar.components(.Weekday, fromDate: date).weekday

        switch weekday {
        case 1:
            currentWeekDay = "sunday"
            break
        case 2:
            currentWeekDay = "monday"
            break
        case 3:
            currentWeekDay = "tuesday"
            break
        case 4:
            currentWeekDay = "wednesday"
            break
        case 5:
            currentWeekDay = "thursday"
            break
        case 6:
            currentWeekDay = "friday"
            break
        case 7:
            currentWeekDay = "saturday"
            break
        default:
            print("Error fetching days")
            currentWeekDay = "day"
        }
    }

    func getCurrentDay() -> Int {
        return currentDay
    }

    func getCurrentMonth() -> Int {
        return currentMonth
    }

    func getCurrentYear() -> Int {
        return currentYear
    }

    func getCurrentHour() -> Int {
        return currentHour
    }

    func getCurrentMinute() -> Int {
        return currentMinute
    }

    func getCurrentWeekday() -> String {
        return currentWeekDay
    }

}
