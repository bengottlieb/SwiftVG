//
//  String+PathTokenizer.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 6/28/20.
//  Copyright © 2020 Stand Alone, inc. All rights reserved.
//

import Foundation
import CoreGraphics

extension String {
	struct PathTokenizer {
		struct PathSegment {
			var command: Command
			var arguments: [String] = []
			var index = 0
			let origin: CGPoint
			
			mutating func nextPoint() -> CGPoint? {
				if self.index >= (self.arguments.count - 1) { return nil }
				if let x = Double(self.arguments[self.index]), let y = Double(self.arguments[self.index + 1]) {
					self.index += 2
					return CGPoint(x: x, y: y) + self.origin
				}
				return nil
			}

			mutating func nextFloat() -> CGFloat? {
				if self.index >= self.arguments.count { return nil }
				if let f = Double(self.arguments[self.index]) {
					self.index += 1
					return CGFloat(f)
				}
				return nil
			}

			mutating func nextBool() -> Bool? {
				if self.index >= self.arguments.count { return nil }
				if self.arguments[self.index] == "0" {
					self.index += 1
					return false
				}
				if self.arguments[self.index] == "1" {
					self.index += 1
					return true
				}
				return nil
			}
		}
		
		enum Command: String {
			case move = "m", moveAbs = "M"
			case closePath = "z", closePathAbs = "Z"
			case line = "l", lineAbs = "L"
			case horizontalLine = "h", horizontalLineAbs = "H"
			case verticalLine = "v", verticalLineAbs = "V"
			case curve = "c", curveAbs = "C"
			case smoothCurve = "s", smoothCurveAbs = "S"
			case quadBezier = "q", quadBezierAbs = "Q"
			case smoothQuadBezier = "t", smoothQuadBezierAbs = "T"
			case arc = "a", arcAbs = "A"
			
			var isAbs: Bool {
				switch self {
				case .moveAbs, .closePathAbs, .lineAbs, .horizontalLineAbs, .verticalLineAbs, .curveAbs, .smoothCurveAbs, .quadBezierAbs, .smoothQuadBezierAbs, .arcAbs: return true
				default: return false
				}
			}
			
			var subsequentMissingCommand: Command {
				switch self {
				case .move, .moveAbs: return .line
				default: return self
				}
			}
			
			var argumentCount: Int {
				switch self {
				case .horizontalLineAbs, .horizontalLine, .verticalLine, .verticalLineAbs:
					 return 1
				case .move, .moveAbs, .line, .lineAbs, .smoothQuadBezier, .smoothQuadBezierAbs:
					 return 2
				case .smoothCurve, .smoothCurveAbs, .quadBezier, .quadBezierAbs:
					 return 4
				case .curve, .curveAbs:
					 return 6
				case .arc, .arcAbs:
					 return 7
				default:
					 return 0
				}
			}
		}
		let tokens: [String]
		let origin: CGPoint
		var index = 0
		
		init(string: String, origin: CGPoint) {
			self.tokens = string.tokens
			self.origin = origin
		}
		
		var segments: [PathSegment] {
			var parser = self
			var segments: [PathSegment] = []
			var lastCommand: Command?
			
			while true {
				let next = parser.nextCommand()
				let command = next ?? lastCommand?.subsequentMissingCommand
				if parser.index == parser.tokens.count || command == nil {
					if next != nil { segments.append(PathSegment(command: next!, origin: self.origin)) }
					break
				}
				let argCount = command!.argumentCount
				lastCommand = command
				segments.append(PathSegment(command: command!, arguments: parser.nextNArguments(argCount), origin: self.origin))
			}
			
			return segments
		}
		
		mutating func nextNArguments(_ n: Int) -> [String] {
			if n == 0 || n >= tokens.count { return [] }
			let end = Swift.min(index + n, tokens.count)
			let result = Array(tokens[index..<end])
			index += result.count
			return result
		}
		
		var hasContentLeft: Bool { return self.index < self.tokens.count }
		
		mutating func nextCommand() -> Command? {
			if self.index >= self.tokens.count { return nil }
			if let command = Command(rawValue: self.tokens[self.index]) {
				self.index += 1
				return command
			}
			return nil
		}

		mutating func nextPoint() -> CGPoint? {
			if self.index >= (self.tokens.count - 1) { return nil }
			if let x = Double(self.tokens[self.index]), let y = Double(self.tokens[self.index + 1]) {
				self.index += 2
				return CGPoint(x: x, y: y)
			}
			return nil
		}

	}
}
