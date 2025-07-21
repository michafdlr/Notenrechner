//
//  ContentView-ViewModel.swift
//  Notenrechner
//
//  Created by Michael Fiedler on 21.06.25.
//

import SwiftData
import SwiftUI

extension ContentView {
    @Observable
    class ViewModel {
        var selectedFach: Fach?
        var columnVisibility = NavigationSplitViewVisibility.automatic
        var searchText = ""
        var showAddFachSheet = false

        var modelContext: ModelContext
        var filteredFacher = [Fach]()

        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            fetchFacher()
        }

        func fetchFacher() {
            do {
                let predicate: Predicate<Fach>

                if searchText.isEmpty {
                    predicate = #Predicate { _ in true }
                } else {
                    let search = searchText
                    predicate = #Predicate { fach in
                        fach.name.localizedStandardContains(search)
                    }
                }

                let descriptor = FetchDescriptor<Fach>(
                    predicate: predicate,
                    sortBy: [SortDescriptor(\.name)]
                )

                filteredFacher = try modelContext.fetch(descriptor)
            } catch {
                print(error.localizedDescription)
            }
        }

        func toggleColumnVisibility(fach: Fach) {
            selectedFach = fach
            columnVisibility = .detailOnly
        }
    }
}
