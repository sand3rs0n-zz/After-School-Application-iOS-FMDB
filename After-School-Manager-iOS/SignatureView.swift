//
//  SignatureView.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 1/19/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class SignatureView: UIView {

    private var lines: [Line] = []
    private var lastPoint : CGPoint!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        lastPoint = touches.first!.locationInView(self)
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let newPoint = touches.first!.locationInView(self)
        lines.append(Line(start: lastPoint, end: newPoint))
        lastPoint = newPoint

        self.setNeedsDisplay()
    }

    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextBeginPath(context)
        for line in lines {
            CGContextMoveToPoint(context, line.getStart().x, line.getStart().y)
            CGContextAddLineToPoint(context, line.getEnd().x, line.getEnd().y)
        }
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetRGBStrokeColor(context, 0, 0, 0, 1)
        CGContextSetLineWidth(context, 5)
        CGContextStrokePath(context)
    }

    func getLines() -> [Line] {
        return lines
    }
    func setLines(lines: [Line]) {
        self.lines = lines
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
