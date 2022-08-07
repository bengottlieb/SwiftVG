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

@MainActor
struct LogoImagesView: View {
	@State var index = 0
	@State var oneAtAtTime = false
	
	var urls: [URL] {
		let root = Bundle.main.url(forResource: "Sample Images", withExtension: nil)!.appendingPathComponent("Logos").appendingPathComponent("Bad")
		let files = try! FileManager.default.contentsOfDirectory(at: root, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
		return files.sorted { $0.lastPathComponent < $1.lastPathComponent }
	}
	var body: some View {
		let urls = urls
		NavigationView() {
			ZStack() {
			//	Color.black.edgesIgnoringSafeArea(.all)
				
				if oneAtAtTime {
					let url = urls[index % urls.count]
					VStack() {
						Text("#\(index) \(url.lastPathComponent)")
							.padding()
						Spacer()
						SVGView(url: url)
							.backgroundColor(.white)
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
						LazyVGrid(columns: [.init(.adaptive(minimum: 100))]) {
							ForEach(urls.indices, id: \.self) { idx in
								NavigationLink(destination: detailView(url: urls[idx])) {
									CachedSVGView(url: urls[idx], ignoreCache: true)
										.resizable()
										.frame(width: 100, height: 100)
										.clipped()
										.border(Color.yellow.opacity(0.9))
								}
							}
						}
					}
					.navigationBarHidden(true)
				}
			}
		}
	}
	
	func detailView(url: URL) -> some View {
		SVGView(url: url)
			.navigationTitle(url.lastPathComponent)
	}
}

struct LogoImagesView_Previews: PreviewProvider {
	static var previews: some View {
		LogoImagesView()
	}
}
