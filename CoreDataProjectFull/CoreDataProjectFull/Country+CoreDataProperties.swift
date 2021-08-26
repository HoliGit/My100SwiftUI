//
//  Country+CoreDataProperties.swift
//  CoreDataProjectFull
//
//  Created by SCOTTY on 25/08/21.
//
//

import Foundation
import CoreData


extension Country {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Country> {
        return NSFetchRequest<Country>(entityName: "Country")
    }

    @NSManaged public var fullName: String?
    @NSManaged public var shortName: String?
    @NSManaged public var tea: NSSet?
    
    public var wrappedShortName: String {
        shortName ?? "Unknown Country"
    }
    
    public var wrappedFullName: String {
        fullName ?? "Unknown Country"
    }
    
    //adjust from old NSSet to SwiftUi:
    
    public var teaArray: [Tea] {
        let set = tea as? Set<Tea> ?? []
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }

}

// MARK: Generated accessors for tea
extension Country {

    @objc(addTeaObject:)
    @NSManaged public func addToTea(_ value: Tea)

    @objc(removeTeaObject:)
    @NSManaged public func removeFromTea(_ value: Tea)

    @objc(addTea:)
    @NSManaged public func addToTea(_ values: NSSet)

    @objc(removeTea:)
    @NSManaged public func removeFromTea(_ values: NSSet)

}

extension Country : Identifiable {

}
