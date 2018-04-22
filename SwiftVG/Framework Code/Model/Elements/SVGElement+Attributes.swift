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
}
