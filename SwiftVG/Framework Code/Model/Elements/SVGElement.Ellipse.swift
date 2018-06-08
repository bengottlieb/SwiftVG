//
//  SVGElement.Ellipse.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/22/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

extension SVGElement {
	class Ellipse: SVGElement {		
		init(kind: SVGElementKind, parent: Container?, attributes: [String: String]) {
			super.init(kind: kind, parent: parent)
			self.load(attributes: attributes)
		}

		override func draw(with ctx: CGContext, in frame: CGRect) {
			guard let cx = self.attributes[float: "cx"], let cy = self.attributes[float: "cy"] else { return }
			
			ctx.saveGState()
			defer { ctx.restoreGState() }
			
			if let transform = self.attributes["transform"]?.embeddedTransform { ctx.concatenate(transform) }

			let rect: CGRect

			if let r = self.attributes[float: "r"] {
				rect = CGRect(x: cx - r, y: cy - r, width: r * 2, height: r * 2)
			} else if let rx = self.attributes[float: "rx"], let ry = self.attributes[float: "ry"] {
				rect = CGRect(x: cx - rx, y: cy - ry, width: rx * 2, height: ry * 2)
			} else {
				return
			}
			
			if let fill = self.fillColor {
				fill.setFill()
				ctx.fillEllipse(in: rect)
			}
			
			if let stroke = self.strokeColor {
				stroke.setStroke()
				ctx.strokeEllipse(in: rect)
			}
		}
	}
}
