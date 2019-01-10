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
    
    static let shared = CoreDataManager()
    
    
    private init() {
        self.setupContexts()
        // on startup, check if a Trainer exists
        // determine to show the game if there is a player
        let fetchRequest = NSFetchRequest<Trainer>(entityName: "Trainer")
        do {
            let result = try mainContext.fetch(fetchRequest)
            if result.count > 0 {
                self.trainer = result.first
            }
        }
        catch { print("Error: \(error)") }
    }
    
    // MARK: External Core Data Accessors
    
    func trainerExists() -> Bool {
        return !(self.trainer == nil)
    }
    
    func deleteTrainer() {
        self.mainContext.delete(self.trainer)
        self.trainer = nil
        self.saveContext()
    }
    
    func trainerName() -> String {
        return self.trainer.name!
    }
    
    func trainerImage() -> Data {
        return Data(referencing: self.trainer.image!)
    }
    
    func currentPokemon() -> [CorePokemon] {
        if let allPokemon = self.trainer.pokemon?.array as? [CorePokemon] {
            return allPokemon
        }
        else {
            return []
        }
    }
    
    
    // MARK: - Core Data stack
    
    private var backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    
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
    
    func saveContext() {
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
    
    func saveBackgroundContext() {
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
    
}
