//
//  ViewController.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 1/29/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        super.viewDidLoad()
        let path = NSBundle.mainBundle().pathForResource("AfterSchoolData", ofType: "sqlite")
        let contactDB = FMDatabase(path: path)
        if contactDB.open() {
            let querySQL = "SELECT pin FROM USERSETTINGS"

            let results:FMResultSet? = contactDB.executeQuery(querySQL,
                withArgumentsInArray: nil)

            if results?.next() == true {
                print(results?.stringForColumn("pin"))
            } else {
                print("fail")
            }
            contactDB.close()
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
    }


    func create() {
        let path = NSBundle.mainBundle().pathForResource("AfterSchoolData", ofType: "sqlite")
            let contactDB = FMDatabase(path: path)

            if contactDB == nil {
                print("Error: \(contactDB.lastErrorMessage())")
            }

            if contactDB.open() {
                let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)"
                if !contactDB.executeStatements(sql_stmt) {
                    print("Error: \(contactDB.lastErrorMessage())")
                }
                contactDB.close()
            }
    }

    func save() {
        let path = NSBundle.mainBundle().pathForResource("AfterSchoolData", ofType: "sqlite")
        let contactDB = FMDatabase(path: path)

        if contactDB.open() {

            let insertSQL = "INSERT INTO CONTACTS (name, address, phone) VALUES ('')"

            let result = contactDB.executeUpdate(insertSQL,
                withArgumentsInArray: nil)

            if !result {
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
            }
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
    }

    func find() {

        let path = NSBundle.mainBundle().pathForResource("AfterSchoolData", ofType: "sqlite")

        let contactDB = FMDatabase(path: path)
        if contactDB.open() {
            let querySQL = "SELECT pin FROM USERSETTINGS"

            let results:FMResultSet? = contactDB.executeQuery(querySQL,
                withArgumentsInArray: nil)

            if results?.next() == true {
                print(results?.stringForColumn("pin"))
            } else {
                print("fail")
            }
            contactDB.close()
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

