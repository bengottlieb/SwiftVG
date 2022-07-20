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
	var recentered = true
	
	public static var elementBorderColor: Color?
	
	public init(svg: SVGImage, scale: Double = 1) {
		_svg = State(initialValue: svg)
		self.scale = scale
		url = nil
	}
	
	public init(url: URL, scale: Double = 1) {
		self.scale = scale
		self.url = url
	}
	
	var viewBoxTransform: CGAffineTransform {
		guard recentered, let box = svg?.viewBox else { return .identity }
		
		if box.origin.x != 0 || box.origin.y != 0 {
			return CGAffineTransform(translationX: -box.origin.x, y: -box.origin.y)
		}
		return .identity
	}
	
	public var body: some View {
		HStack() {
			if let image = svg, image.isDrawable {
				ZStack(alignment: .topLeading) {
					ForEach(image.document.root.resolvedChildren) { child in
						if child.isDisplayable { SVGElementView(element: child) }
					}
				}
				.preference(key: SVGNativeSizePreferenceKey.self, value: image.size)
				.environmentObject(SVGUserInterface.instance)
				.frame(width: image.size == nil ? nil : image.size!.width * scale, height: image.size == nil ? nil : image.size!.height * scale)
				.transformEffect(viewBoxTransform)
				.iflet(SVGView.elementBorderColor) { v, c in v.border(c, width: 1) }
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

