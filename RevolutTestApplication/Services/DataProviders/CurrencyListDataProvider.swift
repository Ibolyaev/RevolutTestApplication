//
//  CurrencyListDataProvider.swift
//  RevolutTestApplication
//
//  Created by Admin on 01/03/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

class CurrencyListDataProvider {
    let requestFactory: RequestFactory
    init(requestFactory: RequestFactory) {
        self.requestFactory = requestFactory
    }
    func getDefaultCurrency() -> Currency {
        // Ideally we need to add some function which would compare currencies that we are currently support and user's current locale currency
        // and if we dont support it yet, just return some default value
        var baseCurrency: Currency
        let locale = Locale.current
        if let currencyCode = locale.currencyCode {
            baseCurrency = currencyCode
        } else {
            baseCurrency = Api.defaultBaseCurrency
        }
        
        return baseCurrency
    }
    func getCurrencyList(for baseCurrency: Currency,  completionHandler: @escaping (CurrenciesList?, Error?)->()) {
        let request = requestFactory.makeCurrenciesListRequestFactory()
        request.getList(baseCurrency: baseCurrency) { (response) in
            guard let result = response.value else {
                completionHandler(nil, response.error)
                return
            }
            completionHandler(result, nil)
        }
    }
}
