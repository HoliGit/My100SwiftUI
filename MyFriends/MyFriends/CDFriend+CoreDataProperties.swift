//
//  CDFriend+CoreDataProperties.swift
//  MyFriends
//
//  Created by EO on 30/08/21.
//
//

import Foundation
import CoreData


extension CDFriend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDFriend> {
        return NSFetchRequest<CDFriend>(entityName: "CDFriend")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    //@NSManaged public var friend: CDUser?
    
    public var wrappedId : String {
        id ?? ""
    }
    
    public var wrappedName : String {
        name ?? ""
    }

}

/*extension CDFriend : Identifiable {

}*/
