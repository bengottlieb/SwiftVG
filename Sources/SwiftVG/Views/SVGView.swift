//
//  SVGView.swift
//  SwiftVG
//
//  Created by ben on 7/1/20.
//  Copyright © 2020 Stand Alone, Inc. All rights reserved.
//

import Suite
import SwiftUI

class SVGUserInterface: ObservableObject {
	static let instance = SVGUserInterface()
	
	@Published var selectedID: String?
}

@MainActor
public struct SVGView: View {
	@State internal var svg: SVGImage?
	@State private var isSetUp = false
	let url: URL?
	var scale: Double = 1
	
	public static var drawElementBorders = true
	
	public init(svg: SVGImage, scale: Double = 1) {
		_svg = State(initialValue: svg)
		self.scale = scale
		url = nil
	}
	
	public init(url: URL, scale: Double = 1) {
		self.scale = scale
		self.url = url
	}
	
	public var body: some View {
		HStack() {
			if let svg = svg, svg.isDrawable {
				ZStack(alignment: .topLeading) {
					ForEach(svg.document.root.resolvedChildren) { child in
						if child.isDisplayable { SVGElementView(element: child) }
					}
				}
				.preference(key: SVGNativeSizePreferenceKey.self, value: svg.size)
				.environmentObject(SVGUserInterface.instance)
				.frame(width: svg.size.width * scale, height: svg.size.height * scale)
				.if(SVGView.drawElementBorders) { $0.border(Color.gray, width: 1) }
			}
		}
		.task { await setup() }
    }
	
	func setup() async {
		if !isSetUp, svg == nil, let url = url {
			isSetUp = true
			do {
				let data = try await DataCache.instance.fetch(for: url)
				svg = SVGImage(data: data)
			} catch {
				print("Failed to load SVG from \(url): \(error)")
			}
		}
	}
}

struct SVGView_Previews: PreviewProvider {
	static var previews: some View {
		SVGView(svg: .sampleTransform)
			.border(Color.red)
	}
}

