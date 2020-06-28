//
//  SVGDisplayWindowController.swift
//  SwiftVGTestMac
//
//  Created by Ben Gottlieb on 8/31/17.
//  Copyright © 2017 Stand Alone, inc. All rights reserved.
//

import Cocoa
import SwiftVG
import WebKit

class SVGDisplayWindowController: NSWindowController {
	static var windows: [SVGDisplayWindowController] = []
	
	var image: SVGImage!
	var data: Data!
	var webView: WKWebView!
	
	convenience init(path: String) {
		self.init(windowNibName: "SVGDisplayWindowController")
		self.image = SVGImage(url: URL(fileURLWithPath: path))
		
		if let xml = self.image?.buildXMLString(prettily: true) {
			print("XML Rebuilt: \n\(xml)")
		}
		
		self.window?.title = (path as NSString).lastPathComponent
		self.window?.representedFilename = path
		self.window?.contentMaxSize = self.image.size
		self.window?.setContentSize(self.image.size)

		SVGDisplayWindowController.windows.append(self)
		
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
