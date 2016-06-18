//
//  UpcomingAbsencesModel.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 3/12/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import Foundation

class UpcomingAbsencesModel {
    private var absenceList = [Absence]()
    private var date = Date()
    private var forwardedAbsence = Absence()

    init() {
        getUpcomingAbsences()
    }

    private func getUpcomingAbsences() {
        let date = Date()
        let querySQL = "SELECT * FROM ABSENCESLIST WHERE year > '\(date.getCurrentYear())' OR (year = '\(date.getCurrentYear())' AND month > '\(date.getCurrentMonth())') OR (year = '\(date.getCurrentYear())' AND month = '\(date.getCurrentMonth())' AND day >= '\(date.getCurrentDay())') ORDER BY year, month, day, studentLastName ASC"
        let results = database.search(querySQL)
        while (results.next()) {
            let cur = Absence()
            cur.setAbsenceID(Int(results.intForColumn("absenceID")))
            cur.setStudentFirstName(results.stringForColumn("studentFirstName"))
            cur.setStudentLastName(results.stringForColumn("studentLastName"))
            cur.setStudentID(Int(results.intForColumn("studentID")))
            cur.setRosterID(Int(results.intForColumn("rosterID")))
            cur.setAbsenceID(Int(results.intForColumn("absenceID")))
            cur.setDay(Int(results.intForColumn("day")))
            cur.setMonth(Int(results.intForColumn("month")))
            cur.setYear(Int(results.intForColumn("year")))
            absenceList.append(cur)
        }
        results.close()
    }

    func resetAbsences() {
        absenceList.removeAll()
        getUpcomingAbsences()
    }

    func getForwardedAbsence() -> Absence {
        return forwardedAbsence
    }
    func setForwardedAbsence(forwardedAbsence: Absence) {
        self.forwardedAbsence = forwardedAbsence
    }
    func getAbsencesCount() -> Int {
        return absenceList.count
    }
    func getAbsence(i: Int) -> Absence {
        return absenceList[i]
    }
    func setDate(day: Int, month: Int, year: Int) {
        date = Date(day: day, month: month, year: year)
    }
    func fullDateAmerican() -> String {
        return date.fullDateAmerican()
    }
    func removeAbsence(index: Int) {
        absenceList.removeAtIndex(index)
    }
    
}