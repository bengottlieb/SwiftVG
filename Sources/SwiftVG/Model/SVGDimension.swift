//
//  SVGDimension.swift
//  SwiftVG
//
//  Created by ben on 6/30/20.
//  Copyright © 2020 Stand Alone, Inc. All rights reserved.
//

import Foundation
import CoreGraphics

public struct SVGDimension {
	public enum Dimension { case width, height }

	let which: Dimension
	var float: CGFloat?
	var string: String?
	let element: SVGElement
	
	init(_ element: SVGElement, _ value: Any?, _ dim: Dimension) {
		self.element = element
		self.which = dim
		
		if let string = value as? String {
			self.string = string
		} else if let float = value as? CGFloat {
			self.float = float
		}
	}

	public var dimension: CGFloat? {
		if let dbl = self.float { return dbl }
		
		if let string = self.string {
			if string.contains("%"),
			   let percent = Double(string.trimmingCharacters(in: CharacterSet(charactersIn: "%"))),
			   let parentDim = element.parentDimension(for: self.which) {
				return parentDim * CGFloat(percent / 100)
			}
			
			let filtered = string.trimmingCharacters(in: .letters)
			if let dbl = Double(filtered) { return CGFloat(dbl) }
		}
		
		return nil
	}
	
}

