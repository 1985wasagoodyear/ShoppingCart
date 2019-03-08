//
//  ProductTabBarController.swift
//  ShoppingCart
//
//  Created by Kevin Yu on 1/11/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

private enum ProductPaidState {
    case paid
    case cancelled
    case unknown
}

final class ProductTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    private var paidState: ProductPaidState = .unknown
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        determineIfShowMessage()
    }
    
    // MARK: - UI for Payment Confirmation
    
    private func determineIfShowMessage() {
        if paidState == .paid {
            showToast("Thank you for your purchase!")
        }
        else if paidState == .cancelled {
            showToast("Payment cancelled")
        }
        paidState = .unknown
    }
    
    private func showToast(_ message: String) {
        guard let vcs = viewControllers, vcs.count > selectedIndex else {
            return
            
        }
        let currentVC = vcs[selectedIndex]
        currentVC.showAlert(text: message)
    }
}

extension ProductTabBarController: PaymentDelegate {

    func finishPaymentFlow(sender: Any? = nil) {
        paidState = .paid
    }
    
    func cancelPaymentFlow(sender: Any? = nil) {
        paidState = .cancelled
    }
}
