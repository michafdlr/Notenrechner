//
//  NotenrechnerApp.swift
//  Notenrechner
//
//  Created by Michael Fiedler on 20.06.25.
//

import SwiftData
import SwiftUI

@main
struct NotenrechnerApp: App {
    let container: ModelContainer
    
    var body: some Scene {
        WindowGroup {
            ContentView(modelContext: container.mainContext)
        }
        .modelContainer(container)
    }
    
    init() {
        do {
            container = try ModelContainer(for: Fach.self, Klausur.self)
        } catch {
            fatalError("Failed to create model Container")
        }
    }
}
