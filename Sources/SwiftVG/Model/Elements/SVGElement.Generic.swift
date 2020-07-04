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
		override public var isDisplayable: Bool { return false }
	}
}

