//
//  Element.Root.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/21/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

extension SVGElement {
	class Root: Container, SetsViewport {
		var viewBox: CGRect?
		var size: CGSize = .zero
		var dimensionsSetup = false
		
		
		var sizeDescription: String {
			if let box = self.viewBox { return "\(box.width)x\(box.height)" }
			return "\(self.size.width)x\(self.size.height)"
		}
		
		override func parentDimension(for dim: SVGElement.Dimension) -> CGFloat? {
			return 0
		}

		
		init(parent: Container? = nil, attributes: [String: String]) {
			super.init(kind: .svg, parent: parent)
			self.attributes = attributes
		}
		
		func setupDimensions() {
			if self.dimensionsSetup { return }
			self.dimensionsSetup = true
			guard let attributes = self.attributes else { return }
			self.viewBox = attributes["viewBox"]?.viewBox(in: self)
			self.size.width = attributes["width"]?.dimension(in: self, for: .width) ?? 0
			self.size.height = attributes["height"]?.dimension(in: self, for: .height) ?? 0
			if self.viewBox == nil { self.viewBox = CGRect(origin: .zero, size: self.size) }
		}
		
		func clearDimensions() {
			
		}
		
		override func draw(with ctx: CGContext, in frame: CGRect) {
			if self.parent == nil, !self.dimensionsSetup {
				self.dimensionsSetup = true
				self.size = frame.size
				self.viewBox = CGRect(origin: .zero, size: self.size)
			}
			self.setupDimensions()
			guard let box = self.viewBox else { return }
			ctx.saveGState()
			self.applyTransform(to: ctx, in: box)
			self.drawChildren(with: ctx, in: box)
			ctx.restoreGState()

		}
	}
}
