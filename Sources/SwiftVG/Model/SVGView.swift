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
	
	public init(svg: SVGImage) {
		self.svg = svg
	}
	
	public var body: some View {
		Group() {
			if svg.image != nil {
				Image(nsImage: svg.image!)
			} else {
				Text("Missing Image")
			}
		}
	}
}

//struct SVGView_Previews: PreviewProvider {
//	static var previews: some View {
//		SVGView()
//	}
//}
