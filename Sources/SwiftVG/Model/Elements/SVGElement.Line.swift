//
//  SVGElement.Line.swift
//  SwiftVG
//
//  Created by ben on 7/8/20.
//  Copyright © 2020 Stand Alone, Inc. All rights reserved.
//


import Foundation
import CoreGraphics

extension SVGElement {
	class Line: SVGElement.Path {
		override var path: CGPath? {
			let x1 = self.attributes[float: "x1"] ?? 0
			let x2 = self.attributes[float: "x2"] ?? 0

			guard
				let y1 = self.attributes[float: "y1"],
				let y2 = self.attributes[float: "y2"]
			else { return nil }
			
			let path = CGMutablePath()
			path.addLines(between: [CGPoint(x: x1, y: y1), CGPoint(x: x2, y: y2)])
			path.closeSubpath()
			return path
		}
	}
}
