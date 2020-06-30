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
			Text(item.briefDescription)
		}
	}
}

struct SVGTree_Previews: PreviewProvider {
	static var previews: some View {
		SVGTree(svg: SVGImage(bundleName: "PreserveAspectRatio", directory: "Sample Images")!)
	}
}
