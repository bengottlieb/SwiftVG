//
//  Element.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/21/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

class Element {
	let kind: Element.Kind
	var parent: Element!
	var attributes: [String: String]?

	func draw(in ctx: CGContext) {}
	
	init(kind: Element.Kind, parent: Element?) {
		self.kind = kind
		self.parent = parent
	}
}

class ContainerElement: Element {
	var children: [Element] = []
	func append(child: Element) { self.children.append(child) }
	override func draw(in ctx: CGContext) { self.drawChildren(in: ctx) }
	func drawChildren(in ctx: CGContext) {
		for child in self.children {
			child.draw(in: ctx)
		}
	}
}

protocol ContentElement {
	func append(content: String)
}

extension Element {
	func toString(depth: Int = 0) -> String {
		var result = String(repeating: "\t", count: depth)
		
		result += "<" + self.kind.rawValue
		
		if let attr = self.attributes, attr.count > 0 {
			result += ", " + attr.prettyString
		}
		
		if let children = (self as? ContainerElement)?.children, children.count > 0 {
			result += ": [\n"
			for child in children {
				result += child.toString(depth: depth + 1)
			}
			result += "]"
		}
		return result + ">\n"
	}
}

extension Element {
	enum Kind: String { case unknown
		case svg
		
		// not yet implemented
		case defs, use, path, rect, line, circle, ellipse, polygon, polyline, title, pattern, clipPath, group = "g", metadata, text, stop, linearGradient, radialGradient, type, format, rdf = "RDF", image, tspan, work = "Work", style, desc, set, script, `switch`, marker, hkern, mask, symbol, view, mpath, cursor, textPath
		case filter, feFlood, feComposite, feOffset, feGaussianBlur, feMerge, feMergeNode, feBlend, feColorMatrix, feComponentTransfer, feFuncR, feFuncG, feFuncB, feFuncA, feImage, feDiffuseLighting, feDistantLight, feConvolveMatrix, feDisplacementMatrix, fePointLight, feSpotLight, feSpecularLighting, feMorphology, feTile, feTurbulence, feDisplacementMap
		case colorProfile = "color-profile"
		case animate, animateMotion, animateColor, animateTransform
		case font, fontFace = "font-face", fontFaceSrc = "font-face-src", fontFaceURI = "font-face-uri"
		case unorderedList = "ul", orderedList = "ol", listItem = "li", strong, tref, span, p, a, em, code
		case glyph, glyphRef, missingGlyph = "missing-glyph", altGlyph, altGlyphDef, altGlyphItem, foreignObject

		func element(in parent: Element?, attributes: [String: String]) -> Element? {
			switch self {
			case .svg: return Element.Root(parent: parent, attributes: attributes)
			case .path: return Element.Path(parent: parent, attributes: attributes)
			default: return Element.Generic(kind: self, parent: parent, attributes: attributes)
			}
		}
	}
}
