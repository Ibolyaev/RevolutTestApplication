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
    private var isAnimatingScroll = false
    private var selectedCell: CurrencyRateCell? {
        didSet {
            makeSelectedCellFirstResponder()
        }
    }
    
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
    private func makeSelectedCellFirstResponder() {
        guard let selectedCell = self.selectedCell else {
            return
        }
        // If current tableView.contentOffset is (0.0) then cell on current screen and no need to wait until it become at top screen
        // then we could simply call becomeFirstResponder on textField
        if tableView?.contentOffset == CGPoint.zero {
            //selectedCell.setSelected(true, animated: false)
            selectedCell.rateTextField.becomeFirstResponder()
            self.selectedCell = nil
        }
    }
    private func showData(_ indexPath: [IndexPath]? = nil) {
        guard !isAnimatingScroll else {
            return
        }
        if let indexPath = indexPath {
            tableView.reloadRows(at: indexPath, with: UITableView.RowAnimation.none)
        } else {
           tableView.reloadData()
        }
        
    }
    func scrollToRow(indexPath: IndexPath) {
        isAnimatingScroll = (tableView.contentOffset != CGPoint.zero)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
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
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // For correct tableview display, we need to stop updating table, because row selection may occurs rows scrolling
        //self.isAnimatingScroll = true
        return indexPath
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRowAt(at: indexPath)
    }
}
extension CurrencyListViewController: UIScrollViewDelegate {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isAnimatingScroll = false
        // Now selected cell on top screen and we can call first responder on it
        self.selectedCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CurrencyRateCell
    }
}
// MARK: - UITextFieldDelegate
extension CurrencyListViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.defaultTextAttributes = CurrencyTextFieldTextAttributes.selectedAttributes
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
        self.isAnimatingScroll = true
        self.tableView.moveRow(at: oldPath, to: newIndexPath)
        self.isAnimatingScroll = false
        
        self.selectedCell = self.tableView.cellForRow(at: newIndexPath) as? CurrencyRateCell
        self.scrollToRow(indexPath: newIndexPath)
    }
    func startFetchingData() {
        // We could show activity indicator, but data updates every second so don't need any.
    }
    func updateData() {
        DispatchQueue.main.async {
            if self.inTheMiddleOfEditing {
                // We are going to update only visible cells, exept first one, becouse it is editing now
                let visibleCellsIndexPath = self.tableView.indexPathsForVisibleRows?.filter{ ($0.row != 0) }
                self.showData(visibleCellsIndexPath)
            } else {
                self.showData()
                self.makeSelectedCellFirstResponder()
            }
        }
    }
}
