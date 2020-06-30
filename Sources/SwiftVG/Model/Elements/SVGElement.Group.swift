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
		override var briefDescription: String { self.svgID ?? "group" }
		init(parent: Container? = nil, attributes: [String: String]) {
			super.init(kind: NativeKind.group, parent: parent)
			self.load(attributes: attributes)
		}
		
		override func draw(with ctx: CGContext, in frame: CGRect) {
			ctx.saveGState()
			defer { ctx.restoreGState() }
			
			if let transform = self.attributes["transform"]?.embeddedTransform { ctx.concatenate(transform) }
			super.draw(with: ctx, in: frame)
		}
	}
}
