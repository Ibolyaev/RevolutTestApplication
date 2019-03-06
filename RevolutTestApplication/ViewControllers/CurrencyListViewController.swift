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
    
    // MARK: - IBOutlet
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Public properties
    var viewModel: CurrencyListViewModel!
   
    // MARK: - Private properties
    private var inTheMiddleOfEditing = false
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupViewModel()
    }
    
    // MARK: - IBAction
    // MARK: - Public methods
    
    // MARK: - Private methods
    private func setupViewModel() {
        viewModel.delegate = self
        viewModel.updateList()
    }
    private func setupTableView() {
        tableView.register(UINib(nibName: CurrencyRateCell.identifier, bundle: nil), forCellReuseIdentifier: CurrencyRateCell.identifier)
    }
}
extension CurrencyListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyRateCell.identifier, for: indexPath) as? CurrencyRateCell else {
            assertionFailure("Failed to get cell with identifier: \(CurrencyRateCell.identifier)")
            return UITableViewCell()
        }
        cell.viewModel = viewModel.getCurrencyRateViewModelFor(index: indexPath)
        cell.rateTextField.delegate = self
        cell.rateTextField.isUserInteractionEnabled = (indexPath.row == 0)
        return cell
    }
}

extension CurrencyListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRowAt(at: indexPath)
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
    func moveItem(from oldPath: IndexPath, to newIndexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.moveRow(at: oldPath, to: newIndexPath)
        tableView.endUpdates()
        tableView.scrollToRow(at: newIndexPath, at: UITableView.ScrollPosition.top, animated: true)
    }
    func startFetchingData() {
        //listViewModel.updateList()
    }
    func updateData(at: [IndexPath]) {
        if inTheMiddleOfEditing {
            tableView.reloadRows(at: at, with: UITableView.RowAnimation.none)
        } else {
            tableView.reloadData()
        }
    }
}
