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
    
    private var paidState: ProductPaidState = .unknown {
        didSet {
            determineIfShowMessage()
        }
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - UI for Payment Confirmation
    
    private func determineIfShowMessage() {
        if paidState == .unknown { return }
        defer { paidState = .unknown }
        
        let message: String
        switch paidState {
            case .paid:
                message = "Thank you for your purchase!"
            case .cancelled:
                message = "Payment cancelled"
            case .unknown:
                return
           // default:
           //     message = "Error - Payment error occurred"
        }
        showToast(message)
    }
    
    private func showToast(_ message: String) {
        guard let vcs = viewControllers, vcs.count > selectedIndex else {
            return
        }
        let currentVC = vcs[selectedIndex]
        currentVC.showAlert(text: message)
    }
}

extension ProductTabBarController: PaymentHandler {

    func finishPaymentFlow() {
        paidState = .paid
    }
    
    func cancelPaymentFlow() {
        paidState = .cancelled
    }
}
