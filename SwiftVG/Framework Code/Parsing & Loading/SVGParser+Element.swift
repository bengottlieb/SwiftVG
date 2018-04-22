//
//  SVGParser+Element.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/21/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

protocol Element {
	var kind: SVGParser.ElementKind { get }
	var children: [Element] { get set }
	func draw(in ctx: CGContext)
}

protocol ContentElement: Element {
	func append(content: String)
}

protocol AttributedElement: Element {
	var attributes: [String: String] { get }
}

extension Element {
	func drawChildren(in ctx: CGContext) {
		for child in self.children {
			child.draw(in: ctx)
		}
	}

	func draw(in ctx: CGContext) { self.drawChildren(in: ctx) }
	
	func toString(depth: Int = 0) -> String {
		var result = String(repeating: "\t", count: depth)
		
		result += "<" + self.kind.rawValue
		
		if let attr = (self as? AttributedElement)?.attributes, attr.count > 0 {
			result += ", " + attr.prettyString
		}
		
		if self.children.count > 0 {
			result += ": [\n"
			for child in self.children {
				result += child.toString(depth: depth + 1)
			}
			result += "]"
		}
		return result + ">\n"
	}
}

extension SVGParser {
	enum ElementKind: String { case unknown
		case svg
		
		// not yet implemented
		case defs, use, path, rect, line, circle, ellipse, polygon, polyline, title, pattern, clipPath, group = "g", metadata, text, stop, linearGradient, radialGradient, type, format, rdf = "RDF", image, tspan, work = "Work", style, desc, set, script, `switch`, marker, hkern, mask, symbol, view, mpath, cursor, textPath
		case filter, feFlood, feComposite, feOffset, feGaussianBlur, feMerge, feMergeNode, feBlend, feColorMatrix, feComponentTransfer, feFuncR, feFuncG, feFuncB, feFuncA, feImage, feDiffuseLighting, feDistantLight, feConvolveMatrix, feDisplacementMatrix, fePointLight, feSpotLight, feSpecularLighting, feMorphology, feTile, feTurbulence, feDisplacementMap
		case colorProfile = "color-profile"
		case animate, animateMotion, animateColor, animateTransform
		case font, fontFace = "font-face", fontFaceSrc = "font-face-src", fontFaceURI = "font-face-uri"
		case unorderedList = "ul", orderedList = "ol", listItem = "li", strong, tref, span, p, a, em, code
		case glyph, glyphRef, missingGlyph = "missing-glyph", altGlyph, altGlyphDef, altGlyphItem, foreignObject

		func element(attributes: [String: String]) -> Element? {
			switch self {
			case .svg: return Element_svg(attributes: attributes)
			case .path: return Element_path(attributes: attributes)
			default: return GenericElement(kind: self, attributes: attributes)
			}
		}
	}
	
	struct GenericElement: Element, CustomStringConvertible, CustomDebugStringConvertible {
		var kind: ElementKind = .unknown
		var qualifiedName: String?
		var nameSpace: String?
		var attributes: [String: String] = [:]
		var children: [Element] = []
		var contents: String = ""
		
		init(kind: ElementKind, attributes: [String: String]) {
			self.kind = kind
			self.attributes = attributes
		}
		
		mutating func append(content: String){
			self.contents += content
		}
		
		var description: String {
			var result = self.kind.rawValue
			
			if !self.contents.isEmpty { result += ": \(self.contents)" }
			if !self.attributes.isEmpty {
				result += " { "
				for (key, value) in self.attributes {
					result += "\(key): \(value), "
				}
				result += "} "
			}
			if !self.children.isEmpty {
				result += " [\n"
				for kid in self.children {
					result += "\t \(kid)\n"
				}
				result += "]\n"
			}
			return result
		}
		
		var debugDescription: String { return self.description }
	}
}
