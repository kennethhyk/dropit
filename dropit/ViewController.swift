//
//  ViewController.swift
//  dropit
//
//  Created by Kenneth on 2016-06-09.
//  Copyright © 2016 kennethio. All rights reserved.
//

import Cocoa
import Witness

class ViewController: NSViewController, fileDetectionViewDeledate {
	
	@IBOutlet var fileDetection: FileDetectionView!
	
	var witness: Witness?
	var witnessList: [String] = []
	override func viewDidLoad() {
		super.viewDidLoad()
		fileDetection.delegate = self
	}
	
	override func viewDidAppear() {
		super.viewDidAppear()
		//disable title bar
		self.view.window?.backgroundColor = DropitColor().black
		self.view.window?.movableByWindowBackground = true
		self.view.window?.titlebarAppearsTransparent = true
		self.view.window?.styleMask |= NSFullSizeContentViewWindowMask
	}
	
	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	func createCampaign(filePath: String) -> Bool {
		let newCampaign = Campaign(inputFilePath: filePath)
		witnessList.appendContentsOf(newCampaign.inputFileList)
		watchFile(newCampaign)
		return true
	}
	
	func watchFile(campaign: Campaign) {
		let sassProcessingService: SassProcessingService = SassProcessingService()
		for file: String in campaign.inputFileList {
			sassProcessingService.compileRawFile(file)
		}
		self.witness = Witness(paths: self.witnessList, flags: .FileEvents, latency: 0.3) { events in
			if ((events.first?.flags.contains(FileEventFlags.ItemModified)) != nil) {
				print(events.first?.path)
				sassProcessingService.compileRawFile((events.first?.path)!)
			}
		}
	}
}

