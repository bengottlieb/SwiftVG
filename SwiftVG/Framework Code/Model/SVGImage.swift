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
	
	public var description: String { return "Image" }
}

extension SVGImage {
}

extension CGContext {
	public func draw(_ image: SVGImage, in frame: CGRect) {
		self.saveGState()
		image.document?.root.applyTransform(to: self, in: frame)
		image.document?.root.draw(in: self)
		self.restoreGState()
	}
}
