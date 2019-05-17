//
//  ProductCollectionViewCell.swift
//  ShoppingCart
//
//  Created by Kevin Yu on 1/10/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    static let name = "ProductCollectionViewCell"
    
    // MARK: - IBOutlets
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var removeButton: UIButton!
    
    weak var delegate: ChangeCountProtocol!
    
    // MARK: - Lifecycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addButton.setImageContentMode()
        removeButton.setImageContentMode()
    }
   
    // MARK: - Custom Action Methods
    
    @IBAction func addAction(_ sender: Any) {
        delegate?.incrementCount(tag)
    }
    
    @IBAction func removeAction(_ sender: Any) {
        delegate?.decrementCount(tag)
    }
    
    // MARK: - Setup Helper
    
    func setup(info: ProductInfo, delegate: ChangeCountProtocol?, index: Int) {
        if let imageData = info.image {
            imageView.image = UIImage(data: imageData)
        }
        else {
            imageView.image = UIImage(named: "bag")
        }
        priceLabel.text = info.price + " (" + info.quantity + ")"
        
        self.delegate = delegate
        tag = index
    }
    
}
