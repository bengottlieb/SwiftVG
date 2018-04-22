//
//  Color+Extension.swift
//  SwiftVGTest
//
//  Created by Ben Gottlieb on 4/22/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

#if os(OSX)
	typealias SVGColor = NSColor
#else
	typealias SVGColor = UIColor
#endif

extension SVGColor {
	static func random() -> SVGColor {
		let red: UInt32 = arc4random() % 255
		let green: UInt32 = arc4random() % 255
		let blue: UInt32 = arc4random() % 255

		return SVGColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 0.3)
	}
	
	convenience init?(_ string: String) {
		var str = string
		var alpha: UInt32 = 255
		var red: UInt32 = 0
		var green: UInt32 = 0
		var blue: UInt32 = 0
		
		if str.hasPrefix("#") { str = String(str[str.startIndex...]) }
		let length = str.count
		if length == 0 { return nil }
		
		if (length == 3 || length == 4) {
			Scanner(string: str[Range(0..<1)] + str[Range(0..<1)]).scanHexInt32(&red)
			Scanner(string: str[Range(1..<2)] + str[Range(1..<2)]).scanHexInt32(&green)
			Scanner(string: str[Range(2..<3)] + str[Range(2..<3)]).scanHexInt32(&blue)
			if length > 3 { Scanner(string: str[Range(3..<4)] + str[Range(3..<4)]).scanHexInt32(&alpha) }
		} else if (length == 6 || length == 8) {
			Scanner(string: str[Range(0...1)]).scanHexInt32(&red)
			Scanner(string: str[Range(2...3)]).scanHexInt32(&green)
			Scanner(string: str[Range(4...5)]).scanHexInt32(&blue)
			if length > 6 { Scanner(string: str[Range(6...7)]).scanHexInt32(&alpha) }
		}

		self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha) / 255.0)

	}
}
