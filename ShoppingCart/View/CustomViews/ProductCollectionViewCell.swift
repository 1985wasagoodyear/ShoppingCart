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
        self.addButton.setImageContentMode()
        self.removeButton.setImageContentMode()
    }
   
    // MARK: - Custom Action Methods
    
    @IBAction func addAction(_ sender: Any) {
        self.delegate?.incrementCount(self.tag)
    }
    
    @IBAction func removeAction(_ sender: Any) {
        self.delegate?.decrementCount(self.tag)
    }
    
    // MARK: - Setup Helper
    
    func setup(info: ProductInfo, delegate: ChangeCountProtocol?, index: Int) {
        if let imageData = info.image {
            self.imageView.image = UIImage(data: imageData)
        }
        else {
            self.imageView.image = UIImage(named: "bag")
        }
        self.priceLabel.text = info.price + " (" + info.quantity + ")"
        
        self.delegate = delegate
        self.tag = index
    }
}
