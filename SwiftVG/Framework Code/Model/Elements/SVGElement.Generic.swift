//
//  Element.Generic.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/22/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation


extension SVGElement {
	class Generic: Container {
		var qualifiedName: String?
		var nameSpace: String?
		var content: String = ""
		
		init(kind: SVGElementKind, parent: Container?, attributes: [String: String]) {
			super.init(kind: kind, parent: parent)
			self.load(attributes: attributes)
		}
		
		func append(content: String){
			self.content += content
		}
	}
}

