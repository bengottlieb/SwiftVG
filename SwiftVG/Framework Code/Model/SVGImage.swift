//
//  SVGImage.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/21/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

public class SVGImage: CustomStringConvertible {
	public var viewBox: CGRect!
	public var size = CGSize.zero

	var parser: SVGParser?
	
	public init?(url: URL) {
		guard let data = try? Data(contentsOf: url) else { return nil }
		self.parser = SVGParser(data: data, from: url)
		self.parser?.start(with: self)
	}
	
	public func draw(in ctx: CGContext) {
		self.parser?.draw(in: ctx)
	}
	
	public var description: String { return "Image" }
}

extension SVGImage {
}
