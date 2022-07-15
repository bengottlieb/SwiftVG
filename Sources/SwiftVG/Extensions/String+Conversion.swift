//
//  String+Conversion.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 7/15/22.
//  Copyright © 2022 Stand Alone, Inc. All rights reserved.
//

import Foundation

extension String {
	var float: CGFloat? {
		guard let raw = Double(self.trimmingCharacters(in: .notNumbersSet)) else { return nil }
		if contains("cm") {			// use cm
			// 72 points = 25.4 mm
			return CGFloat(raw) * 72 / 2.54
		}
		
		return raw
	}
}
