//
//  ProductTableViewCell.swift
//  ShoppingCart
//
//  Created by Kevin Yu on 1/10/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    static let name = "ProductTableViewCell"
    
    @IBOutlet var productImageView: UIImageView!
    
    @IBOutlet var counterLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var removeButton: UIButton!
    
    weak var delegate: ChangeCountProtocol!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
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
        if let imageData = info.image {
            self.productImageView.image = UIImage(data: imageData)
        }
        else {
            self.productImageView.image = UIImage(named: "bag")
        }
        self.priceLabel.text = info.price + " (" + info.quantity + ")"
        self.counterLabel.text = info.totalPrice
        self.delegate = delegate
        self.tag = index
    }
}
