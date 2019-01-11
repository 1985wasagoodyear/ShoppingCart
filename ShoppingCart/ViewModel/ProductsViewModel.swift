//
//  ProductsViewModel.swift
//  ShoppingCart
//
//  Created by Kevin Yu on 1/10/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import Foundation

typealias ViewModelCallback = ()->()

final class ProductsViewModel {
    
    fileprivate var products = [Product]() {
        didSet {
            self.updateUI()
        }
    }
    
    private var updateUI: ViewModelCallback
    
    var productCount: Int {
        return products.count
    }
    
    fileprivate var service: ServiceManager!
    fileprivate var coreData: CoreDataManager!
    
    // MARK: - Initialization
    
    init(callback: @escaping ViewModelCallback) {
        self.coreData = CoreDataManager()
        self.service = ServiceManager(manager: coreData)
        self.updateUI = callback
    }
    
    init(manager: CoreDataManager,
         callback: @escaping ViewModelCallback) {
        self.coreData = manager
        self.service = ServiceManager(manager: manager)
        self.updateUI = callback
    }
    
    init(manager: CoreDataManager,
         service: ServiceManager,
         callback: @escaping ViewModelCallback) {
        self.coreData = manager
        self.service = service
        self.updateUI = callback
    }
}

// MARK: - Accessors and the like

extension ProductsViewModel {
    
    func loadCart() {
        self.products = self.service.fetchProductsFromCart()
    }
    
    func loadProducts(_ success: @escaping ()->(),
                      _ failure: @escaping ()->()) {
        let productSuccess: ([Product])->() = { [weak self] products in
            success()
            self?.products = products
        }
        self.service.fetchProducts(productSuccess, failure)
    }
    
    func productInfo(at index: Int) -> ProductInfo {
        let product = self.products[index]
        
        let imageData = (product.image != nil) ? Data(referencing: product.image!) : nil
        let nameStr = product.name
        let priceStr = String(format: "$%.02f", product.price)
        let totalPrice = String(format: "$%.02f", product.price * Float(product.quantity))
        let quantityStr = String(product.quantity)
        
        return (image: imageData,
                name: nameStr,
                price: priceStr,
                totalPrice: totalPrice,
                quantity: quantityStr)
    }
    
    func getImage(at index: Int, _ completion: @escaping (Data)->()) {
        let product = self.products[index]
        if product.image == nil {
            self.service.fetchImage(product) {
                DispatchQueue.main.async {
                    completion(Data(referencing: product.image!))
                }
                self.coreData.save()
            }
        }
        else {
            completion(Data(referencing: product.image!))
        }
    }
}

extension ProductsViewModel: ChangeCountProtocol {
    
    // need a way to avoid multiple fishes....
    
    func incrementCount(_ index: Int) {
        let product = self.products[index]
        if product.quantity < 99 {
            product.quantity += 1
        }
        
        // create cart if necessary, add item to cart
        if (self.products[index].cart == nil) {
            self.products[index].cart = self.coreData.getShoppingCart()
        }
        self.coreData.save()
    }
    func decrementCount(_ index: Int) {
        let product = self.products[index]
        if product.quantity > 0 {
            product.quantity -= 1
        }
        
        // create cart if necessary, add item to cart
        if (self.products[index].cart == nil) {
            self.products[index].cart = self.coreData.getShoppingCart()
        }
        self.coreData.save()
    }
    
}
