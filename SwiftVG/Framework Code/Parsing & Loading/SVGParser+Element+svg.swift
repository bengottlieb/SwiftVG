//
//  SVGParser+Element+svg.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/21/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

extension SVGParser {
	struct Element_svg: Element, CustomStringConvertible {
		let kind = ElementKind.svg
		var children: [Element] = []
		
		var viewBox: CGRect?
		var size: CGSize = .zero
		
		var description: String {
			return "SVG <\(self.sizeDescription)>"
		}
		
		var sizeDescription: String {
			if let box = self.viewBox { return "\(box.width)x\(box.height)" }
			return "\(self.size.width)x\(self.size.height)"
		}
		
		init(attributes: [String: String]) {
			self.viewBox = attributes["viewBox"]?.viewBox
			self.size.width = attributes["width"]?.dimension ?? 0
			self.size.height = attributes["height"]?.dimension ?? 0
		}
	}
}
