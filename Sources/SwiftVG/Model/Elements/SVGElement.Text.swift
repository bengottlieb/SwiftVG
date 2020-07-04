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
		override var briefDescription: String { "Text: " + self.content }
		override public var isDisplayable: Bool { return true }
		var attributedString: NSAttributedString!
		override var elementName: String { "text" }

		required init(kind: SVGElementKind, parent: Container?, attributes: [String: String]) {
			super.init(kind: kind, parent: parent, attributes: attributes)
		}
		
		override func didLoad() {
			self.attributedString = NSAttributedString(string: self.content, attributes: self.stringAttributes)
			self.size = self.attributedString.size()
			self.size?.height = self.fontSize * 0.7
		}
		
		var stringAttributes: [NSAttributedString.Key: Any] {
			let attr: [NSAttributedString.Key: Any] = [.foregroundColor: self.strokeColor, .backgroundColor: self.fillColor, .font: self.font ]
			
			return attr
		}

		var text: String {
			self.content
		}

		override var swiftUIOffset: CGSize {
			get {
				var trans = self.translation
				
				trans.height -= (self.size?.height ?? 0)
				return trans
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
				return nil// Tspan(in: self)
			}
			return nil
		}
	}
	
	class Tspan: SVGElement, ContentElement {
		convenience init(in parent: Text) {
			self.init(kind: NativeKind.tspan, parent: parent, attributes: [:])
		}
		
		override func append(content: String) {
			(self.parent as? Text)?.append(content: content)
		}
	}
}
