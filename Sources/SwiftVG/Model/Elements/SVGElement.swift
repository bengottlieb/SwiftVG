//
//  Element.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/21/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation
import CoreGraphics
import SwiftUI

open class SVGElement: Equatable, CustomStringConvertible {
	public var id = UUID().uuidString
	public let kind: SVGElementKind
	public var parent: Container!
	public var attributes: SVGAttributes = [:]
	public var styles: CSSFragment?
	public var comment: String?
	public var content = ""
	public var children: [SVGElement]! = []
	public var `class`: String?
	public var elementName: String { self.kind.tagName }
	public var svgID: String?
	
	var svg: SVGImage!
	var _cachedStyles: CSSFragment?
	
	public var description: String { (self.svgID ?? "") + " - " + self.kind.tagName }

	var isDisplayable: Bool { return false }
	var shouldClip: Bool { return false }

	var resolved: SVGElement { self }
	var size: CGSize?
	public var drawnRect: CGRect? { return nil }

	public var briefDescription: String { return self.kind.tagName }

	var classComponents: [String] {
		get { return self.attributes["class"]?.components(separatedBy: " ") ?? [] }
		set { self.attributes["class"] = newValue.joined(separator: " ") }
	}

	open func draw(with ctx: CGContext, in frame: CGRect) {}
	
	public func addClass(_ cls: String) {
		if self.classComponents.contains(cls) { return }
		self.classComponents = self.classComponents + [cls]
	}
	
	public func removeClass(_ cls: String) {
		var components = self.classComponents
		if let index = components.firstIndex(of: cls) {
			components.remove(at: index)
			self.classComponents = components
		}
	}
	
	public func toggleClass(_ cls: String) {
		if self.isMemberOf(class: cls) {
			self.removeClass(cls)
		} else {
			self.addClass(cls)
		}
	}
	
	public func isMemberOf(class name: String) -> Bool {
		return self.classComponents.contains(name)
	}
	
	public func isKind(of kind: SVGElementKind) -> Bool {
		return self.kind.isEqualTo(kind: kind)
	}
	
	open func hierarchicalDescription(_ level: Int = 0) -> String { return "<\(self.kind.tagName)> \(self.attributes.isEmpty ? "" : self.attributes.prettyString)"}
	
	public required init(kind: SVGElementKind, parent: Container?, attributes: [String: String]) {
		self.kind = kind
		self.parent = parent
		self.svg = parent?.svg
		self.attributes = attributes
		self.load(attributes: attributes)
	}
	
	open func load(attributes: [String: String]) {
		self.attributes = attributes
		self.class = self.attributes["class"]
		self.svgID = self.attributes["id"]
		if let style = attributes["style"] { self.styles = CSSFragment(css: style) }
	}
	
	public var root: Root? {
		var parent = self.parent
		while true {
			if let root = parent as? Root { return root }
			parent = parent?.parent
			if parent == nil { return nil }
		}
	}
	
	open func parentDimension(for dim: SVGDimension.Dimension) -> CGFloat? { return (self.parent as? SetsViewport)?.dimension(for: dim) }
	
	public func append(comment: String) {
		if let current = self.comment {
			self.comment = current + comment
		} else {
			self.comment = comment
		}
	}

	public func append(content: String) {
		if content.hasSuffix(" ") && !self.content.hasSuffix(" ") { self.content += " " }
		self.content += content.trimmingCharacters(in: .whitespacesAndNewlines)
		if content.hasSuffix(" ") { self.content += " " }
	}
	
	open func buildXMLString(prefix: String = "") -> String {
		if self.content.isEmpty { return self.xmlSelfClosingTag }
		
		var xml = self.xmlOpenTag
		xml += self.content
		xml += self.xmlCloseTag
		return xml
	}
	
	open func child(with id: String) -> SVGElement? {
		return nil
	}
	
	static public func ==(lhs: SVGElement, rhs: SVGElement) -> Bool {
		return lhs === rhs
	}

	func setupDimensions() {
		if self.dimensionsSetup { return }

		if let width = self.dimWidth.dimension, let height = self.dimHeight.dimension {
			self.size = CGSize(width: width, height: height)
		} else if let raw = self.attributes["viewBox"], let box = CGRect(viewBoxString: raw) {
			self.size = box.size
		}
		do {
			try self.validateDimensions()
		} catch {
			print("\(self): \(error)")
		}
	}
	
	var swiftUIOffset: CGSize {
		let origin = self.origin
		let translation = self.translation
		return CGSize(width: translation.width + origin.x, height: translation.height + origin.y)
	}
	
	func didLoad() { }
	func copy() -> Self {
		let copy = Self.init(kind: self.kind, parent: self.parent, attributes: self.attributes)
		copy.children = self.children.map { $0.copy() }
		return copy
	}

	func attributeDim(_ name: String) -> CGFloat? {
		guard let raw = self.attributes[float: name, basedOn: self] else { return nil }
		return raw * svg.scale
	}
	
	var origin: CGPoint {
		CGPoint(x: attributeDim("x") ?? 0, y: attributeDim("y") ?? 0)
	}
	
	var translation: CGSize {
		var translation = CGSize.zero
		
		if let transform = self.attributes["transform"], transform.hasPrefix("translate("), let pt = transform[9...].extractedPoint {
			translation = CGSize(width: pt.x, height: pt.y)
		}
				
		if let dx = self.attributeDim("dx") {
			translation.width = (self.previousSibling?.translation.width ?? 0) + dx
		}

		if let dy = self.attributeDim("dy") {
			translation.height = (self.previousSibling?.translation.height ?? self.parent.translation.height) + dy
		}

		return translation
	}
	
	var resolvedChildren: [SVGElement] {
		self.children.map { $0.resolved }
	}
}
