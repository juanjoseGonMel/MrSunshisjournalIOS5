
import Foundation
import CoreData

class HabitatManager {
    let coreDataHelper = CoreDataHelper()
    
    func createHabitat(name: String? = nil,
                       descripcion: String? = nil,
                       capacidad: Int64? = nil,
                       tamano: Double? = nil,
                       temperatura: Double? = nil,
                       tipo: String? = nil,
                       isOpened: Bool? = nil,
                       imagen: Data? = nil) throws -> Habitat {
        let habitat = coreDataHelper.createEntity(Habitat.self)
        habitat.id = coreDataHelper.getNextID(Habitat.self)
        habitat.name = name
        habitat.descripcion = descripcion
        habitat.capacidad = capacidad ?? 0
        habitat.size = tamano ?? 0.0
        habitat.temperatura = temperatura ?? 0.0
        habitat.tipo = tipo
        habitat.isopened = isOpened ?? false
        habitat.imagen = imagen
        try coreDataHelper.saveContext()
        return habitat
    }
    
    func fetchHabitats() throws -> [Habitat] {
        return try coreDataHelper.fetchEntities(Habitat.self, sortDescriptors: [NSSortDescriptor(key: "id", ascending: false)])
    }
    
    func fetchHabitat(byID id: Int64) throws -> Habitat? {
        let predicate = NSPredicate(format: "id == %d", id)
        let results = try coreDataHelper.fetchEntities(Habitat.self, predicate: predicate)
        return results.first
    }
    
    func updateHabitat(byID id: Int64,
                       name: String? = nil,
                       descripcion: String? = nil,
                       capacidad: Int64? = nil,
                       tamano: Double? = nil,
                       temperatura: Double? = nil,
                       tipo: String? = nil,
                       isOpened: Bool? = nil,
                       imagen: Data? = nil) throws {
        let predicate = NSPredicate(format: "id == %d", id)
        let habitats = try coreDataHelper.fetchEntities(Habitat.self, predicate: predicate)
        
        guard let habitatToUpdate = habitats.first else {
            throw NSError(domain: "HabitatManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Hábitat no encontrado."])
        }
        
        if let name = name {
            habitatToUpdate.name = name
        }
        if let descripcion = descripcion {
            habitatToUpdate.descripcion = descripcion
        }
        if let capacidad = capacidad {
            habitatToUpdate.capacidad = capacidad
        }
        if let tamano = tamano {
            habitatToUpdate.size = tamano
        }
        if let temperatura = temperatura {
            habitatToUpdate.temperatura = temperatura
        }
        if let tipo = tipo {
            habitatToUpdate.tipo = tipo
        }
        if let isOpened = isOpened {
            habitatToUpdate.isopened = isOpened
        }
        if let imagen = imagen {
            habitatToUpdate.imagen = imagen
        }
        
        try coreDataHelper.saveContext()
    }
    
    func deleteHabitat(_ habitat: Habitat) throws {
        try coreDataHelper.deleteEntity(habitat)
    }
}
