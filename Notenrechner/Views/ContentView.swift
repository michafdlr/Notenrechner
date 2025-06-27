//
//  ContentView.swift
//  Notenrechner
//
//  Created by Michael Fiedler on 20.06.25.
//

import SwiftData
import SwiftUI


struct ContentView: View {
    @Query(sort: \Fach.name) var facher: [Fach]
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        NavigationSplitView(columnVisibility: $viewModel.columnVisibility) {
            List(facher, selection: $viewModel.selectedFach) { fach in
                NavigationLink(fach.name, value: fach)
                    .onTapGesture {
                        viewModel.toggleColumnVisibility(fach: fach)
                    }
            }
            .navigationTitle("Fächer")
        } detail: {
            if viewModel.selectedFach != nil {
                FachDetailView(fach: viewModel.selectedFach ?? Fach(name: "", teacher: ""))
            } else {
                Text("Wähle ein Fach")
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.shared.modelContainer)
}
