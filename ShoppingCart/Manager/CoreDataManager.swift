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
    
    // MARK: - Core Data stack
    
    var backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    
    var mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    func setupContexts() {
        backgroundContext.persistentStoreCoordinator = self.persistentContainer.persistentStoreCoordinator
        
        mainContext.parent = backgroundContext
    }
    
    /*
    lazy var mainContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    */
    private lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "ShoppingCart")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    private func saveContext() {
        let context = self.mainContext
        if context.hasChanges {
            do {
                try context.save()
                self.saveBackgroundContext()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private func saveBackgroundContext() {
        let context = self.backgroundContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension CoreDataManager {
    // MARK: External Core Data Accessors
    
}
