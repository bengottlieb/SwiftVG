//
//  SVGElement.Image.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 7/8/22.
//  Copyright © 2022 Stand Alone, Inc. All rights reserved.
//

import SwiftUI
import CrossPlatformKit

extension SVGElement {
	class Image: SVGElement {
		override public var isDisplayable: Bool { return true }

		var image: UXImage? {
			if let raw = attribute("xlink:href") ?? attribute("src") {
				let components = raw.components(separatedBy: ",")
				if components.count == 2, components[0].hasPrefix("data:image"), let data = Data(base64Encoded: components[1], options: .ignoreUnknownCharacters) {
					return UXImage(data: data)
				}
			}
			
			return nil
		}
		
		var resizeAspectRatio: SwiftUI.ContentMode {
			if attribute("preserveAspectRatio") == "none" {
				return .fill
			}
			return .fit
		}
	}
}
