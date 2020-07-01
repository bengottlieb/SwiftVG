//
//  String+Transform.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/22/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation
import CoreGraphics

extension SVGElement {
	var translation: CGSize {
		guard let transform = self.attributes["transform"] else { return .zero }
		
		if transform.hasPrefix("translate("), let pt = transform[9...].extractedPoint {
			return CGSize(width: pt.x, height: pt.y)
		}
		
		return .zero
	}

	var transform: CGAffineTransform? {
		guard let transform = self.attributes["transform"] else { return nil }
		
		if transform.hasPrefix("translate("), let pt = transform[9...].extractedPoint {
			return CGAffineTransform(translationX: pt.x, y: pt.y)
		}

		if transform.hasPrefix("rotate("), let angle = Double(transform[6...]) {
			let rad = (angle * 2 * .pi) / 360.0
			return CGAffineTransform(rotationAngle: CGFloat(rad))
		}
		
		if transform.hasPrefix("scale("), let pt = transform[5...].extractedPoint {
			return CGAffineTransform(scaleX: pt.x, y: pt.y)
		}
		return nil
	}
	
}

extension String {
	var extractedPoint: CGPoint? {
		let filtered = self.trimmingCharacters(in: CharacterSet(charactersIn: "()"))
		let components = filtered.components(separatedBy: ",")
		if components.count != 2 { return nil }
		guard let x = Double(components[0].trimmingCharacters(in: .whitespaces)), let y = Double(components[1].trimmingCharacters(in: .whitespaces)) else { return nil }
		return CGPoint(x: x, y: y)
	}
}
