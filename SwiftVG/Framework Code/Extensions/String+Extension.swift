//
//  String+Extensions.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/21/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

extension String {
	var viewBox: CGRect? {
		var components = self.components(separatedBy: ",")
		if components.count != 4 { components = self.components(separatedBy: .whitespaces) }
		if components.count != 4 { return nil }
		
		return CGRect(x: Double(components[0]) ?? 0, y: Double(components[1]) ?? 0, width: Double(components[2]) ?? 0, height: Double(components[3]) ?? 0)
	}
	
	var dimension: CGFloat? {
		if let dbl = Double(self) { return CGFloat(dbl) }
		
		let filtered = self.trimmingCharacters(in: .letters)
		if let dbl = Double(filtered) { return CGFloat(dbl) }
		return nil
	}
	
	subscript(_ range: Range<Int>) -> String {
		let start = self.index(self.startIndex, offsetBy: range.lowerBound)
		let end = self.index(self.startIndex, offsetBy: range.upperBound)
		return self[start..<end]
	}
	
	subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
		let start = self.index(self.startIndex, offsetBy: range.lowerBound)
		let end = self.endIndex
		return self[start..<end]
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
			if chr == " " ||  chr == "," {
				inNumber = false
				if !currentChunk.isEmpty { result.append(currentChunk) }
				currentChunk = ""
				continue
			}
			if currentChunk == "" {
				currentChunk = String(chr)
				inNumber = nowInNumber
				continue
			}
			
			if chr == "-" {
				if !currentChunk.isEmpty, (!inNumber || currentChunk.last != "e") { result.append(currentChunk) }
				currentChunk = "-"
				inNumber = true
				continue
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
