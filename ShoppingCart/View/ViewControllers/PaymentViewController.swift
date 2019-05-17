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
    
    private var viewModel: ListViewModel!
    weak var paymentNavDelegate: PaymentNavigationDelegate!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadFromCart()
    }
    
    // MARK: - Setup Methods
    
    func setViewModel(_ newVM: ListViewModel) {
        let callback: ViewModelCallback = {
            DispatchQueue.main.async { [weak self] in
                guard let strSelf = self else { return }
                strSelf.priceLabel.text = strSelf.viewModel.totalPriceString
            }
        }
        viewModel = newVM
        viewModel.setCallback(callback)
    }

    // MARK: - Custom Action Methods
    
    @IBAction private func yesButtonAction(_ sender: Any) {
        showLoading()
        viewModel.performPayment {
            DispatchQueue.main.async { [weak self] in
                guard let strSelf = self else { return }
                strSelf.hideLoading()
                strSelf.paymentNavDelegate?.finishPaymentFlow(sender: strSelf)
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
