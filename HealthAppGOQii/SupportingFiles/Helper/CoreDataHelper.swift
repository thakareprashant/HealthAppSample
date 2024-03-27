//
//  CoreDataHelper.swift
//  HealthAppGOQii
//
//  Created by Apple on 26/03/24.
//

import Foundation
import UIKit
import CoreData

class CoreDataHelper {
    
    // MARK: - Core Data stack
    
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HealthAppGOQii")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    static var managedContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving support
    
    static func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Fetch Entities
    
    static func fetchEntities<T: NSManagedObject>(entityName: String, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            let entities = try managedContext.fetch(fetchRequest)
            return entities
        } catch {
            print("Failed to fetch entities: \(error)")
            return []
        }
    }
    
    // MARK: - Delete Entity
    
    
    static func deleteAllData(forEntityName entityName: String) {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try persistentContainer.viewContext.execute(deleteRequest)
                try persistentContainer.viewContext.save()
            } catch {
                print("Error deleting data: \(error)")
            }
        }
    static func delete(entity: NSManagedObject) {
        managedContext.delete(entity)
        saveContext()
    }
    
}




//class Water: NSManagedObject {
//    @NSManaged var time: Date
//    @NSManaged var litre: Int16
//}

