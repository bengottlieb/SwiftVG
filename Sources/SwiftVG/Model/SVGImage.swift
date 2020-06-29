//
//  SVGImage.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/21/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation
import Combine

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif

open class SVGImage: CustomStringConvertible, Identifiable {
	public var viewBox: CGRect { return self.document?.root.viewBox ?? .zero }
	public var size: CGSize {
		get { return self.document?.root.size ?? .zero }
		set { self.document?.root.size = newValue }
	}
	public var drawable = false
	public var data: Data? { return self.document.data }
	public var url: URL?
	
	public var id: String
	var cachedCGImage: CGImage?
	var cachedNativeImage: NSObject?
	
	public var document: SVGDocument! { didSet { self.drawable = true }}

	public convenience init?(url: URL) {
		guard let data = try? Data(contentsOf: url) else { return nil }
		self.init(data: data)
		self.url = url
		self.id = url.absoluteString
	}
	
	public init?(string: String) {
		guard let data = string.data(using: .utf8) else { return nil }
		let parser = SVGParser(data: data, from: nil)
		self.id = "\(data.hashValue)"
		parser.start(with: self)
	}
	
	public init?(data: Data) {
		let parser = SVGParser(data: data, from: nil)
		self.id = "\(data.hashValue)"
		parser.start(with: self)
	}
	
	public init?(document: SVGDocument) {
		self.id = "\(document.data?.hashValue ?? 0)"
		self.document = document
	}
	
	public init(size: CGSize) {
		self.id = UUID().uuidString
		self.document = SVGDocument(root: SVGElement.Root(attributes: SVGElement.Root.generateDefaultAttributes(for: size)), data: nil)
	}
	
	open var description: String { return "Image" }
	public var name: String? { self.url?.deletingPathExtension().lastPathComponent }
}

extension SVGImage {
}

extension CGContext {
	public func draw(_ image: SVGImage, in frame: CGRect) {
		image.document?.root.draw(with: self, in: frame)
	}
}
