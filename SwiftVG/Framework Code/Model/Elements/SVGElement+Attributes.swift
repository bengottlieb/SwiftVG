//
//  SVGElement+Attributes.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/22/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

extension SVGElement {
	var fillColor: SVGColor? {
		if let color = self.styles?[.fill]?.color { return color }
		
		if let attr = self.attributes?["fill"] { return SVGColor(attr) }
		return nil
	}

	var strokeColor: SVGColor? {
		if let color = self.styles?[.stroke]?.color { return color }
		
		if let attr = self.attributes?["stroke"] { return SVGColor(attr) }
		return nil
	}
	
	var strokeWidth: CGFloat? {
		if let width = self.styles?[.strokeWidth]?.float { return width }
		if let attr = self.attributes?["stroke-width"] { return CGFloat(Double(attr) ?? 0) }
		return nil
	}
	
	var cgFont: CGFont? {
		guard let family = self.styles?[.fontFamily]?.string else { return nil }
		
		return CGFont(family as CFString)
	}
	
	var font: SVGFont? {
		guard let size = self.fontSize else { return nil }
		guard let family = self.styles?[.fontFamily]?.string else {
			return SVGFont.systemFont(ofSize: size)
		}

		return SVGFont(name: family, size: size) ?? SVGFont.systemFont(ofSize: size)
	}
	
	var fontSize: CGFloat? {
		guard let size = self.styles?[.fontSize]?.float else { return nil }
		return size
	}
}
