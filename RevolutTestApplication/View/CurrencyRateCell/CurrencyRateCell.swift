//
//  CurrencyRateCell.swift
//  RevolutTestApplication
//
//  Created by Admin on 28/02/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class CurrencyRateCell: UITableViewCell {
    static var identifier = "CurrencyRateCell"
    @IBOutlet var currencyCodeLabel: UILabel!
    @IBOutlet var countryImageView: UIImageView!
    @IBOutlet var rateTextField: BindingTextField! {
        didSet {
            rateTextField.bind {[unowned self] in
                if self.rateTextField.text?.isEmpty ?? true {
                    self.viewModel?.currencyRateDidChange?(0)
                    return
                }
                let numberString = $0.replacingOccurrences(of: ",", with: ".")
                guard let number = Double(numberString) else {
                    return
                }
                self.viewModel?.currencyRateDidChange?(number)
            }
        }
    }
    var viewModel: CurrencyRateViewModel? {
        didSet {
            self.viewModel?.currency.bind(listener: { [unowned self] in
                self.currencyCodeLabel?.text = $0
            })
            self.viewModel?.rateText.bind(listener: { [unowned self] in
                self.rateTextField.text = $0
            })
            self.countryImageView?.image = UIImage(named: self.viewModel?.currencyImageName.lowercased() ?? "")
        }
    }
    override func awakeFromNib() {
        self.selectionStyle = .none
        self.rateTextField.defaultTextAttributes = CurrencyTextFieldTextAttributes.defaultAttributes
    }
    override func layoutSubviews() {
        countryImageView.clipsToBounds = true
        countryImageView.layer.cornerRadius = countryImageView.frame.width / 2
        countryImageView.layer.borderWidth = 0.5
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            rateTextField.isUserInteractionEnabled = true
        }
    }
}
