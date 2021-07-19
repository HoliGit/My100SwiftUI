//
//  Activity.swift
//  iTrack
//
//  Created by EO on 15/07/21.
//

import Foundation

struct Activity: Codable, Identifiable {
    var id = UUID()
    var name: String
    var description: String
    var completedTimes: Int
}
