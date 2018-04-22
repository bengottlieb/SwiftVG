//
//  SVGImage.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/21/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

public class SVGImage: CustomStringConvertible {
	public var viewBox: CGRect { return self.document?.root.viewBox ?? .zero }
	public var size: CGSize { return self.document?.root.size ?? .zero }
	public var drawable = false
	
	var document: SVGDocument! { didSet { self.drawable = true }}

	public init?(url: URL) {
		guard let data = try? Data(contentsOf: url) else { return nil }
		let parser = SVGParser(data: data, from: url)
		parser.start(with: self)
	}
	
	public func draw(in ctx: CGContext) {
		self.document?.root.draw(in: ctx)
	}
	
	public var description: String { return "Image" }
}

extension SVGImage {
}
