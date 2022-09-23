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
	let contentMode: ContentMode?
	
	public init(url: URL, suggestedSize: CGSize? = nil, contentMode: ContentMode?, scale: Double = 1.0, ignoreCache: Bool = false) {
		self.url = url
		self.contentMode = contentMode
		self.suggestedSize = suggestedSize
		if !ignoreCache, let cached = ImageCache.instance.fetchLocal(for: url, extension: "jpeg") {
			_image = State(initialValue: cached)
		}
	}

	public var body: some View {
		ZStack() {
			if let image = image {
				Image(uxImage: image)
					.resizable()
					//.aspectRatio(contentMode: contentMode)
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

public extension CachedSVGView {
	func resizable(onlyDown: Bool = false) -> some View {
		ResizableSVGView(contentView: self, onlyDown: onlyDown)
	}
}
#endif
