//
//  Order.swift
//  CupcakeCorner
//
//  Created by EO on 19/07/21.
//  Challenges completed on 21/07/21
//

import Foundation

/* @published cannot conform to Codable automatically, we must add CodingKeys by hand - see bottom. Better solve Challenge 3 creating an ObservableObject class wrapper with one @Published property with the data struct inside */


class OrderWrapper: ObservableObject {
    @Published var order = Order()
}

struct Order: Codable {
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    //ensure to disable extras if specialRequestEnabled is false
    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    
    var extraFrosting = false
    var addSprinkles = false
    
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    
    //Challenge 1 - avoid whitespace as valid insertion for textfield
    var hasValidAddress: Bool {
        for stringField in [name, streetAddress, city, zip]{
            if stringField.trimmingCharacters(in: .whitespaces).isEmpty {
                return false
            }
        }
        return true
    }
    
//basic cake cost 2$, extraFrost + 1$ , sprinkles + 0.5$
    var cost: Double {
                                              //quantity x 2 = 2$ x 1 cake
        var cost = Double(quantity) * 2
        cost += Double(type) / 2              //complicated cakes cost more
        
        if extraFrosting {
            cost += Double(quantity)          //1$ per extra frosting
        }
        
        if addSprinkles {
            cost += Double(quantity) / 2      //0.50$ for sprinkles
        }
        
        return cost
    }
}
    
    /*we need an initializer for an empty order/default order values
    init() { }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        type = try container.decode(Int.self, forKey: .type)
        quantity = try container.decode(Int.self, forKey: .quantity)
        extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
        addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)
        name = try container.decode(String.self, forKey: .name)
        streetAddress = try container.decode(String.self, forKey: .streetAddress)
        city = try container.decode(String.self, forKey: .city)
        zip = try container.decode(String.self, forKey: .zip)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type, forKey: .type)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(extraFrosting, forKey: .extraFrosting)
        try container.encode(addSprinkles, forKey: .addSprinkles)
        try container.encode(name, forKey: .name)
        try container.encode(streetAddress, forKey: .streetAddress)
        try container.encode(city, forKey: .city)
        try container.encode(zip, forKey: .zip)
    }
}
 
*/
