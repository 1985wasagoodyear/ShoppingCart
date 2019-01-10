//
//  ShoppingListViewController.swift
//  ShoppingCart
//
//  Created by Kevin Yu on 1/9/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

class ShoppingListViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }


}

extension ShoppingListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
}
