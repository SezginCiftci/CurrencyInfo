//
//  DefaultList.swift
//  CurrencyInfo
//
//  Created by Sezgin Çiftci on 14.02.2023.
//

import Foundation

// MARK: - DefaultList
struct DefaultList: Codable {
    let mypageDefaults: [MypageDefault]
    let mypage: [Mypage]
}

// MARK: - Mypage
struct Mypage: Codable {
    let name, key: String
}

// MARK: - MypageDefault
struct MypageDefault: Codable {
    let cod, gro, tke, def: String
}


