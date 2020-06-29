//
//  String+Path.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/21/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGPoint {
	static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
		return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
	}

	static func +=(lhs: inout CGPoint, rhs: CGPoint) {
		lhs = CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
	}
}

extension String {
	enum PathError: String, Error {
		case failedToGetPoint
	}
	
	struct PreviousCurve {
		
		var point: CGPoint?
		var control1: CGPoint?
		var control2: CGPoint?
		
		var mirrored: CGPoint? {
			guard let pt = self.point, let control = self.control1 else { return nil }
			return CGPoint(x: pt.x + (pt.x - control.x), y: pt.y + (pt.y - control.y))
		}
	}
	
	var firstPathPoint: CGPoint? {
		var tokenizer = PathTokenizer(string: self)
		guard let first = tokenizer.nextCommand() else { return nil }
		
		if first == .move || first == .moveAbs { return tokenizer.nextPoint() }
		return nil
	}
	
	func generateBezierPaths() throws -> CGPath {
		let tokenizer = PathTokenizer(string: self)
		let path = CGMutablePath()
		var lastPoint = CGPoint.zero
		var firstPoint = CGPoint.zero
		var justMoving = true
		var previousCurve: PreviousCurve?
		let segments = tokenizer.segments
		for var segment in segments {
			switch segment.command {
			case .move, .moveAbs:
				justMoving = true
				while true {
					guard var point = segment.nextPoint() else { break }
					if !segment.command.isAbs { point += lastPoint }
					if justMoving {
						firstPoint = point
						justMoving = false
						path.move(to: point)
					} else {
						path.addLine(to: point)
					}
					lastPoint = point
				}
				
			case .line, .lineAbs:
				while true {
					guard var point = segment.nextPoint() else { break }
					if !segment.command.isAbs { point += lastPoint }
					path.addLine(to: point)
					lastPoint = point
				}
					
			case .horizontalLine, .horizontalLineAbs:
				guard var x = segment.nextFloat() else { throw PathError.failedToGetPoint }
				if !segment.command.isAbs { x += lastPoint.x }
				let point = CGPoint(x: x, y: lastPoint.y)
				path.addLine(to: point)
				lastPoint = point
				
			case .verticalLine, .verticalLineAbs:
				guard var y = segment.nextFloat() else { throw PathError.failedToGetPoint }
				if !segment.command.isAbs { y += lastPoint.y }
				let point = CGPoint(x: lastPoint.x, y: y)
				path.addLine(to: point)
				lastPoint = point
				
			case .quadBezier, .quadBezierAbs:
				while true {
					guard var control = segment.nextPoint(), var point = segment.nextPoint() else { break }
					if !segment.command.isAbs { control += lastPoint; point += lastPoint; }
					path.addQuadCurve(to: point, control: control)
					lastPoint = point
				}
				
			case .smoothQuadBezier, .smoothQuadBezierAbs:
				while true {
					guard var point = segment.nextPoint() else { break }
					if !segment.command.isAbs { point += lastPoint; }
					let control = previousCurve?.mirrored ?? point
					path.addQuadCurve(to: point, control: control)
					lastPoint = point
					previousCurve = PreviousCurve(point: point, control1: control, control2: nil)
				}
				
			case .closePath, .closePathAbs:
				path.closeSubpath()
				lastPoint = firstPoint
				
			case .curve, .curveAbs:
				while true {
					guard var control1 = segment.nextPoint(), var control2 = segment.nextPoint(), var point = segment.nextPoint() else { break }
					if !segment.command.isAbs { control1 += lastPoint; control2 += lastPoint; point += lastPoint }
					path.addCurve(to: point, control1: control1, control2: control2)
					lastPoint = point
				}
				
			case .smoothCurve, .smoothCurveAbs:
				guard var control = segment.nextPoint(), var point = segment.nextPoint() else { throw PathError.failedToGetPoint }
				if !segment.command.isAbs { point += lastPoint; control += lastPoint }
				let control2 = previousCurve?.control2 ?? lastPoint
				path.addCurve(to: point, control1: lastPoint, control2: control)
				lastPoint = point
				previousCurve = PreviousCurve(point: point, control1: control, control2: control2)


			case .arc, .arcAbs:
				guard var rₓ = segment.nextFloat(), var rᵧ = segment.nextFloat(), var φ = segment.nextFloat(), let largeArcFlag = segment.nextBool(), let sweepFlag = segment.nextBool(), var p2 = segment.nextPoint() else { throw PathError.failedToGetPoint }
				
				if !segment.command.isAbs { p2 += lastPoint }
				if rₓ == 0 || rᵧ == 0 {
					path.addLine(to: p2)
					break
				}
				
				φ = φ * 2 * .pi / 360
				if φ > 2 * .pi { φ -= .pi * 2 }
				let p1 = lastPoint
				let cosφ = cos(φ)
				let sinφ = sin(φ)
				let x1ʹ = cosφ * (p1.x - p2.x) * 0.5 + sinφ * (p1.y - p2.y) * 0.5
				let y1ʹ = -sinφ * (p1.x - p2.x) * 0.5 + cosφ * (p1.y - p2.y) * 0.5
				
				var rₓ² = rₓ * rₓ
				var rᵧ² = rᵧ * rᵧ
				let xʹ² = x1ʹ * x1ʹ
				let yʹ² = y1ʹ * y1ʹ
				
				let delta = xʹ²/rₓ² + yʹ²/rᵧ²
				if delta > 1.0 {
					rₓ *= sqrt(delta)
					rᵧ *= sqrt(delta)
					
					rₓ² = rₓ * rₓ
					rᵧ² = rᵧ * rᵧ
				}
				
				let sign: CGFloat = (largeArcFlag == sweepFlag) ? -1 : 1
				let rise = max(0, rₓ² * rᵧ² - rₓ² * yʹ² - rᵧ² * xʹ²)
				let range = rₓ² * yʹ² + rᵧ² * xʹ²
				let coefficient = sign * sqrt(rise / range)
				
				let cₓʹ = coefficient * (rₓ * y1ʹ) / rᵧ
				let cᵧʹ = coefficient * -((rᵧ * x1ʹ) / rₓ)
				let cₓ = cosφ * cₓʹ - sinφ * cᵧʹ + (p2.x + p1.x) / 2
				let cᵧ = sinφ * cₓʹ + cosφ * cᵧʹ + (p2.y + p1.y) / 2
				
				let transform = CGAffineTransform(scaleX: 1 / rₓ, y: 1/rᵧ).rotated(by: -φ).translatedBy(x: -cₓ, y: -cᵧ)
				let arc1 = p1.applying(transform)
				let arc2 = p2.applying(transform)
				let startAngle = atan2(arc1.y, arc1.x)
				let endAngle = atan2(arc2.y, arc2.x)
				var angle = endAngle - startAngle
				if sweepFlag {
					if angle < 0 { angle += 2 * .pi }
				} else {
					if angle > 0 { angle -= 2 * .pi }
				}
				let inverted = CGAffineTransform(translationX: cₓ, y: cᵧ).rotated(by: φ).scaledBy(x: rₓ, y: rᵧ)
				path.addRelativeArc(center: .zero, radius: 1, startAngle: startAngle, delta: angle, transform: inverted)

				lastPoint = p2
			}
		}
		if tokenizer.hasContentLeft { print("\(tokenizer.index) / \(tokenizer.tokens.count)") }
		
		return path
	}
}
