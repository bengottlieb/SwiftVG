//
//  SVGElementView+Style.swift
//  SwiftVG
//
//  Created by ben on 7/2/20.
//  Copyright © 2020 Stand Alone, Inc. All rights reserved.
//

import SwiftUI
import Suite

struct SVGStyleFill: ViewModifier {
	let element: SVGElement
	
	func body(content: Content) -> some View {
		Group() {
			content.background(element.fillColor.swiftUIColor)
		}
	}
}

struct SVGStyleStroke: ViewModifier {
	let element: SVGElement
	
	func body(content: Content) -> some View {
		Group() {
			content.foregroundColor(element.strokeColor.swiftUIColor)
		}
	}
}

extension Shape {
	func applyStyles(from element: SVGElement) -> some View {
		ZStack(alignment: .topLeading) {
			self.fill(element.fillColor.swiftUIColor)
			self.stroke(element.strokeColor.swiftUIColor, lineWidth: 1)
				.if(SVGView.drawElementBorders) { $0.border(Color.gray, width: element.strokeWidth) }
		}
	}
}



