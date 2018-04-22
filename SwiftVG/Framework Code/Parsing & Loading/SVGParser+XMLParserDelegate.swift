//
//  SVGParser+XMLParserDelegate.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/21/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

extension SVGParser: XMLParserDelegate {
	func parserDidEndDocument(_ parser: XMLParser) {
		self.finished()
	}
	
	func parser(_ parser: XMLParser, foundCharacters string: String) {
		if self.currentTree.count > 0 {
			(self.currentTree.last as? ContentElement)?.append(content: string)
		}
	}
	
	var computedTitle: String? {
		if let t = self.title { return t }
		if let filename = self.url?.lastPathComponent { return filename }
		return nil
	}
	
	func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes: [String : String] = [:]) {
		guard let kind = ElementKind(rawValue: elementName) else {
			if !elementName.contains(":") { print("Unknown element found: \(elementName) in \(self.computedTitle ?? "")") }
			return
		}
		guard let element = kind.element(in: self.currentTree.last, attributes: attributes) else { return }

		if self.currentTree.count > 0 {
			(self.currentTree.last as? ContainerElement)?.append(child: element)
		}
		self.currentTree.append(element)
	}
	
	func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
		if let topKind = self.currentTree.last?.kind, topKind != ElementKind(rawValue: elementName) {
			print("element name mismatch: \(topKind.rawValue) vs. \(elementName)")
			return
		}
		
		if self.currentTree.count > 1 {
			self.currentTree.removeLast()
		}
	}
	
	func parser(_ parser: XMLParser, foundComment comment: String) {
		//	print("Found comment: \(comment)")
	}
	
	func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
		//	print("Found CDATA: \(String(data: CDATABlock, encoding: .utf8) ?? "unparsable")")
	}
	
	func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
		print("Error while parsing: \(parseError)")
	}
	
	func parser(_ parser: XMLParser, validationErrorOccurred validationError: Error) {
		print("Error while validating: \(validationError)")
	}
}
