//
//  Element.Generic.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/22/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation


extension SVGElement {
	class Generic: Container, CustomStringConvertible, CustomDebugStringConvertible {
		var qualifiedName: String?
		var nameSpace: String?
		var content: String = ""
		
		init(kind: SVGElement.Kind, parent: SVGElement?, attributes: [String: String]) {
			super.init(kind: kind, parent: parent)
			self.attributes = attributes
		}
		
		func append(content: String){
			self.content += content
		}
		
		var description: String {
			var result = self.kind.rawValue
			
			if !self.content.isEmpty { result += ": \(self.content)" }
			if self.attributes?.isEmpty == false {
				result += " { "
				for (key, value) in self.attributes! {
					result += "\(key): \(value), "
				}
				result += "} "
			}
			if !self.children.isEmpty {
				result += " [\n"
				for kid in self.children {
					result += "\t \(kid)\n"
				}
				result += "]\n"
			}
			return result
		}
		
		var debugDescription: String { return self.description }
	}
}

