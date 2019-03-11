//
//  CurrencyListViewModelDelegate.swift
//  RevolutTestApplication
//
//  Created by Admin on 07/03/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
protocol CurrencyListViewModelDelegate: class {
    func showError(error: Error?)
    func startFetchingData()
    func updateData()
    func moveItem(from oldPath: IndexPath, to newIndexPath: IndexPath)
}
