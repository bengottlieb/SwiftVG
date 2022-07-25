//
//  CachedSVGView.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 7/24/22.
//  Copyright © 2022 Stand Alone, Inc. All rights reserved.
//

import SwiftUI
import CrossPlatformKit

#if canImport(Convey)
import Convey

@MainActor
public struct CachedSVGView: View {
	@State var image: UXImage?
	@State var error: Error?
	let url: URL
	let suggestedSize: CGSize?
	
	public init(url: URL, suggestedSize: CGSize? = nil, scale: Double = 1.0) {
		self.url = url
		self.suggestedSize = suggestedSize
		if let image = ImageCache.instance.fetchLocal(for: url, extension: "jpeg") {
			_image = State(initialValue: image)
		}
	}

	public var body: some View {
		ZStack() {
			if let image = image {
				Image(uxImage: image)
					.resizable()
			}
		}
		.onAppear {
			if image == nil, error == nil { Task { await fetchImage() } }
		}
	}
	
	func fetchImage() async {
		do {
			if let data = try await Convey.DataCache.instance.fetch(from: url) {
				let svg = SVGImage(data: data)
				if let image = svg?.image {
					self.image = image
					await Convey.ImageCache.instance.store(image: image, for: url)
				}
			}
		} catch {
			print("Error while fetching/building SVG: \(error)")
			self.error = error
		}
	}
}
#endif
