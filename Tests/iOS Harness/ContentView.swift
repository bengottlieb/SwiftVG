//
//  ContentView.swift
//  SwiftVG
//
//  Created by ben on 6/29/20.
//  Copyright © 2020 Stand Alone, Inc. All rights reserved.
//

import SwiftUI
import SwiftVG
import Suite

struct ContentView: View {
	@ObservedObject var device = CurrentDevice.instance
	@State var selectedImage: SVGImage?
	
	let svg = SVGImage(bundleName: "poll_results_min", directory: "Sample Images")!
//	let svg = SVGImage(bundleName: "aspect_ratio xMidYMin meet", directory: "Sample Images")!

	var body: some View {
		HStack() {
			if device.isIPhone {
				VStack() {
					SVGView(svg: svg)
						.padding()

//					Image(svg: svg)
//						.padding()
				}
				//ImageListView() { image in  }
			} else {
				HStack(spacing: 0) {
					ImageListView() { image in self.selectedImage = image }
						.frame(width: 150)
					Divider()
					Spacer()
					if selectedImage != nil {
						SVGTree(svg: selectedImage!)
							.frame(width: 200)
						SVGContainer(svg: selectedImage!)
					}
					Spacer()
				}
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView() 
	}
}

