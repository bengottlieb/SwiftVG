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
			let dbl = Double(self.raw) ?? 0
			self.value = CGFloat(dbl)
		}
		
		return self.value as? CGFloat
	}
}
