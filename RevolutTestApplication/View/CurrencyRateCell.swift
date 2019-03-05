//
//  CurrencyRateCell.swift
//  RevolutTestApplication
//
//  Created by Admin on 28/02/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class CurrencyRateCell: UITableViewCell {
    @IBOutlet var currencyName: UILabel!
    @IBOutlet var currencyCodeLabel: UILabel!
    @IBOutlet var countryImageView: UIImageView!
    @IBOutlet var rateTextField: UITextField!    
    @IBAction func rateEditingChanged(_ sender: UITextField) {
        viewModel?.currencyRate.rate = Double(sender.text ?? "") ?? 0
    }
    var viewModel: CurrencyRateViewModel? {
        didSet {
            rateTextField?.text = viewModel?.rateText
            currencyCodeLabel?.text = viewModel?.currencyRate.currency
        }
    }
    override func awakeFromNib() {
        self.selectionStyle = .none
        self.rateTextField.textAlignment = .right
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            rateTextField.isUserInteractionEnabled = true
            rateTextField.becomeFirstResponder()
        }
    }
}
extension CurrencyRateCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //self.inTheMiddleOfEditing = true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        //self.inTheMiddleOfEditing = false
       // self.updateBaseItem()
    }
}
