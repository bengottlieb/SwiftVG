//
//  SVGContainer+Extract.swift
//  
//
//  Created by Ben Gottlieb on 10/9/21.
//

import Foundation

public extension SVGElement.Container {
	func extractElements() -> [SVGImage] {
		let closeTag = self.svg.document.root.xmlCloseTag
		
		return children.compactMap { child in
			guard let path = child as? SVGElement.Path else { return nil }
			let root = self.svg.document.root
			
			root.size = path.boundingSize
			root.svgID = UUID().uuidString
			var xml = root.xmlOpenTag
			let element = path.buildXMLString()
			xml += element
			xml += closeTag
			print(xml)
			return SVGImage(string: xml)
		}
	}
}
