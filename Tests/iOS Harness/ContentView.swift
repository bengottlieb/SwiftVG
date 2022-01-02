//
//  ContentView.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 1/2/22.
//  Copyright © 2022 Stand Alone, Inc. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
		 TabView() {
	//		 SingleImageView(name: "btc.com")
			 URLImagesView()
	//		 BuiltInImagesView()
		 }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
