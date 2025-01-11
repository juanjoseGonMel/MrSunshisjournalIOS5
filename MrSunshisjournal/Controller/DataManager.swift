//
//  DataManager.swift
//  MrSunshisjournal
//
//  Created by DISMOV on 25/10/24.
//

import Foundation
import CoreData

class DataManager: NSObject {
    
    static let shared = DataManager()
    
    private override init() {
        super.init()
    }
    
    
    
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "JournalModel") // Asegúrate de que el nombre aquí coincida con el nombre de tu archivo .xcdatamodeld
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    
    
    // MARK: - Managed Context
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
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
    
    // Método para insertar nuevos objetos en el contexto
    func insert<T: NSManagedObject>(_ type: T.Type) -> T {
        let context = persistentContainer.viewContext
        let entityName = String(describing: type)
        let newObject = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! T
        return newObject
    }
    
    // Método para obtener objetos de Core Data
    func fetch<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate? = nil) -> [T]? {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
        request.predicate = predicate
        do {
            let results = try context.fetch(request)
            return results
        } catch {
            print("Error fetching \(type): \(error)")
            return nil
        }
    }
    
    // Método para eliminar un objeto
    func delete<T: NSManagedObject>(_ object: T) {
        let context = persistentContainer.viewContext
        context.delete(object)
    }
    
    
    
    
}
