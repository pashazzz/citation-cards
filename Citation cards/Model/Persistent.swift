//
//  Persistent.swift
//  Citation cards
//
//  Created by Pavlo Malyshkin on 19.1.2024.
//

import Foundation
import CoreData

struct Persistent {
    // MARK: - Core Data stack
    static let container: NSPersistentContainer = NSPersistentContainer(name: "Citation_cards")
    static let context: NSManagedObjectContext = container.viewContext
    
    init() {
        let url = URL.storeURL(for: "group.com.sky-labs.Citation-cards", databaseName: "Citation_cards")
        let storeDescription = NSPersistentStoreDescription(url: url)
        Persistent.container.persistentStoreDescriptions = [storeDescription]
        
        Persistent.container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        Persistent.container.viewContext.automaticallyMergesChangesFromParent = true
    }

    // MARK: - Core Data Saving support

    mutating func saveContext () {
        if Persistent.context.hasChanges {
            do {
                try Persistent.context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

public extension URL {
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Unable to create URL for \(appGroup)")
        }
        
        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
