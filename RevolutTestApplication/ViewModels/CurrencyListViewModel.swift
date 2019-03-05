//
//  CurrencyListViewModel.swift
//  RevolutTestApplication
//
//  Created by Admin on 28/02/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

class CurrencyListViewModel {
    var list: [[CurrencyRate]]
    private var listResult: CurrenciesList? {
        didSet {
            guard let listResult = listResult, listResult.base == baseCurrencyRate.currency else {
                return
            }
            list.removeAll()
            list.append([CurrencyRate(currency: listResult.base, rate: baseCurrencyRate.rate)])
            list.append(listResult.rates.map({CurrencyRate(currency: $0.currency, rate: $0.rate * baseCurrencyRate.rate) }))
            delegate?.finishFetchingData()
        }
    }
    var updateInterval: TimeInterval = 2
    private var timer: Timer
    var dataProvider: CurrencyListDataProvider
    var baseCurrencyRate: CurrencyRate {
        didSet {
            let index = list[1].firstIndex { (rate) -> Bool in
                rate.currency == baseCurrencyRate.currency
            }
            guard let currencyIndex = index else {
                return
            }
            list[1].remove(at: currencyIndex)
            list[1].insert(list[0][0], at: 0)
            list[0][0] = baseCurrencyRate
        }
    }
    
    weak var delegate: CurrencyListViewModelDelegate?
    
    init(dataProvider: CurrencyListDataProvider) {
        var baseCurrency: Currency
        let locale = Locale.current
        // Ideally we need to add some function which would compare currencies that we are currently support and user's current locale currency
        // and if we dont support it yet, just return some default value
        if let currencyCode = locale.currencyCode {
            baseCurrency = currencyCode
        } else {
            baseCurrency = Api.defaultBaseCurrency
        }
        baseCurrencyRate = CurrencyRate(currency: baseCurrency, rate: 1)
        list = [[CurrencyRate]]()
        list.append([baseCurrencyRate])
        self.dataProvider = dataProvider
        self.timer = Timer(timeInterval: updateInterval)
        timer.eventHandler = {
            self.updateData()
        }
        timer.resume()
    }
    deinit {
        timer.suspend()
    }
    func getCurrencyRateViewModelFor(index: IndexPath) -> CurrencyRateViewModel {
        let result = CurrencyRateViewModel(currencyRate: list[index.section][index.row])
        result.currencyRateDidChange = self.currencyRateDidChange
        return result
    }
    func currencyRateDidChange(rateModel: CurrencyRateViewModel) {
        print("New rate is: \(rateModel.currencyRate.rate)")
        baseCurrencyRate.rate = Double(rateModel.currencyRate.rate)
        updateList()
    }
    func updateList() {
        updateData()
    }
    private func updateData() {
        self.delegate?.startFetchingData()
        dataProvider.getCurrencyList(for: baseCurrencyRate.currency) {[weak self] (list, error) in
            guard let listResult = list else {
                // show error
                return
            }
            self?.listResult = listResult
        }
    }
}
protocol CurrencyListViewModelDelegate: class {
    func startFetchingData()
    func finishFetchingData()
}
