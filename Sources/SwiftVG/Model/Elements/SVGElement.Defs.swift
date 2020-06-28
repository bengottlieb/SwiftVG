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
		init(parent: Container?, attributes: [String: String]) {
			super.init(kind: SVGElement.NativeKind.defs, parent: parent)
			self.load(attributes: attributes)
			parent?.defs = self
		}
		
		public override func draw(with ctx: CGContext, in frame: CGRect) { }
	}
}

