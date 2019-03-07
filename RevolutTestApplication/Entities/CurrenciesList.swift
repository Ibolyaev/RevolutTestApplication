//
//  CurrenciesList.swift
//  RevolutTestApplication
//
//  Created by Admin on 28/02/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

typealias Currency = String

struct CurrenciesList: Decodable {
    let base: Currency
    let date: Date
    let rates: [CurrencyRate]
    enum CodingKeys: CodingKey {
        case base
        case date
        case rates
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        base = try values.decode(String.self, forKey: .base)
        date = try values.decode(Date.self, forKey: .date)
        
        let decodedRates = try values.decode([String: Double].self, forKey: .rates)
        rates = decodedRates.map {CurrencyRate(currency: $0.0, rate: $0.1)}
    }
}

struct CurrencyRate: Codable {
    let currency: Currency
    var rate: Double
}
extension CurrencyRate: Equatable {
    static func == (lhs: CurrencyRate, rhs: CurrencyRate) -> Bool {
        return lhs.currency == rhs.currency
    }
}
