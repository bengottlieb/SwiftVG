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
		override var briefDescription: String { self.svgID ?? "rect" }
		init(parent: Container?, attributes: [String: String]) {
			super.init(kind: NativeKind.rect, parent: parent)
			self.load(attributes: attributes)
		}
		
		override public var drawnRect: CGRect? { self.rect }

		var rect: CGRect? {
			guard let x = self.attributes[float: "x"], let y = self.attributes[float: "y"], let width = self.dimWidth.dimension, let height = self.dimHeight.dimension else { return nil }
			return CGRect(x: x, y: y, width: width, height: height)
		}
		
		override func draw(with ctx: CGContext, in frame: CGRect) {
			guard let rect = self.rect else { return }
			ctx.saveGState()
			defer { ctx.restoreGState() }
			
			if let transform = self.transform { ctx.concatenate(transform) }
			
			
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
