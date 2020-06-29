//
//  SVGView.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 6/28/20.
//  Copyright © 2020 Stand Alone, inc. All rights reserved.
//

import SwiftUI

public struct SVGView: View {
	public let svg: SVGImage

	public init(bundleName: String, bundle: Bundle = .main, directory: String? = nil) {
		self.svg = SVGImage(bundleName: bundleName, bundle: bundle, directory: directory) ?? .empty
	}
	
	public init(svg: SVGImage) {
		self.svg = svg
	}
	
	#if os(macOS)
		public var body: some View {
			Group() {
				if svg.image != nil {
					Image(nsImage: svg.image!)
				} else {
					Text("Missing Image")
				}
			}
		}
	#endif

	#if os(iOS)
		public var body: some View {
			Group() {
				if svg.image != nil {
					Image(uiImage: svg.image!)
				} else {
					Text("Missing Image")
				}
			}
		}
	#endif
}


//struct SVGView_Previews: PreviewProvider {
//	static var previews: some View {
//		SVGView()
//	}
//}
