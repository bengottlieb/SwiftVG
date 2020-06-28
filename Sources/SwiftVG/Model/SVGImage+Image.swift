//
//  SVGImage+Image.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 6/27/20.
//  Copyright © 2020 Stand Alone, inc. All rights reserved.
//

import Foundation

#if canImport(Cocoa)
import Cocoa

public extension SVGImage {
	var image: NSImage? {
		let size = self.size == .zero ? CGSize(width: 500, height: 500) : self.size
		let rect = size.rect
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
		guard let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else { return nil }
		context.draw(self, in: rect)
		
		guard let image = context.makeImage() else { return nil }
		return NSImage(cgImage: image, size: size)
	}
}
#endif
