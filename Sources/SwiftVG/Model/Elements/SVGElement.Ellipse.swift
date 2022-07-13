//
//  SVGElement.Ellipse.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/22/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation
import CoreGraphics

extension SVGElement {
	class Ellipse: SVGElement {		
		override public var isDisplayable: Bool { return true }

		required init(kind: SVGElementKind, parent: Container?, attributes: [String: String]) {
			super.init(kind: kind, parent: parent, attributes: attributes)
			if self.size == nil { self.size = self.rect?.size }
		}
		
		override public var drawnRect: CGRect? { self.rect }
		
		var rect: CGRect? {
			guard let cx = attributeDim("cx"), let cy = attributeDim("cy") else { return nil }

			if let r = attributeDim("r") {
				return CGRect(x: cx - (r), y: cy - (r), width: r * 2, height: r * 2)
			} else if let rx = attributeDim("rx"), let ry = attributeDim("ry") {
				return CGRect(x: cx - rx, y: cy - ry, width: rx * 2, height: ry * 2)
			}
			return nil
		}
		
		var path: CGPath? {
			let path = CGMutablePath()
			if let rect = rect {
				path.addEllipse(in: rect)
			}
			path.closeSubpath()
			return path
		}
		
		override func draw(with ctx: CGContext, in frame: CGRect) {
			guard let rect = self.rect else { return }

			ctx.saveGState()
			defer { ctx.restoreGState() }
			
			if let transform = self.transform { ctx.concatenate(transform) }

			self.fillColor.setFill()
			ctx.fillEllipse(in: rect)
			
			ctx.setLineWidth(strokeWidth)
			self.strokeColor.setStroke()
			ctx.strokeEllipse(in: rect)
		}
	}
}
