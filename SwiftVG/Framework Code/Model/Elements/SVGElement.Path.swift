//
//  Element.Path.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/21/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

extension SVGElement {
	class Path: SVGElement, CustomStringConvertible {
		var viewBox: CGRect?
		var size: CGSize = .zero
		
		override func draw(in ctx: CGContext) {
			guard let data = self.attributes?["d"] else { return }
			guard let path = try! data.generateBezierPath() else { return }
			
			NSColor.red.setStroke()
			ctx.addPath(path)
			ctx.strokePath()
		}
		
		var description: String {
			return "Path"
		}
		
		init(parent: SVGElement?, attributes: [String: String]) {
			super.init(kind: .path, parent: parent)
			self.attributes = attributes
		}
	}
}
