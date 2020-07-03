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
		override var briefDescription: String { "ellipse" }
		
		init(kind: SVGElementKind, parent: Container?, attributes: [String: String]) {
			super.init(kind: kind, parent: parent)
			self.load(attributes: attributes)
		}
		
		override public var drawnRect: CGRect? { self.rect }
		
		override var swiftUIOffset: CGSize {
			get {
				let rect = self.rect
				let trans = self.translation
				
				return CGSize(width: trans.width + (rect?.origin.x ?? 0), height: trans.height + (rect?.origin.y ?? 0))
			}
		}
		
		var rect: CGRect? {
			guard let cx = self.attributes[float: "cx"], let cy = self.attributes[float: "cy"] else { return nil }

			if let r = self.attributes[float: "r"] {
				return CGRect(x: cx - r, y: cy - r, width: r * 2, height: r * 2)
			} else if let rx = self.attributes[float: "rx"], let ry = self.attributes[float: "ry"] {
				return CGRect(x: cx - rx, y: cy - ry, width: rx * 2, height: ry * 2)
			}
			return nil
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
