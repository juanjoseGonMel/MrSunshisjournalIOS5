
import Foundation
import CoreData

class MascotaManager {
    let coreDataHelper = CoreDataHelper()
    
    func createMascota(name: String? = nil,
                       descripcion: String? = nil,
                       peso: Double? = nil,
                       fechaNacimiento: Date? = nil,
                       raza: String? = nil,
                       esterilizado: Bool? = nil,
                       genero: String? = nil,
                       imagen: Data? = nil,
                       habitat: Habitat) throws -> Mascota {
        let mascota = coreDataHelper.createEntity(Mascota.self)
        mascota.id = coreDataHelper.getNextID(Mascota.self)
        mascota.name = name
        mascota.descripcion = descripcion
        mascota.peso = peso ?? 0.0
        mascota.fechaNac = fechaNacimiento
        mascota.raza = raza
        mascota.esteril = esterilizado ?? false
        mascota.genero = genero
        mascota.imagen = imagen
        mascota.habitat = habitat
        try coreDataHelper.saveContext()
        return mascota
    }
    
    func fetchMascotas() throws -> [Mascota] {
        return try coreDataHelper.fetchEntities(Mascota.self, sortDescriptors: [NSSortDescriptor(key: "id", ascending: false)])
    }
    
    func fetchMascotas(byHabitat habitat: Habitat) throws -> [Mascota] {
        let predicate = NSPredicate(format: "habitat == %@", habitat)
        return try coreDataHelper.fetchEntities(Mascota.self, predicate: predicate)
    }
    
    func fetchMascota(byID id: Int64) throws -> Mascota? {
        let predicate = NSPredicate(format: "id == %d", id)
        let results = try coreDataHelper.fetchEntities(Mascota.self, predicate: predicate)
        return results.first
    }
    
    func updateMascota(byID id: Int64,
                       name: String? = nil,
                       descripcion: String? = nil,
                       peso: Double? = nil,
                       fechaNacimiento: Date? = nil,
                       raza: String? = nil,
                       esterilizado: Bool? = nil,
                       genero: String? = nil,
                       imagen: Data? = nil,
                       habitat: Habitat? = nil) throws {
        let request: NSFetchRequest<Mascota> = Mascota.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        request.fetchLimit = 1
        
        do {
            if let mascota = try coreDataHelper.context.fetch(request).first {
                if let name = name {
                    mascota.name = name
                }
                if let descripcion = descripcion {
                    mascota.descripcion = descripcion
                }
                if let peso = peso {
                    mascota.peso = peso
                }
                if let fechaNacimiento = fechaNacimiento {
                    mascota.fechaNac = fechaNacimiento
                }
                if let raza = raza {
                    mascota.raza = raza
                }
                if let esterilizado = esterilizado {
                    mascota.esteril = esterilizado
                }
                if let genero = genero {
                    mascota.genero = genero
                }
                if let imagen = imagen {
                    mascota.imagen = imagen
                }
                if let habitat = habitat {
                    mascota.habitat = habitat
                }
                
                try coreDataHelper.saveContext()
            } else {
                throw NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Mascota con ID \(id) no encontrada."])
            }
        } catch {
            throw error
        }
    }
    
    func deleteMascota(_ mascota: Mascota) throws {
        try coreDataHelper.deleteEntity(mascota)
    }
}
