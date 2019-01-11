//
//  ShoppingCartViewController.swift
//  ShoppingCart
//
//  Created by Kevin Yu on 1/10/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

final class ShoppingCartViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    private var viewModel: ProductsViewModel!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.loadFromCart()
    }
    
    // MARK: - Setup Methods
    
    func setupViewModel() {
        let callback: ViewModelCallback = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        self.viewModel = ProductsViewModel(callback: callback)
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let nib = UINib(nibName: ProductTableViewCell.name,
                        bundle: nil)
        self.tableView.register(nib,
                                forCellReuseIdentifier: ProductTableViewCell.name)
    }


}

extension ShoppingCartViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.productCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.name, for: indexPath) as! ProductTableViewCell
        let row = indexPath.row
        let info = self.viewModel.productInfo(at: row)
        cell.setup(info: info, delegate: self, index: row)
        if info.image == nil {
            self.viewModel.getImage(at: row) { [weak self] image in
                self?.reloadCell(at: row)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

extension ShoppingCartViewController: ChangeCountProtocol {
    
    func incrementCount(_ index: Int) {
        self.viewModel.incrementCount(index)
        self.reloadCell(at: index)
    }
    
    func decrementCount(_ index: Int) {
        self.viewModel.decrementCount(index)
        self.reloadCell(at: index)
    }
    
    private func reloadCell(at index: Int) {
        if #available(iOS 11.0, *) {
            UIView.setAnimationsEnabled(false)
            self.tableView.performBatchUpdates({[unowned self] in
                self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)],
                                          with: .automatic)
            }) { (finished) in
                if (finished == true) {
                    UIView.setAnimationsEnabled(true)
                }
            }
        } else {
            self.tableView.reloadData()
        }
    }
    
}
