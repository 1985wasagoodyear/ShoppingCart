//
//  CoreDataManager.swift
//  UltraPokemonFlare
//
//  Created by Kevin Yu on 11/20/18.
//  Copyright © 2018 Kevin Yu. All rights reserved.
//

// this class handles all Core Data interactions
// remark that this is the only class that imports CoreData

// there exists a private MOC to create data and save it
// and we will have a main MOC to show data
// so main MOC is child of private MOC

import Foundation
import CoreData

final class CoreDataManager {
    
    // MARK: - Initialization
    
    init() {
        setupContexts()
    }
    
    // MARK: - Core Data stack
    
    fileprivate var backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    
    fileprivate var mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    private func setupContexts() {
        backgroundContext.persistentStoreCoordinator = self.persistentContainer.persistentStoreCoordinator
        
        mainContext.parent = backgroundContext
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ShoppingCart")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    /// Helper method to reload currently-loaded objects
    func reload() {
        mainContext.refreshAllObjects()
        backgroundContext.refreshAllObjects()
    }
    
    // MARK: - Core Data Saving support
    
    func save() {
        saveMainContext()
    }
    
    private func saveMainContext() {
        let context = mainContext
        context.perform {
            if context.hasChanges {
                do {
                    try context.save()
                    self.saveBackgroundContext()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
    
    private func saveBackgroundContext() {
        let context = backgroundContext
        if context.hasChanges {
            context.performAndWait {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
    
    // MARK: - Core Data Deletion Support
    
    func delete(_ item: NSManagedObject) {
        backgroundContext.delete(item)
        save()
    }
    
    /// Called to delete all items
    static func deleteAll() {
        let manager = CoreDataManager()
        let context = manager.backgroundContext
        context.performAndWait {
            let fetch1 = NSFetchRequest<Cart>(entityName: "Cart")
            do {
                let carts = try context.fetch(fetch1)
                carts.forEach { context.delete($0) }
            }
            catch { print("Error fetching Cart from Persistent Store") }
            let fetch2 = NSFetchRequest<Product>(entityName: "Product")
            do {
                let products = try context.fetch(fetch2)
                products.forEach { context.delete($0) }
            }
            catch { print("Error fetching Product from Persistent Store") }
            
            manager.saveBackgroundContext()
        }
    }
    
}

// MARK: - Shopping Cart Accessors

extension CoreDataManager {
    
    private func newCart(in context: NSManagedObjectContext) -> Cart {
        let cart = Cart(context: context)
        cart.date = NSDate()
        save()
        return cart
    }
    
    func getShoppingCart() -> Cart {
        let context = mainContext
        let fetch = NSFetchRequest<Cart>(entityName: "Cart")
        do {
            if let cart = try context.fetch(fetch).first { return cart }
        }
        catch { print("Error fetching Cart from Persistent Store") }
        
        return newCart(in: context)
    }
}

// MARK: Product Accessors

extension CoreDataManager {
    
    /// to be performed on main thread
    func getProducts() -> [Product]? {
        let context = mainContext
        let fetch = NSFetchRequest<Product>(entityName: "Product")
        do {
            let products = try context.fetch(fetch)
            return products
        } catch {
            print("Error fetching Product from Persistent Store")
            return nil
        }
    }
    
    /// to be performed on background thread
    func saveProducts(_ jsonArray: [[String:Any]]?) {
        guard let json = jsonArray else { return }
        
        let context = backgroundContext
        let fetch = NSFetchRequest<Product>(entityName: "Product")
        var products: [Product]! = nil
        do {
            products = try context.fetch(fetch)
        }
        catch { print("Error fetching Product from Persistent Store for update") }
        
        var allNames = Set<String>()
        allNames.reserveCapacity(products.capacity)
        products.forEach { allNames.insert($0.name) }
        
        for item in json {
            if let name = item["name"] as? String {
                // create new item if does not exist
                if allNames.contains(name) == false {
                    if let price = item["price"] as? Double {
                        let newItem = Product(context: context)
                        newItem.name = name
                        newItem.price = Float(price)
                        newItem.quantity = 0
                    }
                }
            }
        }
        saveBackgroundContext()
    }
    
}
