//
//  ServiceManager.swift
//  ShoppingCart
//
//  Created by Kevin Yu on 1/10/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(Error)
}

typealias ResultCompletion = (Result<[Product]>)->()

class ServiceManager {
    
    private var manager: CoreDataManager
    private var queue: DispatchQueue
    
    // small Cache-like to keep track of what objects are currently being fetched
    // avoid redundant fetching of images
    private var currentlyFetching = Set<String>()
    
    init(manager: CoreDataManager,
         queue: DispatchQueue = DispatchQueue.global(qos: .background)) {
        self.manager = manager
        self.queue = queue
    }
    
    // for showing only items in the cart
    func fetchProductsFromCart() -> [Product] {
        if let products = self.manager.getShoppingCart().products {
            return products.allObjects as! [Product]
        }
        else { return [] }
    }
    
    func fetchProducts(_ success: @escaping ([Product])->(),
                       _ failure: @escaping ()->()) {
        let downloadTask = { [unowned self] in
            // arbitrarily download data from some service
            guard let data = ProductServiceFactory.defaultProductData() else {
                failure() ; return
            }
            
            // transform json response into products in background context
            self.manager.saveProducts(data)
            
            // get products on main context and return
            success(self.manager.getProducts() ?? [])
        }
        
        queue.asyncAfter(deadline: .now() + 1.5,
                         execute: downloadTask)
    }
    
    /// request to fetch an arbitrary image
    /// utilizes cache-like set to avoid making redundant calls
    /// retry logic would be nice to have, if the call fails?
    func fetchImage(_ product: Product, _ completion: @escaping ()->()) {
        let name = product.name
        if (currentlyFetching.contains(name)) { return }
        currentlyFetching.insert(name)
        
        let downloadTask = { [weak self] in
            let imageData = ProductServiceFactory.getImageData(name: name)
            product.image = imageData
            guard let strSelf = self else { completion() ; return }
            strSelf.currentlyFetching.remove(name)
            completion()
        }
        
        queue.asyncAfter(deadline: .now() + 0.5,
                         execute: downloadTask)
        
    }
}
