//
//  SVGElement.Text.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/22/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

extension SVGElement {
	class Text: SVGElement, ContentElement {
		var content = ""
		
		init(parent: SVGElement?, attributes: [String: String]) {
			super.init(kind: .text, parent: parent)
			self.load(attributes: attributes)
		}

		func append(content: String) {
			self.content += content
		}
		
		override func draw(in ctx: CGContext) {
			guard !self.content.isEmpty, let font = self.font else { return }
			ctx.saveGState()
			defer { ctx.restoreGState() }
			
			if let transform = self.attributes?["transform"]?.embeddedTransform { ctx.concatenate(transform) }
			
			var attr: [String: Any] = [NSFontAttributeName: font]
			if let color = self.fillColor { attr[NSForegroundColorAttributeName] = color }
			
			let string = NSAttributedString(string: self.content, attributes: attr)
			let x = self.attributes?[float: "x"] ?? 0
			let y = self.attributes?[float: "y"] ?? 0

			string.draw(at: CGPoint(x: x, y: y - string.size().height))
		}
	}
}
