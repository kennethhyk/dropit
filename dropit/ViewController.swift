//
//  ViewController.swift
//  dropit
//
//  Created by Kenneth on 2016-06-09.
//  Copyright © 2016 kennethio. All rights reserved.
//

import Cocoa
import libsass

class ViewController: NSViewController {
	
	@IBOutlet var fileDetection: filedetectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	
		
		// Do any additional setup after loading the view.
	}

	override func viewDidAppear() {
		super.viewDidAppear()
		//disable title bar
		self.view.window?.backgroundColor = NSColor.init(calibratedRed: 0.129, green: 0.129, blue: 0.129, alpha: 1.0)
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

