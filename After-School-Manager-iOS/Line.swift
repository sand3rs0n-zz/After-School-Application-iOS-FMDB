//
//  Line.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 1/19/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import UIKit

class Line {
    private var start: CGPoint
    private var end: CGPoint

    init (start: CGPoint, end: CGPoint) {
        self.start = start
        self.end = end
    }

    func getStart() -> CGPoint {
        return start
    }

    func getEnd() -> CGPoint {
        return end
    }
}