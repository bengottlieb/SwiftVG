//
//  Dictionary+Extension.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/21/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

extension Dictionary where Key == String, Value == String {
	var prettyString: String {
		var result = "["
		
		for (key, value) in self {
			result += "\(key): \(value), "
		}
		
		return result + "]"
	}
}
