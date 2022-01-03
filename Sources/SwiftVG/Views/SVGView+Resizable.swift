//
//  SVGView+Resizable.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 7/4/20.
//  Copyright © 2020 Stand Alone, Inc. All rights reserved.
//

import SwiftUI
import Suite

public extension SVGView {
	var size: CGSize { self.svg.size }
	
	func scale(from proxy: GeometryProxy) -> CGFloat {
		let size = self.svg.size
		let availableAspect = proxy.size.aspectRatio
		let myAspect = size.aspectRatio
		let scale: CGFloat
		
		if availableAspect > myAspect {
			scale = proxy.size.height / size.height
		} else {
			scale = proxy.size.width / size.width
		}
		return min(1, scale)
	}

	func resizable() -> some View {
		GeometryReader() { proxy in
			HStack() {
				self
					.scaleEffect(self.scale(from: proxy))
			}
			.frame(width: self.size.width * self.scale(from: proxy), height: self.size.height * self.scale(from: proxy))
		}
	}
}
