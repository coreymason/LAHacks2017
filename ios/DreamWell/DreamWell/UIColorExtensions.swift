//
//  UIColorExtensions.swift
//  DreamWell
//
//  Created by Rohin Bhushan on 4/1/17.
//  Copyright © 2017 rohin. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
	
	convenience init(hex: Int) {
		
		let red		= CGFloat(CGFloat((hex & 0xFF0000) >> 16)  / 255.0)
		let green	= CGFloat(CGFloat((hex & 0x00FF00) >>  8)  / 255.0)
		let blue	= CGFloat(CGFloat((hex & 0x0000FF) >>  0)  / 255.0)
		
		self.init(red:red, green:green, blue:blue, alpha:1.0)
	}
}

