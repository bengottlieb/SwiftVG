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
	
	func styles(for element: SVGElement) -> CSSFragment? {
		var result: CSSFragment?
		
		for (sels, rules) in self.selectors {
			if sels.matches(element) {
				if result == nil {
					result = CSSFragment(fragment: rules)
				} else {
					result?.add(from: rules)
				}
			}
		}
		
		return result
	}
	
	struct CSSSelector: Hashable, CustomStringConvertible, CustomDebugStringConvertible {
		enum Kind: String { case element = "", cls = ".", id = "#" }
		let sel: String
		let kind: Kind
		
		var description: String { "\(kind.rawValue)\(sel)" }
		var debugDescription: String { "\(kind.rawValue)\(sel)" }
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

extension Array where Element == CSSSheet.CSSSelector {
	func matches(_ element: SVGElement) -> Bool {
		if let cls = element.class {
			for sel in self {
				if sel.kind == .cls, sel.sel == cls { return true }
			}
		}

		if let id = element.svgID {
			for sel in self {
				if sel.kind == .id, sel.sel == id { return true }
			}
		}
		
		let elem = element.elementName
		for sel in self {
			if sel.kind == .element, sel.sel == elem { return true }
		}
		
		return false
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
		
		while index < lastIndex {
			let chr = css[index]
			index = css.index(after: index)
			position += 1
			
			switch chr {
			case "\n", "\t": continue
				
			case "{":
				let selectors = currentLine.components(separatedBy: ",").compactMap( { CSSSheet.CSSSelector($0) })
				if selectors.count > 0 { selectorStack.append(selectors) }
				currentLine = ""
				
			case "}":
				if !currentLine.trimmingCharacters(in: .whitespaces).isEmpty {
					guard let lastSelectors = selectorStack.last else { throw CSSError.selectorStackUnderflow }
					guard let newFrag = CSSFragment(css: currentLine) else { continue }
					if let current = results[lastSelectors] { newFrag.add(from: current) }
					results[lastSelectors] = newFrag
				}
				selectorStack.removeLast()
				currentLine = ""
				
			default:
				currentLine += "\(chr)"
			}
		}
		
		return results
	}
}
