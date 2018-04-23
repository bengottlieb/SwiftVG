//
//  SVGElement.Use.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/23/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

extension SVGElement {
	class Use: SVGElement {
		var ref: String?
		
		init(parent: Container?, attributes: [String: String]) {
			super.init(kind: .use, parent: parent)
			self.load(attributes: attributes)
			self.ref = attributes["xlink:href"]
		}
		
		override func draw(in ctx: CGContext) {
			if let ref = self.ref, let element = self.parent?.definition(for: ref) {
				element.draw(in: ctx)
			}
		}
	}
}

