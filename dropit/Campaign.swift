//
//  Campaign.swift
//  dropit
//
//  Created by Kenneth on 2016-06-19.
//  Copyright © 2016 kennethio. All rights reserved.
//

import Cocoa
import SwiftFSWatcher

class Campaign: NSObject {
	var inputPath: String = ""
	var fileList: [String] = []
	var campaignStatus: CampaignStatusEnum = CampaignStatusEnum.NONE
	let fileWatcher = SwiftFSWatcher()
	
	init(inputPath: String) {
		super.init()
		self.inputPath = inputPath
		self.fileList = populateInputFileList()
		let sassProcessingService: SassProcessingService = SassProcessingService()
		for file: String in self.fileList {
			sassProcessingService.compileRawFile(file)
		}
		fileWatcher.watchingPaths = self.fileList
		fileWatcher.watch { changeEvents in
			for ev in changeEvents {
				print("eventPath: \(ev.eventPath), eventFlag: \(ev.eventFlag), eventId: \(ev.eventId)")
				
				if ev.eventFlag == (kFSEventStreamEventFlagItemIsFile + kFSEventStreamEventFlagItemInodeMetaMod + kFSEventStreamEventFlagItemModified) {
					print("file modified at: \(ev.eventPath)")
					sassProcessingService.compileRawFile(ev.eventPath)
					
				}
			}
		}
	}
	
	private func populateInputFileList() -> [String]{
		if isDirectory(self.inputPath) {
			let fileManager: NSFileManager = NSFileManager()
			let files = fileManager.enumeratorAtPath(self.inputPath)
			while let file = files?.nextObject() {
				if isFileTypeOk(file as! String) {
					self.fileList.append(self.inputPath + "/" + (file as! String))
				}
			}
		} else {
			fileList.append(self.inputPath)
		}
		return self.fileList
	}
	
	private func isFileTypeOk(path: String) -> Bool {
		let fileTypes = ["sass", "scss"]
		let url = NSURL(fileURLWithPath: path)
		if let fileExtension = url.pathExtension?.lowercaseString {
			return fileTypes.contains(fileExtension)
		}
		return false
	}
	
	private func isDirectory(path: String) -> Bool {
		do {
			var rsrc: AnyObject?
			try NSURL(fileURLWithPath: path).getResourceValue(&rsrc, forKey: NSURLIsDirectoryKey)
			if let isDir = rsrc as? NSNumber {
				if isDir == true { return true }
				else { return false }
			}
		} catch {
			print("file path error in isDirectory()")
			return false
		}
		return false
	}

	
	enum CampaignStatusEnum {
		case SUCCEED
		case ERROR
		case PENDING
		case NONE
	}
}
