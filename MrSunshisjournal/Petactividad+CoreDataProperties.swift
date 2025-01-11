//
//  Petactividad+CoreDataProperties.swift
//  MrSunshisjournal
//
//  Created by DISMOV on 01/01/25.
//
//

import Foundation
import CoreData


extension Petactividad {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Petactividad> {
        return NSFetchRequest<Petactividad>(entityName: "Petactividad")
    }

    @NSManaged public var act_datefin: Date?
    @NSManaged public var act_dateinicio: Date?
    @NSManaged public var act_name: String?
    @NSManaged public var act_secuencia: Double
    @NSManaged public var act_tipo: String?
    @NSManaged public var petmascota: Petmascota?
    @NSManaged public var petnotification: Petnotification?

}

extension Petactividad : Identifiable {

}
