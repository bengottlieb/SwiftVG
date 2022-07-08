//
//  SVGElement.Polygon.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 7/8/22.
//  Copyright © 2022 Stand Alone, Inc. All rights reserved.
//

import Foundation
import CoreGraphics

extension SVGElement {
	class Polygon: SVGElement.Path {
		override var path: CGPath? {
			guard let data = self.attributes["points"], let points = data.extractedPoints else { return nil }
			
			let path = CGMutablePath()
			path.addLines(between: points)
			path.closeSubpath()
			return path
		}
	}
}
