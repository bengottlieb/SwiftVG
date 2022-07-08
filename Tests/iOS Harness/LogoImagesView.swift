//
//  LogoImagesView.swift
//  SwiftVG_iOS_Harness
//
//  Created by Ben Gottlieb on 7/6/22.
//  Copyright © 2022 Stand Alone, Inc. All rights reserved.
//

import SwiftUI
import SwiftVG
import Suite

struct LogoImagesView: View {
	@State var index = 0
	@State var oneAtAtTime = true
	
	var urls: [URL] {
		let root = Bundle.main.url(forResource: "Sample Images", withExtension: nil)!.appendingPathComponent("Logos").appendingPathComponent("Bad")
		let files = try! FileManager.default.contentsOfDirectory(at: root, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
		return files.sorted { $0.lastPathComponent < $1.lastPathComponent }
	}
	var body: some View {
		let urls = urls
		
		ZStack() {
			Color.black.edgesIgnoringSafeArea(.all)
			
			if oneAtAtTime {
				let url = urls[index % urls.count]
				VStack() {
					Text("#\(index) \(url.lastPathComponent)")
						.padding()
					Spacer()
					SVGView(url: url)
						.border(Color.red)
						.backgroundColor(.gray)
						.id(url)
					//	.sizeDisplaying()
				
					Spacer()
					HStack() {
						Button("<-") { index = max(index - 1, 0) }
							.padding()

						Button("->") { index += 1 }
							.padding()
					}
				}
				.foregroundColor(.white)
			} else {
				ScrollView() {
					VStack() {
						ForEach(urls.indices, id: \.self) { idx in
							SVGView(url: urls[idx])
						}
					}
				}
			}
		}
	}
}

struct LogoImagesView_Previews: PreviewProvider {
	static var previews: some View {
		LogoImagesView()
	}
}
