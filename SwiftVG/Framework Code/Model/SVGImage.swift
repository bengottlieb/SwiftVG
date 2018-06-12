//
//  SVGImage.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/21/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

open class SVGImage: CustomStringConvertible {
	public var viewBox: CGRect { return self.document?.root.viewBox ?? .zero }
	public var size: CGSize { return self.document?.root.size ?? .zero }
	public var drawable = false
	public var data: Data? { return self.document.data }
	
	public var document: SVGDocument! { didSet { self.drawable = true }}

	public convenience init?(url: URL) {
		guard let data = try? Data(contentsOf: url) else { return nil }
		self.init(data: data)
	}
	
	public init?(string: String) {
		guard let data = string.data(using: .utf8) else { return nil }
		let parser = SVGParser(data: data, from: nil)
		parser.start(with: self)
	}
	
	public init?(data: Data) {
		let parser = SVGParser(data: data, from: nil)
		parser.start(with: self)
	}
	
	public init?(document: SVGDocument) {
		self.document = document
	}
	
	public init(size: CGSize) {
		self.document = SVGDocument(root: SVGElement.Root(attributes: SVGElement.Root.generateDefaultAttributes(for: size)), data: nil)
	}
	
	open var description: String { return "Image" }
}

extension SVGImage {
}

extension CGContext {
	public func draw(_ image: SVGImage, in frame: CGRect) {
		image.document?.root.draw(with: self, in: frame)
	}
}
