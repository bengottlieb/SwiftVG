//
//  SVGElement+Attributes.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/22/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation
import CoreGraphics
import SwiftUI

public typealias SVGAttributes = [String: String]

extension SVGAttributes {
}

extension SVGElement: Identifiable {
	var dimWidth: SVGDimension { SVGDimension(self, attributeDim("width"), .width) }
	var dimHeight: SVGDimension { SVGDimension(self, attributeDim("height"), .height) }

	public func value(for key: String) -> String? {
		if let value = self.attributes[key] { return value }
		if let parent = self.parent { return parent.value(for: key) }
		return nil
	}
	
	public var fillColor: SVGColor {
		get {
			if let attr = self.value(for: "fill"), let color = SVGColor(attr) { return color }
			if let color = self.computedStyles[.fill]?.color { return color }
			return .black
		}
		set {
			self.attributes["fill"] = newValue.colorString
		}
	}

	public var strokeColor: SVGColor {
		get {
			if let attr = self.value(for: "stroke"), let color = SVGColor(attr) { return color }
			if let color = self.computedStyles[.stroke]?.color { return color }
			return .clear
		}
		set {
			self.attributes["stroke"] = newValue.colorString
		}
	}
	
	public var strokeWidth: CGFloat {
		get {
			if let width = self.computedStyles[.strokeWidth]?.float { return width * svg.scale }
			if let dim = attributeDim("stroke-width") { return dim }
			return svg.scale
		}
		set {
			self.attributes["stroke-width"] = "\(newValue / svg.scale)"
		}
	}
	
	var fontReplacements: [String: String] { [
		"sans-serif": "HelveticaNeue",
		"serif": "TimesNewRomanPSMT",
		"monospace": "Courier",
		"cursive": "ChalkboardSE-Regular",
		"fantasy": "Zapfino",
	] }
	
	var font: SVGFont {
		let size = self.fontSize
		let fam = self.value(for: "font-family") ?? self.computedStyles[.fontFamily]?.string
		let weight = self.value(for: "font-weight") ?? self.computedStyles[.fontWeight]?.string
		let style = self.value(for: "font-style") ?? self.computedStyles[.fontStyle]?.string

		guard let family = fam else { return SVGFont.systemFont(ofSize: size) }
		
		for name in family.components(separatedBy: ",") {
			if let font = SVGFont(name: name, size: size) { return font }
			
			if let fontName = fontReplacements[name], let font = SVGFont.font(named: fontName, size: size, weight: weight, style: style) { return font }
		}

		return SVGFont(name: family, size: size) ?? SVGFont.systemFont(ofSize: size)
	}
	
	var fontSize: CGFloat {
		get {
			if let size = self.computedStyles[.fontSize]?.float { return size }
			if let size = self.value(for: "font-size"), let dbl = Double(size) { return CGFloat(dbl) }
			return 16
		}
		set {
			self.attributes["font-size"] = "\(newValue)"
		}
	}
}
