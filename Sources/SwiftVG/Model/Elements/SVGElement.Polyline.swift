//
//  SVGElement.Polyline.swift
//  SwiftVG
//
//  Created by ben on 7/6/20.
//  Copyright © 2020 Stand Alone, Inc. All rights reserved.
//

import Foundation
import CoreGraphics

extension SVGElement {
	class Polyline: SVGElement.Path {
		override var path: CGPath? {
			guard let data = self.attributes["points"], let points = data.extractedPoints else { return nil }
			
			let path = CGMutablePath()
			path.addLines(between: points)
			path.closeSubpath()
			return path
		}
	}
}
