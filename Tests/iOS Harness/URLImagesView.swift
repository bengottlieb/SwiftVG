//
//  URLImagesView.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 1/2/22.
//  Copyright © 2022 Stand Alone, Inc. All rights reserved.
//

import Suite
import SwiftVG

struct URLImagesView: View {
    var body: some View {
		 VStack() {
			 SVGURLView(url: URL("https://openseauserdata.com/files/029a1fc13ef6a61dc55b8b8fba8365c8.svg"))
				 .border(Color.green, width: 5)
			 SVGURLView(url: URL("https://s.btc.com/btcapp/pool-icons/favicon-default.png"))
			 SVGURLView(url: URL("https://s.btc.com/explorer-app/pool-icons/favicon-antpool.svg"))
			 SVGURLView(url: URL("https://s.btc.com/explorer-app/pool-icons/favicon-btccom.svg"))
			 SVGURLView(url: URL("https://s.btc.com/explorer-app/pool-icons/favicon-foundry.svg"))
			 SVGURLView(url: URL("https://s.btc.com/explorer-app/pool-icons/favicon-f2pool.svg"))
			 SVGURLView(url: URL("https://s.btc.com/explorer-app/pool-icons/favicon-antpool.svg"))
		 }
    }
}

struct URLImagesView_Previews: PreviewProvider {
    static var previews: some View {
        URLImagesView()
    }
}
