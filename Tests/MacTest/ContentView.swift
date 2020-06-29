//
//  ContentView.swift
//  MacTest
//
//  Created by Ben Gottlieb on 6/28/20.
//  Copyright © 2020 Stand Alone, inc. All rights reserved.
//

import SwiftUI
import SwiftVG

struct ContentView: View {
    var body: some View {
		NavigationView() {
			ScrollView() {
				VStack() {
					ForEach(ImageList.instance.images) { image in
						NavigationLink(destination: SVGView(svg: image)) {
							Text(image.name ?? "Unnamed")
						}
					}
				}
				.layoutPriority(1)
			}
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class ImageList {
	static let instance = ImageList()
	var images: [SVGImage] = []
	
	init() {
		let dir = Bundle.main.url(forResource: "Sample Images", withExtension: nil)!
		let urls = try! FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil, options: [])
		
		self.images = urls.compactMap { SVGImage(url: $0) }
	}
}
