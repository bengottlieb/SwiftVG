//
//  String+Transform.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/22/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation
import CoreGraphics

public extension SVGElement {
	struct RawTransform {
		public let name: String
		public let coordinates: [CGFloat]
		
		func point(at index: Int) -> CGPoint? {
			guard coordinates.count > (index * 2 + 1) else { return nil }
			
			let x = coordinates[index * 2]
			let y = coordinates[index * 2 + 1]
			return CGPoint(x: x, y: y)
		}
		
		static let attributesRegex = "(\\w+)\\(((\\-?\\.?\\d+\\.?\\d*e?\\-?\\d*\\s*,?\\s*)+)\\)"
		public static func transforms(from raw: String) -> [RawTransform] {
			let regex = try! NSRegularExpression(pattern: attributesRegex, options: .caseInsensitive)
			let matches = regex.matches(in: raw, options: [], range: NSMakeRange(0, raw.utf8.count))
			
			return matches.compactMap { match -> RawTransform? in
				let nameRange = match.range(at: 1)
				let coordinateRange = match.range(at: 2)
				let name = raw[nameRange.location..<nameRange.location + nameRange.length]
				let coordinateString = raw[coordinateRange.location..<coordinateRange.location + coordinateRange.length]
				let coordinates = coordinateString.components(separatedBy: CharacterSet(charactersIn: ", ")).compactMap { $0.extractedFloat }
				return RawTransform(name: name, coordinates: coordinates)
			}
			
		}
	}
}


extension SVGElement {
	var rawTransform: RawTransform? {
		guard let string = self.attribute("transform"), let transform = RawTransform.transforms(from: string).first else { return nil }
		
		return transform
	}

	var transform: CGAffineTransform? {
		guard let transform = rawTransform else { return nil }

		if self.translation != .zero { return CGAffineTransform(translationX: translation.width, y: translation.height) }

		if transform.name == "matrix" {
			if transform.coordinates.count == 6 {
				return CGAffineTransform(a: transform.coordinates[0], b: transform.coordinates[1], c: transform.coordinates[2], d: transform.coordinates[3], tx: transform.coordinates[4], ty: transform.coordinates[5])
			}
			print("Failed to extract Transform: \(transform)")
		}
		
		if transform.name == "translate", let point = transform.point(at: 0) {
			return CGAffineTransform(translationX: point.x, y: point.y)
		}
		
		if transform.name == "rotate", let angle = transform.coordinates.first {
			let rad = (angle * 2 * .pi) / 360.0
			return CGAffineTransform(rotationAngle: CGFloat(rad))
		}
		
		if transform.name == "scale", let pt = transform.point(at: 0) {
			return CGAffineTransform(scaleX: pt.x, y: pt.y)
		}
		
		return nil
	}
	
	var scale: CGSize? {
		guard let transform = rawTransform else { return nil }

		if transform.name == "scale" {
			if let pt = transform.point(at: 0) {
				return CGSize(width: pt.x, height: pt.y)
			} else if let amount = transform.coordinates.first {
				return CGSize(width: CGFloat(amount) * self.svg.scale, height: CGFloat(amount) * self.svg.scale)
			}
		}
		
		return nil
	}
	
}

extension CharacterSet {
	static let disallowedNumberPunctuationCharacters: CharacterSet = {
		var set = CharacterSet.punctuationCharacters
		set.remove(".")
		set.remove("-")
		return set
	}()
}

extension String {
	var extractedFloat: CGFloat? {
		guard let components = self.components(separatedBy: "(").last else { return nil }
		guard let dbl = Double(components.trimmingCharacters(in: .disallowedNumberPunctuationCharacters)) else { return nil }
	//	if self.hasPrefix("-") { return -1 * CGFloat(dbl) }
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
