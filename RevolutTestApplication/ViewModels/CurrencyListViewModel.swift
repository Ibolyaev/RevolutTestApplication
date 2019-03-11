//
//  CurrencyListViewModel.swift
//  RevolutTestApplication
//
//  Created by Admin on 28/02/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

class CurrencyListViewModel {
    // MARK: - Public properties
    var ratesViewModel = [CurrencyRateViewModel]()
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
    var updateInterval: TimeInterval = 1
    weak var delegate: CurrencyListViewModelDelegate?
    
    // MARK: - Private properties
    private var rates = [CurrencyRate]() {
        didSet {
            if ratesViewModel.isEmpty {
                ratesViewModel = rates.map {
                    CurrencyRateViewModel(currencyRate: $0, baseCurrencyRate: $0.rate)
                }
            } else {
                ratesViewModel.forEach { (viewModel) in
                    guard let newRate = rates.first(where: { (rate) -> Bool in
                        viewModel.currencyRate.currency == rate.currency
                    }) else {
                        return
                    }
                    viewModel.baseCurrencyRate = newRate.rate
                }
            }
            updateBaseCurrency()
            calculateRates()
            updateIndexes()
        }
    }
    private lazy var timer: Timer = {
        let timer = Timer(timeInterval: updateInterval)
        timer.eventHandler = {
            self.updateData()
        }
        return timer
    }()
    
    // MARK: - Init
    init(dataProvider: CurrencyListDataProvider) {
        self.dataProvider = dataProvider
        base = dataProvider.getDefaultCurrency()
    }
    deinit {
        timer.suspend()
    }
    
    // MARK: - Public methods
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
    
    // MARK: - Private methods
    private func calculateRates() {
        ratesViewModel.forEach {
            if $0.currencyRate.currency == base {
                $0.currencyRate.rate = rate
            }
            $0.currencyRate.rate = $0.baseCurrencyRate * rate
        }
    }
    private func updateBaseCurrency() {
        guard !ratesViewModel.isEmpty else {
            return
        }
        let currencyRate = CurrencyRate(currency: base, rate: rate)
        let index = ratesViewModel.firstIndex { $0.currencyRate == currencyRate }
        if let currencyIndex = index {
            ratesViewModel.remove(at: currencyIndex)
        }
        ratesViewModel.insert(CurrencyRateViewModel(currencyRate: currencyRate, baseCurrencyRate: 1), at: 0)
    }
    private func updateIndexes() {
        delegate?.updateData()
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

