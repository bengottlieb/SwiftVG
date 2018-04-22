//
//  CSSFragment.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/22/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

class CSSFragment {
	enum Property: String {
		case font, fontFamily = "font-family", fontSize = "font-size", fontSizeAdjust = "font-size-adjust", fontStretch = "font-stretch", fontStyle = "font-style", fontVariant = "font-variant", fontWeight = "font-weight"
		case direction, letterSpacing = "letter-spacing", textDecoration = "text-decoration", unicodeBidi = "unicode-bidi", wordSpacing = "word-spacing"
		case clip, color, cursor, display, overflow, visibility
		case clipPath = "clip-path", clipRule = "clip-rule", mask, opacity
		case stopColor = "stop-color", stopOpacity = "stop-opacity"
		
		case colorInterpolation = "color-interpolation", colorInterpolationFilters = "color-interpolation-filters", colorProfile = "color-profile", colorRendering = "color-rendering", fill, fillOpacity = "fill-opacity", fillRule = "fill-rule", imageRendering = "image-rendering", marker, markerEnd = "markerEnd", markerMid = "marker-mid", markerStart = "marker-start", shapeRendering = "shape-rendering", stroke, strokeDashArray = "stroke-dasharray", strokeDashOffset = "stroke-dashoffset", strokeLineCap = "stroke-linecap", strokeLineJoin = "stroke-linejoin", strokeMiterLimit = "stroke-miterlimit", strokeOpacity = "stroke-opacity", strokeWidth = "stroke-width", textRendering = "text-rendering"
		
		case alignmentBaseline = "alignment-baseline", baselineShift = "baseline-shift", dominantBaseline = "dominant-baseline", glyphOrientationHorizontal = "glyph-orientation-horizontal", glyphOrientationVertical = "glyph-orientation-vertical", kerning, textAnchor = "text-anchor", writingMode = "writing-mode"
	}
	
	let css: String
	var rules: [Property: CSSValue] = [:]
	subscript(_ property: Property) -> CSSValue? {
		return self.rules[property]
	}
	
	init?(css: String?) {
		self.css = css ?? ""
		guard let css = css else { return nil }
		
		let components = css.components(separatedBy: ";")
		for component in components {
			let pieces = component.components(separatedBy: ":")
			guard pieces.count == 2 else { continue }
			
			guard let property = Property(rawValue: pieces[0]) else {
				print("Unknown CSS property: \(pieces[0])")
				continue
			}
			guard let value = CSSValue(string: pieces[1], for: property) else { continue }
			
			self.rules[property] = value
		}
	}
	
	
}
