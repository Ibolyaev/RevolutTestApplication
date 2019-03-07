//
//  CurrencyListViewModelProtocol.swift
//  RevolutTestApplication
//
//  Created by Admin on 06/03/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

protocol CurrencyListViewModelProtocol {
    var base: Currency { get set }
    var rate: Double { get set }
    var rates: [CurrencyRate] { get set }
}
