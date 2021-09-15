//
//  Shot+CoreDataProperties.swift
//  NameMyPic
//
//  Created by EO on 10/09/21.
//
//
//

import Foundation
import CoreData
import MapKit


extension Shot {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Shot> {
        return NSFetchRequest<Shot>(entityName: "Shot")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: UUID?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    
    var wrappedId: String {
        self.id?.description ?? "Unknown Id"
    }
    
    var wrappedName: String {
        self.name?.description ?? "Unknown Name"
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

}
