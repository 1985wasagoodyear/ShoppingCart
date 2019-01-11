//
//  ProductServiceFactory.swift
//  ShoppingCart
//
//  Created by Kevin Yu on 1/10/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

class ProductServiceFactory {
    static func defaultProducts(_ manager: CoreDataManager) -> [Product]? {
        guard let jsonPath = Bundle.main.path(forResource: "groceries",
                                              ofType: "json") else {
            return nil
        }
        do {
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: jsonPath))
            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey.managedObjectContext!] = manager.backgroundContext
            let json = try decoder.decode([Product].self, from: jsonData)
            print(json.count)
            return json
        }
        catch {
            print(error)
            return nil
        }
    }
    
    static func getImageData(name: String) -> NSData {
        return NSData(data: UIImage(named: name)!.pngData()!)
    }
}
