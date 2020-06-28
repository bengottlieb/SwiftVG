//
//  SVGElement.Unknown.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 6/7/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

extension SVGElement {
	public class Unknown: Container {
		public struct Kind: SVGElementKind {
			public let tagName: String
			
			public func isEqualTo(kind: SVGElementKind?) -> Bool {
				if let other = kind as? Kind { return self.tagName == other.tagName }
				return false
			}
		}
		
		public init(name: String, attributes: [String: String]?, parent: Container?) {
			super.init(kind: Kind(tagName: name), parent: parent)
			self.attributes = attributes ?? [:]
		}
	}
}
