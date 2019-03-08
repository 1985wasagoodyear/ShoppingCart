//
//  PaymentDelegate.swift
//  ShoppingCart
//
//  Created by Kevin Yu on 3/7/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import Foundation

protocol PaymentDelegate: class {
    func startPaymentFlow()
    func finishPaymentFlow(sender: Any?)
    func cancelPaymentFlow(sender: Any?)
}

extension PaymentDelegate {
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
