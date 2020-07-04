//
//  SVGElement.Use.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/23/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation
import CoreGraphics

extension SVGElement {
	class Use: SVGElement {
		var ref: String?
		
		required init(kind: SVGElementKind, parent: Container?, attributes: [String: String]) {
			super.init(kind: kind, parent: parent, attributes: attributes)
			self.ref = attributes["xlink:href"]
		}
		
		override var resolved: SVGElement {
			if let ref = self.ref, let element = self.parent?.definition(for: ref) {
				element.attributes.addItems(from: self.attributes)
				return element
			}
			return self
		}
		
		override func draw(with ctx: CGContext, in frame: CGRect) {
			if let ref = self.ref, let element = self.parent?.definition(for: ref) {
				element.draw(with: ctx, in: frame)
			}
		}
	}
}

