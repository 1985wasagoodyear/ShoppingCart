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
    
    func fetchProducts(_ success: @escaping ([Product])->(),
                       _ failure: @escaping ()->()) {
        let downloadTask = {
            guard let products = ProductServiceFactory.defaultProducts(self.manager) else {
                failure()
                return
            }
            success(products)
        }
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1.5,
                                                          execute: downloadTask)
    }
    
    func fetchImage(_ product: Product, _ completion: @escaping ()->()) {
        let name = product.name!
        if (self.currentlyFetching.contains(name)) {
            return
        }
        self.currentlyFetching.insert(name)
        let downloadTask = { [weak self] in
            let imageData = ProductServiceFactory.getImageData(name: product.name!)
            product.image = imageData
            self?.currentlyFetching.remove(name)
            completion()
        }
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5,
                                                          execute: downloadTask)
        
    }
}
