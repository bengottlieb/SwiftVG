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
		if let previous = UserDefaults.standard.string(forKey: "last-path") {
			SVGDisplayWindowController(path: previous).showWindow(nil)
		} else {
			let url = Bundle.main.url(forResource: "virginia", withExtension: "svg", subdirectory: "Sample Images")!

			SVGDisplayWindowController(path: url.path).showWindow(nil)
		}
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

	func applicationShouldOpenUntitledFile(_ sender: NSApplication) -> Bool {
		return false
	}
	
	func application(_ sender: NSApplication, openFiles filenames: [String]) {
		for file in filenames {
			UserDefaults.standard.set(file, forKey: "last-path")
			SVGDisplayWindowController(path: file).showWindow(nil)
			//print(image?.description ?? "")
		}
	}
}

