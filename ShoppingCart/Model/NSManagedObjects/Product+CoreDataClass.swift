//
//  Product+CoreDataClass.swift
//  ShoppingCart
//
//  Created by Kevin Yu on 1/10/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//
//

import Foundation
import CoreData

public extension CodingUserInfoKey {
    // Helper property to retrieve the context
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}

@objc(Product)
public class Product: NSManagedObject, Decodable {
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case price = "price"
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Product", in: managedObjectContext) else {
                fatalError("ManagedObjectContext could not be found")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? "Bag"
        self.price = try container.decodeIfPresent(Float.self, forKey: .price) ?? 0.0
        self.quantity = 0
        self.image = nil
        self.cart = nil
    }
    
}
