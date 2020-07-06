//
//  SVGElement.Polyline.swift
//  SwiftVG
//
//  Created by ben on 7/6/20.
//  Copyright © 2020 Stand Alone, Inc. All rights reserved.
//

import Foundation
import CoreGraphics

extension SVGElement {
	class Polyline: SVGElement {
		override public var isDisplayable: Bool { return true }
		var indicateFirstPoint = false
		
		var path: CGPath? {
			guard let data = self.attributes["points"], let points = data.extractedPoints else { return nil }
			
			let path = CGMutablePath()
			path.addLines(between: points)
			path.closeSubpath()
			return path
		}
		
		override public var drawnRect: CGRect? {
			return path?.boundingBoxOfPath
		}
		
		override func draw(with ctx: CGContext, in frame: CGRect) {
			guard let path = self.path else { return }

			ctx.saveGState()
			defer { ctx.restoreGState() }

			if let transform = self.transform { ctx.concatenate(transform) }
			
			ctx.setLineWidth(strokeWidth)
			fillColor.setFill()
			ctx.addPath(path)
			ctx.fillPath()

			ctx.setLineWidth(strokeWidth)
			strokeColor.setStroke()
			ctx.addPath(path)
			ctx.strokePath()
		}
	}
}
