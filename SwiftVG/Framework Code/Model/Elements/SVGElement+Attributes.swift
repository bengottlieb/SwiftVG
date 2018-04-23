//
//  SVGElement+Attributes.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/22/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

extension SVGElement {
	func value(for key: String) -> String? {
		if let value = self.attributes?[key] { return value }
		if let parent = self.parent { return parent.value(for: key) }
		return nil
	}
	
	var fillColor: SVGColor? {
		if let color = self.styles?[.fill]?.color { return color }
		
		if let attr = self.value(for: "fill") { return SVGColor(attr) }
		return nil
	}

	var strokeColor: SVGColor? {
		if let color = self.styles?[.stroke]?.color { return color }
		
		if let attr = self.value(for: "stroke") { return SVGColor(attr) }
		return nil
	}
	
	var strokeWidth: CGFloat? {
		if let width = self.styles?[.strokeWidth]?.float { return width }
		if let attr = self.value(for: "stroke-width") { return CGFloat(Double(attr) ?? 0) }
		return nil
	}
	
	var cgFont: CGFont? {
		guard let family = self.styles?[.fontFamily]?.string ?? self.value(for: "font-family") else { return nil }
		
		return CGFont(family as CFString)
	}
	
	var font: SVGFont? {
		guard let size = self.fontSize else { return nil }
		guard let family = self.styles?[.fontFamily]?.string ?? self.value(for: "font-family") else {
			return SVGFont.systemFont(ofSize: size)
		}

		return SVGFont(name: family, size: size) ?? SVGFont.systemFont(ofSize: size)
	}
	
	var fontSize: CGFloat? {
		if let size = self.styles?[.fontSize]?.float { return size }
		if let size = self.value(for: "font-size"), let dbl = Double(size) { return CGFloat(dbl) }
		return nil
	}
}
