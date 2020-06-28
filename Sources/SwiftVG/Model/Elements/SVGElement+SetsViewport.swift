//
//  SVGElement+SetsViewport.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/23/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation
import CoreGraphics

protocol SetsViewport: class {
	var viewBox: CGRect? { get }
}

extension SetsViewport {
	func dimension(for dim: SVGElement.Dimension) -> CGFloat? {
		switch dim {
		case .width: return self.viewBox?.width
		case .height: return self.viewBox?.height
		}
	}
}

