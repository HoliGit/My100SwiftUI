//
//  Habit.swift
//  iTrack
//
//  Created by EO on 15/07/21.
//

import Foundation

class Habit: ObservableObject {
    @Published var activities: [Activity] {
        //if "activities" changes, encodes and saves it into UserDefaults
        didSet {
            
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(activities){
                UserDefaults.standard.set(encoded, forKey: "Acts")
            }
        }
    }
    
 //when app starts loads data from UserDefaults and decodes into activities
    init() {
        if let acts = UserDefaults.standard.data(forKey: "Acts"){
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Activity].self, from: acts){
                self.activities = decoded
                return
            }
        }
        //if fail to load data, initialize empty array
        self.activities = []
    }
    
}
