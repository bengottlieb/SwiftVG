//
//  CoreGraphics+Extension.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 6/30/20.
//  Copyright © 2020 Stand Alone, Inc. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGRect {
	var viewBoxString: String { "\(self.origin.x) \(self.origin.y) \(self.width) \(self.height)"}

	init?(viewBoxString: String?) {
		guard var components = viewBoxString?.components(separatedBy: ",") else { return nil }
		if components.count != 4 { components = viewBoxString?.components(separatedBy: .whitespaces) ?? [] }
		let dims = components.compactMap { Double($0) }
		
		if dims.count != 4 { return nil }
		self.init(x: dims[0], y: dims[1], width: dims[2], height: dims[3])
	}
}
