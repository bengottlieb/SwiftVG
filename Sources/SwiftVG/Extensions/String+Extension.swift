//
//  String+Extensions.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/21/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation
import CoreGraphics

extension String {
	subscript(_ range: Range<Int>) -> String {
		let start = self.index(self.startIndex, offsetBy: range.lowerBound)
		let end = self.index(self.startIndex, offsetBy: range.upperBound)
		return String(self[start..<end])
	}
	
	subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
		let start = self.index(self.startIndex, offsetBy: range.lowerBound)
		let end = self.endIndex
		return String(self[start..<end])
	}
	
//	subscript(_ range: CountablePartialRangeTo<Int>) -> String {
//		let start = self.startIndex
//		let end = self.index(self.startIndex, offsetBy: range.upperBound)
//		return self[start..<end]
//	}
	
	var tokens: [String] {
		var result: [String] = []
		var currentChunk = ""
		var inNumber = false
		
		for chr in self {
			let nowInNumber = (chr >= "0" && chr <= "9") || chr == "." || chr == "-" || chr == "e"
			if chr == " " || chr == "," {
				inNumber = false
				if !currentChunk.isEmpty { result.append(currentChunk) }
				currentChunk = ""
				continue
			}
			
			if chr == ".", currentChunk.contains(".") {
				result.append(currentChunk)
				currentChunk = "0."
				continue
			}
			
			if currentChunk == "" {
				currentChunk = String(chr)
				inNumber = nowInNumber
				continue
			}
			
			if chr == "-" {
				if !inNumber || currentChunk.last != "e" {
					if !currentChunk.isEmpty { result.append(currentChunk) }
					currentChunk = "-"
					inNumber = true
					continue
				}
			}
			
			if nowInNumber {
				if !inNumber, !currentChunk.isEmpty {
					result.append(currentChunk)
					currentChunk = ""
				}
				inNumber = true
				currentChunk += String(chr)
			} else {
				if inNumber {
					result.append(currentChunk)
					currentChunk = ""
					inNumber = false
				}
				result.append(String(chr))
			}
			
		}
		if !currentChunk.isEmpty { result.append(currentChunk) }
		return result
	}
}
