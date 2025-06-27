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
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(SampleData.shared.modelContainer)
    }
}
