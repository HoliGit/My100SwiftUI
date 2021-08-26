//
//  Tea+CoreDataProperties.swift
//  CoreDataProjectFull
//
//  Created by SCOTTY on 25/08/21.
//
//

import Foundation
import CoreData


extension Tea {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tea> {
        return NSFetchRequest<Tea>(entityName: "Tea")
    }

    @NSManaged public var name: String?
    @NSManaged public var origin: Country?
    
    //adjust to SwiftUi
    public var wrappedName: String {
        name ?? "Unknown Tea"
    }

}

extension Tea : Identifiable {

}
