//
//  SVGWindowController.swift
//  SwiftVG_mac_Harness
//
//  Created by Ben Gottlieb on 6/29/20.
//  Copyright © 2020 Stand Alone, Inc. All rights reserved.
//

import Cocoa
import SwiftVG

class SVGWindowController: NSWindowController {
	static var windows: [SVGWindowController] = []
	
	var image: SVGImage!
	var data: Data!
	
	convenience init(path: String) {
		self.init(windowNibName: "SVGWindowController")
		self.image = SVGImage(bundleName: path, directory: "Sample Images")
		
		if let xml = self.image?.buildXMLString(prettily: true) {
			print("XML Rebuilt: \n\(xml)")
		}
		
		self.window?.title = path
		self.window?.representedFilename = path
		self.window?.contentMaxSize = self.image.size
		self.window?.setContentSize(self.image.size)

		SVGWindowController.windows.append(self)
		
	}
	
	 override func windowDidLoad() {
		  super.windowDidLoad()
		
		let view = SVGImageView(frame: self.window!.contentView!.bounds)
		view.image = self.image
		self.window!.contentView?.addSubview(view)
		view.autoresizingMask = [.width, .height]
		view.setNeedsDisplay(view.bounds)
	}
	 
}

class SVGImageView: NSView {
	var image: SVGImage!
	override var isFlipped: Bool { return true }
	
	override func draw(_ dirtyRect: NSRect) {
		let ctx = NSGraphicsContext.current!.cgContext

		if let image = self.image {
			ctx.draw(image, in: self.bounds)
		}
	}
}

