//
//  CurrencyListViewController.swift
//  RevolutTestApplication
//
//  Created by Admin on 28/02/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import UIKit

class CurrencyListViewController: UIViewController {
    // MARK: - Custom types
    // MARK: - Identifiers
    let cellIdentifier = "CurrencyRateCell"
    // MARK: - Constants
    // MARK: - IBOutlet
    @IBOutlet var tableView: UITableView!
    // MARK: - Public properties
    
    var listViewModel: CurrencyListViewModel!
    // MARK: - Private properties
    private var inTheMiddleOfEditing = false
    // MARK: - Init
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CurrencyRateCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        listViewModel.delegate = self
        listViewModel.updateList()
    }
    
    // MARK: - IBAction
    // MARK: - Public methods
    func updateTableViewRows(at indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
        tableView.moveRow(at: IndexPath(row: 0, section: 0), to: IndexPath(row: 0, section: 1))
        tableView.endUpdates()
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true) // NOT working ?
    }
    /*func updateBaseItemRate(rate: String) {
        listViewModel.rate = Double(rate) ?? 0
    }*/
    
    // MARK: - Private methods
    // MARK: - Navigation
}
extension CurrencyListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return listViewModel.list.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.list[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CurrencyRateCell else {
            assertionFailure("Failed to get cell CurrencyRateCell")
            return UITableViewCell()
        }
        cell.viewModel = listViewModel.getCurrencyRateViewModelFor(index: indexPath)
        cell.rateTextField.delegate = self
        cell.rateTextField.isUserInteractionEnabled = (indexPath.section == 0)
        return cell
    }
}

extension CurrencyListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section != 0 else {
            return
        }
        let item = listViewModel.list[indexPath.section][indexPath.row]
        listViewModel.baseCurrencyRate = item
        updateTableViewRows(at: indexPath)
    }
}

extension CurrencyListViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.inTheMiddleOfEditing = true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        self.inTheMiddleOfEditing = false
    }
}

extension CurrencyListViewController: CurrencyListViewModelDelegate {
    func startFetchingData() {
        //listViewModel.updateList()
    }
    
    func finishFetchingData() {
        if inTheMiddleOfEditing {
            tableView.reloadSections(IndexSet(integer: 1), with: UITableView.RowAnimation.none)
        } else {
            tableView.reloadData()
        }
        
    }
}
