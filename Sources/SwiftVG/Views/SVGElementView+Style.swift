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
	@MainActor
	func applyStyles(from element: SVGElement) -> some View {
		ZStack(alignment: .topLeading) {
			self
				.fill(element.fillColor.swiftUIColor, style: FillStyle(eoFill: element.inheritedEvenOddFill, antialiased: false))
				
			self
				.stroke(element.strokeColor.swiftUIColor, lineWidth: element.strokeWidth)
				.iflet(SVGView.elementBorderColor) { v, c in v.border(c, width: 1) }
		}
	}
}



