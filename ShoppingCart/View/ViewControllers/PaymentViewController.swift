//
//  PaymentViewController.swift
//  ShoppingCart
//
//  Created by Kevin Yu on 3/7/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

final class PaymentViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet private var priceLabel: UILabel!
    @IBOutlet private var loadingView: UIView!
    @IBOutlet private var loadingSpinner: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private var viewModel: ProductsViewModel!
    weak var paymentNavDelegate: PaymentNavigationDelegate!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadFromCart()
    }
    
    // MARK: - Setup Methods
    
    func setViewModel(_ viewModel: ProductsViewModel) {
        let callback: ViewModelCallback = { [weak self] in
            DispatchQueue.main.async {
                self?.priceLabel.text = viewModel.totalPriceString
            }
        }
        self.viewModel = viewModel
        self.viewModel.setCallback(callback)
    }

    // MARK: - Custom Action Methods
    
    @IBAction private func yesButtonAction(_ sender: Any) {
        showLoading()
        viewModel.performPayment { [weak self] in
            DispatchQueue.main.async {
                self?.hideLoading()
                if let strongSelf = self {
                    strongSelf.paymentNavDelegate?.finishPaymentFlow(sender: strongSelf)
                }
            }
        }
    }
    
    @IBAction private func noButtonAction(_ sender: Any) {
        paymentNavDelegate?.cancelPaymentFlow(sender: self)
    }
    
    // MARK: - Loading UI Helpers
    
    private func showLoading() {
        loadingView.isHidden = false
        loadingSpinner.startAnimating()
    }
    
    private func hideLoading() {
        loadingView.isHidden = true
        loadingSpinner.stopAnimating()
    }

}
