//
//  CurrencyListViewModel.swift
//  RevolutTestApplication
//
//  Created by Admin on 28/02/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

class CurrencyListViewModel {
    var ratesViewModel = [CurrencyRateViewModel]()
    private var rates = [CurrencyRate]() {
        didSet {
            ratesViewModel = rates.map {
                CurrencyRateViewModel(currencyRate: $0, baseCurrencyRate: $0.rate)
            }
            calculateRates()
            updateBaseCurrency()
            updateIndexes()
        }
    }
    var updateInterval: TimeInterval = 3
    private lazy var timer: Timer = {
        let timer = Timer(timeInterval: updateInterval)
        timer.eventHandler = {
            self.updateData()
        }
        return timer
    }()
    var dataProvider: CurrencyListDataProvider
    var base: Currency {
        didSet {
            updateBaseCurrency()
            updateData()
        }
    }
    var rate: Double = 1 {
        didSet {
            calculateRates()
            updateIndexes()
        }
    }
    
    weak var delegate: CurrencyListViewModelDelegate?
    
    init(dataProvider: CurrencyListDataProvider) {
        self.dataProvider = dataProvider
        base = dataProvider.getDefaultCurrency()
    }
    deinit {
        timer.suspend()
    }
    private func calculateRates() {
        ratesViewModel.forEach {
            guard $0.currencyRate.currency != base else {
                return
            }
            $0.currencyRate.rate = $0.baseCurrencyRate * rate
        }
    }
    private func updateBaseCurrency() {
        let currencyRate = CurrencyRate(currency: base, rate: rate)
        let index = ratesViewModel.firstIndex { $0.currencyRate == currencyRate }
        if let currencyIndex = index {
            ratesViewModel.remove(at: currencyIndex)
        }        
        ratesViewModel.insert(CurrencyRateViewModel(currencyRate: currencyRate, baseCurrencyRate: 1), at: 0)
    }
    func updateIndexes() {
        // Prepare indexes for an update, we need to send message about updating all items
        var indexes = ratesViewModel.enumerated().map { IndexPath(row: $0.offset, section: 0) }
        indexes.remove(at: 0) // we dont want to update base item
        delegate?.updateData(at: indexes)
    }
    func moveBaseCurrencyToTop(from index: Int) {
        guard index != 0 else {
            return
        }
        
    }
    func didSelectRowAt(at indexPath: IndexPath) {
        guard indexPath.row != 0 else {
            return
        }
        let item = ratesViewModel[indexPath.row]
        base = item.currencyRate.currency
        rate = item.currencyRate.rate
        delegate?.moveItem(from: indexPath, to: IndexPath(row: 0, section: 0))
    }
    func getCurrencyRateViewModelFor(index: IndexPath) -> CurrencyRateViewModel {
        let result = ratesViewModel[index.row]
        result.currencyRateDidChange = self.currencyRateDidChange
        return result
    }
    func currencyRateDidChange(rate: Double) {
        self.rate = rate
    }
    func updateList() {
        updateData()
    }
    private func updateData() {        
        self.delegate?.startFetchingData()
        dataProvider.getCurrencyList(for: base) {[weak self] (list, error) in
            guard let listResult = list else {
                self?.delegate?.showError(error: error)
                return
            }
            // Make sure that base currency still the same
            guard self?.base == listResult.base else {
                return
            }
            self?.rates = listResult.rates
        }
        timer.resume()
    }
}
protocol CurrencyListViewModelDelegate: class {
    func showError(error: Error?)
    func startFetchingData()
    func updateData(at indexPath: [IndexPath])
    func moveItem(from oldPath: IndexPath, to newIndexPath: IndexPath)
}
