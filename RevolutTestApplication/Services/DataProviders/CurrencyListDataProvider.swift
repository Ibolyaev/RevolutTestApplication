//
//  CurrencyListDataProvider.swift
//  RevolutTestApplication
//
//  Created by Admin on 11/03/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
protocol CurrencyListDataProvider {
    func getDefaultCurrency() -> Currency
    func getCurrencyList(for baseCurrency: Currency,  completionHandler: @escaping (CurrenciesList?, Error?)->())
}
