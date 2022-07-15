//
//  Dictionary+Extension.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/21/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation
import CoreGraphics

extension CharacterSet {
	static let notNumbersSet = CharacterSet(charactersIn: "1234567890-").inverted
}

extension Dictionary where Key == String, Value == String {
	var prettyString: String {
		var result = "["
		
		for (key, value) in self {
			result += "\(key): \(value), "
		}
		
		return result + "]"
	}
		
	subscript(float key: String, basedOn element: SVGElement? = nil) -> CGFloat? {
		guard let raw = self[key] else { return nil }
		guard let dbl = Double(raw) else {
			guard let number = Double(raw.trimmingCharacters(in: .notNumbersSet)) else { return nil }
			
			if raw.contains("em"), let fontSize = element?.fontSize {			// use em-units
				return CGFloat(number) * fontSize
			}
			
			if raw.contains("%") {
				if let parentValue = element?.parent?.attributeDim(key) {
					return CGFloat(number) * parentValue / 100
				}
			}
			return raw.float
		}
		
		return CGFloat(dbl)
	}
}
