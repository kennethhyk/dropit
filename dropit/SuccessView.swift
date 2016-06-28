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
	
	let circleRadius: CGFloat = 80.0
	let circlePathLayer = CAShapeLayer()
	let innerCirclePathLayer = CAShapeLayer()
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
		NSBezierPathToCAShapeLayer(circle, pathLayer: circlePathLayer, strokeColor: DropitColor().green, fillColor: NSColor.clearColor(), lineWidth: 10)
		createStrokeEndAnimation(circlePathLayer, duration: 0.5, fromValue: 0.0, toValue: 1.0, timingFunction: kCAMediaTimingFunctionEaseInEaseOut, removedOnCompletion: false, completionBlock: nil)
		
		let innerCircle: NSBezierPath = NSBezierPath()
		innerCircle.appendBezierPathWithArcWithCenter(NSPoint(x: 150, y: 150), radius: circleRadius-5, startAngle: -90, endAngle: 270)
		NSBezierPathToCAShapeLayer(innerCircle, pathLayer: innerCirclePathLayer, strokeColor: NSColor.clearColor(), fillColor: DropitColor().black, lineWidth: 0)
	}
	
	func processSucceedAnimation() {
		self.circlePathLayer.removeAllAnimations()
		self.circlePathLayer.fillColor = DropitColor().green.CGColor
		CATransaction.begin()
		let pathAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform")
		pathAnimation.duration = 0.5
		var tr: CATransform3D = CATransform3DIdentity
		tr = CATransform3DScale(tr, 0, 0, 1)
		pathAnimation.toValue = NSValue(CATransform3D: tr)
		pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		pathAnimation.removedOnCompletion = false
		pathAnimation.fillMode = kCAFillModeForwards
		CATransaction.setCompletionBlock({
			self.drawCheck()
		})
		self.innerCirclePathLayer.addAnimation(pathAnimation, forKey: "transform")
		CATransaction.commit()

	}
	
	func drawCheck() {
		let check: NSBezierPath = NSBezierPath()
		check.moveToPoint(NSPoint(x: 110, y: 164))
		check.lineToPoint(NSPoint(x: 134, y: 182))
		check.lineToPoint(NSPoint(x: 188, y: 124))
		self.NSBezierPathToCAShapeLayer(check, pathLayer: self.checkPathLayer, strokeColor: DropitColor().black, fillColor: NSColor.clearColor(), lineWidth: 20)
		self.createStrokeEndAnimation(self.checkPathLayer, duration: 0.5, fromValue: 0.0, toValue: 0.55, timingFunction: kCAMediaTimingFunctionEaseInEaseOut, removedOnCompletion: false) { (Void) in
			let delay = 1 * Double(NSEC_PER_SEC)
			let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
			dispatch_after(time, dispatch_get_main_queue()) {
				self.removeLayer()
			}
		}
	}
	
	func reverseCircle() {
		self.circlePathLayer.fillColor = NSColor.clearColor().CGColor
		self.circlePathLayer.removeAllAnimations()
		createStrokeEndAnimation(circlePathLayer, duration: 0.5, fromValue: (self.circlePathLayer.presentationLayer()?.strokeEnd)!, toValue: 0.0, timingFunction: kCAMediaTimingFunctionEaseInEaseOut, removedOnCompletion: false) { (Void) in
			self.removeLayer()
		}
	}
	
	func NSBezierPathToCAShapeLayer(bezierPath: NSBezierPath, pathLayer: CAShapeLayer, strokeColor: NSColor, fillColor: NSColor,lineWidth: CGFloat) {
		pathLayer.frame = self.layer!.bounds
		pathLayer.bounds = CGRectMake(50, 50, 200, 200)
		pathLayer.geometryFlipped = true
		pathLayer.path = bezierPath.CGPath
		pathLayer.strokeColor = strokeColor.CGColor
		pathLayer.fillColor = fillColor.CGColor
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
		self.innerCirclePathLayer.hidden = true
		self.checkPathLayer.hidden = true
		let delay = 1 * Double(NSEC_PER_SEC)
		let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
		dispatch_after(time, dispatch_get_main_queue()) {
			self.removeFromSuperview()
		}
	}
}