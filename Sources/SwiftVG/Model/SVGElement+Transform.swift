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
	

	var translation: CGSize {
		var translation = CGSize.zero
		
		if let transform = self.attributes["transform"], transform.hasPrefix("translate("), let pt = transform[9...].extractedPoint {
			translation = CGSize(width: pt.x, height: pt.y)
		}
		
		translation.width += self.attributes[float: "x", basedOn: self] ?? 0
		translation.height += self.attributes[float: "y", basedOn: self] ?? 0
		
		if let dx = self.attributes[float: "dx", basedOn: self] {
			translation.width = (self.previousSibling?.translation.width ?? 0) + dx
		}

		if let dy = self.attributes[float: "dy", basedOn: self] {
			translation.height = (self.previousSibling?.translation.height ?? self.parent.translation.height) + dy
		}

		return translation
	}
}

extension String {
	var extractedPoint: CGPoint? {
		let filtered = self.trimmingCharacters(in: CharacterSet(charactersIn: "()"))
		let components = filtered.components(separatedBy: ",")
		if components.count != 2 { return nil }
		let x = Double(components[0].trimmingCharacters(in: .whitespaces))
		let y = Double(components[1].trimmingCharacters(in: .whitespaces))
		if x != nil || y != nil { return CGPoint(x: x ?? 0, y: y ?? 0) }
		return nil
	}
}
