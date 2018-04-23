//
//  SVGElement+SetsViewport.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/23/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

protocol SetsViewport: class {
	var viewBox: CGRect? { get }
}
