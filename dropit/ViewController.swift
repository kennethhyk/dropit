//
//  ViewController.swift
//  dropit
//
//  Created by Kenneth on 2016-06-09.
//  Copyright © 2016 kennethio. All rights reserved.
//

import Cocoa
import SwiftFSWatcher

class ViewController: NSViewController, fileDetectionViewDeledate, NSTableViewDataSource, NSTableViewDelegate {
	
	@IBOutlet var fileDetection: FileDetectionView!
	@IBOutlet weak var campaignTable: NSTableView!
	
	let fileWatcher = SwiftFSWatcher()
	var campaignList: [Campaign] = []
	
	func createCampaign(filePath: String) -> Campaign {
		let newCampaign = Campaign(inputPath: filePath)
		campaignList.append(newCampaign)
		reloadFileList()
		return newCampaign
	}
	
	func numberOfRowsInTableView(tableView: NSTableView) -> Int {
		return self.campaignList.count ?? 0
	}
	
	
	func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
		var image:Campaign.CampaignStatusEnum?
		var text:String = ""
		var cellIdentifier: String = ""
		
		// 1
		guard let item: Campaign = self.campaignList[row] else {
			return nil
		}
		
		// 2
		if tableColumn == tableView.tableColumns[0] {
			image = item.campaignStatus
			cellIdentifier = "statusIndicator"
		} else if tableColumn == tableView.tableColumns[1] {
			text = item.inputPath
			cellIdentifier = "pathCell"
		}
		
		// 3
		if let cell = tableView.makeViewWithIdentifier(cellIdentifier, owner: nil) as? NSTableCellView {
			if(cellIdentifier == "pathCell") {
				let str = text
				//Keep the first 49 characters.
				var strTemp = String(str.characters.suffix(49))
				strTemp = "..." + (strTemp as String)
				
				let paragraphStyleWithSpacing           = NSMutableParagraphStyle()
				paragraphStyleWithSpacing.lineSpacing   = 0 //CGFloat
				paragraphStyleWithSpacing.maximumLineHeight = 15
				let textWithLineSpacing                 = NSAttributedString(string: strTemp as String, attributes: [NSParagraphStyleAttributeName : paragraphStyleWithSpacing, NSKernAttributeName: CGFloat(1.2)])
				cell.textField?.attributedStringValue = textWithLineSpacing
			} else {
				cell.textField?.stringValue = "•"
//				let dotPath = NSBezierPath(ovalInRect: CGRectMake(0, 0, 100, 100))
//				
//				let layer = CAShapeLayer()
//				layer.path = dotPath.CGPath
//				layer.fillColor = DropitColor().green.CGColor
//				
//				cell.imageView?.layer!.addSublayer(layer)
//				cell.imageView?.image = NSImage(named: "pinkFileIcon")
			}
			return cell
		}
		return nil
	}
	
	func reloadFileList() {
		campaignTable.reloadData()
	}
/*=========== System Callbacks ============*/
	override func viewDidLoad() {
		super.viewDidLoad()
		fileDetection.delegate = self
		let campaignView = CampaignView(frame: CGRectMake(0, 0, 300, 300))
		campaignTable.setDelegate(self)
		campaignTable.setDataSource(self)
		super.view.addSubview(campaignView)
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