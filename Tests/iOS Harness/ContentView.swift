//
//  ContentView.swift
//  SwiftVG
//
//  Created by ben on 6/29/20.
//  Copyright © 2020 Stand Alone, Inc. All rights reserved.
//

import SwiftUI
import SwiftVG

struct ContentView: View {
    var body: some View {
		Image(svg: SVGImage(bundleName: "heart") ?? .empty)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
