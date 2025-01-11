//
//  Petnotification+CoreDataProperties.swift
//  MrSunshisjournal
//
//  Created by DISMOV on 01/01/25.
//
//

import Foundation
import CoreData


extension Petnotification {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Petnotification> {
        return NSFetchRequest<Petnotification>(entityName: "Petnotification")
    }

    @NSManaged public var notification_time: Date?
    @NSManaged public var notification_photo: String?
    @NSManaged public var notification_notas: String?
    @NSManaged public var notification_comida: Float
    @NSManaged public var notification_temp: Float
    @NSManaged public var notification_dosis: String?
    @NSManaged public var notification_aseo: String?
    @NSManaged public var petmascota: Petmascota?
    @NSManaged public var petactividad: Petactividad?

}

extension Petnotification : Identifiable {

}
