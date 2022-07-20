//
//  SVGElementView.swift
//  SwiftVG
//
//  Created by ben on 7/1/20.
//  Copyright © 2020 Stand Alone, Inc. All rights reserved.
//

import SwiftUI
import CrossPlatformKit

struct SVGElementView: View {
	@EnvironmentObject var ui: SVGUserInterface
	let element: SVGElement
	
	var scale: CGSize { element.scale ?? CGSize(width: 1, height: 1) }
	var body: some View {
		let transform = element.transform
		ZStack(alignment: .topLeading) {
			if let pathElement = element as? SVGElement.Path {
				if let path = pathElement.path {
					Path(path)
						.applyStyles(from: element)
						//.onTapGesture { print(element) }
				}
			} else if let ellipseElement = element as? SVGElement.Ellipse {
				if let path = ellipseElement.path {
					Path(path)
						.applyStyles(from: element)
				}
			} else if let rectElement = element as? SVGElement.Rect {
				if let rect = rectElement.rect {
					Rectangle()
						.applyStyles(from: element)
						.frame(width: rect.width, height: rect.height)
						.if(ui.selectedID == element.id) { $0.overlay(Color.red) }
						//.onTapGesture { ui.selectedID = element.id }
				}
			} else if let text = element as? SVGElement.Text {
				Text(text.text)
					.font(element.font.swiftUIFont)
					.offset(y: -element.fontSize * 0.8)
					.foregroundColor(Color(element.fillColor ?? .black))
					.iflet(SVGView.elementBorderColor) { v, c in v.border(c, width: 1) }
					//.onTapGesture { print(element) }
			} else if let elem = (element as? SVGElement.Image), let image = elem.image {
				Image(uxImage: image)
					.resizable()
					.aspectRatio(contentMode: elem.resizeAspectRatio)
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
		.transformEffect(transform ?? .identity)
		//.scaleEffect(self.scale)
		.iflet(element.origin) { v, p in v.offset(x: p.x, y: p.y) }
		.iflet(SVGView.elementBorderColor) { v, c in v.border(c, width: 1) }
	}
}

//struct SVGElementView_Previews: PreviewProvider {
//    static var previews: some View {
//        SVGElementView()
//    }
//}
