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
	var delegate: fileDetectionViewDeledate?
	var feedbackView: FeedbackView = FeedbackView(frame: CGRectMake(0, 0, 300 ,300))
	@IBOutlet weak var backgroundImage: NSImageView!
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
		registerForDraggedTypes([NSFilenamesPboardType, NSURLPboardType])
	}
	
	
	let fileTypes = ["sass", "scss"]
	var fileTypeIsOk = false
	
	override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation {
		if isValidDrop(sender) {
			fileTypeIsOk = true
			feedbackView.removeFromSuperview()
			feedbackView = FeedbackView(frame: CGRectMake(0, 0, 300 ,300))
			self.addSubview(feedbackView)
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
	
	override func draggingExited(sender: NSDraggingInfo?) {
		feedbackView.reverseCircle()
	}
	
	override func performDragOperation(sender: NSDraggingInfo) -> Bool {
		if let board = sender.draggingPasteboard().propertyListForType("NSFilenamesPboardType") as? NSArray,
			path = board[0] as? String {
			// THIS IS WERE YOU GET THE PATH FOR THE DROPPED FILE
			filePath = path
			let campaign = self.delegate?.createCampaign(filePath)
			if (campaign?.campaignStatus == Campaign.CampaignStatusEnum.SUCCEED) {
				feedbackView.processSucceedAnimation()
			} else {
				feedbackView.processFailureAnimation()
			}
			return true
		}
		return false
	}
	
	func isValidDrop(drag: NSDraggingInfo) -> Bool {
		if let board = drag.draggingPasteboard().propertyListForType("NSFilenamesPboardType") as? NSArray,
			path = board[0] as? String {
			do {
				var rsrc: AnyObject?
				try NSURL(fileURLWithPath: path).getResourceValue(&rsrc, forKey: NSURLIsDirectoryKey)
				if let isDir = rsrc as? NSNumber {
					if isDir == true { return true }
				}
			} catch {
				self.print("file path error in Directory")
				return false
			}
			
			let url = NSURL(fileURLWithPath: path)
			if let fileExtension = url.pathExtension?.lowercaseString {
				return fileTypes.contains(fileExtension)
			}
		}
		return false
	}
}


protocol fileDetectionViewDeledate {
	func createCampaign(filePath: String) -> Campaign
}
