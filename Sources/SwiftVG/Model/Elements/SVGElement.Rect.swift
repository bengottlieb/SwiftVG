//
//  SVGElement.Rect.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/22/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation
import CoreGraphics

extension SVGElement {
	class Rect: SVGElement {		
		override public var isDisplayable: Bool { return true }
		required init(kind: SVGElementKind, parent: Container?, attributes: [String: String]) {
			super.init(kind: kind, parent: parent, attributes: attributes)
			if self.size == nil { self.size = self.rect?.size }
		}
		
		override public var drawnRect: CGRect? { self.rect }

		var rect: CGRect? {
			let x = self.attributes[float: "x"] ?? 0
			let y = self.attributes[float: "y"] ?? 0
			guard let width = self.dimWidth.dimension, let height = self.dimHeight.dimension else { return nil }
			return CGRect(x: x, y: y, width: width, height: height)
		}
		
		override func draw(with ctx: CGContext, in frame: CGRect) {
			guard let rect = self.rect else { return }
			ctx.saveGState()
			defer { ctx.restoreGState() }
			
			if let transform = self.transform { ctx.concatenate(transform) }
			
			
			self.fillColor.setFill()
			ctx.fill(rect)
			
			ctx.setLineWidth(strokeWidth)
			self.strokeColor.setStroke()
			ctx.stroke(rect)
		}
	}
}
