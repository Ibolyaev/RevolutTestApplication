//
//  CurrencyListViewModel.swift
//  RevolutTestApplication
//
//  Created by Admin on 28/02/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

class CurrencyListViewModel {
    var list: [CurrencyRateViewModel]
    private var listResult: CurrenciesList? {
        didSet {
            guard let listResult = listResult, listResult.base == base.currency else {
                return
            }
            list.removeAll()
            let currencyRateViewModelList: [CurrencyRateViewModel] = listResult.rates.map {
                let newRate = CurrencyRate(currency: $0.currency, rate: $0.rate * base.rate)
                return CurrencyRateViewModel(currencyRate: newRate)
            }
            list.append(CurrencyRateViewModel(currencyRate: base))
            list += currencyRateViewModelList
            
            // Prepate undexes for update, we need to send message about updating all rows but base one
            var indexes = list.enumerated().map { IndexPath(row: $0.offset, section: 0) }
            indexes.remove(at: 0) // we dont want to update base item
            
            delegate?.updateData(at: indexes)
        }
    }
    var updateInterval: TimeInterval = 2
    private lazy var timer: Timer = {
        let timer = Timer(timeInterval: updateInterval)
        timer.eventHandler = {
            self.updateData()
        }
        return timer
    }()
    var dataProvider: CurrencyListDataProvider
    var base: CurrencyRate {
        didSet {
            let index = list.firstIndex {
                $0.currencyRate.currency == base.currency
            }
            guard let currencyIndex = index, currencyIndex != 0 else {
                return
            }
            list.remove(at: currencyIndex)
            list.insert(list[0], at: 0)
            list[0] = CurrencyRateViewModel(currencyRate: base)
            delegate?.moveItem(from: IndexPath(row: currencyIndex, section: 0), to: IndexPath(row: 0, section: 0))
        }
    }
    
    weak var delegate: CurrencyListViewModelDelegate?
    
    init(dataProvider: CurrencyListDataProvider) {
        self.dataProvider = dataProvider
        base = dataProvider.getDefaultCurrencyRate()
        
        // Create list model with base currency rate
        list = [CurrencyRateViewModel]()
        list.append(CurrencyRateViewModel(currencyRate: base))
    }
    deinit {
        timer.suspend()
    }
    func didSelectRowAt(at indexPath: IndexPath) {
        guard indexPath.row != 0 else {
            return
        }
        let item = list[indexPath.row]
        base = item.currencyRate
    }
    func getCurrencyRateViewModelFor(index: IndexPath) -> CurrencyRateViewModel {
        let result = list[index.row]
        result.currencyRateDidChange = self.currencyRateDidChange
        return result
    }
    func currencyRateDidChange(rateModel: CurrencyRateViewModel) {
        base.rate = Double(rateModel.currencyRate.rate)
    }
    func updateList() {
        updateData()
    }
    private func updateData() {
        timer.resume()
        self.delegate?.startFetchingData()
        dataProvider.getCurrencyList(for: base.currency) {[weak self] (list, error) in
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
    func updateData(at indexPath: [IndexPath])
    func moveItem(from oldPath: IndexPath, to newIndexPath: IndexPath)
}
