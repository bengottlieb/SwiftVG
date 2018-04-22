//
//  Element.Path.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/21/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

extension SVGElement {
	class Path: SVGElement, CustomStringConvertible {
		var viewBox: CGRect?
		var size: CGSize = .zero
		var indicateFirstPoint = false
		
		override func draw(in ctx: CGContext) {			
			guard let data = self.attributes?["d"] else { return }
			guard let path = try! data.generateBezierPath() else { return }
			
			NSColor.random().setFill()
			NSColor.black.setStroke()
		//	ctx.addPath(path)
		//	ctx.fillPath()
			ctx.addPath(path)
			ctx.strokePath()
			
			if self.indicateFirstPoint, let first = data.firstPathPoint {
				ctx.beginPath()
				ctx.addArc(center: first, radius: 10, startAngle: 0, endAngle: .pi * 2, clockwise: true)
				ctx.closePath()
				ctx.fillPath()
			}
		}
		
		var description: String {
			return "Path"
		}
		
		init(parent: SVGElement?, attributes: [String: String]) {
			super.init(kind: .path, parent: parent)
			self.attributes = attributes
		}
	}
}
