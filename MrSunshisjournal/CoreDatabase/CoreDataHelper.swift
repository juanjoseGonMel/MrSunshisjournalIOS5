
import Foundation
import CoreData
import UIKit

class CoreDataHelper {
    lazy var context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("No se pudo acceder al AppDelegate.")
        }
        return appDelegate.persistentContainer.viewContext
    }()
    
    func createEntity<T: NSManagedObject>(_ entityType: T.Type) -> T {
        return T(context: context)
    }
    
    func saveContext() throws {
        if context.hasChanges {
            try context.save()
        }
    }
    
    func fetchEntities<T: NSManagedObject>(_ entityType: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> [T] {
        let request = T.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        return try context.fetch(request) as! [T]
    }
    
    func deleteEntity(_ entity: NSManagedObject) throws {
        context.delete(entity)
        try saveContext()
    }
    
    func getNextID<T: NSManagedObject>(_ entityType: T.Type, idKey: String = "id") -> Int64 {
        let request = T.fetchRequest()
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(key: idKey, ascending: false)]
        
        do {
            if let lastObject = try context.fetch(request).first as? T,
               let lastID = lastObject.value(forKey: idKey) as? Int64 {
                return lastID + 1
            }
        } catch {
            print("Error al obtener el último ID: \(error)")
        }
        return 1
    }
}
