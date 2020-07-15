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
	var selectors: [[Selector]: CSSFragment] = [:]
	
	func styles(for element: SVGElement) -> CSSFragment? {
		let result = CSSFragment()
		var classFrags: [CSSFragment] = []
		var nameFrags: [CSSFragment] = []
		var idFrags: [CSSFragment] = []
		
		for (sels, rules) in self.selectors {
			if let matchKind = sels.matches(element) {
				switch matchKind {
				case .id: idFrags.append(rules)
				case .element: nameFrags.append(rules)
				case .cls: classFrags.append(rules)
				}
			}
		}
		
		nameFrags.forEach { result.add(from: $0) }
		classFrags.forEach { result.add(from: $0) }
		idFrags.forEach { result.add(from: $0) }

		return result.isEmpty ? nil : result
	}
	
	struct Selector: Hashable, CustomStringConvertible, CustomDebugStringConvertible {
		enum Kind: Int, Comparable {
			case element, cls, id
			var stringValue: String {
				switch self {
				case .element: return ""
				case .cls: return "."
				case .id: return "#"
				}
			}
			static func <(lhs: Kind, rhs: Kind) -> Bool { lhs.rawValue < rhs.rawValue }
		}
		struct Component: Hashable, CustomStringConvertible, CustomDebugStringConvertible {
			let sel: String
			let kind: Kind
			
			var description: String { "\(kind.stringValue)\(sel)" }
			var debugDescription: String { "\(kind.stringValue)\(sel)" }
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
		
		var description: String { components.map({ $0.description }).joined(separator: " > ") }
		var debugDescription: String { self.description }

		init?(_ raw: String) {
			let parts = raw.components(separatedBy: ">")
			self.components = parts.compactMap { part in
				Component(part.trimmingCharacters(in: .whitespaces))
			}
			if components.count == 0 { return nil }
		}
		let components: [Component]
		func hash(into hasher: inout Hasher) { self.components.hash(into: &hasher) }
		
	}
}

extension CSSSheet.Selector.Component {
	func matches(class cls: String) -> Bool {
		if self.kind != .cls { return false }
		
		for subclass in cls.components(separatedBy: .whitespaces) {
			if self.sel == subclass { return true }
		}
		return false
	}
	func matches(id: String) -> Bool { return self.kind == .id && self.sel == id }
	func matches(name: String) -> Bool { return self.kind == .element && self.sel == name }
	
	func matches(element: SVGElement) -> CSSSheet.Selector.Kind? {
		var matchKind: CSSSheet.Selector.Kind?
		
		if self.kind == .element {
			if !self.matches(name: element.elementName) { return nil }
			matchKind = .element
		}

		if self.kind == .cls, let cls = element.class {
			if !self.matches(class: cls) { return nil }
			matchKind = .cls
		}
		
		if self.kind == .id, let id = element.svgID {
			if !self.matches(id: id) { return nil }
			matchKind = .id
		}
		return matchKind
	}
}

extension CSSSheet.Selector {
	func matches(_ element: SVGElement) -> CSSSheet.Selector.Kind? {
		var target: SVGElement? = element
		var matchKind: CSSSheet.Selector.Kind?

		for sel in self.components.reversed() {
			guard let tgt = target else { return matchKind }
			guard let newMatchKind = sel.matches(element: tgt) else { return nil }
			if matchKind == nil || newMatchKind < matchKind! { matchKind = newMatchKind }
			target = target?.parent
		}
		return matchKind
	}
}

extension Array where Element == CSSSheet.Selector {
	func matches(_ element: SVGElement) -> CSSSheet.Selector.Kind? {
		var matchKind: CSSSheet.Selector.Kind?
		
		for sel in self {
			if let newKind = sel.matches(element), (matchKind == nil || newKind > matchKind!) {
				matchKind = newKind
			}
		}

		return matchKind
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
	
	func parse() throws -> [[CSSSheet.Selector]: CSSFragment]{
		var selectorStack: [[CSSSheet.Selector]] = []
		var currentLine = ""
		var results: [[CSSSheet.Selector]: CSSFragment] = [:]
		
		while index < lastIndex {
			let chr = css[index]
			index = css.index(after: index)
			position += 1
			
			switch chr {
			case "\n", "\t": continue
				
			case "{":
				let selectors = currentLine.components(separatedBy: ",").compactMap( { CSSSheet.Selector($0) })
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
