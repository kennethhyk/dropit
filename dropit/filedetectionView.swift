//
//  draggable.swift
//  dropit
//
//  Created by Kenneth on 2016-06-09.
//  Copyright © 2016 kennethio. All rights reserved.
//

import Cocoa
import AppKit

class filedetectionView: NSView {
	
	var filePath: String = ""
	@IBOutlet weak var consoleLabel: NSTextField!
	
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
		registerForDraggedTypes([NSFilenamesPboardType, NSURLPboardType, NSPasteboardTypeTIFF])
	}
	
	
	let fileTypes = ["sass", "scss"]
	var fileTypeIsOk = false
	var droppedFilePath: String?
	
	override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation {
		if checkExtension(sender) {
			fileTypeIsOk = true
			return .Copy
		} else {
			fileTypeIsOk = false
			return .None
		}
	}
	
	override func draggingUpdated(sender: NSDraggingInfo) -> NSDragOperation {
		if fileTypeIsOk {
			return .Copy
		} else {
			return .None
		}
	}
	
	override func performDragOperation(sender: NSDraggingInfo) -> Bool {
		if let board = sender.draggingPasteboard().propertyListForType("NSFilenamesPboardType") as? NSArray,
			path = board[0] as? String {
			// THIS IS WERE YOU GET THE PATH FOR THE DROPPED FILE
			filePath = path
			droppedFilePath = path
			sassProcess(inputFilePath: droppedFilePath!)
			consoleLabel.stringValue = droppedFilePath!
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
	
}
