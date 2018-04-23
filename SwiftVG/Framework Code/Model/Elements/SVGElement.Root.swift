//
//  Element.Root.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/21/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

extension SVGElement {
	class Root: Container, CustomStringConvertible {
		var viewBox: CGRect?
		var size: CGSize = .zero
		
		var description: String {
			return "SVG <\(self.sizeDescription)>"
		}
		
		var sizeDescription: String {
			if let box = self.viewBox { return "\(box.width)x\(box.height)" }
			return "\(self.size.width)x\(self.size.height)"
		}
		
		init(parent: SVGElement? = nil, attributes: [String: String]) {
			super.init(kind: .svg, parent: parent)
			self.viewBox = attributes["viewBox"]?.viewBox
			self.size.width = attributes["width"]?.dimension ?? 0
			self.size.height = attributes["height"]?.dimension ?? 0
		}
		
		public enum ScaleMode { case scaleToFill, scaleAspectFit, scaleAspectFill, none, center, top, bottom, left, right, topLeft, topRight, bottomLeft, bottomRight
			
			init(rawValue: String?) {
				guard let raw = rawValue else { self = .scaleAspectFit; return }
				let components = raw.components(separatedBy: " ")
				if components.count == 0 || components.first == "none" { self = .none; return }
				
				if components.count > 1 {
					if components.last == "meet" { self = .scaleAspectFit; return }
					if components.last == "slice" { self = .scaleAspectFill; return }
				}
				
				self = .scaleAspectFit
			}
		}

		func applyTransform(to ctx: CGContext, in rect: CGRect) {
			guard let box = self.viewBox else { return }
			let mode = ScaleMode(rawValue: self.attributes?["preserveAspectRatio"])
			let myAspect = box.width / box.height
			let targetApsect = rect.width / rect.height
			switch mode {
			case .scaleAspectFit:
				if (myAspect > 1) == (targetApsect > 1) {
					
				}
			default: break
			}
			
			
		}
	}
}
