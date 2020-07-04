//
//  Settings.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 7/4/20.
//  Copyright © 2020 Stand Alone, Inc. All rights reserved.
//

import Foundation
import Studio


class Settings: DefaultsBasedPreferences {
	static let instance = Settings()
	
	@objc dynamic var imageIndex = 0
	@objc dynamic var showingImages = false
	@objc dynamic var showingOutlines = false
	
	
}
