//
//  AllProductsViewModel.swift
//  ShoppingCart
//
//  Created by Kevin Yu on 1/10/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import Foundation

typealias ViewModelCallback = ()->()

final class AllProductsViewModel {
    
    private var products = [Product]()
    
    private var updateUI: ViewModelCallback
    
    var productCount: Int {
        return products.count
    }
    
    private var service: ServiceManager!
    
    // MARK: - Initialization
    
    init(callback: @escaping ViewModelCallback) {
        self.service = ServiceManager(manager: CoreDataManager())
        self.updateUI = callback
    }
    
    init(manager: CoreDataManager,
         callback: @escaping ViewModelCallback) {
        self.service = ServiceManager(manager: manager)
        self.updateUI = callback
    }
    
    init(service: ServiceManager,
         callback: @escaping ViewModelCallback) {
        self.service = service
        self.updateUI = callback
    }
    
    // MARK: -
    
    func loadProducts(_ success: @escaping ()->(),
                      _ failure: @escaping ()->()) {
        let productSuccess: ([Product])->() = { [weak self] products in
            self?.products = products
            success()
            self?.updateUI()
        }
        self.service.fetchProducts(productSuccess, failure)
    }
    
    func productInfo(at index: Int) -> ProductInfo {
        let product = self.products[index]
        
        let imageData = (product.image != nil) ? Data(referencing: product.image!) : nil
        let nameStr = product.name!
        let priceStr = String(format: "$%.02f", product.price)
        let quantityStr = String(product.quantity)
        
        return (image: imageData,
                name: nameStr,
                price: priceStr,
                quantity: quantityStr)
    }
    
    func getImage(at index: Int, _ completion: @escaping (Data)->()) {
        let product = self.products[index]
        if product.image == nil {
            self.service.fetchImage(product) {
                completion(Data(referencing: product.image!))
            }
        }
        else {
            completion(Data(referencing: product.image!))
        }
    }
}

extension AllProductsViewModel: ChangeCountProtocol {
    func incrementCount(_ index: Int) {
        let product = self.products[index]
        if product.quantity < 99 {
            product.quantity += 1
        }
    }
    func decrementCount(_ index: Int) {
        let product = self.products[index]
        if product.quantity > 0 {
            product.quantity -= 1
        }
    }
    
}
