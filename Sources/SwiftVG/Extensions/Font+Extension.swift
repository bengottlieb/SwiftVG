//
//  Font+Extension.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/22/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation
import SwiftUI


#if os(OSX)
	import Cocoa
	typealias SVGFont = NSFont
#else
	import UIKit
	typealias SVGFont = UIFont
#endif

extension SVGFont {
	enum SVGWeight: String { case normal, bold, bolder, lighter
		var fontWeight: UIFont.Weight? {
			switch self {
			case .normal: return nil
			case .bold: return .bold
			case .bolder: return .heavy
			case .lighter: return .light
			}
		}
	}
	enum SVGStyle: String { case normal, italic, oblique
		var traits: UIFontDescriptor.SymbolicTraits? {
			switch self {
			case .italic: return .traitItalic
			case .oblique: return .traitBold
			case .normal: return nil
			}
		}
	}
	
	var swiftUIFont: Font { Font(self) }
	
	static func font(named name: String, size: CGFloat, weight rawWeight: String?, style rawStyle: String?) -> SVGFont? {
		let weight = SVGWeight(rawValue: rawWeight ?? "") ?? .normal
		var style = SVGStyle(rawValue: rawStyle ?? "") ?? .normal
		if style == .normal, weight == .bold { style = .oblique }
		
		#if os(iOS)
		if style != .normal {
			let attributes: [UIFontDescriptor.AttributeName: Any] = [ .face: name, .size: size ]
			var descriptor: UIFontDescriptor? = UIFontDescriptor(fontAttributes: attributes)
			if var traits = descriptor?.symbolicTraits {
				switch style {
				case .oblique: traits.insert(.traitBold)
				case .italic: traits.insert(.traitItalic)
				default: break
				}
				descriptor = UIFontDescriptor().withSymbolicTraits(traits)
			}

			if let desc = descriptor { return SVGFont(descriptor: desc, size: size) }
		}
		
//		let traits = [UIFontWeightTrait: UIFontWeightLight] // UIFontWeightBold / UIFontWeightRegular
//		let imgFontDescriptor = UIFontDescriptor(fontAttributes: [UIFontDescriptorFamilyAttribute: "Helvetica"])
//		imgFontDescriptor = imgFontDescriptor.fontDescriptorByAddingAttributes([UIFontDescriptorTraitsAttribute: traits])

		#endif
		
		return self.init(name: name, size: size)
	}
}


