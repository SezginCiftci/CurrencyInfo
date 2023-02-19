//
//  String+Extension.swift
//  CurrencyInfo
//
//  Created by Sezgin Çiftci on 18.02.2023.
//

import Foundation

extension String {
    var floatValue: Float { Float(self) ?? 0.0 }
}
