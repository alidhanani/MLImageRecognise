//
//  CoreDataWork.swift
//  MLTryApp
//
//  Created by Ali Dhanani on 14/02/2019.
//  Copyright © 2019 Ali Dhanani. All rights reserved.
//

import Foundation
import CoreData

class CoreDataWork {
    
    private init() {}
    
    static let shared = CoreDataWork()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MLTryApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context = persistentContainer.viewContext
    
    func save() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("Saved")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetch<T: NSManagedObject>(_ objectYype: T.Type) -> [T] {
        let entityName = String(describing: objectYype)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        do {
            let fetchObject = try! context.fetch(fetchRequest) as? [T]
            return fetchObject ?? [T]()
        } catch {
            print(error)
            return [T]()
        }
    }
    
    func delete(_ object: NSManagedObject) {
        context.delete(object)
        try! context.save()
    }
    
}
