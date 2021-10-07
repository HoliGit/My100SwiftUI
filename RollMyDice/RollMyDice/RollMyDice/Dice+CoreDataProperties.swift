//
//  Dice+CoreDataProperties.swift
//  RollMyDice
//
//  Created by EO on 05/10/21.
//
//

import Foundation
import CoreData


extension Dice {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dice> {
        return NSFetchRequest<Dice>(entityName: "Dice")
    }

    @NSManaged public var timestamp: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var number: Int16
    @NSManaged public var sides: Int16
    @NSManaged public var values: String?
    
    var valuesArray: [Int]{
        if let temp = self.values {
            return temp
                .components(separatedBy: ",")
                .map{
                    word in (Int(word.trimmingCharacters(in: CharacterSet.whitespaces))!)
                }
        }
        return [Int]()
    }

}

extension Dice : Identifiable {

}
