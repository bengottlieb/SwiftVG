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
			content.background(element.fillColor?.swiftUIColor ?? .black)
		}
	}
}

struct SVGStyleStroke: ViewModifier {
	let element: SVGElement
	
	func body(content: Content) -> some View {
		Group() {
			content.foregroundColor(element.strokeColor?.swiftUIColor ?? .black)
		}
	}
}

extension Shape {
	@MainActor
	func applyStyles(from element: SVGElement) -> some View {
		ZStack(alignment: .topLeading) {
			if let gradient = element.fillGradient {
				self
			.fill(gradient, style: FillStyle(eoFill: element.inheritedEvenOddFill, antialiased: false))
			.opacity(element.fillOpacity ?? 1)
			}
			if let fill = element.fillColor {
					self
				.fill(fill.swiftUIColor, style: FillStyle(eoFill: element.inheritedEvenOddFill, antialiased: false))
				.opacity(element.fillOpacity ?? 1)
			}
				
			if let stroke = element.strokeColor {
				self
					.stroke(stroke.swiftUIColor, lineWidth: element.strokeWidth)
					.opacity(element.strokeOpacity ?? 1)
					.iflet(SVGView.elementBorderColor) { v, c in v.border(c, width: 1) }
			}
		}
	}
}



