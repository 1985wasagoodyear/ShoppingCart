//
//  ShoppingListViewController.swift
//  ShoppingCart
//
//  Created by Kevin Yu on 1/9/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

final class ShoppingListViewController: UIViewController {

    @IBOutlet private var collectionView: UICollectionView!
    private var loadingIndicator: UIActivityIndicatorView!
    
    private var viewModel: AllProductsViewModel!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        self.setupViewModel()
        self.loadProducts()
    }

    // MARK: - Setup
    
    func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let nib = UINib(nibName: ProductCollectionViewCell.name,
                        bundle: nil)
        self.collectionView.register(nib,
                                     forCellWithReuseIdentifier: ProductCollectionViewCell.name)
    }
    
    func setupViewModel() {
        let callback: ViewModelCallback = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        self.viewModel = AllProductsViewModel(callback: callback)
    }

    func loadProducts() {
        self.loadingIndicator = UIActivityIndicatorView(style: .whiteLarge)
        self.loadingIndicator.color = .red
        self.view.addSubview(self.loadingIndicator)
        self.loadingIndicator.center = self.view.center
        self.loadingIndicator.hidesWhenStopped = true
        self.viewModel.loadProducts({
            DispatchQueue.main.async { [weak self] in
                self?.loadingIndicator.stopAnimating()
                self?.loadingIndicator.removeFromSuperview()
                self?.loadingIndicator = nil
            }
        }) { [weak self] in
            self?.loadingIndicator.stopAnimating()
            self?.loadingIndicator.removeFromSuperview()
            self?.loadingIndicator = nil
            // show some error here...?
        }
    }
}

extension ShoppingListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.productCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.name, for: indexPath) as! ProductCollectionViewCell
        
        let row = indexPath.row
        
        let productInfo = self.viewModel.productInfo(at: row)
        cell.setup(info: productInfo,
                   delegate: self,
                   index: row)
        
        if productInfo.image != nil {
            cell.imageView.image = UIImage(data: productInfo.image!)
        }
        else {
            cell.imageView.image = UIImage(named: "bag")
            self.viewModel.getImage(at: row) { [weak self] image in
                DispatchQueue.main.async {
                    cell.imageView.image = UIImage(data: image)
                    self?.reloadCell(at: row)
                }
            }
        }
        
        return cell
    }
}


extension ShoppingListViewController: ChangeCountProtocol {
    
    func incrementCount(_ index: Int) {
        self.viewModel.incrementCount(index)
        self.reloadCell(at: index)
    }
    
    func decrementCount(_ index: Int) {
        self.viewModel.decrementCount(index)
        self.reloadCell(at: index)
    }
    
    private func reloadCell(at index: Int) {
        UIView.setAnimationsEnabled(false)
        self.collectionView.performBatchUpdates({[unowned self] in
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
