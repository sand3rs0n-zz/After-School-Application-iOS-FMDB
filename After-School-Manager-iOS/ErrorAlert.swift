//
//  ErrorAlert.swift
//  After-School-Manager-iOS
//
//  Created by Steven on 3/11/16.
//  Copyright © 2016 Steven Anderson. All rights reserved.
//

import Foundation
import UIKit

class ErrorAlert {
    private var errorString = ""
    private var viewController: UIViewController

    init(viewController: UIViewController) {
        errorString = "Undefined Error. Call 1-941-266-5447"
        self.viewController = viewController
    }

    init(viewController: UIViewController, errorString: String) {
        self.viewController = viewController
        self.errorString = errorString
    }

    func displayError() {
        let myAlertController = UIAlertController(title: "Error", message: errorString, preferredStyle: .Alert)
        let acknowledgeAction = UIAlertAction(title: "OK", style: .Default) { action -> Void in
        }
        myAlertController.addAction(acknowledgeAction)
        viewController.presentViewController(myAlertController, animated: true, completion: nil)
    }
}
