//
//  SVGElement.Container.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/22/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

extension SVGElement {
	class Container: SVGElement, CustomStringConvertible, CustomDebugStringConvertible {
		var children: [SVGElement] = []
		var defs: Defs?

		func append(child: SVGElement) { self.children.append(child) }
		override func draw(in ctx: CGContext) { self.drawChildren(in: ctx) }
		func drawChildren(in ctx: CGContext) {
			for child in self.children {
				child.draw(in: ctx)
			}
		}
		
		func child(with id: String) -> SVGElement? {
			for child in self.children {
				if child.id == id { return child }
			}
			return nil
		}
		
		func definition(for id: String) -> SVGElement? {
			var search = id
			if search.hasPrefix("#") { search = search[1...] }

			if let result = self.defs?.child(with: search) { return result }
			return self.parent?.definition(for: search)
		}
		
		func createElement(ofKind: Kind, with attributes: [String: String]) -> SVGElement? {
			return nil
		}
		
		var description: String { return self.hierarchicalDescription() }
		
		override func hierarchicalDescription(_ level: Int = 0) -> String {
			var result = self.kind.rawValue
			let prefix = String(repeating: "\t", count: level)
			
			//if let contentable = self as? ContentElement, !contentable.content.isEmpty { result += ": \(contentable.content)" }
			if self.attributes?.isEmpty == false {
				result.append(", " + self.attributes!.prettyString)
			}
			if !self.children.isEmpty {
				result += " [\n"
				for kid in self.children {
					result += "\(prefix) \(kid.hierarchicalDescription(level + 1))\n"
				}
				result += "\(prefix) ]\n"
			}
			return result
		}
		
		var debugDescription: String { return self.description }

	}
}

