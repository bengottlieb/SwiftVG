//
//  SVGDocument.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/22/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

public class SVGDocument {
	public let root: SVGElement.Root
	public var data: Data?
	
	init(root: SVGElement.Root, data: Data?) {
		self.root = root
		self.data = data
	}
	
	public func child(with id: String) -> SVGElement? {
		return self.root.child(with: id)
	}
}
