//
//  CoreDataManager.swift
//  UltraPokemonFlare
//
//  Created by Kevin Yu on 11/20/18.
//  Copyright © 2018 Kevin Yu. All rights reserved.
//

// this class handles all Core Data interactions
// remark that this is the only class that imports CoreData

import Foundation
import CoreData

class CoreDataManager {
    
    init() {
        self.setupContexts()
    }
    
    
    static func deleteAll() {
        let manager = CoreDataManager()
        let context = manager.mainContext
        
        let fetch1 = NSFetchRequest<Cart>(entityName: "Cart")
        do {
            let carts = try context.fetch(fetch1)
            carts.forEach { context.delete($0) }
        } catch {
            print("Error fetching Cart from Persistent Store")
        }
        let fetch2 = NSFetchRequest<Product>(entityName: "Product")
        do {
            let products = try context.fetch(fetch2)
            products.forEach { context.delete($0) }
        } catch {
            print("Error fetching Product from Persistent Store")
        }
        
        manager.save()
    }
    
    // MARK: - Core Data stack
    
    var backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    
    var mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    func setupContexts() {
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
    
    // MARK: - Core Data Saving support
    
    func save() {
        self.saveBackgroundContext()
    }
    
    private func saveMainContext() {
        let context = self.mainContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private func saveBackgroundContext() {
        let context = self.backgroundContext
        if context.hasChanges {
            context.performAndWait {
                do {
                    try context.save()
                    self.saveMainContext()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
}

extension CoreDataManager {
    
    private func newCart(in context: NSManagedObjectContext) -> Cart {
        let cart = Cart(context: context)
        cart.date = NSDate()
        self.save()
        return cart
    }
    
    func getShoppingCart() -> Cart {
        let context = self.backgroundContext
        let fetch = NSFetchRequest<Cart>(entityName: "Cart")
        do {
            if let cart = try context.fetch(fetch).first {
                return cart
            }
        } catch {
            print("Error fetching Cart from Persistent Store")
        }
        
        return self.newCart(in: context)
    }
    
    // MARK: External Core Data Accessors (?)
    
    func getProducts() -> [Product]? {
        let context = self.backgroundContext
        let fetch = NSFetchRequest<Product>(entityName: "Product")
        do {
            let products = try context.fetch(fetch)
            return products
        } catch {
            print("Error fetching Product from Persistent Store")
            return nil
        }
    }
    
}
