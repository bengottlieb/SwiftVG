//
//  SVGElementView.swift
//  SwiftVG
//
//  Created by ben on 7/1/20.
//  Copyright © 2020 Stand Alone, Inc. All rights reserved.
//

import SwiftUI

struct SVGElementView: View {
	let element: SVGElement
	
	var body: some View {
		Group() {
			if let pathElement = element as? SVGElement.Path {
				if let path = pathElement.path {
					Path(path)
						.applyStyles(from: element)
				}
			} else if let rectElement = element as? SVGElement.Rect {
				if let rect = rectElement.rect {
					Rectangle()
						.applyStyles(from: element)
						.frame(width: rect.width, height: rect.height)
				}
			} else if let ellipseElement = element as? SVGElement.Ellipse {
				if let rect = ellipseElement.rect {
					Ellipse()
						.applyStyles(from: element)
						.frame(width: rect.width, height: rect.height)
				}
			} else if let text = element as? SVGElement.Text {
				Text(text.text)
					.font(element.font.swiftUIFont)
			} else if let container = element as? SVGElement.Container {
				ZStack(alignment: .topLeading) {
					ForEach(container.children) { child in
						if child.isDisplayable { SVGElementView(element: child) }
					}
				}
				.frame(width: element.drawnRect?.width, height: element.drawnRect?.height)
			} else {
				Rectangle()
					.stroke(Color.green)
					.frame(width: element.size?.width, height: element.size?.height)
			}
		}
		.offset(element.swiftUIOffset)
	}
}

//struct SVGElementView_Previews: PreviewProvider {
//    static var previews: some View {
//        SVGElementView()
//    }
//}
