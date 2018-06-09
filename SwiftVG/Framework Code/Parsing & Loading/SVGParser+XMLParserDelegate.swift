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
		if let top = self.currentTree.last {
			top.append(content: string)
		}
	}
	
	var computedTitle: String? {
		if let t = self.title { return t }
		if let filename = self.url?.lastPathComponent { return filename }
		return nil
	}
	
	func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes: [String : String] = [:]) {
		let currentParent = (self.currentTree.last as? SVGElement.Container)
		guard let kind = SVGElement.NativeKind(rawValue: elementName) else {
			if !elementName.contains(":") { print("Unknown element found: \(elementName) in \(self.computedTitle ?? "")") }
			
			let element = SVGElement.Unknown(name: elementName, attributes: attributes, parent: currentParent)
			currentParent?.append(child: element)
			self.currentTree.append(element)
			return
		}
		
		if let element = (self.currentTree.last as? SVGElement.Container)?.createElement(ofKind: kind, with: attributes) {
			self.currentTree.append(element)
			return
		}
		guard let element = kind.element(in: self.currentTree.last as? SVGElement.Container, attributes: attributes) else { return }
		
		if self.document == nil, let root = element as? SVGElement.Root { self.document = SVGDocument(root: root, data: self.data) }

		currentParent?.append(child: element)
		self.currentTree.append(element)
	}
	
	func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
		if let topKind = self.currentTree.last?.kind, topKind.tagName != elementName {
			if SVGElement.NativeKind(rawValue: elementName) != nil {
				print("element name mismatch: \(topKind.tagName) vs. \(elementName)")
			}
			return
		}
		
		if self.currentTree.count > 1 {
			self.currentTree.removeLast()
		}
	}
	
	func parser(_ parser: XMLParser, foundComment comment: String) {
		if let top = self.currentTree.last {
			top.append(comment: comment)
		}
	}
	
	func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
		print("Found CDATA: \(String(data: CDATABlock, encoding: .utf8) ?? "unparsable")")
	}
	
	func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
		print("Error while parsing: \(parseError)")
	}
	
	func parser(_ parser: XMLParser, validationErrorOccurred validationError: Error) {
		print("Error while validating: \(validationError)")
	}
	
	public func parser(_ parser: XMLParser, foundNotationDeclarationWithName name: String, publicID: String?, systemID: String?) {
		
	}
	
	public func parser(_ parser: XMLParser, foundUnparsedEntityDeclarationWithName name: String, publicID: String?, systemID: String?, notationName: String?) {
		
	}
	
	
	public func parser(_ parser: XMLParser, foundAttributeDeclarationWithName attributeName: String, forElement elementName: String, type: String?, defaultValue: String?) {
		
	}
	
	
	public func parser(_ parser: XMLParser, foundElementDeclarationWithName elementName: String, model: String) {
		
	}
	
	
	public func parser(_ parser: XMLParser, foundInternalEntityDeclarationWithName name: String, value: String?) {
		
	}
	
	
	public func parser(_ parser: XMLParser, foundExternalEntityDeclarationWithName name: String, publicID: String?, systemID: String?) {
		
	}

	public func parser(_ parser: XMLParser, didStartMappingPrefix prefix: String, toURI namespaceURI: String) {
		
	}
	
	
	public func parser(_ parser: XMLParser, didEndMappingPrefix prefix: String) {
		
	}

	public func parser(_ parser: XMLParser, foundProcessingInstructionWithTarget target: String, data: String?) {
		
	}
}
