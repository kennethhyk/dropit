//
//  Campaign.swift
//  dropit
//
//  Created by Kenneth on 2016-06-19.
//  Copyright © 2016 kennethio. All rights reserved.
//

import Cocoa

class Campaign: NSObject {
	var inputPath: String = ""
	var fileList: [String] = []
	var campaignStatus: CampaignStatusEnum = CampaignStatusEnum.NONE
	
	init(inputPath: String) {
		super.init()
		self.inputPath = inputPath
		self.fileList = populateInputFileList()
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
