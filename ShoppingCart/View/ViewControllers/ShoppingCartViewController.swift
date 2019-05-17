//
//  ShoppingCartViewController.swift
//  ShoppingCart
//
//  Created by Kevin Yu on 1/10/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

final class ShoppingCartViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet var tableView: UITableView! {
        didSet { setupTableView() }
    }
    @IBOutlet var payNowButton: UIButton! {
        didSet { setupPayNowButton() }
    }
    
    // MARK: - Properties
    
    private var viewModel: (ListViewModel & ChangeCountProtocol)!
    weak var paymentNavDelegate: PaymentNavigationDelegate!
    var blankCell = UITableViewCell()
    
    // MARK: - Lifecycle Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadFromCart()
    }
    
    // MARK: - Setup Methods
    
    func setViewModel(_ newVM: (ChangeCountProtocol & ListViewModel)) {
        let callback: ViewModelCallback = {
            DispatchQueue.main.async { [weak self] in
                guard let strSelf = self else { return }
                strSelf.tableView.reloadData()
                strSelf.payNowButton.isEnabled = strSelf.viewModel.productCount > 0
            }
        }
        viewModel = newVM
        viewModel.setCallback(callback)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = ProductTableViewCell.recommendedCellHeight
        let nib = UINib(nibName: ProductTableViewCell.name,
                        bundle: nil)
        tableView.register(nib,
                           forCellReuseIdentifier: ProductTableViewCell.name)
    }
    
    private func setupPayNowButton() {
        payNowButton.layer.cornerRadius = 30.0
        payNowButton.layer.masksToBounds = false
        payNowButton.titleLabel?.numberOfLines = 0
        payNowButton.titleLabel?.adjustsFontSizeToFitWidth = true
        payNowButton.titleLabel?.textAlignment = .center
        payNowButton.dropShadow()
    }

    // MARK: - Custom Action Methods

    @IBAction func payNowButtonAction(_ sender: UIButton) {
        paymentNavDelegate?.startPaymentFlow()
    }
}

extension ShoppingCartViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? viewModel.productCount : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return productCell(atIndexPath: indexPath)
        default:
            return blankCell
        }
    }
    
    private func productCell(atIndexPath indexPath: IndexPath) -> ProductTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.name, for: indexPath) as! ProductTableViewCell
        let row = indexPath.row
        let info = viewModel.productInfo(at: row)
        cell.setup(info: info, delegate: self, index: row)
        if info.image == nil {
            viewModel.getImage(at: row) { [weak self] image in
                self?.reloadCell(at: row)
            }
        }
        return cell
    }
    
}

extension ShoppingCartViewController: ChangeCountProtocol {
    
    func incrementCount(_ index: Int) {
        viewModel.incrementCount(index)
        reloadCell(at: index)
    }
    
    func decrementCount(_ index: Int) {
        viewModel.decrementCount(index)
        if viewModel.productCount(at: index) == 0 {
            viewModel.loadFromCart()
        }
        reloadCell(at: index)
    }
    
    private func reloadCell(at index: Int) {
        let basicReload: ()->Void = { self.tableView.reloadData() }
        if #available(iOS 11.0, *) {
            let indices = [IndexPath(row: index, section: 0)]
            if tableView.numberOfRows(inSection: 0) == viewModel.productCount {
                tableView.reloadRows(at: indices, with: .fade)
            }
            else {
                tableView.beginUpdates()
                tableView.deleteRows(at: indices, with: .fade)
                tableView.endUpdates()
            }
        }
        else { basicReload() }
    }
    
}
