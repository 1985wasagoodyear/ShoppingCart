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
    
    @IBOutlet var imageView: UIImageView!

    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var removeButton: UIButton!
    
    weak var delegate: ChangeCountProtocol!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addButton.setImageContentMode()
        self.removeButton.setImageContentMode()
    }
    
    @IBAction func addAction(_ sender: Any) {
        self.delegate?.incrementCount(self.tag)
    }
    
    @IBAction func removeAction(_ sender: Any) {
        self.delegate?.decrementCount(self.tag)
    }
    
    func setup(info: ProductInfo, delegate: ChangeCountProtocol?, index: Int) {
        self.imageView.image = UIImage(named: "cheese") // UIImage(data: info.image)
        self.priceLabel.text = info.price + " (" + info.quantity + ")"
        
        self.delegate = delegate
        self.tag = index
    }
}
