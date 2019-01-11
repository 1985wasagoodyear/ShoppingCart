//
//  ServiceManager.swift
//  ShoppingCart
//
//  Created by Kevin Yu on 1/10/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import Foundation

class ServiceManager {
    
    private var manager: CoreDataManager!
    
    private var currentlyFetching = Set<String>()
    
    init(manager: CoreDataManager) {
        self.manager = manager
    }
    
    func fetchProductsFromCart() -> [Product] {
        if let products = self.manager.getShoppingCart().products {
            return products.allObjects as! [Product]
        } else {
            return []
        }
    }
    
    func fetchProducts(_ success: @escaping ([Product])->(),
                       _ failure: @escaping ()->()) {
        let downloadTask = { [unowned self] in
            guard let products = ProductServiceFactory.defaultProducts(self.manager) else {
                failure()
                return
            }
           // success(products)
            //return
            
            // upon completion of downloading:
            
            // if there are existing products
            // bind products with existing products
            // and return the union
            if var savedProducts = self.manager.getProducts() {
                var prodDict = [String:Int16]()
                prodDict.reserveCapacity(savedProducts.count)
                var savedDict = [String:Product]()
                savedDict.reserveCapacity(savedProducts.count)
                for product in savedProducts {
                    prodDict[product.name] = product.quantity
                    savedDict[product.name] = product
                }
                for product in products {
                    if prodDict[product.name] != nil {
                        savedDict[product.name]?.price = product.price
                        self.manager.delete(product)
                    }
                    else {
                        savedProducts.append(product)
                    }
                }
                success(savedProducts)
            }
            else {
                // return only the new products
                success(products)
            }
            
        }
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1.5,
                                                          execute: downloadTask)
    }
    
    func fetchImage(_ product: Product, _ completion: @escaping ()->()) {
        let name = product.name
        if (self.currentlyFetching.contains(name)) {
            return
        }
        self.currentlyFetching.insert(name)
        let downloadTask = { [weak self] in
            let imageData = ProductServiceFactory.getImageData(name: name)
            product.image = imageData
            self?.currentlyFetching.remove(name)
            completion()
        }
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5,
                                                          execute: downloadTask)
        
    }
}
