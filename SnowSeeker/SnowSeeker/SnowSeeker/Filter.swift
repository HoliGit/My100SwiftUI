//
//  Filter.swift
//  SnowSeeker
//
//  Created by EO on 06/10/21.
//

import Foundation

struct Filter {
    var selectedCountry: String = "All"
    var selectedPrice: Int = 0
    var selectedResortSize: Int = 0
    
    func matchCountry(country: String) -> Bool {
        if selectedCountry == "All" {
            return true
        }
        
        if selectedCountry == country {
            return true
        }
        
        return false
    }
    
    func matchPrice(price: Int) -> Bool {
        if selectedPrice == 0 {
            return true
        }
        
        if selectedPrice == price {
            return true
        }
        
        return false
    }
    
    func matchResortSize(size: Int) -> Bool {
        if selectedResortSize == 0 {
            return true
        }
        
        if selectedResortSize == size {
            return true
        }
        
        return false
    }
    
}
