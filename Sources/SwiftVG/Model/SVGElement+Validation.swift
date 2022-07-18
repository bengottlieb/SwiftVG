//
//  SVGElement+Validation.swift
//  SwiftVG
//
//  Created by ben on 6/30/20.
//  Copyright © 2020 Stand Alone, Inc. All rights reserved.
//

import Foundation
import CoreGraphics

public extension SVGElement {
	enum SVGValidationError: Error { case zeroWidthViewBox, zeroHeightViewBox, zeroWidth, zeroHeight }
	func validateDimensions() throws {
		if let box = (self as? SetsViewport)?.viewBox {
			if box.width == 0 { throw SVGValidationError.zeroWidthViewBox}
			if box.height == 0 { throw SVGValidationError.zeroHeightViewBox}
		}
		
		if self.dimWidth.dimension == 0 { throw SVGValidationError.zeroWidth }
		if self.dimHeight.dimension == 0 { throw SVGValidationError.zeroHeight }
	}
}
