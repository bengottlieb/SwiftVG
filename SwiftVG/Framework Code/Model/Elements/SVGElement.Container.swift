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
		var defs: Defs?

		func append(child: SVGElement) { self.children.append(child) }
		override func draw(in ctx: CGContext) { self.drawChildren(in: ctx) }
		func drawChildren(in ctx: CGContext) {
			for child in self.children {
				child.draw(in: ctx)
			}
		}
		
		func child(with id: String) -> SVGElement? {
			for child in self.children {
				if child.id == id { return child }
			}
			return nil
		}
		
		func definition(for id: String) -> SVGElement? {
			var search = id
			if search.hasPrefix("#") { search = search[1...] }

			if let result = self.defs?.child(with: search) { return result }
			return self.parent?.definition(for: search)
		}
	}
}

