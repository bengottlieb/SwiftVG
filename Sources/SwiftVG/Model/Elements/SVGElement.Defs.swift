//
//  SVGElement.Defs.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/23/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation
import CoreGraphics

extension SVGElement {
	public class Defs: Container {
		required init(kind: SVGElementKind, parent: Container?, attributes: [String: String]) {
			super.init(kind: kind, parent: parent, attributes: attributes)
			parent?.defs = self
		}
		
		var styleSheet: SVGElement.Style?
		var css: CSSSheet? { self.styleSheet?.css }
		
		public override func draw(with ctx: CGContext, in frame: CGRect) { }
	}
}

