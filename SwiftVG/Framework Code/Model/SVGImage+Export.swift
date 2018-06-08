//
//  SVGImage+Export.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 6/7/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

extension SVGImage {
	public func buildXMLString(prettily: Bool = false) -> String {
		return self.document?.root.buildXMLString(prefix: prettily ? "\n" : "") ?? ""
	}
}
