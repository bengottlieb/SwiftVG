//
//  SVGContainer.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 6/29/20.
//  Copyright © 2020 Stand Alone, Inc. All rights reserved.
//

import SwiftUI
import SwiftVG

struct SVGContainer: View {
	let svg: SVGImage
	@State var scale = 1.0
	var maxScale = 2.0
	@State var previousScale = 1.0
	
	func printDescription() {
		let text = self.svg.buildXMLString(prettily: true)
		print(text)
	}
	
	var body: some View {
		ZStack {
			ScrollView([.horizontal, .vertical]) {
				SVGView(svg: svg, scale: scale)
					.highPriorityGesture(MagnificationGesture().onChanged { val in
						print(val)
						let delta = val / self.previousScale
						self.previousScale = val
						var newScale = self.scale * delta
						if newScale < 1.0 {
							newScale = 1.0
						}
						scale = newScale
					}.onEnded{val in
						previousScale = 1
					}
					)
			}
			VStack {
				Spacer()
				HStack() {
					Spacer()
					Button(action: printDescription) {
						Image(systemName: "info.circle")
							.font(.title)
					}
					.padding()
				}
			}
		}
		
	}
}

struct SVGContainer_Previews: PreviewProvider {
	static var previews: some View {
		SVGContainer(svg: SVGImage(bundleName: "PreserveAspectRatio", directory: "Sample Images")!)
	}
}
