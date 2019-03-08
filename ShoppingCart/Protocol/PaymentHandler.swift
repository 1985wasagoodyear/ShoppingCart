//
//  PaymentHandler.swift
//  ShoppingCart
//
//  Created by Kevin Yu on 3/7/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import Foundation

protocol PaymentHandler: class {
    func startPaymentFlow()
    func finishPaymentFlow()
    func cancelPaymentFlow()
}

extension PaymentHandler {
    func startPaymentFlow() {
        print("Unimplemented")
    }
    func finishPaymentFlow() {
        print("Unimplemented")
    }
    func cancelPaymentFlow() {
        print("Unimplemented")
    }
}
