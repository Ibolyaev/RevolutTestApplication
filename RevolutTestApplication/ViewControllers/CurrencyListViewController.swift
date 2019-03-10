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
    
    // MARK: - Public methods
    func showAlertView(with text: String, title: String = "") {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
            })
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Private methods
    private func setupViewModel() {
        viewModel.delegate = self
        viewModel.updateList()
    }
    private func setupTableView() {
        tableView.register(UINib(nibName: CurrencyRateCell.identifier, bundle: nil), forCellReuseIdentifier: CurrencyRateCell.identifier)
    }
}
// MARK: - UITableViewDataSource
extension CurrencyListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.ratesViewModel.count
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
// MARK: - UITableViewDelegate
extension CurrencyListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRowAt(at: indexPath)
    }
}
// MARK: - UITextFieldDelegate
extension CurrencyListViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.inTheMiddleOfEditing = true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        self.inTheMiddleOfEditing = false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - CurrencyListViewModelDelegate
extension CurrencyListViewController: CurrencyListViewModelDelegate {
    func showError(error: Error?) {
        showAlertView(with: error?.localizedDescription ?? "Unkown error", title: "Problem")
    }
    func moveItem(from oldPath: IndexPath, to newIndexPath: IndexPath) {
        tableView.performBatchUpdates({
            self.tableView.moveRow(at: oldPath, to: newIndexPath)
        }) { (success) in
            self.tableView.cellForRow(at: newIndexPath)?.setSelected(true, animated: false)
            self.tableView.scrollToRow(at: newIndexPath, at: .top, animated: true)
        }
    }
    func startFetchingData() {
        // We could show activity indicator, but data updates every second so dont need any
        //print("startFetchingData")
    }
    func updateData(at: [IndexPath]) {
        DispatchQueue.main.async {
            if self.inTheMiddleOfEditing {
                self.tableView.reloadData()
                let newCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CurrencyRateCell
                newCell?.setSelected(true, animated: false)
                //newCell?.rateTextField.becomeFirstResponder()
            } else {
                self.tableView.reloadData()
            }
        }
    }
}
