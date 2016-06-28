//
//  Campaign.swift
//  dropit
//
//  Created by Kenneth on 2016-06-19.
//  Copyright © 2016 kennethio. All rights reserved.
//

import Cocoa

class Campaign: NSObject {
	var inputFilePath: String = ""
	var inputFileList: [String] = []
	var campaignStatus: CampaignStatusEnum = CampaignStatusEnum.NONE
	
	init(inputFilePath: String) {
		super.init()
		self.inputFilePath = inputFilePath
		self.inputFileList = populateInputFileList()
	}
	
	private func populateInputFileList() -> [String]{
		if isDirectory(self.inputFilePath) {
			let fileManager: NSFileManager = NSFileManager()
			let files = fileManager.enumeratorAtPath(self.inputFilePath)
			while let file = files?.nextObject() {
				if isFileTypeOk(file as! String) {
					self.inputFileList.append(self.inputFilePath + "/" + (file as! String))
				}
			}
		} else {
			inputFileList.append(self.inputFilePath)
		}
		print(self.inputFileList)
		return self.inputFileList
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
