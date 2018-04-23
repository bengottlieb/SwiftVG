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
	var webView: WebView!
	
	convenience init(path: String) {
		self.init(windowNibName: NSNib.Name("SVGDisplayWindowController"))
		self.image = SVGImage(url: URL(fileURLWithPath: path))
		
		self.window?.title = (path as NSString).lastPathComponent

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

extension SVGDisplayWindowController: WebFrameLoadDelegate {
	public func webView(_ sender: WebView!, didStartProvisionalLoadFor frame: WebFrame!) {
	}
	
	public func webView(_ sender: WebView!, didFailProvisionalLoadWithError error: Error!, for frame: WebFrame!) {
		
	}
	
	public func webView(_ sender: WebView!, didFinishLoadFor frame: WebFrame!) {
		
	}
	
	public func webView(_ sender: WebView!, didFailLoadWithError error: Error!, for frame: WebFrame!) {
		
	}
}
