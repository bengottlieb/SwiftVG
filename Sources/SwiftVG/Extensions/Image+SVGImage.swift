//
//  SVGView.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 6/28/20.
//  Copyright © 2020 Stand Alone, inc. All rights reserved.
//

import SwiftUI

public extension Image {
	init(svg: SVGImage) {
		#if os(macOS)
			if let image = svg.image {
				self.init(nsImage: image)
			} else {
				self.init("missing_image")
			}
		#else
			if let image = svg.image {
				self.init(uiImage: image)
			} else {
				self.init(systemName: "bandage")
			}
		#endif
	}
}
