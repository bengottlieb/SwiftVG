//
//  SVGElement.Rect.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/22/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

extension SVGElement {
	class Rect: SVGElement {		
		init(parent: Container?, attributes: [String: String]) {
			super.init(kind: .rect, parent: parent)
			self.load(attributes: attributes)
		}
		
		override func draw(in ctx: CGContext) {
			guard let x = self.attributes?[float: "x"], let y = self.attributes?[float: "y"], let width = self.attributes?[float: "width"], let height = self.attributes?[float: "height"] else { return }
			
			ctx.saveGState()
			defer { ctx.restoreGState() }
			
			if let transform = self.attributes?["transform"]?.embeddedTransform { ctx.concatenate(transform) }
			
			let rect = CGRect(x: x, y: y, width: width, height: height)
			
			if let fill = self.fillColor {
				fill.setFill()
				ctx.fill(rect)
			}
			
			if let stroke = self.strokeColor {
				if let strokeWidth = self.strokeWidth { ctx.setLineWidth(strokeWidth) }
				stroke.setStroke()
				ctx.stroke(rect)
			}
		}
	}
}
