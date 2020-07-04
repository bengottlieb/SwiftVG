//
//  CSSSheet.swift
//  SwiftVG
//
//  Created by ben on 7/4/20.
//  Copyright © 2020 Stand Alone, Inc. All rights reserved.
//

import Foundation

public class CSSSheet {
	init(string css: String) {
		let parser = CSSParser(css: css)
		
		do {
			self.selectors = try parser.parse()
		} catch {
			print(error)
		}
	}
	
	var numberOfRules: Int { selectors.reduce(0) { $0 + $1.value.rules.count }}
	var selectors: [[CSSSelector]: CSSFragment] = [:]
	
	struct CSSSelector: Hashable, CustomStringConvertible {
		enum Kind: String { case element = "", cls = ".", id = "#" }
		let sel: String
		let kind: Kind
		
		var description: String { "\(kind.rawValue)\(sel)" }
		func hash(into hasher: inout Hasher) {
			sel.hash(into: &hasher)
			kind.rawValue.hash(into: &hasher)
		}
		
		init?(_ raw: String) {
			let filtered = raw.trimmingCharacters(in: CharacterSet(charactersIn: "{}")).trimmingCharacters(in: .whitespaces)
			
			if filtered.hasPrefix(".") {
				kind = .cls
				sel = String(filtered[1...])
			} else if filtered.hasPrefix("#") {
				kind = .id
				sel = String(filtered[1...])
			} else if !filtered.isEmpty {
				kind = .element
				sel = filtered
			} else {
				kind = .element
				sel = ""
				return nil
			}
		}
	}
}

class CSSParser {
	enum CSSError: Error { case emptySelectors, selectorStackUnderflow }
	let css: String
	var index: String.Index
	let lastIndex: String.Index
	var position = 0
	
	init(css: String) {
		self.css = css
		index = css.startIndex
		lastIndex = css.endIndex
	}
	
	func parse() throws -> [[CSSSheet.CSSSelector]: CSSFragment]{
		var selectorStack: [[CSSSheet.CSSSelector]] = []
		var currentLine = ""
		var results: [[CSSSheet.CSSSelector]: CSSFragment] = [:]
		
		while true {
			let chr = css[index]
			index = css.index(after: index)
			position += 1
			if index == lastIndex { break }
			
			switch chr {
			case "\n": continue
				
			case "{":
				let selectors = currentLine.components(separatedBy: ",").compactMap( { CSSSheet.CSSSelector($0) })
				if selectors.count > 0 { selectorStack.append(selectors) }
				currentLine = ""
				
			case "}":
				if currentLine.trimmingCharacters(in: .whitespaces).isEmpty {
					_ = selectorStack.dropLast()
				} else {
					guard let lastSelectors = selectorStack.last else { throw CSSError.selectorStackUnderflow }
					guard let newFrag = CSSFragment(css: currentLine) else { continue }
					if let current = results[lastSelectors] { newFrag.add(from: current) }
					results[lastSelectors] = newFrag
				}
				currentLine = ""
				
			default:
				currentLine += "\(chr)"
			}
		}
		
		return results
	}
}
