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
           self.currencyRateDidChange?(self)
        }
    }
    let formatter = NumberFormatter()
    var rateText: String {
        get {
            formatter.roundingMode = .halfDown
            formatter.minimumIntegerDigits = 1
            formatter.maximumFractionDigits = 2 // we can change it for more digits
            return formatter.string(from: NSNumber(value: currencyRate.rate)) ?? ""
        }
    }
    var currencyRateDidChange: ((CurrencyRateViewModel) -> ())?
    init(currencyRate: CurrencyRate) {
        self.currencyRate = currencyRate
    }
}
