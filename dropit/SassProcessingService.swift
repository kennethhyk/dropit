//
//  sassProcessingController.swift
//  dropit
//
//  Created by Kenneth on 2016-06-17.
//  Copyright © 2016 kennethio. All rights reserved.
//

import Foundation
import Cocoa
import libsass

class SassProcessingService {
	
	func compileRawFile (filePath: String) {
		var inputFilePath: String
		var outputFileName: String
		
		var file_ctx: COpaquePointer
		var ctx: COpaquePointer
		var ctx_opt: COpaquePointer
		
		var status: Int32
		
		inputFilePath = filePath
		
		let fileName = String((NSURL(string: inputFilePath)?.URLByDeletingPathExtension?.lastPathComponent)!)
		if fileName[fileName.startIndex] == "_" {
			return
		}
		
		outputFileName = (NSURL(string: filePath)?.URLByDeletingPathExtension?.lastPathComponent)! + ".css"
		
		file_ctx = sass_make_file_context(inputFilePath)
		ctx = sass_file_context_get_context(file_ctx)
		ctx_opt = sass_context_get_options(ctx)
		sass_option_set_precision(ctx_opt, 10)
		
		status = sass_compile_file_context(file_ctx)
		
		if (status == 0) {
			var path = NSURL(fileURLWithPath: inputFilePath).URLByDeletingLastPathComponent
			print("inspect why optional value \(path?.absoluteURL)")//optional value? why?
			path = NSURL(fileURLWithPath: (path!.absoluteString)).URLByAppendingPathComponent(outputFileName)
//			campaign.campaignStatus = Campaign.CampaignStatusEnum.PENDING
			
			//writing
			do {
				try String.fromCString(sass_context_get_output_string(ctx))!.writeToURL(path!, atomically: false, encoding: NSUTF8StringEncoding)
//				campaign.campaignStatus = Campaign.CampaignStatusEnum.SUCCEED
			}
			catch {
				print("error processing SASS/SCSS file")
//				campaign.campaignStatus = Campaign.CampaignStatusEnum.ERROR
			}
			
		}
		else {
			puts(sass_context_get_error_message(ctx))
//			campaign.campaignStatus = Campaign.CampaignStatusEnum.ERROR
		}
		
		sass_delete_file_context(file_ctx)
	}
	
	
}