
import Foundation
import CoreData
import UIKit
class UsuarioManager {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext) {
        self.context = context
    }
    
    private func getNextID() -> Int64 {
        let request: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        request.fetchLimit = 1
        
        do {
            let lastUsuario = try context.fetch(request).first
            return (lastUsuario?.id ?? 0) + 1
        } catch {
            print("Error al obtener el próximo ID: \(error)")
            return 1
        }
    }
    
    func createUsuario(apellidos: String? = nil,
                       foto: Data? = nil,
                       correo: String? = nil,
                       nombre: String? = nil,
                       telefono: String? = nil,
                       ubicacion: String? = nil) throws {
        let newUsuario = Usuario(context: context)
        newUsuario.apellidos = apellidos
        newUsuario.foto = foto
        newUsuario.correo = correo
        newUsuario.nombre = nombre
        newUsuario.telefono = telefono
        newUsuario.ubicacion = ubicacion
        
        saveContext()
    }
    
    func updateUsuario(id: Int64,
                       apellidos: String? = nil,
                       foto: Data? = nil,
                       correo: String? = nil,
                       nombre: String? = nil,
                       telefono: String? = nil,
                       ubicacion: String? = nil) throws {
        let request: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        request.fetchLimit = 1
        
        do {
            if let usuario = try context.fetch(request).first {
                if let apellidos = apellidos {
                    usuario.apellidos = apellidos
                }
                if let foto = foto {
                    usuario.foto = foto
                }
                if let correo = correo {
                    usuario.correo = correo
                }
                if let nombre = nombre {
                    usuario.nombre = nombre
                }
                if let telefono = telefono {
                    usuario.telefono = telefono
                }
                if let ubicacion = ubicacion {
                    usuario.ubicacion = ubicacion
                }
                saveContext()
            } else {
                print("No se encontró un usuario con el ID \(id)")
            }
        } catch {
            print("Error al actualizar el usuario con ID \(id): \(error)")
        }
    }
    
    func fetchAllUsuarios() throws -> [Usuario] {
        let request: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Error al obtener los usuarios: \(error)")
            return []
        }
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error al guardar en Core Data: \(error)")
        }
    }
}
