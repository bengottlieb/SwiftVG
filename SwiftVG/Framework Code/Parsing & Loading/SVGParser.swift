//
//  XMLParser.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/21/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

class SVGParser: NSObject {
	let data: Data
	var xmlParser: XMLParser!
	var root: XMLElement! { return self.currentTree.first }
	
	var currentTree: [XMLElement] = []
	
	init(data: Data) {
		self.data = data
	}
	
	func start() {
		self.xmlParser = XMLParser(data: self.data)
		self.xmlParser.delegate = self
		self.xmlParser.parse()
	}
}

extension SVGParser: XMLParserDelegate {
	struct XMLElement: CustomStringConvertible, CustomDebugStringConvertible {
		var name: String
		var qualifiedName: String?
		var nameSpace: String?
		var attributes: [String: String] = [:]
		var children: [XMLElement] = []
		var contents: String = ""
		
		var description: String {
			var result = self.name
			
			if !self.contents.isEmpty { result += ": \(self.contents)" }
			if !self.attributes.isEmpty {
				result += " { "
				for (key, value) in self.attributes {
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
	
	func parserDidEndDocument(_ parser: XMLParser) {
		print("\(self.root)")
	}
	
	func parser(_ parser: XMLParser, foundCharacters string: String) {
		if self.currentTree.count > 0 {
			self.currentTree[self.currentTree.count - 1].contents += string
		}
	}
	
	func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
		let element = XMLElement(name: elementName, qualifiedName: qName, nameSpace: namespaceURI, attributes: attributeDict, children: [], contents: "")
		
		if self.currentTree.count > 0 {
			self.currentTree[self.currentTree.count - 1].children.append(element)
		}
		self.currentTree.append(element)
	}
	
	func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
		if let topName = self.currentTree.last?.name, topName != elementName {
			print("element name mismatch: \(topName) vs. elementName)")
		}
		
		if self.currentTree.count > 1 {
			self.currentTree.removeLast()
		}
	}
	
	func parser(_ parser: XMLParser, foundComment comment: String) {
		print("Found comment: \(comment)")
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
}
