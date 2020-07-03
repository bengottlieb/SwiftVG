//
//  SVGView.swift
//  SwiftVG
//
//  Created by ben on 7/1/20.
//  Copyright © 2020 Stand Alone, Inc. All rights reserved.
//

import SwiftUI

public struct SVGView: View {
	public let svg: SVGImage
	
	public static var drawElementBorders = false
	
	public init(svg: SVGImage) {
		self.svg = svg
	}
	
	public var body: some View {
		ZStack(alignment: .topLeading) {
			ForEach(svg.document.root.children) { child in
				if child.isDisplayable { SVGElementView(element: child) }
			}
		}
    }
}

struct SVGView_Previews: PreviewProvider {
    static var previews: some View {
		SVGView(svg: .empty)
    }
}

