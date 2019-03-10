//
//  CurrencyRateViewModel.swift
//  RevolutTestApplication
//
//  Created by Игорь Боляев on 04.03.2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

class CurrencyRateViewModel {
    var currencyRate: CurrencyRate {
        didSet {
            rateText = BindingBox(formatter.string(from: NSNumber(value: currencyRate.rate)) ?? "")
        }
    }
    var baseCurrencyRate: Double
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.roundingMode = .halfDown
        formatter.minimumIntegerDigits  = 1
        formatter.maximumFractionDigits = 2 // we can change it for more digits
        return formatter
    }()
    var currencyImageName: String {        
        return currency.value
    }
    let currency: BindingBox<Currency>
    var rateText: BindingBox<String>
    var currencyRateDidChange: ((Double) -> ())?
    init(currencyRate: CurrencyRate, baseCurrencyRate: Double) {
        self.currencyRate = currencyRate
        self.baseCurrencyRate = baseCurrencyRate
        self.currency = BindingBox(currencyRate.currency)
        rateText = BindingBox(formatter.string(from: NSNumber(value: currencyRate.rate)) ?? "")
    }
}
