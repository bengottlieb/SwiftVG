//
//  SVGElement.Style.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 7/4/20.
//  Copyright © 2020 Stand Alone, Inc. All rights reserved.
//

import Foundation
import CoreGraphics

extension SVGElement {
	public class Style: Container {
		var css: CSSSheet?
		
		required init(kind: SVGElementKind, parent: Container?, attributes: [String: String]) {
			super.init(kind: kind, parent: parent, attributes: attributes)
			self.root?.styleSheet = self
		}
		
		override func didLoad() {
			if attributes["type"] == "text/css" {
				self.css = CSSSheet(string: self.content)
			}
		}
		
		public override func draw(with ctx: CGContext, in frame: CGRect) { }
	}
}

