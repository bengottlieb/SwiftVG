//
//  CSSValue.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/22/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

class CSSValue {
	let raw: String
	var value: Any?
	
	init?(string: String, for property: CSSFragment.Property) {
		self.raw = string
	}
	
	var color: SVGColor? {
		if value == nil {
			self.value = SVGColor(self.raw)
		}
		
		return self.value as? SVGColor
	}

	var float: CGFloat? {
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
	
	var string: String { return self.raw }
}
