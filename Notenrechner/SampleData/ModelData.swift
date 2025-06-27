//
//  ModelData.swift
//  Notenrechner
//
//  Created by Michael Fiedler on 21.06.25.
//

import Foundation
import SwiftData

@MainActor
class SampleData {
    static let shared = SampleData()
    let modelContainer: ModelContainer
    
    var context: ModelContext {
        modelContainer.mainContext
    }
    
    private init() {
        let schema = Schema([
            Fach.self,
            Klausur.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            insertSampleData()
            try context.save()
        } catch {
            fatalError("Could not create model container: \(error.localizedDescription)")
        }
    }
    
    private func insertSampleData() {
        for fach in Fach.sampleData {
            context.insert(fach)
        }
    }
}
