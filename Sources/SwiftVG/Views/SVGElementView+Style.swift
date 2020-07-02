//
//  SVGElementView+Style.swift
//  SwiftVG
//
//  Created by ben on 7/2/20.
//  Copyright © 2020 Stand Alone, Inc. All rights reserved.
//

import SwiftUI

struct SVGStyleFill: ViewModifier {
	let element: SVGElement
	
	func body(content: Content) -> some View {
		Group() {
			if element.fillColor?.swiftUIColor != nil {
				content.background(element.fillColor!.swiftUIColor)
			} else {
				content
			}
		}
	}
}

struct SVGStyleStroke: ViewModifier {
	let element: SVGElement
	
	func body(content: Content) -> some View {
		Group() {
			if element.strokeColor?.swiftUIColor != nil {
				content.foregroundColor(element.strokeColor!.swiftUIColor)
			} else {
				content
			}
		}
	}
}

extension Shape {
	func applyStyles(from element: SVGElement) -> some View {
		ZStack() {
			if element.fillColor?.swiftUIColor != nil {
				self.fill(element.fillColor!.swiftUIColor)
			}

			if element.strokeColor?.swiftUIColor != nil {
				self.stroke(element.strokeColor!.swiftUIColor)
			}
		}
	}
}



