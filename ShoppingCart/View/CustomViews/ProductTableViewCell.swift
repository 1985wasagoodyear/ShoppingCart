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
    static let recommendedCellHeight: CGFloat = 100.0
    
    // MARK: - IBOutlets
    
    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var counterLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var removeButton: UIButton!
    
    weak var delegate: ChangeCountProtocol!
    
    // MARK: - Lifecycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
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
            productImageView.image = UIImage(data: imageData)
        }
        else {
            productImageView.image = UIImage(named: "bag")
        }
        priceLabel.text = info.price + " (" + info.quantity + ")"
        counterLabel.text = info.totalPrice
        self.delegate = delegate
        tag = index
    }
    
}


