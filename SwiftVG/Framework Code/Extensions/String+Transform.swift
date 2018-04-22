//
//  String+Transform.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/22/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

extension String {
	var embeddedTransform: CGAffineTransform? {
		if self.hasPrefix("translate("), let pt = self[9...].extractedPoint {
			return CGAffineTransform(translationX: pt.x, y: pt.y)
		}

		if self.hasPrefix("rotate("), let angle = Double(self[6...]) {
			let rad = (angle * 2 * .pi) / 360.0
			return CGAffineTransform(rotationAngle: CGFloat(rad))
		}
		
		if self.hasPrefix("scale("), let pt = self[5...].extractedPoint {
			return CGAffineTransform(scaleX: pt.x, y: pt.y)
		}
		return nil
	}
	
	var extractedPoint: CGPoint? {
		let filtered = self.trimmingCharacters(in: CharacterSet(charactersIn: "()"))
		let components = filtered.components(separatedBy: ",")
		if components.count != 2 { return nil }
		guard let x = Double(components[0].trimmingCharacters(in: .whitespaces)), let y = Double(components[1].trimmingCharacters(in: .whitespaces)) else { return nil }
		return CGPoint(x: x, y: y)
	}
}
