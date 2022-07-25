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

struct BuiltInImagesView: View {
	@ObservedObject var device = CurrentDevice.instance
	@State var selectedImage: SVGImage?
	var fixedImage: String? = "bench.svg"
	
	@State var index = Settings.instance.imageIndex
	@State var showingSVGView = !Settings.instance.showingImages
	@State var id = UUID().uuidString
	
	var outlineColor: Binding<Color?> {
		Binding(
			get: { SVGView.elementBorderColor },
			set: {
				SVGView.elementBorderColor = $0;
				id = UUID().uuidString
				Settings.instance.showingOutlines = $0 != nil
			})
	}

	var showOutlines: Binding<Bool> {
		Binding(
			get: { outlineColor.wrappedValue != nil },
			set: {
				outlineColor.wrappedValue = $0 ? .red : nil
				id = UUID().uuidString
				Settings.instance.showingOutlines = $0
		})
	}
	let urls = Bundle.main.directory(named: "Sample Images")!.urls
	
//	let svg = SVGImage(bundleName: "poll_results_min", directory: "Sample Images")!
//	let svg = SVGImage(bundleName: "aspect_ratio xMidYMin meet", directory: "Sample Images")!

	var body: some View {
		Group() {
			if let fixed = fixedImage, let url = Bundle.main.url(forResource: fixed, withExtension: "svg", subdirectory: "Sample Images"), let svg = SVGImage(url: url) {
				ScrollingSVGImageView(svg: svg)
			} else if device.isIPhone {
				iPhoneBody
			} else {
				macBody
			}
		}
		.id(id)
	}
	
	var macBody: some View {
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
	
	@ViewBuilder var iPhoneBody: some View {
		ZStack() {
			if let image = SVGImage(url: urls[index]) {
				SVGView(svg: image)
					.resizable()
					.padding(2)
					.border(Color.black, width: 2)
					.id(index)
			} else {
				Text("Could not display \(urls[index].lastPathComponent)")
			}
				
			VStack() {
				Spacer()
				buttons
					.padding(.horizontal)
			}
		}
	}
	
	var full_iPhoneBody: some View {
		ZStack() {
			VStack(alignment: .center) {
				if showingSVGView {
					if let image = SVGImage(url: urls[index]) {
						SVGView(svg: image)
							.resizable()
							.padding(2)
							.border(Color.black, width: 2)
					} else {
						Text("Could not display \(urls[index].lastPathComponent)")
					}
				}
//				Image(svg: SVGImage(url: urls[index])!)
//					.resizable()
//					.aspectRatio(contentMode: .fit)
//					.border(Color.black, width: 2)
			}
			
			VStack() {
				if self.showingSVGView {
					Toggle("", isOn: showOutlines)
						.labelsHidden()
				}
				Spacer()
				buttons
				.font(.headline)
				.padding()
			}
			//.layoutPriority(1)
		}
	}
	
	@ViewBuilder var buttons: some View {
		HStack() {
			Button(action: {
				if self.index > 0 { self.index -= 1 }
				Settings.instance.imageIndex = self.index
			}) { Image(.arrow_left) }
				.disabled(index == 0)
			
			Spacer()
			VStack() {
				Toggle("", isOn: $showingSVGView.onChange { show in Settings.instance.showingImages = !show })
					.labelsHidden()
				Text(urls[index].lastPathComponent)
			}
			Spacer()
			Button(action: {
				if self.index < (self.urls.count - 1) { self.index += 1 }
				Settings.instance.imageIndex = self.index
			}) { Image(.arrow_right) }
				.disabled(index == (urls.count - 1))
		}
	}
}

struct BuiltInImagesView_Previews: PreviewProvider {
	static var previews: some View {
		BuiltInImagesView() 
	}
}

