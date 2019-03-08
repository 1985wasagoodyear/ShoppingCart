//
//  ProductsViewModel.swift
//  ShoppingCart
//
//  Created by Kevin Yu on 1/10/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import Foundation

private let MAXIMUM_ALLOWED_COUNT = 99
private let MINIMUM_ALLOWED_COUNT = 0

final class ProductsViewModel: ViewModel {
    
    fileprivate var products = [Product]() {
        didSet {
            self.updateUI()
        }
    }
    
    private var updateUI: ViewModelCallback!
    
    var productCount: Int {
        return products.count
    }
    var totalPrice: Double {
        return products.reduce(0.0) {$0 + (($1.quantity > 0) ? Double($1.price) * Double($1.quantity) : 0.0) }
    }
    var totalPriceString: String {
        return String.init(format: "$%.2f", totalPrice)
    }
    
    fileprivate var service: ServiceManager!
    fileprivate var coreData: CoreDataManager!
    
    // MARK: - Initialization
    
    init(manager: CoreDataManager,
         service: ServiceManager) {
        self.coreData = manager
        self.service = service
    }
    
    func setCallback(_ callback: @escaping ViewModelCallback) {
        self.updateUI = callback
    }
}

// MARK: - Load/Refresh Data

extension ProductsViewModel {
    
    func reload() {
        self.coreData.reload()
        self.updateUI()
    }
    
    /// Get images from Cart
    /// Only show items in ShoppingCart screen, with counts > 0
    /// Does not perform callback for UI
    func loadFromCart() {
        self.products = self.service.fetchProductsFromCart().filter { $0.quantity > 0 }
    }
    
    func loadProducts(_ success: @escaping ()->(),
                      _ failure: @escaping ()->()) {
        let productSuccess: ([Product])->() = { [weak self] products in
            success()
            self?.products = products
        }
        self.service.fetchProducts(productSuccess, failure)
    }
    
    /// simulates a long-running API call to perform payment operation
    func performPayment(_ completion: @escaping ()->()) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let products = self?.products else {
                completion()
                return
            }
            
            for product in products {
                product.quantity = 0
            }
            
            self?.coreData.save()
            completion()
        }
    }
}

// MARK: - Individual Product Info/Image Accessors

extension ProductsViewModel {
    
    func productCount(at index: Int) -> Int {
        return Int(self.products[index].quantity)
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
                    guard let data = product.image else { return }
                    completion(Data(referencing: data))
                }
                self.coreData.save()
            }
        }
        else {
            completion(Data(referencing: product.image!))
        }
    }
}

// MARK: - ChangeCountProtocol Delegate Methods

// should actually return some discardableResult BOOL to indicate failed change attempt
// for UI callbacks?

extension ProductsViewModel: ChangeCountProtocol {
    
    /// Increment the quantity, but do nothing if count would exceed MAXIMUM_ALLOWED_COUNT
    func incrementCount(_ index: Int) {
        let product = self.products[index]
        if product.quantity < MAXIMUM_ALLOWED_COUNT {
            product.quantity += 1
        }
        
        // create cart if necessary, add item to cart
        if (product.cart == nil) {
            product.cart = self.coreData.getShoppingCart()
        }
        self.coreData.save()
    }
    
    /// Decrement the quantity, but do nothing if count would be below MINIMUM_ALLOWED_COUNT
    func decrementCount(_ index: Int) {
        let product = self.products[index]
        if product.quantity > MINIMUM_ALLOWED_COUNT {
            product.quantity -= 1
        }
        
        // create cart if necessary, add item to cart
        if (product.cart == nil) {
            product.cart = self.coreData.getShoppingCart()
        }
        
        self.coreData.save()
    }
    
}
