//
//  SVGElement.Text.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/22/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

extension SVGElement {
	class Text: Container, ContentElement {
		var content = ""
		
		init(parent: Container?, attributes: [String: String]) {
			super.init(kind: .text, parent: parent)
			self.load(attributes: attributes)
		}

		func append(content: String) {
			if content.hasSuffix(" ") && !self.content.hasSuffix(" ") { self.content += " " }
			self.content += content.trimmingCharacters(in: .whitespacesAndNewlines)
			if content.hasSuffix(" ") { self.content += " " }
		}
		
		override func draw(with ctx: CGContext, in frame: CGRect) {
			guard !self.content.isEmpty, let font = self.font else { return }
			ctx.saveGState()
			defer { ctx.restoreGState() }
			
			if let transform = self.attributes?["transform"]?.embeddedTransform { ctx.concatenate(transform) }
			
			var attr: [String: Any] = [NSFontAttributeName: font]
			if let color = self.fillColor { attr[NSForegroundColorAttributeName] = color }
			
			let string = NSAttributedString(string: self.content.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "\n", with: ""), attributes: attr)
			let x = self.attributes?[float: "x"] ?? 0
			let y = self.attributes?[float: "y"] ?? 0

			if x != 0 || y != 0 { ctx.concatenate(CGAffineTransform(translationX: x, y: y))}
			
			string.draw(at: CGPoint(x: 0, y: -string.size().height))
			super.draw(with: ctx, in: frame)
		}
		
		override func createElement(ofKind kind: Kind, with attributes: [String: String]) -> SVGElement? {
			if kind == .tspan {
				return Tspan(in: self)
			}
			return nil
		}

	}
	
	class Tspan: SVGElement, ContentElement {
		init(in parent: Text) {
			super.init(kind: .tspan, parent: parent)
		}
		
		func append(content: String) {
			(self.parent as? Text)?.append(content: content)
		}
	}
}
