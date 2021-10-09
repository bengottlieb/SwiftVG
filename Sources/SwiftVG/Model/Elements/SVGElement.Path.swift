//
//  Element.Path.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/21/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Studio
import CoreGraphics

public extension SVGElement {
	class Path: SVGElement {
		override public var isDisplayable: Bool { return true }
		var indicateFirstPoint = false
		
		public var path: CGPath? {
			return try? self.attributes["d"]?.generateBezierPaths(from: self.origin)
		}
		
		public override var boundingSize: CGSize? {
			try? self.attributes["d"]?.generateBezierPaths(from: self.origin).boundingSize
		}
		
		override public var drawnRect: CGRect? {
			return path?.boundingBoxOfPath
		}
		
		public override func draw(with ctx: CGContext, in frame: CGRect) {
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
