//
//  Box.swift
//  RevolutTestApplication
//
//  Created by Admin on 06/03/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

class BindingBox<T> {
    typealias Listener = (T) -> ()
    var value: T {
        didSet {
            listener?(value)
        }
    }
    var listener: Listener?
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    init(_ value: T) {
        self.value = value
    }    
}
