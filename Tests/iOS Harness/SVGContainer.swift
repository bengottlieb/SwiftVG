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
	
	func printDescription() {
		let text = self.svg.buildXMLString(prettily: true)
		print(text)
	}
	
	var body: some View {
		ZStack {
			SVGView(svg: svg)
				.scaleEffect(0.25)
				.aspectRatio(contentMode: .fit)
			
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
