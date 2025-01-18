import Foundation
import CoreData
import UserNotifications

class NotificacionManager {
    let coreDataHelper = CoreDataHelper()

    func createNotificacion(tipo: String? = nil,
                            descripcion: String? = nil,
                            fecha: Date,
                            frecuenciadias: Int64? = nil,
                            horario: String? = nil,
                            mascota: Mascota? = nil) throws -> Notificacion {
        let notificacion = coreDataHelper.createEntity(Notificacion.self)
        notificacion.id = coreDataHelper.getNextID(Notificacion.self)
        notificacion.tipo = tipo
        notificacion.descripcion = descripcion

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        notificacion.fechaString = dateFormatter.string(from: fecha)

        notificacion.frecuenciadias = frecuenciadias ?? 0
        notificacion.horario = horario
        notificacion.mascota = mascota

        try coreDataHelper.saveContext()
        programarNotificacion(notificacion: notificacion)
        return notificacion
    }

    func fetchNotificaciones() throws -> [Notificacion] {
        return try coreDataHelper.fetchEntities(Notificacion.self, sortDescriptors: [NSSortDescriptor(key: "id", ascending: false)])
    }

    func fetchNotificaciones(for fecha: String) throws -> [Notificacion] {
        let predicate = NSPredicate(format: "fechaString == %@", fecha)
        return try coreDataHelper.fetchEntities(Notificacion.self, predicate: predicate, sortDescriptors: [NSSortDescriptor(key: "id", ascending: false)])
    }

    func fetchNotificaciones(byMascota mascota: Mascota) throws -> [Notificacion] {
        let predicate = NSPredicate(format: "mascota == %@", mascota)
        return try coreDataHelper.fetchEntities(Notificacion.self, predicate: predicate, sortDescriptors: [NSSortDescriptor(key: "id", ascending: false)])
    }

    func fetchDistinctFechas() throws -> [String] {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Notificacion")
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.propertiesToFetch = ["fechaString"]
        fetchRequest.returnsDistinctResults = true

        let results = try coreDataHelper.context.fetch(fetchRequest)
        return results.compactMap { ($0 as? [String: Any])?["fechaString"] as? String }
    }

    func fetchNotificacion(byID id: Int64) throws -> Notificacion? {
        let predicate = NSPredicate(format: "id == %d", id)
        let results = try coreDataHelper.fetchEntities(Notificacion.self, predicate: predicate)
        return results.first
    }

    func updateNotificacion(byID id: Int64,
                            tipo: String? = nil,
                            descripcion: String? = nil,
                            fecha: Date? = nil,
                            frecuenciadias: Int64? = nil,
                            horario: String? = nil,
                            mascota: Mascota? = nil) throws {
        let request: NSFetchRequest<Notificacion> = Notificacion.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        request.fetchLimit = 1

        if let notificacion = try coreDataHelper.context.fetch(request).first {
            if let tipo = tipo { notificacion.tipo = tipo }
            if let descripcion = descripcion { notificacion.descripcion = descripcion }
            if let fecha = fecha { notificacion.fecha = fecha }
            if let frecuenciadias = frecuenciadias { notificacion.frecuenciadias = frecuenciadias }
            if let horario = horario { notificacion.horario = horario }
            if let mascota = mascota { notificacion.mascota = mascota }

            try coreDataHelper.saveContext()
        } else {
            throw NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Notificación con ID \(id) no encontrada."])
        }
    }

    func deleteNotificacion(_ notificacion: Notificacion) throws {
        try coreDataHelper.deleteEntity(notificacion)
    }
    
    func normalizeExistingDates() throws {
        let request: NSFetchRequest<Notificacion> = Notificacion.fetchRequest()
        let notificaciones = try coreDataHelper.context.fetch(request)

        for notificacion in notificaciones {
            if let fechaOriginal = notificacion.fecha {
                let fechaNormalizada = fechaOriginal.toDateOnly()
                if fechaOriginal != fechaNormalizada {
                    notificacion.fecha = fechaNormalizada
                }
            }
        }
        
        try coreDataHelper.saveContext()
    }
    
    func convertirFechasExistentes() throws {
        let request: NSFetchRequest<Notificacion> = Notificacion.fetchRequest()
        let notificaciones = try coreDataHelper.context.fetch(request)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        for notificacion in notificaciones {
            if let fecha = notificacion.fecha {
                notificacion.fechaString = dateFormatter.string(from: fecha)
            }
        }
        
        try coreDataHelper.saveContext()
    }
    
    func programarNotificacion(notificacion: Notificacion) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "⏰ ¡Alarma!"
        content.body = notificacion.descripcion ?? "Es hora de tu evento."
        content.sound = UNNotificationSound.defaultCritical
        content.userInfo = ["notificacion_id": notificacion.id] // 🔥 Agregar el ID a la notificación

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        guard let fechaNotificacion = notificacion.fechaString,
              let horario = notificacion.horario,
              let fechaInicial = dateFormatter.date(from: "\(fechaNotificacion) \(horario)") else {
            print("❌ Error: No se pudo convertir la fecha/hora")
            return
        }

        let frecuencia = notificacion.frecuenciadias
        print("📅 Programando notificación para \(fechaInicial) con frecuencia de \(frecuencia) días.")

        for i in 0..<52 {
            let fechaProgramada = Calendar.current.date(byAdding: .day, value: Int(frecuencia) * i, to: fechaInicial)
            guard let fechaFinal = fechaProgramada else { continue }

            let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: fechaFinal)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

            let request = UNNotificationRequest(identifier: "\(notificacion.id)_\(i)", content: content, trigger: trigger)

            center.add(request) { error in
                if let error = error {
                    print("❌ Error al programar la notificación: \(error.localizedDescription)")
                } else {
                    print("✅ Notificación programada para: \(fechaFinal)")
                }
            }
        }
    }


    func createFutureNotificacion(notificacion: Notificacion, fecha: Date) throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let nuevaNotificacion = coreDataHelper.createEntity(Notificacion.self)
        nuevaNotificacion.id = coreDataHelper.getNextID(Notificacion.self)
        nuevaNotificacion.tipo = notificacion.tipo
        nuevaNotificacion.descripcion = notificacion.descripcion
        nuevaNotificacion.horario = notificacion.horario
        nuevaNotificacion.mascota = notificacion.mascota
        nuevaNotificacion.fechaString = dateFormatter.string(from: fecha)

        try coreDataHelper.saveContext()
    }
}

