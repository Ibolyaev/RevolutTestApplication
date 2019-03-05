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
/*
 {
 "base": "EUR",
 "date": "2018-09-06",
 "rates": {
 "AUD": 1.6221,
 "BGN": 1.9627,
 "BRL": 4.8088,
 "CAD": 1.5392,
 "CHF": 1.1315,
 "CNY": 7.9732,
 "CZK": 25.806,
 "DKK": 7.4831,
 "GBP": 0.90142,
 "HKD": 9.1647,
 "HRK": 7.4604,
 "HUF": 327.65,
 "IDR": 17385,
 "ILS": 4.1854,
 "INR": 84.014,
 "ISK": 128.25,
 "JPY": 130.01,
 "KRW": 1309.4,
 "MXN": 22.444,
 "MYR": 4.829,
 "NOK": 9.8106,
 "NZD": 1.7695,
 "PHP": 62.814,
 "PLN": 4.3336,
 "RON": 4.6549,
 "RUB": 79.856,
 "SEK": 10.628,
 "SGD": 1.6057,
 "THB": 38.265,
 "TRY": 7.6552,
 "USD": 1.1675,
 "ZAR": 17.886
 }
 }*/
