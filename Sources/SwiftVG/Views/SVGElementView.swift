//
//  SVGElementView.swift
//  SwiftVG
//
//  Created by ben on 7/1/20.
//  Copyright © 2020 Stand Alone, Inc. All rights reserved.
//

import SwiftUI

struct SVGElementView: View {
	@EnvironmentObject var ui: SVGUserInterface
	let element: SVGElement
	
	var scale: CGSize { element.scale ?? CGSize(width: 1, height: 1) }
	var body: some View {
		ZStack(alignment: .topLeading) {
			if let pathElement = element as? SVGElement.Path {
				if let path = pathElement.path {
					Path(path)
						.applyStyles(from: element)
						//.onTapGesture { print(element) }
				}
			} else if let rectElement = element as? SVGElement.Rect {
				if let rect = rectElement.rect {
					Rectangle()
						.applyStyles(from: element)
						.frame(width: rect.width, height: rect.height)
						.if(ui.selectedID == element.id) { $0.overlay(Color.red) }
						//.onTapGesture { ui.selectedID = element.id }
				}
			} else if let ellipseElement = element as? SVGElement.Ellipse {
				if let rect = ellipseElement.rect {
					Ellipse()
						.applyStyles(from: element)
						.frame(width: rect.width, height: rect.height)
						//.onTapGesture { print(element) }
				}
			} else if let text = element as? SVGElement.Text {
				Text(text.text)
					.font(element.font.swiftUIFont)
					.foregroundColor(Color(element.fillColor))
					.if(SVGView.drawElementBorders) { $0.border(Color.gray, width: 1) }
					//.onTapGesture { print(element) }
			}
			
			if let container = element as? SVGElement.Container {
				ZStack(alignment: .topLeading) {
					Rectangle()
						.fill(Color.clear)
					ForEach(container.resolvedChildren) { child in
						if child.isDisplayable { SVGElementView(element: child) }
					}
				}
				.frame(width: element.dimWidth.dimension, height: element.dimHeight.dimension)
				.if(element.shouldClip) { $0.clipped() }
			}
			
		}
		.frame(width: element.dimWidth.dimension, height: element.dimHeight.dimension)
		.offset(element.swiftUIOffset)
		//.scaleEffect(self.scale)
		.if(SVGView.drawElementBorders) { $0.border(Color.gray.opacity(0.5), width: 0.5) }
	}
}

//struct SVGElementView_Previews: PreviewProvider {
//    static var previews: some View {
//        SVGElementView()
//    }
//}
