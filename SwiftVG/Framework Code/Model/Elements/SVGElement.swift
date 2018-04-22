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
	var parent: SVGElement!
	var attributes: [String: String]?

	func draw(in ctx: CGContext) {}
	
	var id: String? { return self.attributes?["id"] }
	
	init(kind: SVGElement.Kind, parent: SVGElement?) {
		self.kind = kind
		self.parent = parent
	}
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
	enum Kind: String { case unknown
		case svg, path
		
		// not yet implemented
		case defs, use, rect, line, circle, ellipse, polygon, polyline, title, pattern, clipPath, group = "g", metadata, text, stop, linearGradient, radialGradient, type, format, rdf = "RDF", image, tspan, work = "Work", style, desc, set, script, `switch`, marker, hkern, mask, symbol, view, mpath, cursor, textPath
		case filter, feFlood, feComposite, feOffset, feGaussianBlur, feMerge, feMergeNode, feBlend, feColorMatrix, feComponentTransfer, feFuncR, feFuncG, feFuncB, feFuncA, feImage, feDiffuseLighting, feDistantLight, feConvolveMatrix, feDisplacementMatrix, fePointLight, feSpotLight, feSpecularLighting, feMorphology, feTile, feTurbulence, feDisplacementMap
		case colorProfile = "color-profile"
		case animate, animateMotion, animateColor, animateTransform
		case font, fontFace = "font-face", fontFaceSrc = "font-face-src", fontFaceURI = "font-face-uri"
		case unorderedList = "ul", orderedList = "ol", listItem = "li", strong, tref, span, p, a, em, code
		case glyph, glyphRef, missingGlyph = "missing-glyph", altGlyph, altGlyphDef, altGlyphItem, foreignObject

		func element(in parent: SVGElement?, attributes: [String: String]) -> SVGElement? {
			switch self {
			case .svg: return SVGElement.Root(parent: parent, attributes: attributes)
			case .path: return SVGElement.Path(parent: parent, attributes: attributes)
			default: return SVGElement.Generic(kind: self, parent: parent, attributes: attributes)
			}
		}
	}
}
