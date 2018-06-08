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
	public var data: Data!
	public var string: String? { return String(data: self.data, encoding: .utf8) }
	
	public var document: SVGDocument! { didSet { self.drawable = true }}

	public convenience init?(url: URL) {
		guard let data = try? Data(contentsOf: url) else { return nil }
		self.init(data: data)
	}
	
	public convenience init?(string: String) {
		guard let data = string.data(using: .utf8) else { return nil }
		self.init(data: data)
	}
	
	public init?(data: Data) {
		self.data = data
		let parser = SVGParser(data: data, from: nil)
		parser.start(with: self)
	}
	
	public init(size: CGSize) {
		self.document = SVGDocument(root: SVGElement.Root(attributes: SVGElement.Root.generateDefaultAttributes(for: size)))
	}
	
	public var description: String { return "Image" }
}

extension SVGImage {
}

extension CGContext {
	public func draw(_ image: SVGImage, in frame: CGRect) {
		image.document?.root.draw(with: self, in: frame)
	}
}
