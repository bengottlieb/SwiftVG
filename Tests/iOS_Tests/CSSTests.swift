//
//  CSSTests.swift
//  iOS_Tests
//
//  Created by ben on 7/4/20.
//  Copyright © 2020 Stand Alone, Inc. All rights reserved.
//

import XCTest
@testable import SwiftVG


let css = """
text {
				font-size: 9pt;
				font-family: sans-serif;
			}
			
			.percentage,
			.date,
			.title {
				font-weight: bold;
			}
			
			.source {
				font-style: italic;
				font-size: 7pt;
			}
			
			.publisher {
				text-transform: uppercase;
				font-size: 7pt;
				font-family: Georgia, "Times New Roman", Times, serif;
			}
			
			.bar-section {
				fill: #C4CDD2;
				stroke-fill: #E3E7EA;
				stroke-width: 1;
			}
			
			.graph-line {
				stroke-dasharray: 1 2;
				stroke: #B2B2B2;
			}
			
			.tick {
				stroke: black;
				stroke-width: 0.5;
			}
"""

class CSSTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSheet() throws {
		let sheet = CSSSheet(string: css)
		
		XCTAssert(sheet.numberOfRules == 14, "incorrect number of rules")
		
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
