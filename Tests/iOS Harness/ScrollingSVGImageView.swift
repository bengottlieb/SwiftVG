//
//  ScrollingSVGImageView.swift
//  SwiftVG_iOS_Harness
//
//  Created by Ben Gottlieb on 10/6/21.
//  Copyright © 2021 Stand Alone, Inc. All rights reserved.
//

import SwiftUI
import SwiftVG

struct ScrollingSVGImageView: View {
	let svg: SVGImage
	//calculated:
	@State var scale: CGFloat = 1.0
	@State var lastScaleValue: CGFloat = 1.0
	@State var originalScale: CGFloat = 1.0
	
	var body: some View {
		ZStack {
			GeometryReader(content: { geometry in
				Color.clear.frame(width: 1, height: 1).onAppear(perform: {
					print("calculating geo for image")
					if let size = svg.size, size.width >= size.height {
						if size.width > geometry.size.width {
							originalScale = 1 - ((size.width - geometry.size.width) / size.width)
							scale = originalScale
						} else {
							originalScale = 1
							scale = 1
						}
					} else {
						if let size = svg.size, size.height > geometry.size.height {
							originalScale = 1 - ((size.height - geometry.size.height) / size.height)
							scale = originalScale
						} else {
							originalScale = 1
							scale = 1
						}
					}
					print("original scale: \(originalScale)")
				})
			})
			
			ScrollView([.vertical, .horizontal], showsIndicators: false) {
				ZStack {
					
					SVGView(svg: svg)
					.aspectRatio(contentMode: .fit).scaleEffect(scale)
						.gesture(MagnificationGesture().onChanged { val in
							let delta = val / self.lastScaleValue
							self.lastScaleValue = val
							var newScale = self.scale * delta
							if newScale < originalScale
							{
								newScale = originalScale
							}
							scale = newScale
						}.onEnded{val in
							lastScaleValue = 1
						})
					
				}
				.frame(width: svg.size == nil ? nil : svg.size!.width * scale, height: svg.size == nil ? nil : svg.size!.height * scale, alignment: .center)
			}.background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
		}.edgesIgnoringSafeArea(.all)
	}
}
