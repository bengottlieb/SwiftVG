//
//  SVGElement.Text.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/22/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation
import CoreGraphics

extension SVGElement {
	class Text: Container, ContentElement {		
		init(parent: Container?, attributes: [String: String]) {
			super.init(kind: NativeKind.text, parent: parent)
			self.load(attributes: attributes)
		}

		override func draw(with ctx: CGContext, in frame: CGRect) {
			guard !self.content.isEmpty, let font = self.font else { return }
			ctx.saveGState()
			defer { ctx.restoreGState() }
			
			if let transform = self.attributes["transform"]?.embeddedTransform { ctx.concatenate(transform) }
			
			var attr: [NSAttributedString.Key: Any] = [.font: font]
			if let color = self.fillColor { attr[.foregroundColor] = color }
			
			let string = NSAttributedString(string: self.content.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "\n", with: ""), attributes: attr)
			let x = self.attributes[float: "x"] ?? 0
			let y = self.attributes[float: "y"] ?? 0

			if x != 0 || y != 0 { ctx.concatenate(CGAffineTransform(translationX: x, y: y))}
			
			string.draw(at: CGPoint(x: 0, y: -string.size().height))
			super.draw(with: ctx, in: frame)
		}
		
		override func createElement(ofKind kind: SVGElementKind, with attributes: [String: String]) -> SVGElement? {
			if kind.isEqualTo(kind: NativeKind.tspan) {
				return Tspan(in: self)
			}
			return nil
		}

	}
	
	class Tspan: SVGElement, ContentElement {
		init(in parent: Text) {
			super.init(kind: NativeKind.tspan, parent: parent)
		}
		
		override func append(content: String) {
			(self.parent as? Text)?.append(content: content)
		}
	}
}
