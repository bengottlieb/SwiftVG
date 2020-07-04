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
	public var id = UUID()
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

		guard let width = self.dimWidth.dimension, let height = self.dimHeight.dimension else { return }
		self.size = CGSize(width: width, height: height)

		do {
			try self.validateDimensions()
		} catch {
			print("\(self): \(error)")
		}
	}
	
	var swiftUIOffset: CGSize { self.translation }
	
	func didLoad() { }
	func copy() -> Self {
		Self.init(kind: self.kind, parent: self.parent, attributes: self.attributes)
	}
}

protocol ContentElement {
	func append(content: String)
}

extension SVGElement {
	public func toString(depth: Int = 0) -> String {
		var result = String(repeating: "\t", count: depth)
		
		result += "<" + self.kind.tagName
		
		if !self.attributes.isEmpty {
			result += ", " + self.attributes.prettyString
		}
		
		if let children = (self as? Container)?.children, children.count > 0 {
			result += ": [\n"
			for child in children {
				result += child.toString(depth: depth + 1)
			}
			result += "]"
		}
		return result + ">\n"
	}
}

public protocol SVGElementKind {
	var tagName: String { get }
	func isEqualTo(kind: SVGElementKind?) -> Bool
}

extension SVGElement {
	public enum NativeKind: String, SVGElementKind { case unknown
		case svg, path, group = "g", ellipse, circle, rect, defs, use, tspan, style
		
		// not yet implemented
		case line, polygon, polyline, title, pattern, clipPath, metadata, text, stop, linearGradient, radialGradient, type, format, rdf = "RDF", image, work = "Work", desc, set, script, `switch`, marker, hkern, mask, symbol, view, mpath, cursor, textPath
		case filter, feFlood, feComposite, feOffset, feGaussianBlur, feMerge, feMergeNode, feBlend, feColorMatrix, feComponentTransfer, feFuncR, feFuncG, feFuncB, feFuncA, feImage, feDiffuseLighting, feDistantLight, feConvolveMatrix, feDisplacementMatrix, fePointLight, feSpotLight, feSpecularLighting, feMorphology, feTile, feTurbulence, feDisplacementMap
		case colorProfile = "color-profile"
		case animate, animateMotion, animateColor, animateTransform
		case font, fontFace = "font-face", fontFaceSrc = "font-face-src", fontFaceURI = "font-face-uri"
		case unorderedList = "ul", orderedList = "ol", listItem = "li", strong, tref, span, p, a, em, code
		case glyph, glyphRef, missingGlyph = "missing-glyph", altGlyph, altGlyphDef, altGlyphItem, foreignObject

		public var tagName: String { return self.rawValue }
		public 	func isEqualTo(kind: SVGElementKind?) -> Bool {
			if let other = kind as? NativeKind { return self == other }
			return false
		}
		func element(in parent: Container?, attributes: [String: String]) -> SVGElement? {
			switch self {
			case .svg: return SVGElement.Root(kind: self, parent: parent, attributes: attributes)
			case .defs: return SVGElement.Defs(kind: self, parent: parent, attributes: attributes)
			case .use: return SVGElement.Use(kind: self, parent: parent, attributes: attributes)
			case .path: return SVGElement.Path(kind: self, parent: parent, attributes: attributes)
			case .group: return SVGElement.Group(kind: self, parent: parent, attributes: attributes)
			case .text, .tspan: return SVGElement.Text(kind: self, parent: parent, attributes: attributes)
			case .style: return SVGElement.Style(kind: self, parent: parent, attributes: attributes)
			case .circle, .ellipse: return SVGElement.Ellipse(kind: self, parent: parent, attributes: attributes)
			case .rect: return SVGElement.Rect(kind: self, parent: parent, attributes: attributes)
			default:
				return SVGElement.Generic(kind: self, parent: parent, attributes: attributes)
			}
		}
	}
}
