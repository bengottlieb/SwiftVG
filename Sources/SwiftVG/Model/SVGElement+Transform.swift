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
	var transform: CGAffineTransform? {
		if self.translation != .zero { return CGAffineTransform(translationX: translation.width, y: translation.height) }

		guard let transform = self.attributes["transform"] else { return nil }
		
//		if transform.hasPrefix("translate("), let pt = transform[9...].extractedPoint {
//			return CGAffineTransform(translationX: pt.x, y: pt.y)
//		}
		
		if transform.hasPrefix("rotate("), let angle = Double(transform[6...]) {
			let rad = (angle * 2 * .pi) / 360.0
			return CGAffineTransform(rotationAngle: CGFloat(rad))
		}
		
		if let scale = self.scale {
			return CGAffineTransform(scaleX: scale.x, y: scale.y)
		}
		
		return nil
	}
	
	var scale: CGPoint? {
		guard let transform = self.attributes["transform"] else { return nil }

		if transform.hasPrefix("scale(") {
			if let pt = transform[5...].extractedPoint {
				return CGPoint(x: pt.x, y: pt.y)
			} else if let amount = transform[5...].extractedFloat {
				return CGPoint(x: CGFloat(amount), y: CGFloat(amount))
			}
		}
		
		return nil
	}
	
}

extension String {
	var extractedFloat: CGFloat? {
		guard let components = self.components(separatedBy: "(").last else { return nil }
		guard let dbl = Double(components.trimmingCharacters(in: .punctuationCharacters)) else { return nil }
		return CGFloat(dbl)
	}

	var extractedPoint: CGPoint? {
		let filtered = self.trimmingCharacters(in: CharacterSet(charactersIn: "()"))
		let components = filtered.components(separatedBy: ",")
		if components.count != 2 { return nil }
		let x = Double(components[0].trimmingCharacters(in: .whitespaces))
		let y = Double(components[1].trimmingCharacters(in: .whitespaces))
		if x != nil || y != nil { return CGPoint(x: x ?? 0, y: y ?? 0) }
		return nil
	}
		
	var extractedPoints: [CGPoint]? {
		let filtered = self.trimmingCharacters(in: CharacterSet(charactersIn: "()"))
		let components = filtered.components(separatedBy: " ")
		
		return components.compactMap { $0.extractedPoint }
	}
}
