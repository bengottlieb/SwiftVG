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
		
		var sizeDescription: String {
			if let box = self.viewBox { return "\(box.width)x\(box.height)" }
			return "\(self.size.width)x\(self.size.height)"
		}
		
		init(parent: Container? = nil, attributes: [String: String]) {
			super.init(kind: .svg, parent: parent)
			self.attributes = attributes
			self.viewBox = attributes["viewBox"]?.viewBox
			self.size.width = attributes["width"]?.dimension ?? 0
			self.size.height = attributes["height"]?.dimension ?? 0
		}
	}
}
