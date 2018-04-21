//
//  SVGImage.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/21/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

public class SVGImage {
	var parser: SVGParser?
	
	public init(data: Data) {
		self.parser = SVGParser(data: data)
		self.parser?.start()
	}
}

extension SVGImage {
	public convenience init?(url: URL) {
		guard let data = try? Data(contentsOf: url) else { return nil }
		self.init(data: data)
	}
}
