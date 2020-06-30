//
//  SVGElement+Export.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 6/8/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

extension SVGElement {
	public var xmlElementContents: String {
		var xml = self.kind.tagName
		
		for key in self.attributes.keys.sorted() {
			xml += " \(key)=\"\(self.attributes[key] ?? "")\""
		}
		return xml
	}
	
	public var xmlOpenTag: String { return "<" + self.xmlElementContents + ">" }
	public var xmlSelfClosingTag: String { return "<" + self.xmlElementContents + " />" }
	public var xmlCloseTag: String { return "</\(self.kind.tagName)>"}
}
