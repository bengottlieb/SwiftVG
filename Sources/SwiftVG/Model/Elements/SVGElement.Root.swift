//
//  Element.Root.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/21/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation
import CoreGraphics
import Suite

extension SVGElement {
	var dimensionsSetup: Bool { self.size != nil }
	var visibleBox: CGRect {
		//if let box = self.viewBox { return box }
		return CGRect(x: 0, y: 0, size: self.size ?? .zero)
	}
	
	var sizeDescription: String {
		guard let size = self.size else { return "" }
		return "\(size.width)x\(size.height)"
	}

	func clearDimensions() {
		
	}

	public class Root: Container, SetsViewport {
		var viewBox: CGRect?
		var styleSheet: SVGElement.Style?
		var css: CSSSheet? { self.styleSheet?.css }

		override var shouldClip: Bool { return true }
		
		public override func parentDimension(for dim: SVGDimension.Dimension) -> CGFloat? {
			return 0
		}
		
		public override var drawnRect: CGRect? {
			if let size = self.size { return CGRect(origin: self.translation.point, size: size) }
			return nil
		}
		
		override func setupDimensions() {
			super.setupDimensions()
			self.viewBox = CGRect(viewBoxString: self.attributes["viewBox"])
		}
		
		init(kind: SVGElementKind, svg: SVGImage, attributes: [String: String]) {
			super.init(kind: kind, parent: nil, attributes: attributes)
			self.svg = svg
			self.setupDimensions()
		}

		required init(kind: SVGElementKind, parent: Container?, attributes: [String: String]) {
			super.init(kind: kind, parent: parent, attributes: attributes)
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
				
		public override func draw(with ctx: CGContext, in frame: CGRect) {
			if self.parent == nil, !self.dimensionsSetup {
				self.setupDimensions()
				if self.size == .zero { self.size = frame.size }
			}
			self.setupDimensions()
			ctx.saveGState()
			if let box = self.size?.rect { ctx.clip(to: box) }
			
			self.applyTransform(to: ctx, in: self.size?.rect ?? frame)
			self.drawChildren(with: ctx, in: self.size?.rect ?? frame)
			ctx.restoreGState()

		}
	}
}
