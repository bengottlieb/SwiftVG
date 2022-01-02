//
//  SVGURLView.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 1/2/22.
//  Copyright © 2022 Stand Alone, Inc. All rights reserved.
//

import Suite

public struct SVGURLView: View {
	let url: URL
	@State var image: SVGImage?
	
	public init(url: URL) {
		self.url = url
	}
	
	public var body: some View {
		ZStack() {
			if let image = image {
				SVGView(svg: image)
			}
		}
		.task {
			do {
				let data = try await DataCache.instance.fetch(for: url)
				image = SVGImage(data: data)
			} catch {
				print("Error downloading image: \(error)")
			}
		}
	}
}
