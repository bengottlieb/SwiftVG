//
//  SVGImage+Samples.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 7/7/22.
//  Copyright © 2022 Stand Alone, Inc. All rights reserved.
//

import Foundation

public extension SVGImage {
	static let sampleCubicCurve1: SVGImage = {
		let raw = """
<svg width="190" height="160" xmlns="http://www.w3.org/2000/svg">

  <path d="M 10 10 C 20 20, 40 20, 50 10" stroke="black" fill="transparent"/>
  <path d="M 70 10 C 70 20, 110 20, 110 10" stroke="black" fill="transparent"/>
  <path d="M 130 10 C 120 20, 180 20, 170 10" stroke="black" fill="transparent"/>
  <path d="M 10 60 C 20 80, 40 80, 50 60" stroke="black" fill="transparent"/>
  <path d="M 70 60 C 70 80, 110 80, 110 60" stroke="black" fill="transparent"/>
  <path d="M 130 60 C 120 80, 180 80, 170 60" stroke="black" fill="transparent"/>
  <path d="M 10 110 C 20 140, 40 140, 50 110" stroke="black" fill="transparent"/>
  <path d="M 70 110 C 70 140, 110 140, 110 110" stroke="black" fill="transparent"/>
  <path d="M 130 110 C 120 140, 180 140, 170 110" stroke="black" fill="transparent"/>

</svg>
"""
		return SVGImage(string: raw)!
	}()
	
	static let sampleCubicCurve2: SVGImage = {
		let raw = """
<svg width="190" height="160" xmlns="http://www.w3.org/2000/svg">
  <path d="M 10 80 C 40 10, 65 10, 95 80 S 150 150, 180 80" stroke="black" fill="transparent"/>
</svg>
"""
		return SVGImage(string: raw)!
	}()
	
	static let sampleSmoothCurve1: SVGImage = {
		let raw = """
<svg width="190" height="160" xmlns="http://www.w3.org/2000/svg">
  <path d="M 10 80 C 40 10, 65 10, 95 80 S 150 150, 180 80" stroke="black" fill="transparent"/>
</svg>
"""
		return SVGImage(string: raw)!
	}()
	
	
	static let smoothCurveCircle1: SVGImage = {
		let raw = """
<svg xmlns="http://www.w3.org/2000/svg" height="249.98" viewBox="0 0 250 249.97997" width="250"><g transform="matrix(1.25 0 0 -1.25 -1089.3 622.78)"><g><path d="m1070.6 398.15c0 54.778-44.414 99.192-99.2 99.192s-99.2-44.406-99.2-99.192 44.414-99.192 99.2-99.192 99.2 44.406 99.2 99.192z" fill="#ef3340"/></g></g></svg>
"""
		return SVGImage(string: raw)!
	}()
	
	static let smoothCurveCircle2: SVGImage = {
		let raw = """
<svg xmlns="http://www.w3.org/2000/svg" height="249.98" viewBox="0 0 250 249.97997" width="250"><g><g transform="matrix(0.25 0 0 -0.25 0 0)"><path d="m218.7 124.63c0 43.8-35.5 79.35-79.36 79.35s-79.36-35.5248-79.36-79.35 44.414-79.35 79.36-79.35 79.36 35.5248 79.36 79.35" fill="#ef3340"/></g></g></svg>
"""
		return SVGImage(string: raw)!
	}()
	
	static let sampleTransform: SVGImage = {
		let raw = """
 <svg viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">
	<rect x="10" y="10" width="30" height="20" fill="green" />

	<!--
	In the following example we are applying the matrix:
	[a c e]    [3 -1 30]
	[b d f] => [1  3 40]
	[0 0 1]    [0  0  1]

	which transform the rectangle as such:

	top left corner: oldX=10 oldY=10
	newX = a * oldX + c * oldY + e = 3 * 10 - 1 * 10 + 30 = 50
	newY = b * oldX + d * oldY + f = 1 * 10 + 3 * 10 + 40 = 80

	top right corner: oldX=40 oldY=10
	newX = a * oldX + c * oldY + e = 3 * 40 - 1 * 10 + 30 = 140
	newY = b * oldX + d * oldY + f = 1 * 40 + 3 * 10 + 40 = 110

	bottom left corner: oldX=10 oldY=30
	newX = a * oldX + c * oldY + e = 3 * 10 - 1 * 30 + 30 = 30
	newY = b * oldX + d * oldY + f = 1 * 10 + 3 * 30 + 40 = 140

	bottom right corner: oldX=40 oldY=30
	newX = a * oldX + c * oldY + e = 3 * 40 - 1 * 30 + 30 = 120
	newY = b * oldX + d * oldY + f = 1 * 40 + 3 * 30 + 40 = 170
	-->
	<rect x="10" y="10" width="30" height="20" fill="red"
	  transform="matrix(3 1 -1 3 30 40)" />
 </svg>
"""
		return SVGImage(string: raw)!
	}()
}
