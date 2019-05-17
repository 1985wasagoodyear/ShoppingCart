//
//  ShoppingListViewController.swift
//  ShoppingCart
//
//  Created by Kevin Yu on 1/9/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

final class ShoppingListViewController: UIViewController {

    // MARK: - IBOutlets & UI
    
    @IBOutlet private var collectionView: UICollectionView! {
        didSet { setupCollectionView() }
    }
    private var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private var viewModel: (ListViewModel & ChangeCountProtocol)! {
        didSet { loadProducts() }
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.reload()
    }

    // MARK: - Setup
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: ProductCollectionViewCell.name,
                        bundle: nil)
        collectionView.register(nib,
                                forCellWithReuseIdentifier: ProductCollectionViewCell.name)
    }
    
    func setViewModel(_ newVM: (ChangeCountProtocol & ListViewModel)) {
        let callback: ViewModelCallback = {
            DispatchQueue.main.async { [weak self] in
                guard let strSelf = self else { return }
                strSelf.collectionView.reloadData()
            }
        }
        viewModel = newVM
        viewModel.setCallback(callback)
    }

    private func loadProducts() {
        self.loadingIndicator = UIActivityIndicatorView(style: .whiteLarge)
        self.loadingIndicator.color = .red
        self.view.addSubview(self.loadingIndicator)
        self.loadingIndicator.center = self.view.center
        self.loadingIndicator.hidesWhenStopped = true
        self.loadingIndicator.startAnimating()
        self.viewModel.loadProducts({
            DispatchQueue.main.async { [weak self] in
                guard let strSelf = self else { return }
                strSelf.loadingIndicator.stopAnimating()
                strSelf.loadingIndicator.removeFromSuperview()
                strSelf.loadingIndicator = nil
            }
        }) { [weak self] in
            guard let strSelf = self else { return }
            strSelf.loadingIndicator.stopAnimating()
            strSelf.loadingIndicator.removeFromSuperview()
            strSelf.loadingIndicator = nil
            // show some error here...?
        }
    }
}

extension ShoppingListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.productCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.name, for: indexPath) as! ProductCollectionViewCell
        
        let row = indexPath.row
        
        let productInfo = viewModel.productInfo(at: row)
        cell.setup(info: productInfo,
                   delegate: self,
                   index: row)
        
        if productInfo.image == nil {
            viewModel.getImage(at: row) { [weak self] image in
                guard let strSelf = self else { return }
                strSelf.reloadCell(at: row)
            }
        }
        
        return cell
    }
}


extension ShoppingListViewController: ChangeCountProtocol {
    
    func incrementCount(_ index: Int) {
        viewModel.incrementCount(index)
        reloadCell(at: index)
    }
    
    func decrementCount(_ index: Int) {
        viewModel.decrementCount(index)
        reloadCell(at: index)
    }
    
    private func reloadCell(at index: Int) {
        UIView.setAnimationsEnabled(false)
        collectionView.performBatchUpdates({
            self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
        }) { (finished) in
            if (finished == true) {
                UIView.setAnimationsEnabled(true)
            }
        }
    }
    
}

extension ShoppingListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width / 2.0
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
}

