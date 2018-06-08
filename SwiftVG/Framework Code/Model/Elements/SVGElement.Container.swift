//
//  SVGElement.Container.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/22/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

extension SVGElement {
	public class Container: SVGElement, CustomStringConvertible, CustomDebugStringConvertible {
		public var children: [SVGElement] = []
		public var defs: Defs?

		func append(child: SVGElement) { self.children.append(child) }
		public override func draw(with ctx: CGContext, in frame: CGRect) { self.drawChildren(with: ctx, in: frame) }
		func drawChildren(with ctx: CGContext, in frame: CGRect) {
			for child in self.children {
				child.draw(with: ctx, in: frame)
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
		
		func createElement(ofKind: SVGElementKind, with attributes: [String: String]) -> SVGElement? {
			return nil
		}
		
		public var description: String { return self.hierarchicalDescription() }
		
		public override func hierarchicalDescription(_ level: Int = 0) -> String {
			var result = self.kind.tagName
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
		
		public var debugDescription: String { return self.description }

	}
}

