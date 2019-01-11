//
//  Product+CoreDataProperties.swift
//  ShoppingCart
//
//  Created by Kevin Yu on 1/10/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var image: NSData?
    @NSManaged public var name: String
    @NSManaged public var price: Float
    @NSManaged public var quantity: Int16
    @NSManaged public var cart: Cart?

}
