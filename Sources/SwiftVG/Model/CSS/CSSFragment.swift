//
//  CSSFragment.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/22/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

extension SVGElement {
	var computedStyles: CSSFragment {
		let ancestry = Array(self.ancestry.reversed()) + [self]
		let styles = CSSFragment(fragment: nil)
		
		for element in ancestry {
			if let fromSheet = (element as? SVGElement.Container)?.defs?.styleSheet?.css?.styles(for: self) {
				styles.add(from: fromSheet)
			}
			styles.add(from: element.styles)
		}
		
		return styles
	}
	
	var ancestry: [SVGElement] {
		var ancestry: [SVGElement] = []
		var parent = self.parent
		
		while parent != nil {
			ancestry.append(parent!)
			parent = parent?.parent
		}
		return ancestry
	}
}

public class CSSFragment: CustomStringConvertible {
	public enum Property: String {
		case font, fontFamily = "font-family", fontSize = "font-size", fontSizeAdjust = "font-size-adjust", fontStretch = "font-stretch", fontStyle = "font-style", fontVariant = "font-variant", fontWeight = "font-weight", textAlign = "text-align", lineHeight = "line-height", textIndent = "text-indent", textTransform = "text-transform"
		case direction, letterSpacing = "letter-spacing", textDecoration = "text-decoration", unicodeBidi = "unicode-bidi", wordSpacing = "word-spacing"
		case clip, color, cursor, display, overflow, visibility
		case clipPath = "clip-path", clipRule = "clip-rule", mask, opacity, filter
		case stopColor = "stop-color", stopOpacity = "stop-opacity"
		
		case colorInterpolation = "color-interpolation", colorInterpolationFilters = "color-interpolation-filters", colorProfile = "color-profile", colorRendering = "color-rendering", fill, fillOpacity = "fill-opacity", fillRule = "fill-rule", imageRendering = "image-rendering", marker, markerEnd = "markerEnd", markerMid = "marker-mid", markerStart = "marker-start", shapeRendering = "shape-rendering", stroke, strokeDashArray = "stroke-dasharray", strokeDashOffset = "stroke-dashoffset", strokeLineCap = "stroke-linecap", strokeLineJoin = "stroke-linejoin", strokeMiterLimit = "stroke-miterlimit", strokeOpacity = "stroke-opacity", strokeWidth = "stroke-width", textRendering = "text-rendering"
		
		case alignmentBaseline = "alignment-baseline", baselineShift = "baseline-shift", dominantBaseline = "dominant-baseline", glyphOrientationHorizontal = "glyph-orientation-horizontal", glyphOrientationVertical = "glyph-orientation-vertical", kerning, textAnchor = "text-anchor", writingMode = "writing-mode"
	}
	
	public var description: String {
		var results = ""
		for (key, value) in rules {
			results += "\(key.rawValue): \(value);\n"
		}
		return results.trimmingCharacters(in: .whitespacesAndNewlines)
	}
	
	public var css: String
	public var rules: [Property: CSSValue] = [:]
	public subscript(_ property: Property) -> CSSValue? {
		return self.rules[property]
	}
	
	init(fragment: CSSFragment?) {
		self.css = fragment?.css ?? ""
		self.rules = fragment?.rules ?? [:]
	}
	
	func add(from styles: CSSFragment?) {
		guard let styles = styles else { return }
		
		self.css += css
		for (prop, val) in styles.rules {
			self.rules[prop] = val
		}
	}

	public init?(css: String?) {
		self.css = css ?? ""
		guard let css = css else { return nil }
		
		let components = css.components(separatedBy: ";")
		for component in components {
			let pieces = component.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: ":")
			guard pieces.count == 2 else { continue }
			
			guard let property = Property(rawValue: pieces[0].trimmingCharacters(in: .whitespaces)) else {
				if !pieces[0].hasPrefix("-") { print("Unknown CSS property: \(pieces[0])") }
				continue
			}
			guard let value = CSSValue(string: pieces[1], for: property) else { continue }
			
			self.rules[property] = value
		}
	}
	
	
}
