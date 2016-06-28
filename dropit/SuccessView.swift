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
	let circleRadius: CGFloat = 100.0
	var circle: NSBezierPath = NSBezierPath()
	var check: NSBezierPath = NSBezierPath()
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
		circle.appendBezierPathWithArcWithCenter(NSPoint(x: 150, y: 150), radius: circleRadius, startAngle: -90, endAngle: 270)
		circlePathLayer.frame = self.layer!.bounds
		circlePathLayer.bounds = CGRectMake(50, 50, 200, 200)
		circlePathLayer.geometryFlipped = true
		circlePathLayer.path = circle.CGPath
		circlePathLayer.strokeColor = DropitColor().green.CGColor
		circlePathLayer.fillColor = nil
		circlePathLayer.lineWidth = 10
		circlePathLayer.lineJoin = kCALineJoinBevel
		circlePathLayer.lineCap = kCALineCapRound
		self.layer?.addSublayer(circlePathLayer)
		CATransaction.begin()
		let pathAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
		pathAnimation.duration = 0.5
		pathAnimation.fromValue = 0.0
		pathAnimation.toValue = 1.0
		pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		pathAnimation.removedOnCompletion = false
		pathAnimation.fillMode = kCAFillModeForwards
		CATransaction.setCompletionBlock({
			
		})
		self.circlePathLayer.addAnimation(pathAnimation, forKey: "strokeEnd")
		CATransaction.commit()
	}
	
	func removeLayer() {
		self.circlePathLayer.hidden = true
		self.checkPathLayer.hidden = true
		self.removeFromSuperview()
	}
	
	func reverseCircle() {
		CATransaction.begin()
		let pathAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
		pathAnimation.duration = 0.5
		pathAnimation.fromValue = self.circlePathLayer.presentationLayer()?.strokeEnd
		pathAnimation.toValue = 0.0
		pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		pathAnimation.removedOnCompletion = false
		pathAnimation.fillMode = kCAFillModeForwards
		self.circlePathLayer.removeAllAnimations()
		CATransaction.setCompletionBlock({
			self.circlePathLayer.hidden = true
		})
		self.circlePathLayer.addAnimation(pathAnimation, forKey: "strokeEnd")
		CATransaction.commit()
	}
	
	func drawCheck() {
		self.check.moveToPoint(NSPoint(x: 110, y: 164))
		self.check.lineToPoint(NSPoint(x: 134, y: 182))
		self.check.lineToPoint(NSPoint(x: 188, y: 124))
		
		checkPathLayer.frame = self.layer!.bounds
		checkPathLayer.bounds = CGRectMake(50, 50, 200, 200)
		checkPathLayer.geometryFlipped = true
		checkPathLayer.path = check.CGPath
		checkPathLayer.strokeColor = DropitColor().green.CGColor
		checkPathLayer.fillColor = nil
		checkPathLayer.lineWidth = 20
		checkPathLayer.lineJoin = kCALineJoinRound
		checkPathLayer.lineCap = kCALineCapRound
		self.layer?.addSublayer(checkPathLayer)
		
		CATransaction.begin()
		let pathAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
		pathAnimation.duration = 0.5
		pathAnimation.fromValue = 0.0
		pathAnimation.toValue = 0.5
		pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		pathAnimation.removedOnCompletion = false
		pathAnimation.fillMode = kCAFillModeForwards
		CATransaction.setCompletionBlock({
			let delay = 1 * Double(NSEC_PER_SEC)
			let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
			dispatch_after(time, dispatch_get_main_queue()) {
				self.removeLayer()
			}
		})
		self.checkPathLayer.addAnimation(pathAnimation, forKey: "strokeEnd")
		CATransaction.commit()
	}
	
	func reverseCheck() {
		CATransaction.begin()
		let pathAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
		pathAnimation.duration = 0.5
		pathAnimation.fromValue = self.checkPathLayer.presentationLayer()?.strokeEnd
		pathAnimation.toValue = 0.0
		pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		pathAnimation.removedOnCompletion = false
		pathAnimation.fillMode = kCAFillModeForwards
		self.checkPathLayer.removeAllAnimations()
		CATransaction.setCompletionBlock({
			self.checkPathLayer.hidden = true
		})
		self.checkPathLayer.addAnimation(pathAnimation, forKey: "strokeEnd")
		CATransaction.commit()
	}
}

extension NSBezierPath {
	
	var CGPath: CGPathRef {
		
		get {
			return self.transformToCGPath()
		}
	}
	
	/// Transforms the NSBezierPath into a CGPathRef
	///
	/// :returns: The transformed NSBezierPath
	private func transformToCGPath() -> CGPathRef {
		
		// Create path
		let path = CGPathCreateMutable()
		let points = UnsafeMutablePointer<NSPoint>.alloc(3)
		let numElements = self.elementCount
		
		if numElements > 0 {
			
			var didClosePath = true
			
			for index in 0..<numElements {
				
				let pathType = self.elementAtIndex(index, associatedPoints: points)
				
				switch pathType {
					
				case .MoveToBezierPathElement:
					CGPathMoveToPoint(path, nil, points[0].x, points[0].y)
				case .LineToBezierPathElement:
					CGPathAddLineToPoint(path, nil, points[0].x, points[0].y)
					didClosePath = false
				case .CurveToBezierPathElement:
					CGPathAddCurveToPoint(path, nil, points[0].x, points[0].y, points[1].x, points[1].y, points[2].x, points[2].y)
					didClosePath = false
				case .ClosePathBezierPathElement:
					CGPathCloseSubpath(path)
					didClosePath = true
				}
			}
			
			if !didClosePath { CGPathCloseSubpath(path) }
		}
		
		points.dealloc(3)
		return path
	}
}