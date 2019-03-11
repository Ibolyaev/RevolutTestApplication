//
//  CurrencyListDataProviderMock.swift
//  RevolutTestApplicationTests
//
//  Created by Admin on 11/03/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
@testable import RevolutTestApplication

class CurrencyListDataProviderMock: CurrencyListDataProvider {
    func getDefaultCurrency() -> Currency {
        return ApiMock.defaultBaseCurrency
    }
    
    func getCurrencyList(for baseCurrency: Currency, completionHandler: @escaping (CurrenciesList?, Error?) -> ()) {
        let pathEnd = ApiMock.latestCurrencies
        
        let resourceArr = pathEnd.split(separator: ".")
        let fileName = String(resourceArr[0])
        let fileExtension = String(resourceArr[1])
        
        let fileUrl = Bundle.main.url(
            forResource: fileName,
            withExtension: fileExtension
            )!
        let stringResult = try! String(contentsOf: fileUrl)
        let decoder = newJSONDecoder()
        let result = try! decoder.decode(CurrenciesList.self, from: stringResult.data(using: .utf8)!)
        completionHandler(result, nil)
    }
    
    
}

fileprivate func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy.mm.dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
    return decoder
}
