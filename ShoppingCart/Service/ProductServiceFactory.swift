//
//  ProductServiceFactory.swift
//  ShoppingCart
//
//  Created by Kevin Yu on 1/10/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

final class ProductServiceFactory {
    
    /// Call to return arbitrary data from some service
    static func defaultProductData() -> [[String:Any]]? {
        guard let jsonPath = Bundle.main.path(forResource: "groceries",
                                              ofType: "json") else {
                                                return nil
        }
        let url = URL(fileURLWithPath: jsonPath)
        guard let data = try? Data(contentsOf: url) else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) else { return nil }
        return json as? [[String:Any]]
    }
    
    /// Call to return an arbitrary image from some service
    /// For this project, images are locally provided,
    /// with the same name as each product
    static func getImageData(name: String) -> NSData? {
        guard let image = UIImage(named: name) else {
            return nil
        }
        return NSData(data: image.pngData()!)
    }
    
}
