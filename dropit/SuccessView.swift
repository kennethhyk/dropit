//
//  successView.swift
//  dropit
//
//  Created by Kenneth on 2016-06-20.
//  Copyright © 2016 kennethio. All rights reserved.
//

import Cocoa
import AppKit

class SuccessView: NSView {
	
	let circlePathLayer = CAShapeLayer()
	let circleRadius: CGFloat = 80.0
	let checkPathLayer =  CAShapeLayer()

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
		drawCircle()
    }
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func drawCircle() {
		let circle: NSBezierPath = NSBezierPath()
		circle.appendBezierPathWithArcWithCenter(NSPoint(x: 150, y: 150), radius: circleRadius, startAngle: -90, endAngle: 270)
		NSBezierPathToCAShapeLayer(circle, pathLayer: circlePathLayer, strokeColor: DropitColor().green, lineWidth: 10)
		createStrokeEndAnimation(circlePathLayer, duration: 0.5, fromValue: 0.0, toValue: 1.0, timingFunction: kCAMediaTimingFunctionEaseInEaseOut, removedOnCompletion: false, completionBlock: nil)
	}
	
	func drawCheck() {
		let check: NSBezierPath = NSBezierPath()
		check.moveToPoint(NSPoint(x: 110, y: 164))
		check.lineToPoint(NSPoint(x: 134, y: 182))
		check.lineToPoint(NSPoint(x: 188, y: 124))
		NSBezierPathToCAShapeLayer(check, pathLayer: checkPathLayer, strokeColor: DropitColor().green, lineWidth: 20)
		createStrokeEndAnimation(checkPathLayer, duration: 0.5, fromValue: 0.0, toValue: 0.5, timingFunction: kCAMediaTimingFunctionEaseInEaseOut, removedOnCompletion: false) { (Void) in
			let delay = 1 * Double(NSEC_PER_SEC)
			let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
			dispatch_after(time, dispatch_get_main_queue()) {
				self.removeLayer()
			}
		}
	}
	
	func reverseCircle() {
		self.circlePathLayer.removeAllAnimations()
		createStrokeEndAnimation(circlePathLayer, duration: 0.5, fromValue: (self.circlePathLayer.presentationLayer()?.strokeEnd)!, toValue: 0.0, timingFunction: kCAMediaTimingFunctionEaseInEaseOut, removedOnCompletion: false) { (Void) in
			self.circlePathLayer.hidden = true
		}
	}
	
	func reverseCheck() {
		self.checkPathLayer.removeAllAnimations()
		createStrokeEndAnimation(checkPathLayer, duration: 0.5, fromValue: (self.checkPathLayer.presentationLayer()?.strokeEnd)!, toValue: 0.0, timingFunction: kCAMediaTimingFunctionEaseInEaseOut, removedOnCompletion: false) { (Void) in
			self.checkPathLayer.hidden = true
		}
	}

	
	func NSBezierPathToCAShapeLayer(bezierPath: NSBezierPath, pathLayer: CAShapeLayer, strokeColor: NSColor, lineWidth: CGFloat) {
		pathLayer.frame = self.layer!.bounds
		pathLayer.bounds = CGRectMake(50, 50, 200, 200)
		pathLayer.geometryFlipped = true
		pathLayer.path = bezierPath.CGPath
		pathLayer.strokeColor = strokeColor.CGColor
		pathLayer.fillColor = nil
		pathLayer.lineWidth = lineWidth
		pathLayer.lineJoin = kCALineJoinRound
		pathLayer.lineCap = kCALineCapRound
		self.layer?.addSublayer(pathLayer)
	}
	
	func createStrokeEndAnimation(layer: CAShapeLayer, duration: CFTimeInterval, fromValue: AnyObject, toValue: AnyObject, timingFunction: String, removedOnCompletion: Bool, completionBlock: ((Void) -> Void)?) {
		CATransaction.begin()
		let pathAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
		pathAnimation.duration = duration
		pathAnimation.fromValue = fromValue
		pathAnimation.toValue = toValue
		pathAnimation.timingFunction = CAMediaTimingFunction(name: timingFunction)
		pathAnimation.removedOnCompletion = removedOnCompletion
		pathAnimation.fillMode = kCAFillModeForwards
		CATransaction.setCompletionBlock(completionBlock)
		layer.addAnimation(pathAnimation, forKey: "strokeEnd")
		CATransaction.commit()
	}
	
	func removeLayer() {
		self.circlePathLayer.hidden = true
		self.checkPathLayer.hidden = true
		self.removeFromSuperview()
	}
}