//
//  SVGElement.Group.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/22/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation
import CoreGraphics

extension SVGElement {
	class Group: SVGElement.Container {
		override public var isDisplayable: Bool { return true }

		override public var drawnRect: CGRect? {
			if self.children.isEmpty { return nil }
			
			var rect: CGRect?
			
			for child in self.children {
				let childRect = child.drawnRect
				if let actual = rect, let actualChild = childRect {
					rect = actual.union(actualChild)
				} else {
					rect = childRect
				}
			}
			return rect
		}
				
		override func draw(with ctx: CGContext, in frame: CGRect) {
			ctx.saveGState()
			defer { ctx.restoreGState() }
			
			if let transform = self.transform { ctx.concatenate(transform) }
			super.draw(with: ctx, in: frame)
		}
	}
}
