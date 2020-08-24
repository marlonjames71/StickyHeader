//
//  Font+Ext.swift
//  Sticky Header
//
//  Created by Marlon Raskin on 8/23/20.
//

import SwiftUI

extension Font {
	static func avenirNext(size: CGFloat) -> Font {
		return Self.custom("Avenir Next", size: size)
	}

	static func avenirNextRegular(size: CGFloat) -> Font {
		return Self.custom("AvenirNext-Regular", size: size)
	}
}
