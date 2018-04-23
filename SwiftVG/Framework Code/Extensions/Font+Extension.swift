//
//  Font+Extension.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/22/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

#if os(OSX)
	typealias SVGFont = NSFont
#else
	typealias SVGFont = UIFont
#endif

extension SVGFont {
	
}


