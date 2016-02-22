//
//  FMDBSupport.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 2/22/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import Foundation

class FMDBSupport {
    private var path: String
    private var contactDB: FMDatabase
    init() {
        path = Util.getPath("AfterSchoolData.sqlite")
        contactDB = FMDatabase(path: path)

    }

    func search(query: String) -> FMResultSet {
        return contactDB.executeQuery(query, withArgumentsInArray: nil)
    }

    func update(update: String) -> Bool {
        let successful = contactDB.executeUpdate(update, withArgumentsInArray: nil)
        if (!successful) {
            print("Error: \(contactDB.lastErrorMessage())")
        } else {
            print("Successful")
        }
        return successful
    }

    func openDatabase() {
        if (contactDB.open()) {
            print("db open")
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
    }

    func closeDatabase() {
        if (contactDB.close()) {
            print("db closed")
        }
    }
}