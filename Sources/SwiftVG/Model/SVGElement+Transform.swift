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
		
		func float(at index: Int) -> CGFloat? {
			guard coordinates.count > index else { return nil }
			
			return coordinates[index]
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
	var rawTransforms: [RawTransform] {
		guard let string = self.attribute("transform") else { return [] }
		
		return RawTransform.transforms(from: string)
	}

	var transform: CGAffineTransform? {
		var components: [CGAffineTransform] = []
		
		for transform in rawTransforms {
			if transform.name == "matrix" {
				if transform.coordinates.count == 6 {
					components.append(CGAffineTransform(a: transform.coordinates[0], b: transform.coordinates[1], c: transform.coordinates[2], d: transform.coordinates[3], tx: transform.coordinates[4], ty: transform.coordinates[5]))
				} else {
					print("Failed to extract Transform: \(transform)")
				}
			}
			
			if transform.name == "translate", let point = transform.point(at: 0) {
				components.append(CGAffineTransform(translationX: point.x, y: point.y))
			}
			
			if transform.name == "rotate", let angle = transform.coordinates.first {
				let rad = (angle * 2 * .pi) / 360.0
				components.append(CGAffineTransform(rotationAngle: CGFloat(rad)))
			}
			
			if transform.name == "scale" {
				if let pt = transform.point(at: 0) {
					components.append(CGAffineTransform(scaleX: pt.x, y: pt.y))
				} else if let scale = transform.float(at: 0) {
					components.append(CGAffineTransform(scaleX: scale, y: scale))
				}
			}
		}

		if let translation = translation {
			components.append(CGAffineTransform(translationX: translation.width, y: translation.height))
		}
		
		var transform = CGAffineTransform.identity
		for sub in components.reversed() {
			transform = transform.concatenating(sub)
		}
		return transform
	}
	
	var scale: CGSize? {
		guard let transform = rawTransforms.first else { return nil }

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
	static let disallowedNumberCharacters: CharacterSet = {
		var set = CharacterSet(charactersIn: "0123456789.-")
		return set.inverted
	}()
}

extension String {
	var extractedFloat: CGFloat? {
		guard let components = self.components(separatedBy: "(").last else { return nil }
		guard let dbl = Double(components.trimmingCharacters(in: .disallowedNumberCharacters)) else { return nil }
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
		let parenthesedPairs = self.trimmingCharacters(in: CharacterSet(charactersIn: "()"))
		if parenthesedPairs.isNotEmpty {
			let components = parenthesedPairs.components(separatedBy: " ")
			
			let points = components.compactMap { $0.extractedPoint }
			if !points.isEmpty { return points }
		}
		
		let pairs = self.components(separatedBy: .whitespacesAndNewlines).filter { $0.isNotEmpty && $0 != "," }
		if pairs.isNotEmpty {
			return (0..<(pairs.count / 2)).compactMap { n in
				guard
					let x = pairs[n * 2].extractedFloat,
					let y = pairs[n * 2 + 1].extractedFloat
				else { return nil }
				
				return CGPoint(x: x, y: y)
			}
		}
		
		return nil
	}
}
