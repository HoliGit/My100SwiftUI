//
//  Astronaut.swift
//  Moonshot
//
//  Created by EO on 08/07/21.
//  Updated on 18/07/22

import Foundation

//Codable = we can create instances of this struct from json
//Identifiable = that id field can be used for arrays inside ForEach etc

struct Astronaut: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
}

  //convert json in array = use Bundle to find path and load it in an instance of data
