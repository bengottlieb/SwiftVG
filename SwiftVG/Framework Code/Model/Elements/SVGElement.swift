//
//  Element.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/21/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

open class SVGElement: Equatable {
	public let kind: SVGElementKind
	public var parent: Container!
	public var attributes: [String: String]
	public var styles: CSSFragment?
	public var comment: String?
	public var content = ""

	open func draw(with ctx: CGContext, in frame: CGRect) {}
	
	public var id: String? { return self.attributes["id"] }
	open var `class`: String? { return self.attributes["class"] }
	
	open func hierarchicalDescription(_ level: Int = 0) -> String { return "<\(self.kind.tagName)> \(self.attributes.isEmpty ? "" : self.attributes.prettyString)"}
	
	public init(kind: SVGElementKind, parent: Container?) {
		self.kind = kind
		self.parent = parent
		self.attributes = [:]
	}
	
	open func load(attributes: [String: String]?) {
		self.attributes = attributes ?? [:]
		if let style = attributes?["style"] { self.styles = CSSFragment(css: style) }
	}
	
	public var root: Root? {
		var parent = self.parent
		while true {
			if let root = parent as? Root { return root }
			parent = parent?.parent
			if parent == nil { return nil }
		}
	}
	
	open func parentDimension(for dim: SVGElement.Dimension) -> CGFloat? { return (self.parent as? SetsViewport)?.dimension(for: dim) }
	
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
	
	static public func ==(lhs: SVGElement, rhs: SVGElement) -> Bool {
		return lhs === rhs
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

extension SVGElement {
	public enum Dimension { case width, height }
}

public protocol SVGElementKind {
	var tagName: String { get }
	func isEqualTo(kind: SVGElementKind?) -> Bool
}

extension SVGElement {
	public enum NativeKind: String, SVGElementKind { case unknown
		case svg, path, group = "g", ellipse, circle, rect, defs, use, tspan
		
		// not yet implemented
		case line, polygon, polyline, title, pattern, clipPath, metadata, text, stop, linearGradient, radialGradient, type, format, rdf = "RDF", image, work = "Work", style, desc, set, script, `switch`, marker, hkern, mask, symbol, view, mpath, cursor, textPath
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
			case .svg: return SVGElement.Root(parent: parent, attributes: attributes)
			case .defs: return SVGElement.Defs(parent: parent, attributes: attributes)
			case .use: return SVGElement.Use(parent: parent, attributes: attributes)
			case .path: return SVGElement.Path(parent: parent, attributes: attributes)
			case .group: return SVGElement.Group(parent: parent, attributes: attributes)
			case .text: return SVGElement.Text(parent: parent, attributes: attributes)
			case .circle, .ellipse: return SVGElement.Ellipse(kind: self, parent: parent, attributes: attributes)
			case .rect: return SVGElement.Rect(parent: parent, attributes: attributes)
			default: return SVGElement.Generic(kind: self, parent: parent, attributes: attributes)
			}
		}
	}
}
