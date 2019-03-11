//
//  CurrencyListViewModelTest.swift
//  RevolutTestApplicationTests
//
//  Created by Admin on 11/03/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import XCTest
@testable import RevolutTestApplication

class CurrencyListViewModelTest: XCTestCase {

    var viewModel: CurrencyListViewModel!
    
    override func setUp() {
        super.setUp()
        let dataProvider = CurrencyListDataProviderMock()
        viewModel = CurrencyListViewModel(dataProvider: dataProvider)
        viewModel.updateList()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testdidSelectRowAt() {
        viewModel.didSelectRowAt(at: IndexPath(row: 2, section: 0))
        let first = viewModel.ratesViewModel.first
        XCTAssert(first?.currencyRate.currency != ApiMock.defaultBaseCurrency)
    }
    
    func testSetNewBaseCurrency() {
        viewModel.base = Currency("USD")
        let first = viewModel.ratesViewModel.first
        XCTAssert(first?.currencyRate.currency == Currency("USD"))
    }
    
    func testCurrencyRateDidChange() {
        let newRate: Double = 100
        viewModel.currencyRateDidChange(rate: newRate)
        XCTAssert(viewModel.ratesViewModel.last!.currencyRate.rate == (viewModel.ratesViewModel.last!.baseCurrencyRate * newRate))
    }
}
