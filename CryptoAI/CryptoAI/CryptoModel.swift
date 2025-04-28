//
//  CryptoModel.swift
//  CryptoAI
//
//  Created by Jihene on 28/04/2025.
//

import Foundation

struct Crypto: Identifiable, Decodable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let current_price: Double
    let price_change_percentage_24h: Double?
}
