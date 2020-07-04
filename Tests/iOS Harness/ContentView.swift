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
	
	@State var index = 0
	@State var showingImage = false
	@State var id = UUID().uuidString
	
	var showOutlines: Binding<Bool> {
		Binding<Bool>(get: { SVGView.drawElementBorders }, set: { SVGView.drawElementBorders = $0; id = UUID().uuidString })
	}
	let urls = Bundle.main.directory(named: "Sample Images")!.urls
	
	let svg = SVGImage(bundleName: "poll_results_min", directory: "Sample Images")!
//	let svg = SVGImage(bundleName: "aspect_ratio xMidYMin meet", directory: "Sample Images")!

	var body: some View {
		Group() {
			if device.isIPhone {
				ZStack() {
					HStack() {
						Group() {
							if showingImage {
								SVGView(svg: SVGImage(url: urls[index])!)
							} else {
								Image(svg: SVGImage(url: urls[index])!)
									.resizable()
									.aspectRatio(contentMode: .fit)
							}
						}
						.padding()
					}
					
					VStack() {
						Toggle("", isOn: showOutlines)
						.labelsHidden()
						Spacer()
						HStack() {
							Button(action: {
								if self.index > 0 { self.index -= 1 }
							}) { Image(.arrow_left) }
							.disabled(index == 0)

							Spacer()
							VStack() {
								Toggle("", isOn: $showingImage)
								.labelsHidden()
								Text(urls[index].lastPathComponent)
							}
							Spacer()
							Button(action: {
								if self.index < (self.urls.count - 1) { self.index += 1 }
							}) { Image(.arrow_right) }
							.disabled(index == (urls.count - 1))
						}
						.font(.headline)
						.padding()
					}
					.layoutPriority(1)
				}
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
		}.id(id)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView() 
	}
}

