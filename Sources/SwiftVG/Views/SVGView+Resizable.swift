//
//  SVGView+Resizable.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 7/4/20.
//  Copyright © 2020 Stand Alone, Inc. All rights reserved.
//

import SwiftUI
import Suite

struct SVGNativeSizePreferenceKey: PreferenceKey {
	static var defaultValue: CGSize?
	
	static func reduce(value: inout CGSize?, nextValue: () -> CGSize?) {
		value = value ?? nextValue()
	}
}

public extension SVGView {
	func resizable(onlyDown: Bool = false) -> some View {
		ResizableSVGView(svgView: self, onlyDown: onlyDown)
	}
}

struct ResizableSVGView: View {
	@State var nativeSize: CGSize?
	@State var scale: Double?
	let svgView: SVGView
	let onlyDown: Bool
	
	var body: some View {
		if let scale = scale, let size = nativeSize {
			let full = size.scaled(by: scale)
			HStack() {
				svgView
					.scaleEffect(scale)
			}
			.frame(width: full.width, height: full.height)
		} else {
			GeometryReader() { proxy in
				svgView
					.onPreferenceChange(SVGNativeSizePreferenceKey.self) { size in
						nativeSize = size
						scale = calculateScale(from: proxy, using: size)
					}
			}
		}
	}
	
	func calculateScale(from proxy: GeometryProxy, using size: CGSize?) -> Double? {
		guard let size = size else { return nil }
		let availableAspect = proxy.size.aspectRatio
		let myAspect = size.aspectRatio
		let scale: CGFloat
		
		if size == .zero { return 1 }
		if availableAspect > myAspect {
			scale = proxy.size.height / size.height
		} else {
			scale = proxy.size.width / size.width
		}
		return onlyDown ? min(1, scale) : scale
	}
	
}
