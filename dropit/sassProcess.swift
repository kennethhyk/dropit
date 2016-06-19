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

class sassProcess {
	var inputFilePath: String
	var outputFile: String
	
	var file_ctx: COpaquePointer
	var ctx: COpaquePointer
	var ctx_opt: COpaquePointer
	
	var status: Int32
	
	init(inputFilePath: String) {
		self.inputFilePath = inputFilePath
		self.outputFile = (NSURL(string: self.inputFilePath)?.URLByDeletingPathExtension?.lastPathComponent)! + ".css"
		
		self.file_ctx = sass_make_file_context(inputFilePath)
		self.ctx = sass_file_context_get_context(file_ctx)
		self.ctx_opt = sass_context_get_options(ctx)
		sass_option_set_precision(ctx_opt, 10)
		
		self.status  = sass_compile_file_context(file_ctx)
		if (status == 0) {
			var path = NSURL(fileURLWithPath: self.inputFilePath).URLByDeletingLastPathComponent
			print(path?.absoluteURL)
			path = NSURL(fileURLWithPath: (path!.absoluteString)).URLByAppendingPathComponent(self.outputFile)
			print(self.outputFile)
			print(path?.absoluteURL)
			
			//writing
			do {
				try String.fromCString(sass_context_get_output_string(ctx))!.writeToURL(path!, atomically: false, encoding: NSUTF8StringEncoding)
			}
			catch {
				print("error processing SASS/SCSS file")
			}
			
		}
		else {
			puts(sass_context_get_error_message(ctx))
		}
		
		sass_delete_file_context(file_ctx)

	}
	
}