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
    @IBOutlet var currencyName: UILabel!
    @IBOutlet var currencyCodeLabel: UILabel!
    @IBOutlet var countryImageView: UIImageView!
    @IBOutlet var rateTextField: BindingTextField!  {
        didSet {
            rateTextField.bind {
                self.viewModel?.currencyRateDidChange?(Double($0) ?? 0)
            }
        }
    }
    var viewModel: CurrencyRateViewModel? {
        didSet {
            viewModel?.currency.bind(listener: { [unowned self] in
                self.currencyCodeLabel?.text = $0
            })
            viewModel?.rateText.bind(listener: { [unowned self] in
                self.rateTextField.text = $0
            })
            countryImageView?.image = UIImage(named: viewModel?.currencyImageName ?? "")
        }
    }
    override func awakeFromNib() {
        self.selectionStyle = .none
        self.rateTextField.textAlignment = .right
        countryImageView.clipsToBounds = true
        countryImageView.layer.cornerRadius = countryImageView.frame.width / 2
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            rateTextField.isUserInteractionEnabled = true
            rateTextField.becomeFirstResponder()
        }
    }
}
