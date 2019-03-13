//
//  CurrencyTextFieldTextAttributes.swift
//  RevolutTestApplication
//
//  Created by Admin on 13/03/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import UIKit
class CurrencyTextFieldTextAttributes {
    static let paragraphStyle: NSMutableParagraphStyle = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        return paragraphStyle
    }()
    static let selectedAttributes: [NSAttributedString.Key : Any] = {
        
        return [.underlineStyle : NSUnderlineStyle.single.rawValue,
                                           .underlineColor : UIColor.blue,
                                           .paragraphStyle : paragraphStyle]
    }()
    static let defaultAttributes: [NSAttributedString.Key : Any] = {
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .right
        return [.underlineStyle : NSUnderlineStyle.single.rawValue,
                                                    .underlineColor : UIColor.lightGray,
                                                    .paragraphStyle: paragraphStyle]
    }()
}
