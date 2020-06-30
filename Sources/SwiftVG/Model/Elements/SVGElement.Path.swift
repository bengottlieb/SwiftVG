//
//  Element.Path.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/21/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation
import CoreGraphics

extension SVGElement {
	class Path: SVGElement, CustomStringConvertible {
		override var briefDescription: String { self.svgID ?? "path" }
		var indicateFirstPoint = false
		
		override func draw(with ctx: CGContext, in frame: CGRect) {			
			guard let data = self.attributes["d"] else { return }

			ctx.saveGState()
			defer { ctx.restoreGState() }

			if let transform = self.attributes["transform"]?.embeddedTransform { ctx.concatenate(transform) }
			
			let path = try! data.generateBezierPaths()
			
			
			//for path in paths {
			if let strokeWidth = self.strokeWidth { ctx.setLineWidth(strokeWidth) }
			if let fill = self.fillColor {
				fill.setFill()
				ctx.addPath(path)
				ctx.fillPath()
			}
			if let stroke = self.strokeColor {
				stroke.setStroke()
				ctx.addPath(path)
				ctx.strokePath()
			}
			
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
		
		init(parent: Container?, attributes: [String: String]) {
			super.init(kind: NativeKind.path, parent: parent)
			self.load(attributes: attributes)
		}
	}
}
