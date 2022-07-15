//
//  ImageListView.swift
//  SwiftVG_iOS_Harness
//
//  Created by Ben Gottlieb on 6/29/20.
//  Copyright © 2020 Stand Alone, Inc. All rights reserved.
//

import SwiftUI
import SwiftVG

struct ImageListView: View {
	let selectedAction: (SVGImage?) -> Void
	
	var body: some View {
		ScrollView() {
			VStack(spacing: 5) {
				ForEach(Bundle.main.directory(named: "Sample Images")!.urls) { url in
					Button() {
						self.selectedAction(SVGImage(url: url))
					} label: {
						SVGRow(url: url)
					}
					.buttonStyle(PlainButtonStyle())
				}
			}
		}
	}
}

struct SVGRow: View {
	let url: URL
	let image: SVGImage
	
	init(url: URL) {
		image = SVGImage(url: url) ?? .empty
		self.url = url
	}
	
	
	var body: some View {
		VStack(spacing: 2) {
			Image(svg: image)
				.resizable()
				.aspectRatio(contentMode: .fit)
				.border(Color(white: 0.8), width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
			
			Text(url.deletingPathExtension().lastPathComponent)
			Text(image.size?.dimString ?? "undefined size").font(.caption)
		}
		.padding(.horizontal, 5)
	}
}

struct ImageListView_Previews: PreviewProvider {
	static var previews: some View {
		ImageListView() { image in print(image!) }
	}
}
