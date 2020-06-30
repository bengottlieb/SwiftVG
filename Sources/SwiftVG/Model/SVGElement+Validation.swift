//
//  SVGElement+Validation.swift
//  SwiftVG
//
//  Created by ben on 6/30/20.
//  Copyright © 2020 Stand Alone, Inc. All rights reserved.
//

import Foundation

public extension SVGElement {
	enum SVGValidationError: Error { case viewBoxMismatchWidth, viewBoxMismatchHeight, viewBoxNaN }
	func validateDimensions() throws {
		if let viewPort = self as? SetsViewport {
			if self.dimWidth.dimension != viewPort.viewBox?.width { throw SVGValidationError.viewBoxMismatchWidth }
			if self.dimHeight.dimension != viewPort.viewBox?.height { throw SVGValidationError.viewBoxMismatchHeight }
			
			if let box = viewPort.viewBox {
				if box.origin.x.isNaN { throw SVGValidationError.viewBoxNaN }
				if box.origin.y.isNaN { throw SVGValidationError.viewBoxNaN }
				if box.size.width.isNaN { throw SVGValidationError.viewBoxNaN }
				if box.size.height.isNaN { throw SVGValidationError.viewBoxNaN }
			}
		}
	}
}
