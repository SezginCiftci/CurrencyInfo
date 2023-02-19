//
//  Optional+Extension.swift
//  CurrencyInfo
//
//  Created by Sezgin Çiftci on 18.02.2023.
//

import Foundation

extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        self == "" || self == nil
    }
}
