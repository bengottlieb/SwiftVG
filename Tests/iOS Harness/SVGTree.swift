//
//  SVGTree.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 6/29/20.
//  Copyright © 2020 Stand Alone, Inc. All rights reserved.
//

import SwiftUI
import SwiftVG
import Suite


struct SVGTree: View {
	let svg: SVGImage
	
	var body: some View {
		List(self.svg.document.root.children, children: \.children) { item in
			if item.drawnRect != nil {
				HStack() {
					Text(item.briefDescription)
						.font(.body)
						.padding()
					Text(item.drawnRect!.size.dimString)
						.font(.caption)
				}
			} else {
				Text(item.briefDescription)
					.padding()
			}
		}
	}
}

struct SVGTree_Previews: PreviewProvider {
	static var previews: some View {
		SVGTree(svg: SVGImage(bundleName: "PreserveAspectRatio", directory: "Sample Images")!)
	}
}
