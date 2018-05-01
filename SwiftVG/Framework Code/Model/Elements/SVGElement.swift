//
//  Element.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/21/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

class SVGElement {
	let kind: SVGElement.Kind
	var parent: Container!
	var attributes: [String: String]?
	var styles: CSSFragment?

	func draw(with ctx: CGContext, in frame: CGRect) {}
	
	var id: String? { return self.attributes?["id"] }
	var `class`: String? { return self.attributes?["class"] }
	
	func hierarchicalDescription(_ level: Int = 0) -> String { return "<\(self.kind.rawValue)> \(self.attributes?.prettyString ?? "")"}
	
	init(kind: SVGElement.Kind, parent: Container?) {
		self.kind = kind
		self.parent = parent
	}
	
	func load(attributes: [String: String]?) {
		self.attributes = attributes
		if let style = attributes?["style"] { self.styles = CSSFragment(css: style) }
	}
	
	var root: Root? {
		var parent = self.parent
		while true {
			if let root = parent as? Root { return root }
			parent = parent?.parent
			if parent == nil { return nil }
		}
	}
	
	func parentDimension(for dim: SVGElement.Dimension) -> CGFloat? { return (self.parent as? SetsViewport)?.dimension(for: dim) }

}

protocol ContentElement {
	func append(content: String)
}

extension SVGElement {
	func toString(depth: Int = 0) -> String {
		var result = String(repeating: "\t", count: depth)
		
		result += "<" + self.kind.rawValue
		
		if let attr = self.attributes, attr.count > 0 {
			result += ", " + attr.prettyString
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
	enum Dimension { case width, height }
}

extension SVGElement {
	enum Kind: String { case unknown
		case svg, path, group = "g", ellipse, circle, rect, defs, use, tspan
		
		// not yet implemented
		case line, polygon, polyline, title, pattern, clipPath, metadata, text, stop, linearGradient, radialGradient, type, format, rdf = "RDF", image, work = "Work", style, desc, set, script, `switch`, marker, hkern, mask, symbol, view, mpath, cursor, textPath
		case filter, feFlood, feComposite, feOffset, feGaussianBlur, feMerge, feMergeNode, feBlend, feColorMatrix, feComponentTransfer, feFuncR, feFuncG, feFuncB, feFuncA, feImage, feDiffuseLighting, feDistantLight, feConvolveMatrix, feDisplacementMatrix, fePointLight, feSpotLight, feSpecularLighting, feMorphology, feTile, feTurbulence, feDisplacementMap
		case colorProfile = "color-profile"
		case animate, animateMotion, animateColor, animateTransform
		case font, fontFace = "font-face", fontFaceSrc = "font-face-src", fontFaceURI = "font-face-uri"
		case unorderedList = "ul", orderedList = "ol", listItem = "li", strong, tref, span, p, a, em, code
		case glyph, glyphRef, missingGlyph = "missing-glyph", altGlyph, altGlyphDef, altGlyphItem, foreignObject

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
