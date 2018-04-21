//
//  AppDelegate.swift
//  SwiftVGTestMac
//
//  Created by Ben Gottlieb on 8/31/17.
//  Copyright © 2017 Stand Alone, inc. All rights reserved.
//

import Cocoa
import SwiftVG

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!


	func applicationDidFinishLaunching(_ aNotification: Notification) {
		let url = Bundle.main.url(forResource: "united-states", withExtension: "svg", subdirectory: "Sample Images")!
		let image = SVGImage(url: url)
		
		print("Image: \(image!)")
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

	func applicationShouldOpenUntitledFile(_ sender: NSApplication) -> Bool {
		return false
	}
	
	func application(_ sender: NSApplication, openFiles filenames: [String]) {
	}
}

