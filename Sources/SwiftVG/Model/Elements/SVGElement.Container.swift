//
//  SVGElement.Container.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/22/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation
import CoreGraphics

extension SVGElement {
	public class Container: SVGElement {
		override public var isDisplayable: Bool { return true }

		public var defs: Defs?
		var cachedChildrenByID: [String: SVGElement]?

		public func append(child: SVGElement) {
			self.children.append(child)
			if let id = child.svgID { self.cachedChildrenByID?[id] = child }
		}
		public func remove(child: SVGElement) {
			if let index = self.children.firstIndex(of: child) {
				self.children.remove(at: index)
				if let id = child.svgID { self.cachedChildrenByID?.removeValue(forKey: id) }
			}
		}
		public override func draw(with ctx: CGContext, in frame: CGRect) { self.drawChildren(with: ctx, in: frame) }
		func drawChildren(with ctx: CGContext, in frame: CGRect) {
			for child in self.children {
				child.draw(with: ctx, in: frame)
			}
		}
		
		public func removeAllChildren(ofClass checkClass: String? = nil) {
			if let check = checkClass {
				let removed = self.children.filter { ($0.isMemberOf(class: check)) }
				removed.forEach { self.remove(child: $0) }
			} else {
				self.children = []
				if self.cachedChildrenByID != nil { self.cachedChildrenByID = [:] }
			}
		}
		
		public func children(ofClass className: String) -> [SVGElement] {
			return self.children.filter { $0.isMemberOf(class: className) }
		}
		
		public func firstChild(ofClass className: String) -> SVGElement? {
			for child in self.children {
				if child.isMemberOf(class: className) { return child }
			}
			return nil
		}
		
		public func children(ofKind kind: SVGElementKind) -> [SVGElement] {
			return self.children.filter { $0.isKind(of: kind) }
		}
		
		public func firstChild(ofKind kind: SVGElementKind) -> SVGElement? {
			for child in self.children {
				if child.isKind(of: kind) { return child }
			}
			return nil
		}
		
		public func definition(for id: String) -> SVGElement? {
			var search = id
			if search.hasPrefix("#") { search = search[1...] }

			if let result = self.defs?.child(with: search) { return result }
			return self.parent?.definition(for: search)
		}
		
		func createElement(ofKind: SVGElementKind, with attributes: [String: String]) -> SVGElement? {
			return nil
		}
		
		override public var description: String { return self.hierarchicalDescription() }
		
		public override func hierarchicalDescription(_ level: Int = 0) -> String {
			var result = self.kind.tagName
			let prefix = String(repeating: "\t", count: level)
			
			//if let contentable = self as? ContentElement, !contentable.content.isEmpty { result += ": \(contentable.content)" }
			if !self.attributes.isEmpty {
				result.append(", " + self.attributes.prettyString)
			}
			if !self.children.isEmpty {
				result += " [\n"
				for kid in self.children {
					result += "\(prefix) \(kid.hierarchicalDescription(level + 1))\n"
				}
				result += "\(prefix) ]\n"
			}
			return result
		}
		
		public var debugDescription: String { return self.description }

		open override func child(with id: String) -> SVGElement? {
			if self.cachedChildrenByID == nil {
				self.cachedChildrenByID = [:]
				self.children.forEach {
					if let id = $0.svgID { self.cachedChildrenByID?[id] = $0 }
				}
			}
			return self.cachedChildrenByID?[id]
		}
		
		override open func buildXMLString(prefix: String = "") -> String {
			if self.children.count == 0, self.content.isEmpty {
				return self.xmlSelfClosingTag
			}
			
			var xml = self.xmlOpenTag + self.content
			let childPrefix = prefix.isEmpty ? "" : prefix + "\t"
			
			for child in self.children {
				xml += childPrefix
				xml += child.buildXMLString(prefix: childPrefix)
			}
			
			if !self.children.isEmpty, !prefix.isEmpty { xml += prefix }
			xml += self.xmlCloseTag
			return xml
		}
	}
}

