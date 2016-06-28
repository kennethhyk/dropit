//
//  draggable.swift
//  dropit
//
//  Created by Kenneth on 2016-06-09.
//  Copyright © 2016 kennethio. All rights reserved.
//

import Cocoa
import AppKit

class FileDetectionView: NSView {
	
	var filePath: String = ""
	@IBOutlet weak var consoleLabel: NSTextField!
	var delegate: fileDetectionViewDeledate?
	var successView: SuccessView = SuccessView(frame: CGRectMake(0, 0, 300 ,300))
	
	override var mouseDownCanMoveWindow: Bool {
		return true
	}
	
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        // Drawing code here.
    }
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		
		// Declare and register an array of accepted types
		registerForDraggedTypes([NSFilenamesPboardType, NSURLPboardType])
	}
	
	
	let fileTypes = ["sass", "scss"]
	var fileTypeIsOk = false
	var isDirectory = false
	
	override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation {
		if isDirectory(sender) {
			isDirectory = true
			fileTypeIsOk = true
			return .Copy
		} else {
			if checkExtension(sender) {
				fileTypeIsOk = true
				successView = SuccessView(frame: CGRectMake(0, 0, 300 ,300))
				self.addSubview(successView)
				return .Copy
			} else {
				fileTypeIsOk = false
				return .None
			}
		}
	}
	
	override func draggingUpdated(sender: NSDraggingInfo) -> NSDragOperation {
		if fileTypeIsOk {
			return .Copy
		} else {
			return .None
		}
	}
	
	override func draggingExited(sender: NSDraggingInfo?) {
		successView.reverseCircle()
	}
	
	override func performDragOperation(sender: NSDraggingInfo) -> Bool {
		if let board = sender.draggingPasteboard().propertyListForType("NSFilenamesPboardType") as? NSArray,
			path = board[0] as? String {
			// THIS IS WERE YOU GET THE PATH FOR THE DROPPED FILE
			filePath = path
			let campaignStatus = self.delegate?.createCampaign(filePath)
			if (campaignStatus != nil) {
				successView.drawCheck()
			}
			isDirectory = false
//			successView.removeLayer()
//			consoleLabel.stringValue = filePath
			return true
		}
		return false
	}
	
	func checkExtension(drag: NSDraggingInfo) -> Bool {
		if let board = drag.draggingPasteboard().propertyListForType("NSFilenamesPboardType") as? NSArray,
			path = board[0] as? String {
			let url = NSURL(fileURLWithPath: path)
			if let fileExtension = url.pathExtension?.lowercaseString {
				return fileTypes.contains(fileExtension)
			}
		}
		return false
	}
	
	func isDirectory(drag: NSDraggingInfo) -> Bool {
		if let board = drag.draggingPasteboard().propertyListForType("NSFilenamesPboardType") as? NSArray,
			path = board[0] as? String {
			do {
				var rsrc: AnyObject?
				try NSURL(fileURLWithPath: path).getResourceValue(&rsrc, forKey: NSURLIsDirectoryKey)
				if let isDir = rsrc as? NSNumber {
					if isDir == true { return true }
					else { return false }
				}
			} catch {
				self.print("file path error in isDirectory()")
				return false
			}
		}
		return false
	}
	
}


protocol fileDetectionViewDeledate {
	func createCampaign(filePath: String) -> Bool
}
