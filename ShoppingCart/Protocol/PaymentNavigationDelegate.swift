//
//  PaymentNavigationDelegate.swift
//  ShoppingCart
//
//  Created by Kevin Yu on 3/8/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

protocol PaymentNavigationDelegate: class {
    func startPaymentFlow()
    func finishPaymentFlow(sender: UIViewController)
    func cancelPaymentFlow(sender: UIViewController)
}

extension PaymentNavigationDelegate {
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
