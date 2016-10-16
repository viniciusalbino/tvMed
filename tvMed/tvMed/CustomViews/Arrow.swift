//
//  Arrow.swift
//  Zattini
//
//  Created by Christopher John Morris on 8/4/15.
//  Copyright (c) 2015 Netshoes. All rights reserved.
//

import Foundation

let kGoldenRatio = CGFloat(1.61803398875)

public class Arrow: UIView {
    var bezierPath = UIBezierPath()
    var strokeColor = UIColor.blackColor()
    
    init() {
        super.init(frame: Arrow.defaultFrame())
        initializeView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeView()
    }
    
    init(strokeColor: UIColor) {
        super.init(frame: Arrow.defaultFrame())
        self.strokeColor = strokeColor
        initializeView()
    }
    
    func initializeView() {
        backgroundColor = UIColor.clearColor()
    }
    
    func lineWidth() -> CGFloat {
        return CGFloat(1)
    }
    
    func distanceBetween(pointOne: CGPoint, pointTwo: CGPoint) -> CGFloat {
        let dx = pointOne.x - pointTwo.x
        let dy = pointOne.y - pointTwo.y
        let dxSquared = pow(dx, 2)
        let dySquared = pow(dy, 2)
        return sqrt(dxSquared + dySquared)
    }
    
    func changeStrokeColor(color: UIColor) {
        strokeColor = color
        self.setNeedsDisplay()
    }
    
    class func defaultFrame() -> CGRect {
        return CGRect(x: 0, y: 0, width: 22, height: 22)
    }
}

public class LeftPointingArrow: Arrow {
    public override func drawRect(rect: CGRect) {
        bezierPath.lineWidth = lineWidth()
        bezierPath.lineCapStyle = CGLineCap.Round
        
        let startingPoint = CGPoint(x: frame.size.width, y: -bezierPath.lineWidth)
        bezierPath.moveToPoint(startingPoint)
        
        let firstPoint = CGPoint(x: frame.size.width - (frame.size.height / kGoldenRatio), y: frame.size.height / 2)
        bezierPath.addLineToPoint(firstPoint)
        bezierPath.moveToPoint(firstPoint)
        
        let secondPoint = CGPoint(x: frame.size.width, y: frame.size.height + bezierPath.lineWidth)
        bezierPath.addLineToPoint(secondPoint)
        bezierPath.moveToPoint(secondPoint)
        
        strokeColor.setStroke()
        bezierPath.stroke()
    }
}

public class RightPointingArrow: Arrow {
    public override func drawRect(rect: CGRect) {
        bezierPath.lineWidth = lineWidth()
        bezierPath.lineCapStyle = CGLineCap.Butt
        
        let startingPoint = CGPoint(x: 0, y: -bezierPath.lineWidth)
        bezierPath.moveToPoint(startingPoint)
        
        let firstPoint = CGPoint(x: frame.size.height / kGoldenRatio, y: frame.size.height / 2)
        bezierPath.addLineToPoint(firstPoint)
        bezierPath.moveToPoint(firstPoint)
        
        let secondPoint = CGPoint(x: 0, y: frame.size.height + bezierPath.lineWidth)
        bezierPath.addLineToPoint(secondPoint)
        bezierPath.moveToPoint(secondPoint)
        
        strokeColor.setStroke()
        bezierPath.stroke()
    }
}