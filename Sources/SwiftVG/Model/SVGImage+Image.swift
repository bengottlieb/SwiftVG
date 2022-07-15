//
//  SVGImage+Image.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 6/27/20.
//  Copyright © 2020 Stand Alone, inc. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGContext {
	func draw(_ image: SVGImage, in frame: CGRect) {
		#if os(OSX)
			let ctx = NSGraphicsContext(cgContext: self, flipped: true)
			ctx.saveGraphicsState()
			image.document?.root.draw(with: self, in: frame)
			ctx.restoreGraphicsState()
		#else
			UIGraphicsPushContext(self)
			image.document?.root.draw(with: self, in: frame)
			UIGraphicsPopContext()
		#endif
	}
}

public extension SVGImage {

}

#if canImport(Cocoa)
import Cocoa

public extension SVGImage {
	var cgImage: CGImage? {
		var rect = self.size.rect
		return self.image?.cgImage(forProposedRect: &rect, context: nil, hints: nil)
	}
	static var defaultBackgroundColor = NSColor.clear
	var image: NSImage? {
		let image = NSImage(size: self.size, flipped: true) { rect in
			guard let ctx = NSGraphicsContext.current?.cgContext else { return false }
			ctx.saveGState()
			ctx.draw(self, in: rect)
			ctx.restoreGState()
			return true
		}

		self.cachedNativeImage = image
		return image
	}
}
#endif


#if canImport(UIKit)
import UIKit

public extension SVGImage {
	static var defaultBackgroundColor = UIColor.clear

	var cgImage: CGImage? {
		if let cached = self.cachedCGImage { return cached }
		var size: CGSize! = self.size
		if size == nil || size == .zero { size = CGSize(width: 500, height: 500) }
		let rect = size.rect
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
		guard let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else { return nil }
		
		context.saveGState()
		context.scaleBy(x: 1, y: -1)
		context.translateBy(x: 0, y: -size.height)
		context.setFillColor(Self.defaultBackgroundColor.cgColor)
		context.draw(self, in: rect)
		context.restoreGState()
		
		guard let image = context.makeImage() else { return nil }
		self.cachedCGImage = image
		return image
	}

	var image: UIImage? {
		if let cached = self.cachedNativeImage as? UIImage { return cached }
		guard let image = self.cgImage else { return nil }
		let result = UIImage(cgImage: image)
		self.cachedNativeImage = result
		return result
	}
}
#endif
