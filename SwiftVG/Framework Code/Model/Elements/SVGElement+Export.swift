//
//  SVGElement+Export.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 6/8/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

extension SVGElement {
	var xmlElementContents: String {
		var xml = self.kind.tagName
		
		for (key, value) in self.attributes ?? [:] {
			xml += " \(key)=\"\(value)\""
		}
		return xml
	}
	
	var xmlOpenTag: String { return "<" + self.xmlElementContents + ">" }
	var xmlSelfClosingTag: String { return "<" + self.xmlElementContents + " />" }
	var xmlCloseTag: String { return "</\(self.kind.tagName)>"}
}
