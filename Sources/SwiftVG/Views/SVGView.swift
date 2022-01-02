//
//  SVGView.swift
//  SwiftVG
//
//  Created by ben on 7/1/20.
//  Copyright © 2020 Stand Alone, Inc. All rights reserved.
//

import SwiftUI

class SVGUserInterface: ObservableObject {
	static let instance = SVGUserInterface()
	
	@Published var selectedID: String?
}

public struct SVGView: View {
	public let svg: SVGImage
	var scale: Double = 1
	
	public static var drawElementBorders = false
	
	public init(svg: SVGImage, scale: Double = 1) {
		self.svg = svg
		self.scale = scale
	}
	
	public var body: some View {
		if svg.isDrawable {
			ZStack(alignment: .topLeading) {
				ForEach(svg.document.root.resolvedChildren) { child in
					if child.isDisplayable { SVGElementView(element: child) }
				}
			}
			.environmentObject(SVGUserInterface.instance)
			.frame(width: svg.size.width * scale, height: svg.size.height * scale)
			.if(SVGView.drawElementBorders) { $0.border(Color.gray, width: 1) }
		}
    }
}

struct SVGView_Previews: PreviewProvider {
    static var previews: some View {
		SVGView(svg: .empty)
    }
}

