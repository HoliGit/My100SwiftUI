//
//  DiceItem.swift
//  RollMyDice
//
//  Created by EO on 05/10/21.
//

import Foundation

struct DiceItem {
    var sides: Int
    var values: [Int] = []
    var numberOfDice: Int
    
    //var isRotating: Bool = false
    
    var total: Int {
        if !values.isEmpty {
            return values.reduce(0, +)
        } else {
            return 0
        }
    }
    
}
    

