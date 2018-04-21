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
	
	var data: Data!
	var webView: WebView!
	
	convenience init(path: String) {
		self.init(windowNibName: NSNib.Name("SVGDisplayWindowController"))
		self.data = try! Data(contentsOf: URL(fileURLWithPath: path))
		
		SVGDisplayWindowController.windows.append(self)
	}
	
    override func windowDidLoad() {
        super.windowDidLoad()
		

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
