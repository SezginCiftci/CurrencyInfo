//
//  ListDetail.swift
//  CurrencyInfo
//
//  Created by Sezgin Çiftci on 18.02.2023.
//

import Foundation

// MARK: - ListDetail
struct ListDetail: Codable {
    let l: [L]
    let z: String
}

// MARK: - L
struct L: Codable {
    let tke, clo, pdd, las, low, hig, ddi: String?
}
