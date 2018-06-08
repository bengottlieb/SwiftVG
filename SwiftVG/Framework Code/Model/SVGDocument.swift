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
	
	init(root: SVGElement.Root) {
		self.root = root
	}
	
	public func child(with id: String) -> SVGElement? {
		return self.root.child(with: id)
	}
}
