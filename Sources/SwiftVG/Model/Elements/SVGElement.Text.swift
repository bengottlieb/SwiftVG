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
		override var briefDescription: String { self.content }
		
		init(parent: Container?, attributes: [String: String]) {
			super.init(kind: NativeKind.text, parent: parent)
			self.load(attributes: attributes)
		}

		var text: String {
			self.content
		}

		override var swiftUIOffset: CGSize {
			get {
				let trans = self.translation
				
				return CGSize(width: trans.width, height: trans.height - self.fontSize * 0.5)
			}
		}
		
		override func draw(with ctx: CGContext, in frame: CGRect) {
			guard !self.content.isEmpty else { return }
			ctx.saveGState()
			defer { ctx.restoreGState() }
			
			if let transform = self.transform { ctx.concatenate(transform) }
			
			var attr: [NSAttributedString.Key: Any] = [.font: self.font]
			attr[.foregroundColor] = self.fillColor
			
			let string = NSAttributedString(string: text.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "\n", with: ""), attributes: attr)
			
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
