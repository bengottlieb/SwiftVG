//
//  SingleImageView.swift
//  SwiftVG_iOS
//
//  Created by Ben Gottlieb on 1/2/22.
//  Copyright © 2022 Stand Alone, Inc. All rights reserved.
//

import SwiftUI
import SwiftVG

struct SingleImageView: View {
	let name: String
	var directory = "Sample Images"
	var body: some View { 
		SVGView(svg: SVGImage(bundleName: name, directory: directory)!)
	}
}

struct SingleImageView_Previews: PreviewProvider {
	static var previews: some View {
		SingleImageView(name: "btc.com")
	}
}
