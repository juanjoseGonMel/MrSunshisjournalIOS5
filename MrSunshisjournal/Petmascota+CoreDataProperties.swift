//
//  Petmascota+CoreDataProperties.swift
//  MrSunshisjournal
//
//  Created by DISMOV on 01/01/25.
//
//

import Foundation
import CoreData


extension Petmascota {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Petmascota> {
        return NSFetchRequest<Petmascota>(entityName: "Petmascota")
    }

    @NSManaged public var pet_cumpleanos: Date?
    @NSManaged public var pet_descripcion: String?
    @NSManaged public var pet_esteril: Bool
    @NSManaged public var pet_genero: Bool
    @NSManaged public var pet_name: String?
    @NSManaged public var pet_peso: Float
    @NSManaged public var pet_raza: String?
    @NSManaged public var pet_photo: String?
    @NSManaged public var petactividad: NSSet?
    @NSManaged public var pethabitat: Pethabitat?
    @NSManaged public var petnotification: Petnotification?

}

// MARK: Generated accessors for petactividad
extension Petmascota {

    @objc(addPetactividadObject:)
    @NSManaged public func addToPetactividad(_ value: Petactividad)

    @objc(removePetactividadObject:)
    @NSManaged public func removeFromPetactividad(_ value: Petactividad)

    @objc(addPetactividad:)
    @NSManaged public func addToPetactividad(_ values: NSSet)

    @objc(removePetactividad:)
    @NSManaged public func removeFromPetactividad(_ values: NSSet)

}

extension Petmascota : Identifiable {

}
