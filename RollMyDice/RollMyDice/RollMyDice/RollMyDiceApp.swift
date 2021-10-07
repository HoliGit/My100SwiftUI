//
//  RollMyDiceApp.swift
//  RollMyDice
//
//  Created by EO on 05/10/21.
//

import SwiftUI

@main
struct RollMyDiceApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
