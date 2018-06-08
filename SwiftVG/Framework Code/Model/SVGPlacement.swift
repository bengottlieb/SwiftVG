//
//  SVGPlacement.swift
//  SwiftVG
//
//  Created by Ben Gottlieb on 4/23/18.
//  Copyright © 2018 Stand Alone, inc. All rights reserved.
//

import Foundation

extension SVGElement {
	public struct Placement {
		var scaling: Scaling
		var position: Positioning
		
		init(rawValue: String?) {
			self.scaling = Scaling(rawValue: rawValue)
			self.position = Positioning(rawValue: rawValue)
		}
	}
	
	public enum Scaling { case none, scaleToFill, scaleAspectFit, scaleAspectFill
		init(rawValue: String?) {
			guard let raw = rawValue else { self = .scaleAspectFit; return }
			let components = raw.components(separatedBy: " ")
			if components.count == 0 || components.first == "none" { self = .none; return }
			
			if components.count > 1 {
				if components.last == "meet" { self = .scaleAspectFit; return }
				if components.last == "slice" { self = .scaleAspectFill; return }
			}
			
			self = .scaleAspectFit
		}
	}
	public enum Positioning { case none, center, top, bottom, left, right, topLeft, topRight, bottomLeft, bottomRight
		
		init(rawValue: String?) {
			guard let raw = rawValue else { self = .none; return }
			let components = raw.components(separatedBy: " ")
			if components.count == 0 || components.first == "none" { self = .none; return }
			
			switch components.first ?? "none" {
			case "xMinYMin": self = .topLeft
			case "xMidYMin": self = .top
			case "xMaxYMin": self = .topRight

			case "xMinYMid": self = .left
			case "xMidYMid": self = .center
			case "xMaxYMid": self = .right

			case "xMinYMax": self = .bottomLeft
			case "xMidYMax": self = .bottom
			case "xMaxYMax": self = .bottomRight

			default: self = .none
			}
			
		}
	}
	
	func applyTransform(to ctx: CGContext, in rect: CGRect) {
		guard let box = (self as? SetsViewport)?.viewBox else { return }
		let placement = Placement(rawValue: self.attributes["preserveAspectRatio"])
		let myAspect = box.width / box.height
		var scaleX: CGFloat = 1
		var scaleY: CGFloat = 1
		var targetRect = rect
		switch placement.scaling {
		case .scaleAspectFit:
			if myAspect > 1 {
				if targetRect.size.height > targetRect.width / myAspect {
					targetRect.size.height = targetRect.width / myAspect
				} else {
					targetRect.size.width = targetRect.height * myAspect
				}
			} else {
				if targetRect.size.width > targetRect.height * myAspect {
					targetRect.size.width = targetRect.height * myAspect
				} else {
					targetRect.size.width = targetRect.width / myAspect
				}
			}
			scaleX = min(targetRect.width / box.width, targetRect.height / box.height)
			scaleY = scaleX

		case .scaleAspectFill:
			if myAspect > 1 {
				if targetRect.size.height < targetRect.width / myAspect {
					targetRect.size.height = targetRect.width / myAspect
				} else {
					targetRect.size.width = targetRect.height * myAspect
				}
			} else {
				if targetRect.size.width < targetRect.height * myAspect {
					targetRect.size.width = targetRect.height * myAspect
				} else {
					targetRect.size.width = targetRect.width / myAspect
				}
			}
			scaleX = max(targetRect.width / box.width, targetRect.height / box.height)
			scaleY = scaleX
			
		case .none, .scaleToFill:
			scaleX = rect.width / box.width
			scaleY = rect.height / box.height
		}
		
		targetRect.size.width = box.width * scaleX
		targetRect.size.height = box.height * scaleY

		var xTranslation: CGFloat = 0
		var yTranslation: CGFloat = 0
		
		switch placement.position {
		case .topLeft, .none: break			//do nothing, already there
		case .top:
			xTranslation = (rect.width - targetRect.width) / 2
		case .topRight:
			xTranslation = (rect.width - targetRect.width)
			
		case .left:
			yTranslation = (rect.height - targetRect.height) / 2

		case .center:
			xTranslation = (rect.width - targetRect.width) / 2
			yTranslation = (rect.height - targetRect.height) / 2

		case .right:
			xTranslation = (rect.width - targetRect.width)
			yTranslation = (rect.height - targetRect.height) / 2

		case .bottomLeft:
			yTranslation = (rect.height - targetRect.height)

		case .bottom:
			xTranslation = (rect.width - targetRect.width) / 2
			yTranslation = (rect.height - targetRect.height)

		case .bottomRight:
			xTranslation = (rect.width - targetRect.width)
			yTranslation = (rect.height - targetRect.height)

		}
		
		ctx.concatenate(CGAffineTransform(translationX: xTranslation, y: yTranslation))
		ctx.concatenate(CGAffineTransform(scaleX: scaleX, y: scaleY))
	}

}
