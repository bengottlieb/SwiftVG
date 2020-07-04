//
//  SVGElement+Content.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 7/4/20.
//  Copyright © 2020 Stand Alone, Inc. All rights reserved.
//

import Foundation

protocol ContentElement {
	func append(content: String)
}

extension SVGElement {
	public func toString(depth: Int = 0) -> String {
		var result = String(repeating: "\t", count: depth)
		
		result += "<" + self.kind.tagName
		
		if !self.attributes.isEmpty {
			result += ", " + self.attributes.prettyString
		}
		
		if let children = (self as? Container)?.children, children.count > 0 {
			result += ": [\n"
			for child in children {
				result += child.toString(depth: depth + 1)
			}
			result += "]"
		}
		return result + ">\n"
	}
}
