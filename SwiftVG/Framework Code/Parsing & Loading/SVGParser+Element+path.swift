//
//  SVGParser+Element+path.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/21/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

extension SVGParser {
	struct Element_path: Element, AttributedElement, CustomStringConvertible {
		let kind = ElementKind.path
		var children: [Element] = []
		var attributes: [String : String] = [:]
		
		var viewBox: CGRect?
		var size: CGSize = .zero
		
		func draw(in ctx: CGContext) {
			guard let data = self.attributes["d"] else { return }
			guard let path = try! data.generateBezierPath() else { return }
			
			NSColor.red.setStroke()
			ctx.addPath(path)
			ctx.strokePath()
			
			self.drawChildren(in: ctx) 
		}
		
		var description: String {
			return "Path"
		}
		
		init(attributes: [String: String]) {
			self.attributes = attributes
		}
	}
}
