//
//  CSSValue.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/22/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation
import CoreGraphics

public class CSSValue: CustomStringConvertible {
	public let raw: String
	public var value: Any?
	
	public var description: String { raw }
	
	public init?(string: String, for property: CSSFragment.Property) {
		self.raw = string.trimmingCharacters(in: .whitespacesAndNewlines)
	}
	
	public var color: SVGColor? {
		if value == nil {
			self.value = SVGColor(self.raw)
		}
		
		return self.value as? SVGColor
	}

	public var float: CGFloat? {
		if value == nil {
			if let dbl = Double(self.raw) {
				self.value = CGFloat(dbl)
			}
			
			let filtered = self.raw.trimmingCharacters(in: CharacterSet.decimalDigits.inverted)
			if let dbl = Double(filtered) {
				self.value = CGFloat(dbl)
			}

		}
		
		return self.value as? CGFloat
	}
	
	public var string: String { return self.raw }
}
