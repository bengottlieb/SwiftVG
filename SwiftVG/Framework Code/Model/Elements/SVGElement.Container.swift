//
//  SVGElement.Container.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/22/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

extension SVGElement {
	class Container: SVGElement {
		var children: [SVGElement] = []
		func append(child: SVGElement) { self.children.append(child) }
		override func draw(in ctx: CGContext) { self.drawChildren(in: ctx) }
		func drawChildren(in ctx: CGContext) {
			for child in self.children {
				child.draw(in: ctx)
			}
		}
	}
}

