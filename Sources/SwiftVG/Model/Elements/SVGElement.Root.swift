//
//  Element.Root.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/21/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation
import CoreGraphics

extension SVGElement {
	public class Root: Container, SetsViewport {
		var viewBox: CGRect?
		var size: CGSize = .zero { didSet {
			self.viewBox = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
			self.attributes["viewBox"] = "0 0 \(self.size.width) \(self.size.height)"
		}}
		var dimensionsSetup = false
		
		
		var sizeDescription: String {
			if let box = self.viewBox { return "\(box.width)x\(box.height)" }
			return "\(self.size.width)x\(self.size.height)"
		}
		
		public override func parentDimension(for dim: SVGElement.Dimension) -> CGFloat? {
			return 0
		}

		
		init(parent: Container? = nil, attributes: [String: String]) {
			super.init(kind: NativeKind.svg, parent: parent)
			self.attributes = attributes
			self.setupDimensions()
		}
		
		static func generateDefaultAttributes(for size: CGSize) -> [String: String] {
			let attr: [String: String] = [
				"version": "1.1",
				"id": "svg",
				"xmlns:rdf": "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
				"xmlns:svg": "http://www.w3.org/2000/svg",
				"xmlns:cc": "http://creativecommons.org/ns#",
				"xmlns:dc": "http://purl.org/dc/elements/1.1/",
				"xmlns": "http://www.w3.org/2000/svg",
				"xmlns:xlink": "http://www.w3.org/1999/xlink",
				"viewBox": "0 0 \(size.width) \(size.height)",
				"xml:space": "preserve",
			]
			return attr
		}
		
		func setupDimensions() {
			if self.dimensionsSetup { return }
			self.dimensionsSetup = true
			self.viewBox = self.attributes["viewBox"]?.viewBox(in: self)
			self.size.width = self.attributes["width"]?.dimension(in: self, for: .width) ?? 0
			self.size.height = self.attributes["height"]?.dimension(in: self, for: .height) ?? 0
			if self.viewBox == nil { self.viewBox = CGRect(origin: .zero, size: self.size) }
		}
		
		func clearDimensions() {
			
		}
		
		public override func draw(with ctx: CGContext, in frame: CGRect) {
			if self.parent == nil, !self.dimensionsSetup {
				self.setupDimensions()
				if self.size == .zero { self.size = frame.size }
				if self.viewBox == .zero { self.viewBox = CGRect(origin: .zero, size: self.size) }
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
