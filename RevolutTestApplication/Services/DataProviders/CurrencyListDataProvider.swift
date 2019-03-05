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
