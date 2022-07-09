//
//  SVGElement+Kind.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 7/4/20.
//  Copyright © 2020 Stand Alone, Inc. All rights reserved.
//

import Foundation


public protocol SVGElementKind {
	var tagName: String { get }
	func isEqualTo(kind: SVGElementKind?) -> Bool
}

extension SVGElement {
	public struct UnknownKind: SVGElementKind {
		public let tagName: String
		
		public func isEqualTo(kind: SVGElementKind?) -> Bool {
			kind?.tagName == self.tagName
		}
	}
	
	public enum NativeKind: String, SVGElementKind { case unknown
		case svg, path, group = "g", ellipse, circle, rect, defs, use, tspan, style, polyline, a, line, polygon, image
		
		// not yet implemented
		case title, pattern, clipPath, metadata, text, stop, linearGradient, radialGradient, type, format, rdf = "RDF", work = "Work", desc, set, script, `switch`, marker, hkern, mask, symbol, view, mpath, cursor, textPath
		case filter, feFlood, feComposite, feOffset, feGaussianBlur, feMerge, feMergeNode, feBlend, feColorMatrix, feComponentTransfer, feFuncR, feFuncG, feFuncB, feFuncA, feImage, feDiffuseLighting, feDistantLight, feConvolveMatrix, feDisplacementMatrix, fePointLight, feSpotLight, feSpecularLighting, feMorphology, feTile, feTurbulence, feDisplacementMap
		case colorProfile = "color-profile"
		case animate, animateMotion, animateColor, animateTransform
		case font, fontFace = "font-face", fontFaceSrc = "font-face-src", fontFaceURI = "font-face-uri"
		case unorderedList = "ul", orderedList = "ol", listItem = "li", strong, tref, span, p, em, code
		case glyph, glyphRef, missingGlyph = "missing-glyph", altGlyph, altGlyphDef, altGlyphItem, foreignObject

		public var tagName: String { return self.rawValue }
		public 	func isEqualTo(kind: SVGElementKind?) -> Bool {
			if let other = kind as? NativeKind { return self == other }
			return false
		}
		func element(in parent: Container?, attributes: [String: String], svg: SVGImage) -> SVGElement? {
			switch self {
			case .svg: return SVGElement.Root(kind: self, svg: svg, attributes: attributes)
			case .defs: return SVGElement.Defs(kind: self, parent: parent, attributes: attributes)
			case .use: return SVGElement.Use(kind: self, parent: parent, attributes: attributes)
			case .path: return SVGElement.Path(kind: self, parent: parent, attributes: attributes)
			case .image: return SVGElement.Image(kind: self, parent: parent, attributes: attributes)
			case .polyline: return SVGElement.Polyline(kind: self, parent: parent, attributes: attributes)
			case .polygon: return SVGElement.Polygon(kind: self, parent: parent, attributes: attributes)
			case .line: return SVGElement.Line(kind: self, parent: parent, attributes: attributes)
			case .group: return SVGElement.Group(kind: self, parent: parent, attributes: attributes)
			case .a: return SVGElement.Group(kind: Self.a, parent: parent, attributes: attributes)
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
