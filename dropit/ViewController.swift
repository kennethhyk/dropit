//
//  ViewController.swift
//  dropit
//
//  Created by Kenneth on 2016-06-09.
//  Copyright © 2016 kennethio. All rights reserved.
//

import Cocoa
import Witness
import SwiftFSWatcher

class ViewController: NSViewController, fileDetectionViewDeledate {
	
	@IBOutlet var fileDetection: FileDetectionView!
	
	let fileWatcher = SwiftFSWatcher()
	var campaignList: [Campaign] = []
	
	func createCampaign(filePath: String) -> Campaign {
		let newCampaign = Campaign(inputPath: filePath)
		campaignList.append(newCampaign)
		return newCampaign
	}
	
/*=========== System Callbacks ============*/
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
}

