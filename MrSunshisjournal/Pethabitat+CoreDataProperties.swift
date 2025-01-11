//
//  Pethabitat+CoreDataProperties.swift
//  MrSunshisjournal
//
//  Created by DISMOV on 01/01/25.
//
//

import Foundation
import CoreData


extension Pethabitat {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pethabitat> {
        return NSFetchRequest<Pethabitat>(entityName: "Pethabitat")
    }

    @NSManaged public var habitat_acceso: Bool
    @NSManaged public var habitat_capacidad: Int16
    @NSManaged public var habitat_descripcion: String?
    @NSManaged public var habitat_tamano: Float
    @NSManaged public var habitat_temperatura: Float
    @NSManaged public var habitat_tipo: String?
    @NSManaged public var habitat_name: String?
    @NSManaged public var habitat_photo: String?
    @NSManaged public var petmascota: NSSet?

}

// MARK: Generated accessors for petmascota
extension Pethabitat {

    @objc(addPetmascotaObject:)
    @NSManaged public func addToPetmascota(_ value: Petmascota)

    @objc(removePetmascotaObject:)
    @NSManaged public func removeFromPetmascota(_ value: Petmascota)

    @objc(addPetmascota:)
    @NSManaged public func addToPetmascota(_ values: NSSet)

    @objc(removePetmascota:)
    @NSManaged public func removeFromPetmascota(_ values: NSSet)

}

extension Pethabitat : Identifiable {

}
