
import Foundation
import CoreData

class ActividadManager {
    let coreDataHelper = CoreDataHelper()

    func createActividad(fecha: Date, observaciones: String? = nil, notificacion: Notificacion?) throws -> Actividad {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let actividad = coreDataHelper.createEntity(Actividad.self)
        actividad.fecha = fecha
        actividad.fechaString = dateFormatter.string(from: fecha) // 🔥 Se agrega la conversión
        actividad.observaciones = observaciones
        actividad.notificacion = notificacion

        try coreDataHelper.saveContext()
        print("✅ Actividad creada con éxito: \(actividad.fechaString!)")
        return actividad
    }
    func fetchActividades() throws -> [Actividad] {
        return try coreDataHelper.fetchEntities(Actividad.self, sortDescriptors: [NSSortDescriptor(key: "id", ascending: false)])
    }

    func fetchActividades(for fecha: String) throws -> [Actividad] {
        let predicate = NSPredicate(format: "fechaString == %@", fecha)
        return try coreDataHelper.fetchEntities(Actividad.self, predicate: predicate, sortDescriptors: [NSSortDescriptor(key: "id", ascending: false)])
    }

    func fetchActividad(byID id: Int64) throws -> Actividad? {
        let predicate = NSPredicate(format: "id == %d", id)
        return try coreDataHelper.fetchEntities(Actividad.self, predicate: predicate).first
    }

    func updateActividad(byID id: Int64, fecha: Date? = nil, observaciones: String? = nil, notificacion: Notificacion? = nil) throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let request: NSFetchRequest<Actividad> = Actividad.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        request.fetchLimit = 1

        if let actividad = try coreDataHelper.context.fetch(request).first {
            if let nuevaFecha = fecha {
                actividad.fecha = nuevaFecha
                actividad.fechaString = dateFormatter.string(from: nuevaFecha)
            }
            if let nuevasObservaciones = observaciones {
                actividad.observaciones = nuevasObservaciones
            }
            if let nuevaNotificacion = notificacion {
                actividad.notificacion = nuevaNotificacion
            }
            
            try coreDataHelper.saveContext()
            print("✅ Actividad actualizada con éxito: \(actividad.fechaString!)")
        } else {
            throw NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Actividad con ID \(id) no encontrada."])
        }
    }

    func deleteActividad(_ actividad: Actividad) throws {
        try coreDataHelper.deleteEntity(actividad)
        print("✅ Actividad eliminada con éxito.")
    }
}
